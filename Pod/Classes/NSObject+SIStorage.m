//
//  NSObject+SIStorage.m
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-01.
//
//

#import <CocoaLumberjack/CocoaLumberjack.h>
#ifdef DEBUG
static const DDLogLevel ddLogLevel = DDLogLevelVerbose;
#else
static const DDLogLevel ddLogLevel = DDLogLevelWarning;
#endif

#import "SIStoryboardI18N.h"
#import <BlocksKit/BlocksKit.h>

@implementation NSObject (SIStorage)

- (void)si_setOriginalContent:(id)content
{
    DDLogDebug(@"Set original text to: %@", content);
    [self bk_associateCopyOfValue:content withKey:@selector(si_originalContent)];
}

- (id)si_originalContent
{
    return [self bk_associatedValueForKey:@selector(si_originalContent)];
}

- (void)si_setOriginalContent:(id)content withKey:(const void *)key
{
    DDLogDebug(@"Set original text with key to: %@", content);
    [self bk_associateCopyOfValue:content withKey:key];
}

- (id)si_originalContentForKey:(const void *)key
{
    return [self bk_associatedValueForKey:key];
}



-(void)si_setContentCustomized:(BOOL)customized;
{
    [self bk_associateCopyOfValue:@(customized) withKey:@selector(si_isContentCustomized)];
}

-(BOOL)si_isContentCustomized;
{
    return [[self bk_associatedValueForKey:@selector(si_isContentCustomized)] boolValue];
}

@end
