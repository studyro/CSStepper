//
//  CSProgram.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-12.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSProgram.h"
#import "CSCodeParser.h"

#define MAX_INDEXPATH_LENGTH 10

@interface CSProgram ()
{
    BOOL _finished;
}
@property (strong, nonatomic) NSArray *snippetsArray;
@property (strong, nonatomic) NSMutableArray *executedSnippetStack;

@property (strong, nonatomic) NSMutableArray *scopeStack;
@property (strong, nonatomic, readwrite) NSDictionary *currentLoopInfo;

@property (strong, nonatomic, readwrite) NSIndexPath *currentIndexPath;
@property (strong, nonatomic) NSIndexPath *mainIndexPath;
@property (strong, nonatomic, readwrite) NSIndexPath *nextIndexPath;
@property (strong, nonatomic, readonly) CSSnippet *nextSnippet;

@property (strong, nonatomic) NSIndexPath *indexPathToSkip;

@end

@implementation CSProgram

- (id)init
{
    if (self = [super init]) {
        self.executedSnippetStack = [[NSMutableArray alloc] init];
        self.scopeStack = [[NSMutableArray alloc] initWithCapacity:5];
    }
    return self;
}

+ (instancetype)sharedProgram
{
    static dispatch_once_t once;
    static CSProgram *instance;
    dispatch_once(&once, ^ { instance = [[CSProgram alloc] init]; });
    return instance;
}

- (void)setCodeView:(CSCodeView *)codeView
{
    _codeView = codeView;
    [_codeView setText:self.codeText configureWithBlock:nil];
}

- (void)_clearCurrentStatus
{
    [self.scopeStack removeAllObjects];
    [self.executedSnippetStack removeAllObjects];
    self.currentIndexPath = nil;
    self.currentLoopInfo = nil;
    self.indexPathToSkip = nil;
}

- (void)reloadProgram:(kCSProgramCase *)aCase
                error:(NSError *__autoreleasing *)error
{
    _finished = NO;
    self.codeText = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:aCase ofType:@"txt"] encoding:NSUTF8StringEncoding error:error];
    
    if (error) return;
    
    CSCodeParser *parser = [[CSCodeParser alloc] init];
    self.snippetsArray = [parser snippetsArrayByString:self.codeText];
    self.mainIndexPath = [CSUtils mainIndexPathWithCase:aCase];
    
    [self _clearCurrentStatus];
}

- (CSSnippet *)nextSnippet
{
    if (self.nextIndexPath == nil) return nil;
    
    return [self _snippetAtIndexPath:self.nextIndexPath];
}

- (CSSnippet *)_snippetAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.length == 0) return nil;
    
    NSUInteger length = indexPath.length;
    NSUInteger indices[MAX_INDEXPATH_LENGTH];
    [indexPath getIndexes:indices];
    
    CSSnippet *tempSnippet = nil;
    if (indices[0] < [self.snippetsArray count])
        tempSnippet = self.snippetsArray[indices[0]];
    
    for (NSUInteger i = 1; i < length; i++) {
        if ([tempSnippet.subSnippets count] >= indices[i] + 1) {
            tempSnippet = tempSnippet.subSnippets[indices[i]];
        }
        else {
            tempSnippet = nil;
            break;
        }
    }
    
    return tempSnippet;
}

/*
 * 返回以参数indexPath索引路径微标准的统计索引级别下的下一个节点。
 * @shouldSkipping : 是否应该跳过下一个节点。
 */
- (NSIndexPath *)_seriallyNextIndexPathAfterIndexPath:(NSIndexPath *)indexPath shouldSkipping:(BOOL)shouldSkipping
{
    if (!indexPath) return nil;
    
    NSUInteger length = indexPath.length;
    NSUInteger indices[MAX_INDEXPATH_LENGTH];
    [indexPath getIndexes:indices];
    
    indices[length - 1]++;
    
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathWithIndexes:indices length:length];
    
    if (shouldSkipping && self.indexPathToSkip && [self.indexPathToSkip compare:nextIndexPath] == NSOrderedSame) {
        indices[length - 1]++;
        nextIndexPath = [NSIndexPath indexPathWithIndexes:indices length:length];
        self.indexPathToSkip = nil;
    }
    
    return nextIndexPath;
}

- (NSIndexPath *)_firstChildIndexPath
{
    if (!self.currentIndexPath) return nil;
    
    return [self.currentIndexPath indexPathByAddingIndex:0];
}

- (NSIndexPath *)_firstSiblingIndexPath
{
    if (!self.currentIndexPath) return nil;
    
    NSUInteger length = self.currentIndexPath.length;
    NSUInteger indices[MAX_INDEXPATH_LENGTH];
    [self.currentIndexPath getIndexes:indices];
    
    indices[length - 1] = 0;
    
    return [NSIndexPath indexPathWithIndexes:indices length:length];
}

- (BOOL)_isLastSnippetInScope
{
    if (![self.scopeStack count]) return YES;
    
    NSDictionary *loopInfo = [self.scopeStack lastObject];
    NSIndexPath *scopeIndexPath = loopInfo[@"indexPath"];
    CSSnippet *snippet = [self _snippetAtIndexPath:scopeIndexPath];
    
    NSUInteger length = self.currentIndexPath.length;
    NSUInteger indices[MAX_INDEXPATH_LENGTH];
    [self.currentIndexPath getIndexes:indices];
    
    if (indices[length - 1] >= [snippet.subSnippets count] - 1) return YES;
    else return NO;
}

