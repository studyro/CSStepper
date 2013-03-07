//
//  CSSnippet.m
//  Code
//
//  Created by Zhang Studyro on 13-2-13.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSSnippet.h"

@implementation CSSnippet

- (void)dealloc
{
    [_subSnippets release];
    
    [super dealloc];
}

- (instancetype)initWithRangeLocation:(NSUInteger)location length:(NSUInteger)length
{
    if (self = [super init]) {
        _textRange.location = location;
        _textRange.length = length;
    }
    
    return self;
}

- (NSString *)description
{
    NSMutableString *string = [NSMutableString stringWithFormat:@"\n-location : %d, length, %d", self.textRange.location, self.textRange.length];
    if (self.subSnippets) {
        [string appendFormat:@"has %d children", [self.subSnippets count]];
        for (id snippet in self.subSnippets)
            [string appendFormat:@"\n\t\t %@", [snippet description]];
    }
    
    
    return string;
}

@end
