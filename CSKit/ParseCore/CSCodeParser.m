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
    NSMutableArray *_parentSnippetsStack;
    NSMutableArray *_parentSubSnippetMutableArrayStack;
    struct ShouldHandleKeys _shouldHandleKeys;
}
@end

@implementation CSCodeParser

- (void)dealloc
{
    if (_parentSnippetsStack) [_parentSnippetsStack release];
    if (_parentSubSnippetMutableArrayStack) [_parentSubSnippetMutableArrayStack release];
    if (_snippetsTree) [_snippetsTree release];
    
    if (_mainScanner) [_mainScanner release];
    if (_separatorScanner) [_separatorScanner release];
    
    [super dealloc];
}

- (id)init
{
    if (self = [super init]) {
        _shouldHandleKeys.inBracketCount = 0;
        _shouldHandleKeys.isBehindEqual = NO;
    }
    
    return self;
}

- (CSSnippet *)_popFromParentSnippetStack
{
    if ([_parentSnippetsStack count] == 0) return nil;
    CSSnippet *currentParentSnippet = [[_parentSnippetsStack lastObject] retain];
    [_parentSnippetsStack removeLastObject];
    return [currentParentSnippet autorelease];
}

- (void)_pushIntoParentSnippetStackWithSnippet:(CSSnippet *)snippet
{
    if (_parentSnippetsStack == nil)
        _parentSnippetsStack = [[NSMutableArray alloc] init];
    [_parentSnippetsStack addObject:snippet];
}

- (NSMutableArray *)_popFromParentsChildrenStack
{
    if ([_parentSubSnippetMutableArrayStack count] == 0) return nil;
    NSMutableArray *currentParentsChildren = [[_parentSubSnippetMutableArrayStack lastObject] retain];
    [_parentSubSnippetMutableArrayStack removeLastObject];
    return [currentParentsChildren autorelease];
}

- (void)_pushIntoParentsChildrenStackWithSnippetArray:(NSMutableArray *)snippetMutableArray
{
    if (_parentSubSnippetMutableArrayStack == nil)
        _parentSubSnippetMutableArrayStack = [[NSMutableArray alloc] init];
    [_parentSubSnippetMutableArrayStack addObject:snippetMutableArray];
}

- (void)_handleScannerAccordingToSeparator:(NSString *)character
{
    if ([character isEqualToString:@";"]) {
        // a simple sentence.
        CSSnippet *lineSnippet = [[CSSnippet alloc] initWithRangeLocation:[_mainScanner scanLocation] length:[_separatorScanner scanLocation] - [_mainScanner scanLocation] + 1];
        NSMutableArray *currentParentsChildren = [self _popFromParentsChildrenStack];
        [currentParentsChildren addObject:lineSnippet];
        [lineSnippet release];
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
        
        if ([_parentSubSnippetMutableArrayStack count]) {
            NSMutableArray *parentChildrenArray = [self _popFromParentsChildrenStack];
            [parentChildrenArray addObject:currentParentSnippet];
            [self _pushIntoParentsChildrenStackWithSnippetArray:parentChildrenArray];
        }
    }
    else if ([character isEqualToString:@"{"]) {
        // this is a imcompleted snippet which indicates beginning of a code block.
        CSSnippet *aNewParentSnippet = [[CSSnippet alloc] initWithRangeLocation:[_mainScanner scanLocation] length:0];
        NSMutableArray *aNewParentChildrenArray = [[NSMutableArray alloc] initWithCapacity:5];
        
        if ([_parentSnippetsStack count] == 0) {
            if (_snippetsTree == nil)
                _snippetsTree = [[NSMutableArray alloc] initWithCapacity:3];
            
            [_snippetsTree addObject:aNewParentSnippet];
        }
        
        [self _pushIntoParentSnippetStackWithSnippet:aNewParentSnippet];
        [aNewParentSnippet release];
        [self _pushIntoParentsChildrenStackWithSnippetArray:aNewParentChildrenArray];
        [aNewParentChildrenArray release];
    }
    
    // _mainScanner should scan beginning with separator location next turn.
    if ([_separatorScanner scanLocation] < [[_separatorScanner string] length] - 1)
        [_mainScanner setScanLocation:[_separatorScanner scanLocation] + 1];
    else
        [_mainScanner setScanLocation:[_separatorScanner scanLocation]];
}

- (BOOL)_isSeparatorCharacterWithString:(NSString *)character
{
    if ([character isEqualToString:@"{"] || [character isEqualToString:@"}"] || [character isEqualToString:@";"])
        return YES;
    return NO;
}

- (BOOL)_isIgnorableSeperatorWithString:(NSString *)character
{
    if (character == nil || (_shouldHandleKeys.inBracketCount && ![character isEqualToString:@")"])) return YES;
    
    if ([character isEqualToString:@";"] && _shouldHandleKeys.isBehindEqual == YES) {
        _shouldHandleKeys.isBehindEqual = NO;
        return NO;
    }
    if ([@"()=" rangeOfString:character].location != NSNotFound) {
        if ([character isEqualToString:@"("])
            _shouldHandleKeys.inBracketCount++;
        else if ([character isEqualToString:@")"])
            _shouldHandleKeys.inBracketCount--;
        else if ([character isEqualToString:@"="])
            _shouldHandleKeys.isBehindEqual = YES;
        
        return YES;
    }
    else
        return _shouldHandleKeys.isBehindEqual || _shouldHandleKeys.inBracketCount;
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
            while ([self _isIgnorableSeperatorWithString:character]) {
                [_separatorScanner scanUpToCharactersFromSet:separatorSet intoString:NULL];
                unitRange.location = [_separatorScanner scanLocation];
                character = [codeText substringWithRange:unitRange];
                
                if (![_separatorScanner isAtEnd])
                    [_separatorScanner setScanLocation:[_separatorScanner scanLocation] + 1];
            }
            [self _handleScannerAccordingToSeparator:character];
        }
        else
            [self _handleScannerAccordingToSeparator:mainScannedTempString];
    }
    
    return [[_snippetsTree copy] autorelease];
}

@end
