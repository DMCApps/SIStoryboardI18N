//
//  SIStoryboardI18N.h
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
 List of localizations table to be searched in proder of preference. By default Localizable will be searched FIRST, followed by these.
 */
@property(nonatomic, strong, nonnull, readonly) NSMutableSet<NSString *> *searchTables;

/**
 Forces the bundle to use a specific locale
 */
@property(nonatomic, readwrite) NSString *forcedLocale;

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
