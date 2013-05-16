//
//  CSCodeParser.m
//  Code
//
//  Created by Zhang Studyro on 13-2-13.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSCodeParser.h"

struct ShouldHandleKeys {
    NSUInteger inBracketCount;
    BOOL isBehindEqual;
};

@interface CSCodeParser()
{
    struct ShouldHandleKeys _shouldHandleKeys;
}

@property (strong, nonatomic) NSMutableArray *parentSnippetsStack;
@property (strong, nonatomic) NSMutableArray *parentSubSnippetMutableArrayStack;

@end

@implementation CSCodeParser


- (id)init
{
    if (self = [super init]) {
        _shouldHandleKeys.inBracketCount = 0;
        _shouldHandleKeys.isBehindEqual = NO;
        
        _snippetsTree = [[NSMutableArray alloc] initWithCapacity:3];
        
        [self _pushIntoParentsChildrenStackWithSnippetArray:_snippetsTree];
    }
    
    return self;
}

- (CSSnippet *)_popFromParentSnippetStack
{
    if ([self.parentSnippetsStack count] == 0) return nil;
    CSSnippet *currentParentSnippet = [self.parentSnippetsStack lastObject];
    [self.parentSnippetsStack removeLastObject];
    return currentParentSnippet;
}

- (void)_pushIntoParentSnippetStackWithSnippet:(CSSnippet *)snippet
{
    if (self.parentSnippetsStack == nil)
        self.parentSnippetsStack = [[NSMutableArray alloc] init];
    [self.parentSnippetsStack addObject:snippet];
}

- (NSMutableArray *)_popFromParentsChildrenStack
{
    if ([self.parentSubSnippetMutableArrayStack count] == 0) return nil;
    NSMutableArray *currentParentsChildren = [self.parentSubSnippetMutableArrayStack lastObject];
    [self.parentSubSnippetMutableArrayStack removeLastObject];
    return currentParentsChildren;
}

- (void)_pushIntoParentsChildrenStackWithSnippetArray:(NSMutableArray *)snippetMutableArray
{
    if (self.parentSubSnippetMutableArrayStack == nil)
        self.parentSubSnippetMutableArrayStack = [[NSMutableArray alloc] init];
    [self.parentSubSnippetMutableArrayStack addObject:snippetMutableArray];
}

- (void)_handleScannerAccordingToSeparator:(NSString *)character
{
    if ([character isEqualToString:@";"]) {
        // a simple sentence.
        CSSnippet *lineSnippet = [[CSSnippet alloc] initWithRangeLocation:[_mainScanner scanLocation] length:[_separatorScanner scanLocation] - [_mainScanner scanLocation] + 1];
        NSMutableArray *currentParentsChildren = [self _popFromParentsChildrenStack];
        [currentParentsChildren addObject:lineSnippet];
        [self _pushIntoParentsChildrenStackWithSnippetArray:currentParentsChildren];
    }
    else if ([character isEqualToString:@"}"]) {
        // this case will complete the situation below.
        CSSnippet *currentParentSnippet = [self _popFromParentSnippetStack];
        NSRange finishedRange;
        finishedRange.location = currentParentSnippet.textRange.location;
        finishedRange.length = [_separatorScanner scanLocation] - currentParentSnippet.textRange.location + 1;
        
        currentParentSnippet.textRange = finishedRange;
        currentParentSnippet.subSnippets = [self _popFromParentsChildrenStack];
        if ([self.parentSubSnippetMutableArrayStack count]) {
            NSMutableArray *parentChildrenArray = [self _popFromParentsChildrenStack];
            [parentChildrenArray addObject:currentParentSnippet];
            [self _pushIntoParentsChildrenStackWithSnippetArray:parentChildrenArray];
        }
    }
    else if ([character isEqualToString:@"{"]) {
        // this is a imcompleted snippet which indicates beginning of a code block.
        CSSnippet *aNewParentSnippet = [[CSSnippet alloc] initWithRangeLocation:[_mainScanner scanLocation] length:0];
        NSMutableArray *aNewParentChildrenArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        [self _pushIntoParentSnippetStackWithSnippet:aNewParentSnippet];
        [self _pushIntoParentsChildrenStackWithSnippetArray:aNewParentChildrenArray];
    }
    
    if (![_separatorScanner isAtEnd]) {
        [_mainScanner setScanLocation:_separatorScanner.scanLocation + 1];
    }
}

