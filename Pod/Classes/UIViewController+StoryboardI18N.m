//
//  UIViewController+StoryboardI18N.m
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
static const DDLogLevel ddLogLevel = DDLogLevelInfo;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

#import <objc/runtime.h>

#import "SIStoryboardI18N.h"

@implementation UIViewController (StoryboardI18N)

- (void)si_localizeCommonProperties
{
    
    if (![[SIStoryboardI18N sharedManager] viewControllerIsEnabled:self]) {
        DDLogDebug(@"StoryboardI18N Not Localizing controller (exlcuded via class): %@", self);
        return;
    }
    
    if (self.title) {
        self.title = StoryboardI18NLocalizedString(self.title);
    }
    if (self.navigationItem) {
        DDLogDebug(@"StoryboardI18N nav item: %@", self.navigationItem);

        if (self.navigationItem.title.length > 0) {
            self.navigationItem.title = StoryboardI18NLocalizedString(self.navigationItem.title);
        }
        [self.navigationItem.leftBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *item, NSUInteger idx, BOOL *stop) {
            item.title = StoryboardI18NLocalizedString(item.title);
        }];
        [self.navigationItem.rightBarButtonItems enumerateObjectsUsingBlock:^(UIBarButtonItem *item, NSUInteger idx, BOOL *stop) {
            item.title = StoryboardI18NLocalizedString(item.title);
        }];
        if (self.navigationItem.backBarButtonItem) {
            self.navigationItem.backBarButtonItem.title = StoryboardI18NLocalizedString(self.navigationItem.backBarButtonItem.title);
        }
        if (self.navigationItem.prompt.length > 0) {
            self.navigationItem.prompt = StoryboardI18NLocalizedString(self.navigationItem.prompt);
        }
    }
    if (self.tabBarItem) {
        if (self.tabBarItem.title.length > 0) {
            self.tabBarItem.title = StoryboardI18NLocalizedString(self.tabBarItem.title);
        }
    }
}

- (void)si_localizeViewHeirachy
{
    [self.view si_localizeStringsAndSubviews];
}

- (void)si_localizeStringsInViews:(NSArray *)views
{
    if (!views || views.count == 0)
        return;
    for (UIView *view in views) {
        [self si_localizeStringsInView:view];
    }
}

- (void)si_localizeStringsInView:(UIView *)view
{
    [view si_localizeStrings];
}

#pragma mark - Method Swizzling

- (void)si_swizzledAwakeFromNib
{
    [self si_localizeCommonProperties];
    // Now call the original...
    [self si_swizzledAwakeFromNib];
}

- (void)si_swizzledViewDidLoad
{
    // Now call the original...
    [self si_localizeCommonProperties];
    [self si_localizeViewHeirachy];
    [self si_swizzledViewDidLoad];
}

+ (void)load
{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzelSelector:@selector (awakeFromNib)
                                 with:@selector (si_swizzledAwakeFromNib)];
        [[self class] swizzelSelector:@selector (viewDidLoad)
                                 with:@selector (si_swizzledViewDidLoad)];
    });

}

+ (void)swizzelSelector:(SEL)originalSelector with:(SEL)swizzledSelector
{
    // When swizzling a class method, use the following:
    // Class class = object_getClass((id)self);
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod (class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod (class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod (class,
                     originalSelector,
                     method_getImplementation (swizzledMethod),
                     method_getTypeEncoding (swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod (class,
                             swizzledSelector,
                             method_getImplementation (originalMethod),
                             method_getTypeEncoding (originalMethod));
    } else {
        method_exchangeImplementations (originalMethod, swizzledMethod);
    }

    NSLog(@"Swizzled: %@ %s with %s", self, sel_getName(swizzledSelector), sel_getName(originalSelector));
}

@end


