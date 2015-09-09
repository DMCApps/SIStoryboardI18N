//
//  UIView+StoryboardI18N.m
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-03.
//
//

#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

#import <objc/runtime.h>

#import "SIStoryboardI18N.h"


@implementation NSString (StoryboardI18N)

- (BOOL)si_containsString:(NSString *)other
{
    NSRange range = [self rangeOfString:other];
    return range.length != 0;
}

@end

@implementation UIView (StoryboardI18N)

- (BOOL)si_isSubviewOfControlClass:(Class)controlClass
{
    UIView *superview = self.superview;
    do {
        if ([superview isKindOfClass:controlClass]) {
            return YES;
        }
        superview = superview.superview;
    } while (superview);
    return false;
}

- (NSString *)si_storeOriginal:(NSString *)text forKey:(NSString *)key
{
    if (![text hasPrefix:@"_"]) {
        NSMutableDictionary *originalDict = [[self si_originalContent] mutableCopy];
        if (!originalDict) {
            originalDict = [NSMutableDictionary new];
        }
        if (![originalDict[key] hasPrefix:@"_"]) {
            if (!originalDict[key]) {
                originalDict[key] = text;
                [self si_setOriginalContent:originalDict];
            }
            NSString *localized = StoryboardI18NLocalizedString(originalDict[key]);
            DDLogDebug(@"\ttext selector: %@: %@", originalDict[key], localized);
            return localized;
        }
    }
    return nil;
}

- (void)si_localizeStrings
{
    
    if ([self si_isContentCustomized]) {
        return;
    }
    
    if ([self si_isSubviewOfControlClass:[UISegmentedControl class]]) {
        return;
    }
    
    DDLogDebug(@"StoryboardI18N Localizing view: %@", self);
    
    
    if ([self isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segmentedControl = (id)self;
        for (NSUInteger i = 0; i < segmentedControl.numberOfSegments; i++) {
            [segmentedControl setTitle:StoryboardI18NLocalizedString([segmentedControl titleForSegmentAtIndex:i]) forSegmentAtIndex:i];
        }
        [segmentedControl setNeedsUpdateConstraints];
        [segmentedControl setNeedsLayout];
        return;
    }
    
    if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (id)self;
        NSString *title = nil;
        title = [button titleForState:UIControlStateNormal];
        if ([title respondsToSelector:@selector(si_containsString:)]) {
            if (![title hasPrefix:@"_"]) {
                [button setTitle:StoryboardI18NLocalizedString(title) forState:UIControlStateNormal];
                [button.titleLabel setNeedsLayout];
            }
            title = [button titleForState:UIControlStateSelected];
            if (![title hasPrefix:@"_"]) {
                [button setTitle:StoryboardI18NLocalizedString(title) forState:UIControlStateSelected];
                [button.titleLabel setNeedsLayout];
            }
            title = [button titleForState:UIControlStateHighlighted];
            if (![title hasPrefix:@"_"]) {
                [button setTitle:StoryboardI18NLocalizedString(title) forState:UIControlStateHighlighted];
                [button.titleLabel setNeedsLayout];
            }
            title = [button titleForState:UIControlStateDisabled];
            if (![title hasPrefix:@"_"]) {
                [button setTitle:StoryboardI18NLocalizedString(title) forState:UIControlStateDisabled];
                [button.titleLabel setNeedsLayout];
            }
        }
        return;
    }
    
    
    id unknownSelf = (id)self;
    
    if ([unknownSelf respondsToSelector:@selector(text)] && [unknownSelf respondsToSelector:@selector(setText:)]) {
        NSString *localized = [(UIView *)unknownSelf si_storeOriginal:[unknownSelf text] forKey:@"text"];
        if (localized) {
            [unknownSelf setText:localized];
            [unknownSelf setNeedsLayout];
        }
    }
    
    if ([unknownSelf respondsToSelector:@selector(placeholder)] && [unknownSelf respondsToSelector:@selector(setPlaceholder:)]) {
        NSString *localized = [(UIView *)unknownSelf si_storeOriginal:[unknownSelf placeholder] forKey:@"placeholder"];
        if (localized) {
            [unknownSelf setPlaceholder:localized];
            [unknownSelf setNeedsLayout];
        }
    }
    
    
    // don't call subviews here as this method is called on ALL views.
}

- (void)si_localizeStringsAndSubviews
{
    [self si_localizeStrings];
    if (!self.subviews || self.subviews.count == 0)
        return;
    for (UIView *view in self.subviews) {
        [view si_localizeStringsAndSubviews];
    }
}

#pragma mark - Method Swizzling

- (void)si_swizzledWillMoveToWindow:(UIWindow *)window
{
    [self si_swizzledWillMoveToWindow:window];
    [self si_localizeStrings];
}

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzelSelector:@selector(willMoveToWindow:)
                                 with:@selector(si_swizzledWillMoveToWindow:)];
    });
}

+ (void)swizzelSelector:(SEL)originalSelector with:(SEL)swizzledSelector
{
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
    NSLog(@"Swizzled: %@ %s with %s", self, sel_getName(swizzledSelector), sel_getName(originalSelector));
}

@end
