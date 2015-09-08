//
//  UIViewController+StoryboardI18N.h

#import <UIKit/UIKit.h>

@interface UIViewController (StoryboardI18N)

- (void)si_localizeCommonProperties;
- (void)si_localizeViewHeirachy;

- (void)si_localizeStringsInViews:(NSArray *)views;
- (void)si_localizeStringsInView:(UIView *)view;

@end

