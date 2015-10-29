//
//  UIView+StoryboardI18N.m
//
// Copyright (c) 2015 Jeffrey Sambells
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

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

- (NSString *)si_localizedTextForKey:(const void *)key inObject:(id)unknownSelf current:(NSString *)current
{
    NSString *originalText = [unknownSelf si_originalContent];
    if (![current hasPrefix:@"_"]) {
        DDLogVerbose(@"Current text has no prefix: %@", current);
        if (![originalText hasPrefix:@"_"]) {
            if (!originalText) {
                [unknownSelf si_setOriginalContent:current];
                originalText = [unknownSelf si_originalContent];
                DDLogVerbose(@"No original text set. Set to: %@", originalText);
            }
            if (![originalText hasPrefix:@"_"]) {
                DDLogVerbose(@"Original text doesn not have _. Translate: %@", originalText);
                NSString *localized = StoryboardI18NLocalizedString(originalText);
                DDLogVerbose(@"\t%@: %@", originalText, localized);
                return localized;
            }
        } else {
            DDLogVerbose(@"Skipping Dynamic Key: '%@' current value '%@'", originalText, current);
        }
    } else  {
        DDLogVerbose(@"Current text has prefix: %@", current);
        if (!originalText) {
            [unknownSelf si_setOriginalContent:current];
            originalText = [unknownSelf si_originalContent];
            DDLogVerbose(@"No original text for _ key. Leave as %@", originalText);
        } else {
            DDLogVerbose(@"Original text already exists. Skipping. %@", originalText);
        }
    }
    return nil;
}

static void *const siKEY_ButtonUIControlStateNormal = (void *)&siKEY_ButtonUIControlStateNormal;
static void *const siKEY_ButtonUIControlStateSelected = (void *)&siKEY_ButtonUIControlStateSelected;
static void *const siKEY_ButtonUIControlStateHighlighted = (void *)&siKEY_ButtonUIControlStateHighlighted;
static void *const siKEY_ButtonUIControlStateDisabled = (void *)&siKEY_ButtonUIControlStateDisabled;

- (void)si_localizeStrings
{
    DDLogVerbose(@"StoryboardI18N Localizing view: %@", self);
    
    if ([self si_isContentCustomized]) {
        DDLogVerbose(@"Customized: %@", self);
        return;
    } else {
        DDLogVerbose(@"Not Customized: %@", self);
    }
    
    id unknownSelf = (id)self;
    
    
    if ([self isKindOfClass:[UISegmentedControl class]]) {
        DDLogVerbose(@"Is segmented control: %@", self);
        UISegmentedControl *segmentedControl = (id)self;
        for (NSUInteger i = 0; i < segmentedControl.numberOfSegments; i++) {
            [segmentedControl setTitle:StoryboardI18NLocalizedString([segmentedControl titleForSegmentAtIndex:i]) forSegmentAtIndex:i];
        }
        return;
    }
    
    if ([self isKindOfClass:[UIButton class]]) {
        DDLogVerbose(@"Is button control: %@", self);
        UIButton *button = (id)self;
        NSString *normalTitle = [button titleForState:UIControlStateNormal];
        
        NSString *title = normalTitle;
        NSString *localized = [self si_localizedTextForKey:siKEY_ButtonUIControlStateNormal inObject:button current:[button titleForState:UIControlStateNormal]];
        if (localized) {
            [button setTitle:StoryboardI18NLocalizedString(title) forState:UIControlStateNormal];
            [button.titleLabel setNeedsLayout];
        }
        
        title = [button titleForState:UIControlStateSelected];
        if (![normalTitle isEqualToString:title]) {
            NSString *localized = [self si_localizedTextForKey:siKEY_ButtonUIControlStateNormal inObject:button current:[button titleForState:UIControlStateSelected]];
            if (localized) {
                [button setTitle:StoryboardI18NLocalizedString(title) forState:UIControlStateSelected];
                [button.titleLabel setNeedsLayout];
            }
        }
        title = [button titleForState:UIControlStateHighlighted];
        if (![normalTitle isEqualToString:title]) {
            NSString *localized = [self si_localizedTextForKey:siKEY_ButtonUIControlStateNormal inObject:button current:[button titleForState:UIControlStateHighlighted]];
            if (localized) {
                [button setTitle:StoryboardI18NLocalizedString(title) forState:UIControlStateHighlighted];
                [button.titleLabel setNeedsLayout];
            }
        }
        title = [button titleForState:UIControlStateDisabled];
        if (![normalTitle isEqualToString:title]) {
            NSString *localized = [self si_localizedTextForKey:siKEY_ButtonUIControlStateNormal inObject:button current:[button titleForState:UIControlStateDisabled]];
            if (localized) {
                [button setTitle:StoryboardI18NLocalizedString(title) forState:UIControlStateDisabled];
                [button.titleLabel setNeedsLayout];
            }
        }
        return;
    }
    
    if ([unknownSelf respondsToSelector:@selector(placeholder)] && [unknownSelf respondsToSelector:@selector(setPlaceholder:)]) {
        DDLogVerbose(@"Responds to placeholder: %@", self);
        if ([[unknownSelf placeholder] respondsToSelector:@selector(si_containsString:)]) {
            if (![[unknownSelf placeholder] hasPrefix:@"_"]) {
                [unknownSelf setPlaceholder:StoryboardI18NLocalizedString([unknownSelf placeholder])];
                [unknownSelf setNeedsLayout];
            }
        }
    }
    
    if ([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]]) {
        DDLogVerbose(@"Responds to text: %@", self);
        return;
    }
    
    if ([unknownSelf respondsToSelector:@selector(text)]
        && [unknownSelf respondsToSelector:@selector(setText:)]
        && ![self si_view:unknownSelf isChildOfClass:[UIButton class]]
        && ![self si_view:unknownSelf isChildOfClass:[UITextField class]]
        && ![self si_view:unknownSelf isChildOfClass:[UITextView class]]) {
        DDLogVerbose(@"Responds to text: %@", self);
        NSString *localized = [self si_localizedTextForKey:@selector(text) inObject:unknownSelf current:[unknownSelf text]];
        if (localized) {
            [unknownSelf setText:localized];
            [unknownSelf setNeedsLayout];
        }
    }
    
    

    
    // don't call subviews here as this method is called on ALL views.
}

- (BOOL)si_view:(UIView *)view isChildOfClass:(Class)class
{
    while (view.superview) {
        if ([view.superview isKindOfClass:class]) {
            return YES;
        }
        view = view.superview;
    }
    return NO;
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
    
    DDLogVerbose(@"Swizzled: %@ %s with %s", self, sel_getName(swizzledSelector), sel_getName(originalSelector));
}

@end
