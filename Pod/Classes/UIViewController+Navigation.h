//
//  UIViewController+Navigation.h
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

#import <UIKit/UIKit.h>

#define NavSegueMatches(segue, segueName) \
    ([segue.identifier isEqualToString:segueName])
#define NavSegueIdentifierMatches(identifier, segueName) \
    ([identifier isEqualToString:segueName])
#define NavSegueForRootInStoryboard(storyboardName) \
    [storyboardName stringByAppendingString:@"RootControllerSegue"]
#define NavStoryboardNameForClass(className) \
    NSStringFromClass ([className class])
#define NavSegueForClass(className) \
    [NavStoryboardNameForClass (className) stringByAppendingString:@"Segue"]
#define NavDynamicSegueForClassInStoryboard(className, storyboardName) \
    [NSString stringWithFormat:@"%@%@Segue", storyboardName, NavStoryboardNameForClass (className)]

typedef enum : NSUInteger {
    NavigationButtonItemPositionFirst,
    NavigationButtonItemPositionLast,
} NavigationButtonItemPosition;

@interface UIViewController (Navigation)

@property (assign, nonatomic, getter=isCustomNavigationTitleDisabled) BOOL customNavigationTitleDisabled;

- (UIViewController *)nav_loadRootControllerFromStoryboard:(NSString *)storyboardName;
- (UIViewController *)nav_loadRootControllerFromStoryboard:(NSString *)storyboardName segueClass:(Class)segueClass;
- (UIViewController *)nav_loadController:(NSString *)controllerIdentifier fromStoryboard:(NSString *)storyboardName;
- (UIViewController *)nav_loadController:(NSString *)controllerIdentifier fromStoryboard:(NSString *)storyboardName segueClass:(Class)segueClass;

- (id)nav_pushViewControllerWithIdentifier:(NSString *)controllerIdentifier fromStoryboard:(NSString *)storyboardName animated:(BOOL)animated;

- (id)nav_firstChildController:(id)viewController;

- (void)nav_appendRightBarButtonItem:(UIBarButtonItem *)item position:(NavigationButtonItemPosition)position animated:(BOOL)animated;
@end