- (void)_highlightSnippetAtIndexPath:(NSIndexPath *)indexPath pushToStack:(BOOL)pushFlag
{
    self.currentIndexPath = indexPath;
    CSSnippet *currentSnippet = self.nextSnippet;
    [self.codeView highlightTextInRange:currentSnippet.textRange];
    
    if (pushFlag) [self.executedSnippetStack addObject:currentSnippet];
}

- (void)beginNewScopeWithLoopCount:(NSInteger)loopCount
{
    if (loopCount == -1 || _finished) return;
    
    CSSnippet *snippet = [self _snippetAtIndexPath:self.currentIndexPath];
    
    if (![snippet.subSnippets count]) return;
    
    NSDictionary *loopInfo = @{ @"total" : [NSNumber numberWithUnsignedInteger:loopCount], @"current" : @1, @"indexPath" : self.currentIndexPath};
    
    [self.scopeStack addObject:loopInfo];
    
    self.nextIndexPath = [self _firstChildIndexPath];
}

- (void)beginNewScopeAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath == nil) return;
    
    CSSnippet *snippet = [self _snippetAtIndexPath:indexPath];
    
    if (![snippet.subSnippets count]) return;
    
    NSDictionary *loopInfo = @{@"total": @1, @"current" : @1, @"indexPath" : self.currentIndexPath};
    
    [self.scopeStack addObject:loopInfo];
    self.nextIndexPath = indexPath;
}

- (void)skipNextSeriallyLineOfCode
{
    self.indexPathToSkip = [self _seriallyNextIndexPathAfterIndexPath:self.currentIndexPath shouldSkipping:NO];
}

- (void)breakCurrentScopeInverselyAtIndex:(NSUInteger)idx
{
    if (idx > self.scopeStack.count - 1) {
        return;
    }
    [self.scopeStack removeObjectAtIndex:self.scopeStack.count - 1 - idx];
}

- (BOOL)isAtTheLoopBeginning
{
    if (_finished == NO)
        return self.currentLoopInfo ? NO : YES;
    else
        return NO;
}

- (void)_analyzeCurrentContextBeginingWithIndexPath:(NSIndexPath *)indexPath
{
    if (self.currentIndexPath == nil) {
        self.nextIndexPath = self.mainIndexPath;
        return;
    }
    
    if (self.currentLoopInfo) {
        // self.currentLoopInfo != nil means we've just come out of a loop scope, and hanging on loop check.
        NSInteger currentCount = [self.currentLoopInfo[@"current"] integerValue];
        NSInteger totalCount = [self.currentLoopInfo[@"total"] integerValue];
        NSIndexPath *currentIndexPath = self.currentLoopInfo[@"indexPath"];
        self.currentLoopInfo = nil;
        
        if (++currentCount > totalCount) {
            [self _analyzeCurrentContextBeginingWithIndexPath:self.currentIndexPath];
        }
        else {
            NSIndexPath *firstChildIndexPath = [self _firstChildIndexPath];
            CSSnippet *firstChildSnippet = [self _snippetAtIndexPath:firstChildIndexPath];
            
            if (firstChildSnippet)
                self.nextIndexPath = firstChildIndexPath;
            
            NSDictionary *loopInfo = @{@"current": [NSNumber numberWithInteger:currentCount],
                                       @"total" : [NSNumber numberWithInteger:totalCount],
                                       @"indexPath" : currentIndexPath};
            [self.scopeStack addObject:loopInfo];
        }
    }
    else {
        // self.currentLoopInfo = nil means we're in a current scope.
        if ([self.scopeStack count] == 0) {
            _finished = YES;
            self.nextIndexPath = nil;
            return;
        }
        
        NSIndexPath *nextSiblingIndexPath = [self _seriallyNextIndexPathAfterIndexPath:indexPath shouldSkipping:YES];
        CSSnippet *nextSiblingSnippet = [self _snippetAtIndexPath:nextSiblingIndexPath];
        
        if (!_finished) {
            if (nextSiblingSnippet && indexPath.length != 1)
                self.nextIndexPath = nextSiblingIndexPath;
            else {
                // if nextSiblingSnippet is nil, we've got the edge of current scope.
                
                NSDictionary *loopInfo = [self.scopeStack lastObject];
                NSInteger totalCount = [loopInfo[@"total"] integerValue];
                NSIndexPath *parentIndexPath = loopInfo[@"indexPath"];
                [self.scopeStack removeLastObject];
                
                if (totalCount == 0) {
                    // 对于if或者else的情况来说，结束当前作用域后要高亮的是父节点为准的下一个节点，递归使用这套规则判断。
                    [self _analyzeCurrentContextBeginingWithIndexPath:parentIndexPath];
                }
                else if (totalCount > 0) {
                    // 对于循环的情况来说，结束当前作用域后需要高亮的是它的父节点(因为要检查循环次数)
                    self.nextIndexPath = parentIndexPath;
                    self.currentLoopInfo = loopInfo;
                }
            }
        }
    }
}

- (BOOL)nextStep
{
    if (_finished) {
        // EOF
        return NO;
    }
    
    if (self.nextSnippet == nil) {
        // 如果下一行高亮的代码没有被指定(可以被beginNewScope..指定)，进入分析方法中获得它。
        [self _analyzeCurrentContextBeginingWithIndexPath:self.currentIndexPath];
    }
    
    if (self.nextSnippet) {
        [self _highlightSnippetAtIndexPath:self.nextIndexPath pushToStack:YES];
        self.nextIndexPath = nil;
        return YES;
    }
    
    return NO;
}

- (BOOL)hasChildrenOfCodeAtIndexPath:(NSIndexPath *)indexPath
{
    CSSnippet *snippet = (CSSnippet *)[self _snippetAtIndexPath:indexPath];
    
    if (snippet == nil || [snippet.subSnippets count] == 0) return NO;
    return YES;
}

@end
