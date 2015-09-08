//
//  UIViewController+Navigation.h


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
