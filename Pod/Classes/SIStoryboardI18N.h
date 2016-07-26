//
//  SIStoryboardI18N.h
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-03.
//
//

#import <SIStoryboardI18N/UIViewController+Navigation.h>
#import <SIStoryboardI18N/UIViewController+StoryboardI18N.h>
#import <SIStoryboardI18N/UIView+StoryboardI18N.h>
#import <SIStoryboardI18N/SILocalizationHelper.h>
#import <SIStoryboardI18N/NSObject+SIStorage.h>
#import <SIStoryboardI18N/SIEmptySegue.h>



@interface SIStoryboardI18N : NSObject

@property(nonatomic, assign) BOOL enableDebugging;

/**
 Returns the default singleton instance.
 */
+ (nonnull instancetype)sharedManager;

/**
 Enable/disable managing localization of storyboards. Default is YES(Enabled when class loads in `+(void)load` method).
 */
@property(nonatomic, assign, getter = isEnabled) BOOL enable;

/**
 Disable automatic localization within the scope of disabled viewControllers classes. Within this scope, 'enableAutomaticLocalization' property is ignored. Class should be kind of UIViewController.
 */
@property(nonatomic, strong, nonnull, readonly) NSMutableSet<Class> *disabledClasses;

/**
 Enable automatic localization within the scope of enabled viewControllers classes. Within this scope, 'enableAutomaticLocalization' property is ignored. Class should be kind of UIViewController. If same Class is added in disabledClasses list, then enabledClasses will be ignored.
 */
@property(nonatomic, strong, nonnull, readonly) NSMutableSet<Class> *enabledClasses;

/**
 Unavailable. Please use sharedManager method
 */
-(nonnull instancetype)init NS_UNAVAILABLE;

/**
 Unavailable. Please use sharedManager method
 */
+ (nonnull instancetype)new NS_UNAVAILABLE;

-(BOOL)subviewIsEnabled:(UIView * _Nullable)subview;

-(BOOL)viewControllerIsEnabled:(UIViewController * _Nullable)viewController;

@end