- (BOOL)_isSeparatorCharacterWithString:(NSString *)character
{
    if ([character isEqualToString:@"{"] || [character isEqualToString:@"}"] || [character isEqualToString:@";"])
        return YES;
    return NO;
}

- (BOOL)_isIgnorableSeperatorWithString:(NSString *)character
{
    BOOL isIgnorable;
    if ([@"()=" rangeOfString:character].location != NSNotFound) {
        if ([character isEqualToString:@"("])
            _shouldHandleKeys.inBracketCount++;
        else if ([character isEqualToString:@")"])
            _shouldHandleKeys.inBracketCount--;
        else if ([character isEqualToString:@"="]) {
            if (_shouldHandleKeys.inBracketCount == 0)
                _shouldHandleKeys.isBehindEqual = YES;
            else
                _shouldHandleKeys.isBehindEqual = NO;
        }
        isIgnorable = YES;
    }
    else {
        isIgnorable = NO;
        if (_shouldHandleKeys.inBracketCount) {
            // any char in bracket shouldn't be regarded as separator
            isIgnorable = YES;
        }
        else {
            if ([character isEqualToString:@";"]) {
                // a ';' out of bracket will terminate an equal.
                _shouldHandleKeys.isBehindEqual = NO;
            }
            else if (_shouldHandleKeys.isBehindEqual == YES) {
                // '{' or '}' behind '=' shouldn't be ragarded as separator
                isIgnorable = YES;
            }
        }
    }
    
    return isIgnorable;
}

- (NSArray *)snippetsArrayByString:(NSString *)codeText
{
    if (!codeText || ![codeText length]) return nil;
    
    _mainScanner = [[NSScanner alloc] initWithString:codeText];
    [_mainScanner setCharactersToBeSkipped:nil];
    // mainSet also includes letter set, cuz there're cases that a separator may be tightly behind a separator.
    NSMutableCharacterSet *mainSet = [NSMutableCharacterSet letterCharacterSet];
    [mainSet addCharactersInString:@";{}"];
    
    _separatorScanner = [[NSScanner alloc] initWithString:codeText];
    [_separatorScanner setCharactersToBeSkipped:nil];
    NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@";{}()="];
    NSString *mainScannedTempString = nil;
    NSRange unitRange;
    unitRange.length = 1;
    while ([_mainScanner scanUpToCharactersFromSet:mainSet intoString:nil]) {
        unitRange.location = [_mainScanner scanLocation];
        mainScannedTempString = [codeText substringWithRange:unitRange];
        [_separatorScanner setScanLocation:[_mainScanner scanLocation]];
        
        if (![self _isSeparatorCharacterWithString:mainScannedTempString]) {
            NSString *character = nil;
            BOOL isIgnorable = YES;
            while (isIgnorable) {
                [_separatorScanner scanUpToCharactersFromSet:separatorSet intoString:NULL];
                unitRange.location = [_separatorScanner scanLocation];
                
                character = [codeText substringWithRange:unitRange];
                
                isIgnorable = [self _isIgnorableSeperatorWithString:character];
                if (![_separatorScanner isAtEnd] && isIgnorable)
                    [_separatorScanner setScanLocation:[_separatorScanner scanLocation] + 1];
            }
            [self _handleScannerAccordingToSeparator:character];
        }
        else
            [self _handleScannerAccordingToSeparator:mainScannedTempString];
    }
    
    return [_snippetsTree copy];
}

@end
