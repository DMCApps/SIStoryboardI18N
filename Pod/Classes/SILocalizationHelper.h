//
//  SILocalizationHelper.h
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-03.
//
//

#import <Foundation/Foundation.h>

#define StoryboardI18NLocalizedString(key) \
[SILocalizationHelper si_localizeString:(key)]

@interface SILocalizationHelper : NSObject
+ (NSString *)si_localizeString:(NSString *)key;
+ (void)si_setLocalization:(NSString *)locale;
@end
