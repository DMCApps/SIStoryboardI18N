//
//  UIView+StoryboardI18N.h
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-03.
//
//

#import <UIKit/UIKit.h>

@interface UIView (StoryboardI18N)
- (void)si_localizeStrings;
- (void)si_localizeStringsAndSubviews;

-(UIViewController*)si_viewController;
-(UIViewController *)si_topMostController;
-(UIView*)si_superviewOfClassType:(Class)classType;
@end