//
//  NSObject+SIStorage.m
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-01.
//
//

#import "SIStoryboardI18N.h"
#import <BlocksKit/BlocksKit.h>

@implementation NSObject (SIStorage)

- (void)si_setOriginalContent:(id)content
{
    [self bk_associateCopyOfValue:content withKey:@selector(si_originalContent)];
}

- (id)si_originalContent
{
    return [self bk_associatedValueForKey:@selector(si_originalContent)];
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
