//
//  CSCodeParser.h
//  Code
//
//  Created by Zhang Studyro on 13-2-13.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSSnippet.h"

@interface CSCodeParser : NSObject
{
    NSScanner *_mainScanner;
    NSScanner *_separatorScanner;
    NSMutableArray *_snippetsTree;
}

// can only handle code string, there's no error handler.
- (NSArray *)snippetsArrayByString:(NSString *)codeText;

@end
