//
//  SILocalizationHelper.m
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

#import "SIStoryboardI18N.h"

#define DEFAULT_LANG_CODE_BASE @"Base"
#define DEFAULT_LANG_CODE_EN @"en"

typedef enum : NSUInteger {
    SILocalizationTransformNone,
    SILocalizationTransformUppercase,
    SILocalizationTransformLowercase,
    SILocalizationTransformTitleCase,
} SILocalizationTransform;

static NSMutableDictionary *languageBundles;

@implementation SILocalizationHelper
+ (NSString *)si_localizeString:(NSString *)key
{
    if (!languageBundles) {
        languageBundles = [NSMutableDictionary new];
    }
    
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
    
    NSBundle *bundle = [SILocalizationHelper si_findBundleForPreferredLanguage];
    
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

/**
 *  Looks through the preferred languages of the device for the first available Localizable.strings.
 *  If there is no Localizable.strings is found for the preferred languages, the Base Localizable.strings will be checked for.
 *  Furthermore if no Base Localizable.strings exists, we look for en Localizable.strings
 *
 *  @return
 *      Bundle for the given language
 *      nil if not found
 */
+ (NSBundle *)si_findBundleForPreferredLanguage {
    
    // Find the first language code in the preferredLanguages that has a Localizable.strings file.
    NSArray *langCodes = [NSLocale preferredLanguages];
    NSString *langCode = nil;
    for (NSString *langCodeWithRegion in langCodes) {
        langCode = [SILocalizationHelper si_bundleForLangCode:langCodeWithRegion];
        if (langCode) {
            break;
        }
    }
    
    // Attempt Base Localizable.strings.
    if (!langCode && ([SILocalizationHelper si_bundleLangCodeExists:DEFAULT_LANG_CODE_BASE] || [SILocalizationHelper si_generateBundleForLangCode:DEFAULT_LANG_CODE_BASE])) {
        langCode = DEFAULT_LANG_CODE_BASE;
    }
    
    // Base doesn't exists. Try English
    if (!langCode && ([SILocalizationHelper si_bundleLangCodeExists:DEFAULT_LANG_CODE_EN] || [SILocalizationHelper si_generateBundleForLangCode:DEFAULT_LANG_CODE_EN])) {
        langCode = DEFAULT_LANG_CODE_EN;
    }
    
    return languageBundles[langCode];
}

/**
 *  This method attempts to create a bundle for the given language. If the bundle is found it is added to the languageBundles and the
 *  language code is returned.
 *
 *  @param
 *      langCode - The language code with region to search for.
 *
 *  @return
 *      language code if bundle is generated
 *      else nil
 */
+ (NSString *)si_bundleForLangCode:(NSString *)langCode {
    if ([SILocalizationHelper si_bundleLangCodeExists:langCode] || [SILocalizationHelper si_generateBundleForLangCode:langCode]) {
        return langCode;
    }
    // Check if the language has a region on the end of it.
    // If it doesn't there is no need for this secondary check since the primary check already looked for the main langCode in the bundle.
    else if ([langCode containsString:@"-"]) {
        NSRange rangeOfRegionStart = [langCode rangeOfString:@"-" options:NSBackwardsSearch];
        langCode = [langCode substringToIndex:rangeOfRegionStart.location];
    
        if ([SILocalizationHelper si_bundleLangCodeExists:langCode] || [SILocalizationHelper si_generateBundleForLangCode:langCode]) {
            return langCode;
        }
    }
    
    return nil;
}

/**
 *  Attempts to create the bundle and add it to the cache for the given language code. If the current language code doesn't exist,
 *  then we remove the language code and check for the language code itself.
 *
 *  @param
 *      langCode -> The language code (including region) to search for a Localizable.strings file
 *
 *  @return
 *      YES -> Bundle is cached OR created.
 *      NO -> Bundle could not be found or created.
 */
+ (BOOL)si_generateBundleForLangCode:(NSString *)langCode {
    if ([SILocalizationHelper si_bundleLangCodeExists:langCode]) {
        return YES;
    }
    
    NSString *path = [[[NSBundle mainBundle] pathForResource:@"Localizable" ofType:@"strings" inDirectory:nil forLocalization:langCode] stringByDeletingLastPathComponent];
    
    if (path) {
        languageBundles[langCode] = [[NSBundle alloc] initWithPath:path];
        return YES;
    }
    
    return NO;
}

/**
 *  Check if the given langCode exists in the cache
 *
 *  @param
 *      langCode -> Language code to look for in the cache
 *
 *  @return
 *      YES -> Exists in the Cache
 *      NO -> Doesn't exist in the Cache
 */
+ (BOOL)si_bundleLangCodeExists:(NSString *)langCode {
    return languageBundles[langCode];
}

@end
