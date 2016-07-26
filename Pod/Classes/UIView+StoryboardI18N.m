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

- (void)si_localizeStrings
{
 
    if (![[SIStoryboardI18N sharedManager] subviewIsEnabled:self]) {
        DDLogDebug(@"StoryboardI18N Not Localizing view (exlcuded via class): %@", self);
        return;
    }

    DDLogDebug(@"StoryboardI18N Localizing view: %@", self);
    
    if ([self si_isContentCustomized]) {
        return;
    }
    
    id unknownSelf = (id)self;
    
    if ([unknownSelf respondsToSelector:@selector(text)] && [unknownSelf respondsToSelector:@selector(setText:)]) {
        
        if (![[unknownSelf text] hasPrefix:@"_"]) {
            NSString *originalText = [unknownSelf si_originalContent];
            if (![originalText hasPrefix:@"_"]) {
                if (!originalText) {
                [unknownSelf si_setOriginalContent:[unknownSelf text]];
                originalText = [unknownSelf si_originalContent];
                }
                if (originalText) {
                    NSString *localized = StoryboardI18NLocalizedString(originalText);
                    DDLogDebug(@"\t%@: %@", originalText, localized);
                    [unknownSelf setText:localized];
                    [unknownSelf setNeedsLayout];
                }
            }
        }
        
//        if ([[unknownSelf text] respondsToSelector:@selector(si_containsString:)]) {
//            if (![[unknownSelf text] hasPrefix:@"_"]) {
//                [unknownSelf setText:StoryboardI18NLocalizedString ([unknownSelf text])];
//                [unknownSelf setNeedsLayout];
//            }
//        }
    }
    
    if ([unknownSelf respondsToSelector:@selector(placeholder)] && [unknownSelf respondsToSelector:@selector(setPlaceholder:)]) {
        if ([[unknownSelf placeholder] respondsToSelector:@selector(si_containsString:)]) {
            if (![[unknownSelf placeholder] hasPrefix:@"_"]) {
                [unknownSelf setPlaceholder:StoryboardI18NLocalizedString([unknownSelf placeholder])];
                [unknownSelf setNeedsLayout];
            }
        }
    }
    
    if ([self isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segmentedControl = (id)self;
        for (NSUInteger i = 0; i < segmentedControl.numberOfSegments; i++) {
            [segmentedControl setTitle:StoryboardI18NLocalizedString([segmentedControl titleForSegmentAtIndex:i]) forSegmentAtIndex:i];
        }
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
    }
    
    // don't call subviews here as this method is called on ALL views.
}

- (void)si_localizeStringsAndSubviews
{
    if (![[SIStoryboardI18N sharedManager] subviewIsEnabled:self]) {
        DDLogDebug(@"StoryboardI18N Not Localizing view (exlcuded via class): %@", self);
        return;
    }

    [self si_localizeStrings];
    if (!self.subviews || self.subviews.count == 0)
        return;
    for (UIView *view in self.subviews) {
        [view si_localizeStrings];
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


-(UIViewController*)si_viewController
{
    UIResponder *nextResponder =  self;
    
    do
    {
        nextResponder = [nextResponder nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
            return (UIViewController*)nextResponder;
        
    } while (nextResponder != nil);
    
    return nil;
}

-(UIViewController *)si_topMostController
{
    NSMutableArray *controllersHierarchy = [[NSMutableArray alloc] init];
    
    UIViewController *topController = self.window.rootViewController;
    
    if (topController)
    {
        [controllersHierarchy addObject:topController];
    }
    
    while ([topController presentedViewController]) {
        
        topController = [topController presentedViewController];
        [controllersHierarchy addObject:topController];
    }
    
    UIResponder *matchController = [self si_viewController];
    
    while (matchController != nil && [controllersHierarchy containsObject:matchController] == NO)
    {
        do
        {
            matchController = [matchController nextResponder];
            
        } while (matchController != nil && [matchController isKindOfClass:[UIViewController class]] == NO);
    }
    
    return (UIViewController*)matchController;
}

-(UIView*)si_superviewOfClassType:(Class)classType
{
    UIView *superview = self.superview;
    
    while (superview)
    {
        if ([superview isKindOfClass:classType])
        {
            return superview;
        }
        else    superview = superview.superview;
    }
    
    return nil;
}

@end
