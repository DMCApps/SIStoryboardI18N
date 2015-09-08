//
//  UIViewController+Navigation.m


#import <BlocksKit/BlocksKit.h>

#import "SIStoryboardI18N.h"

@implementation UIViewController (Navigation)

+(void)load
{
    NSLog(@"LOAD UIViewController (Navigation)");
}

static void *const KEY_DISABLE_CUSTOM_NAVIGATION_TITLE = (void *)&KEY_DISABLE_CUSTOM_NAVIGATION_TITLE;

- (void)setCustomNavigationTitleDisabled:(BOOL)disabled
{
    [self bk_associateCopyOfValue:@(disabled) withKey:KEY_DISABLE_CUSTOM_NAVIGATION_TITLE];
}

- (BOOL)isCustomNavigationTitleDisabled
{
    return [(NSNumber *)[self bk_associatedValueForKey:KEY_DISABLE_CUSTOM_NAVIGATION_TITLE] boolValue];
}

- (UIViewController *)nav_loadRootControllerFromStoryboard:(NSString *)storyboardName
{
    return [self nav_loadRootControllerFromStoryboard:storyboardName segueClass:nil];
}

- (UIViewController *)nav_loadRootControllerFromStoryboard:(NSString *)storyboardName segueClass:(Class)segueClass
{

    UIStoryboard *storyboard = nil;

    @try {
        storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    }
    @catch (NSException *exception) {
        return nil;
    }

    UIViewController *destinationViewController = nil;
    destinationViewController = [storyboard instantiateInitialViewController];

    NSAssert(destinationViewController != nil, @"Initial View Controller is NULL in storyboard.");

    NSString *segueIdentifier = NavSegueForRootInStoryboard(storyboardName);
    if (!segueClass) {
        segueClass = [SIEmptySegue class];
    }
    id segue = [[segueClass alloc] initWithIdentifier:segueIdentifier source:self destination:destinationViewController];
    [self prepareForSegue:segue sender:self];
    [segue perform];

    return destinationViewController;
}

- (UIViewController *)nav_loadController:(NSString *)controllerIdentifier fromStoryboard:(NSString *)storyBoardName
{
    return [self nav_loadController:controllerIdentifier fromStoryboard:storyBoardName segueClass:nil];
}

- (UIViewController *)nav_loadController:(NSString *)controllerIdentifier fromStoryboard:(NSString *)storyBoardName segueClass:(Class)segueClass
{
    UIStoryboard *storyboard = nil;
    if (!storyBoardName) {
        storyboard = self.storyboard;
    } else {
        storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    }

    UIViewController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    NSString *segueIdentifier = [NSString stringWithFormat:@"%@%@Segue", storyBoardName, controllerIdentifier];
    if (!segueClass) {
        segueClass = [SIEmptySegue class];
    }
    id segue = [[segueClass alloc] initWithIdentifier:segueIdentifier source:self destination:destinationViewController];
    [self prepareForSegue:segue sender:self];
    [segue perform];

    return destinationViewController;
}

- (id)nav_pushViewControllerWithIdentifier:(NSString *)controllerIdentifier fromStoryboard:(NSString *)storyBoardName animated:(BOOL)animated
{
    UIStoryboard *storyboard = nil;
    if (!storyBoardName) {
        storyboard = self.storyboard;
    } else {
        storyboard = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    }

    UIViewController *destinationViewController = [storyboard instantiateViewControllerWithIdentifier:controllerIdentifier];
    [self.navigationController pushViewController:destinationViewController animated:animated];
    return destinationViewController;
}

- (id)nav_firstChildController:(id)viewController;
{
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [(UINavigationController *)viewController viewControllers].firstObject;
    }
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [(UITabBarController *)viewController viewControllers].firstObject;
    } else if ([viewController respondsToSelector:@selector(viewControllers)]) {
        return [viewController viewControllers].firstObject;
    } else {
        return viewController;
    }
}

- (void)nav_appendRightBarButtonItem:(UIBarButtonItem *)item position:(NavigationButtonItemPosition)position animated:(BOOL)animated
{

    NSMutableArray *items = [self.navigationItem.rightBarButtonItems mutableCopy];
    if (!items) {
        items = [NSMutableArray new];
    }
    switch (position) {
    case NavigationButtonItemPositionFirst:
        [items addObject:item];
        break;

    case NavigationButtonItemPositionLast:
        [items insertObject:item atIndex:0];
        break;
    }
    [self.navigationItem setRightBarButtonItems:items animated:animated];
}

@end
