//
//  NSObject+SIStorage.h
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-01.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (SIStorage)

-(void)si_setOriginalContent:(id)content;
-(id)si_originalContent;

- (void)si_setOriginalContent:(id)content withKey:(const void *)key;
- (id)si_originalContentForKey:(const void *)key;

-(void)si_setContentCustomized:(BOOL)customized;
-(BOOL)si_isContentCustomized;

@end
