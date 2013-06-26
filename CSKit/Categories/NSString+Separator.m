//
//  NSString+Separator.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-16.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "NSString+Separator.h"

@implementation NSString (Separator)

- (NSArray *)separatedCharStringArrayWithTail:(BOOL)withTail
{
    if (self.length == 0) return nil;
    
    NSMutableArray *chars = [[NSMutableArray alloc] init];
    NSRange unitRange = {0, 1};
    
    for (NSUInteger i = 0; i < self.length; i++) {
        [chars addObject:[self substringWithRange:unitRange]];
        unitRange.location++;
    }
    
    NSMutableArray *result = [NSMutableArray arrayWithArray:chars];
    [result addObject:@"\\0"];
    
    return [result copy];
}

- (BOOL)isLetters
{
	if([self length] <= 0)
		return NO;
    NSString *regex = @"[a-zA-Z]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumbers
{
	if([self length] <= 0)
		return NO;
    NSString *regex = @"[0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumberOrLetters
{
	if([self length] <= 0)
		return NO;
    NSString *regex = @"[a-zA-Z0-9]*";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

@end
