//
//  CSProgram.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSProgram.h"
#import "CSCodeParser.h"

@interface CSProgram ()
{
    NSUInteger _currentStep;
    NSMutableArray *_necessarySnippets;
}
@property (nonatomic, retain) CSCodeView *codeView;
@end

@implementation CSProgram

- (void)dealloc
{
    [_codeText release];
    [_necessarySnippets release];
    
    [super dealloc];
}

- (CSSnippet *)_snippetWithIndexPath:(NSIndexPath *)indexPath totalArray:(NSArray *)array;
{
    NSUInteger indices[[indexPath length]];
    [indexPath getIndexes:indices];
    
    NSUInteger itr = 0;
    CSSnippet *snippet = [array objectAtIndex:indices[itr++]];
    while (itr < [indexPath length]) {
        snippet = [snippet.subSnippets objectAtIndex:indices[itr]];
        itr++;
    }
    
    return snippet;
}

- (instancetype)initWithCodeText:(NSString *)codeText indexPaths:(NSArray *)indexPaths
{
    if (self = [super init]) {
        _codeText = [codeText copy];
        CSCodeParser *parser = [[CSCodeParser alloc] init];
        NSArray *totalSnippetsArray = [parser snippetsArrayByString:codeText];
        [parser release];
        
        _necessarySnippets = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in indexPaths)
            [_necessarySnippets addObject:[self _snippetWithIndexPath:indexPath totalArray:totalSnippetsArray]];
        
        _currentStep = 0;
    }
    
    return self;
}

- (void)acceptCodeView:(CSCodeView *)codeView
{
    self.codeView = codeView;
}

- (void)nextStep
{
    if ([self hasNext]) {
        self.currentRange = ((CSSnippet *)[_necessarySnippets objectAtIndex:++_currentStep]).textRange;
        [self.codeView highlightTextInRange:self.currentRange];
    }
}

- (void)lastStep
{
    if (_currentStep > 0) {
        self.currentRange = ((CSSnippet *)[_necessarySnippets objectAtIndex:--_currentStep]).textRange;
        [self.codeView highlightTextInRange:self.currentRange];
    }
}

- (BOOL)hasNext
{
    return [_necessarySnippets count] - 1 - _currentStep;
}

@end
