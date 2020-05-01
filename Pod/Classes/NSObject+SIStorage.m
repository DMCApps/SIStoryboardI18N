//
//  NSObject+SIStorage.m
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
#import "NSObject+BKAssociatedObjects.h"

@implementation NSObject (SIStorage)

- (void)si_setOriginalContent:(id)content
{
    //NSLog(@"Set original text to: %@", content);
    [self bk_associateCopyOfValue:content withKey:@selector(si_originalContent)];
}

- (id)si_originalContent
{
    return [self bk_associatedValueForKey:@selector(si_originalContent)];
}

- (void)si_setOriginalContent:(id)content withKey:(const void *)key
{
    //NSLog(@"Set original text with key to: %@", content);
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
