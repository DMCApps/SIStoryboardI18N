//
//  SILocalizationHelper.m
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-03.
//
//

#import "SIStoryboardI18N.h"

@implementation SILocalizationHelper
+ (NSString *)si_localizeString:(NSString *)key
{
    if ([key hasPrefix:@"_"]) {
        return key;
    }
    
    BOOL upperCase = NO;
    upperCase = [key hasPrefix:@"uc:"];
    if (upperCase) {
        key = [key substringFromIndex:3];
    }
    
    NSString *loc = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"AppleLanguages"] firstObject];
    NSString *path = [[[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:loc] stringByDeletingLastPathComponent];
    if (!path) {
        path = [[[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:@"Base"] stringByDeletingLastPathComponent];
    }
    NSBundle *bundle = [[NSBundle alloc] initWithPath:path];
    
    NSString *translated = NSLocalizedStringFromTableInBundle(key, nil, bundle, @"StoryboardI18N");
    
    if (upperCase) {
        return translated.uppercaseString;
    }
    
    return translated;
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
