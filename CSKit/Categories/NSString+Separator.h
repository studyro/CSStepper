//
//  NSString+Separator.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-16.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Separator)

- (NSArray *)separatedCharStringArrayWithTail:(BOOL)withTail;

- (BOOL)isLetters;
- (BOOL)isNumbers;
- (BOOL)isNumberOrLetters;

@end
