//
//  SILocalizationHelper.m
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-03.
//
//

#import "SIStoryboardI18N.h"

typedef enum : NSUInteger {
    SILocalizationTransformNone,
    SILocalizationTransformUppercase,
    SILocalizationTransformLowercase,
    SILocalizationTransformTitleCase,
} SILocalizationTransform;

@implementation SILocalizationHelper
+ (NSString *)si_localizeString:(NSString *)key
{
    if ([key hasPrefix:@"_"]) {
        return key;
    }
    
    SILocalizationTransform transform = SILocalizationTransformNone;
    if([key hasPrefix:@"uc:"]) {
        transform = SILocalizationTransformUppercase;
    } else if([key hasPrefix:@"lc:"]) {
        transform = SILocalizationTransformLowercase;
    } else if([key hasPrefix:@"tc:"]) {
        transform = SILocalizationTransformTitleCase;
    }
    
    if (transform != SILocalizationTransformNone) {
        key = [key substringFromIndex:3];
    }
    
    NSString *loc = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"] firstObject];
    NSArray *deviceLang = [NSLocale preferredLanguages];
    if (![deviceLang containsObject:loc]) {
        loc = [deviceLang firstObject];
    }
    loc = [[loc componentsSeparatedByString:@"-"] firstObject];
    NSString *path = [[[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:loc] stringByDeletingLastPathComponent];
    if (!path) {
        path = [[[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:@"Base"] stringByDeletingLastPathComponent];
    }
    
    NSBundle *bundle = [[NSBundle alloc] initWithPath:path];
    
    NSString *translated = NSLocalizedStringFromTableInBundle(key, nil, bundle, @"StoryboardI18N");
    
    switch (transform) {
        default:
            return translated;
        case SILocalizationTransformUppercase:
            return translated.uppercaseString;
        case SILocalizationTransformLowercase:
            return translated.lowercaseString;
        case SILocalizationTransformTitleCase:
            return translated.capitalizedString;
    }
}

+ (void)si_setLocalization:(NSString *)locale
{
    NSArray *AppleLanguages = [[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"];
    if (!AppleLanguages) {
        AppleLanguages = [NSArray new];
    }
    NSMutableArray *mutableLanguageSet = [AppleLanguages mutableCopy];
    [mutableLanguageSet removeObject:locale];
    [mutableLanguageSet insertObject:locale atIndex:0];
    [[NSUserDefaults standardUserDefaults] setObject:mutableLanguageSet forKey:@"AppleLanguages"];
    [[NSUserDefaults standardUserDefaults] synchronize]; //to make the change immediate
    UIView *rootView = [[UIApplication sharedApplication].delegate window].rootViewController.view;
    // TODO use si_setLocalizationNeedsUpdate
    // TODO use si_updateLocalization
    [rootView si_localizeStringsAndSubviews];
}

@end
