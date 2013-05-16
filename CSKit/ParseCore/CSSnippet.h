//
//  CSSnippet.h
//  Code
//
//  Created by Zhang Studyro on 13-2-13.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CSSnippet : NSObject

@property (nonatomic, strong) NSArray *subSnippets;
@property (nonatomic, assign) NSRange textRange;

- (instancetype)initWithRangeLocation:(NSUInteger)location length:(NSUInteger)length;

@end
