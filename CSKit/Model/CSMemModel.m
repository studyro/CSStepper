//
//  CSMemModel.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-7.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSMemModel.h"

@interface CSMemModel ()
{
    BOOL _inTransaction;
}

@property (strong, nonatomic) NSMutableArray *stackArray;
@property (strong, nonatomic) NSMutableArray *dataSegArray;
@property (strong, nonatomic) NSMutableArray *heapArray;

@end

NSString *const kCSStackNameMain = @"kCSStackNameMain";

NSString *const CSMemModelDidChangedNotification = @"CSMemModelDidChangedNotification";

NSString *const kCSVariableValueUnassigned = @"kCSVariableValueUnassigned";

@implementation CSMemModel

- (id)init
{
    if (self = [super init]) {
        self.stackArray = [[NSMutableArray alloc] initWithCapacity:5];
        self.dataSegArray = [[NSMutableArray alloc] initWithCapacity:5];
        self.heapArray = [[NSMutableArray alloc] initWithCapacity:5];
        _inTransaction = NO;
    }
    
    return self;
}

+ (instancetype)sharedMemModel
{
    static dispatch_once_t once;
    static CSMemModel *instacne;
    dispatch_once(&once, ^ { instacne = [[[self class] alloc] init]; });
    return instacne;
}

- (void)flushData
{
    [self.stackArray removeAllObjects];
    [self.dataSegArray removeAllObjects];
    [self.heapArray removeAllObjects];
}

- (void)beginTransaction
{
    _inTransaction = YES;
}

- (void)commitTransaction
{
    _inTransaction = NO;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CSMemModelDidChangedNotification object:self userInfo:@{@"type": @"stack"}];
}

#pragma mark - Stack-related Methods

- (void)openStackWithName:(NSString *)name collapseFormerVariables:(BOOL)shouldCollapse
{
    if (shouldCollapse) {
        [self.stackArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            CSStack *stack = (CSStack *)obj;
            stack.isActivated = NO;
        }];
    }
    
    CSStack *stack = [[CSStack alloc] initWithName:name];
    [self.stackArray addObject:stack];
    
    if (!_inTransaction) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CSMemModelDidChangedNotification object:self userInfo:@{@"type": @"stack"}];
    }
}

- (void)pushValue:(id)value named:(NSString *)key
{
    if ([self.stackArray count] == 0) return;
    
    CSStack *stack = [self.stackArray lastObject];
    // because our tableView is 0~n order, so insert stack top element at idx 0.
    [stack.variables insertObject:[NSMutableDictionary dictionaryWithObject:value forKey:key] atIndex:0];
    
    if (!_inTransaction)
        [[NSNotificationCenter defaultCenter] postNotificationName:CSMemModelDidChangedNotification object:self userInfo:@{@"type": @"stack"}];
}

- (void)setValueInStack:(id)value named:(NSString *)key
{
    // entire lookup may seem slow. But in our cases, there won't be so many vars.
    for (NSInteger i = [self.stackArray count] - 1; i >= 0; i--) {
        CSStack *stack = self.stackArray[i];
        if (stack.isActivated == NO) continue;
        
        [stack.variables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
            if ([obj objectForKey:key]) {
                [obj setObject:value forKey:key];
                *stop = YES;
            }
        }];
    }
    
    if (!_inTransaction)
        [[NSNotificationCenter defaultCenter] postNotificationName:CSMemModelDidChangedNotification object:self userInfo:@{@"type": @"stack"}];
}

- (NSArray *)stackModelArray
{
    // totally reversed
    NSMutableArray *stackArrayToReturn = [[NSMutableArray alloc] init];
    
    for (NSInteger i = [self.stackArray count] - 1; i >= 0; i--) {
        CSStack *stack = (CSStack *)self.stackArray[i];
        
        if (stack.isActivated) {
            [stack.variables enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
                [stackArrayToReturn addObject:obj];
            }];
        }
        else {
            [stackArrayToReturn addObject:stack];
        }
    }
    
    return [stackArrayToReturn copy];
}

- (void)recycleStackActivatingLevel:(NSUInteger)lvlCount;
{
    for (NSUInteger i = 0; i < MIN(lvlCount, [self.stackArray count]); i++) {
        [self.stackArray removeLastObject];
    }
    
    if ([self.stackArray count]) {
        CSStack *stack = (CSStack *)[self.stackArray lastObject];
        stack.isActivated = YES;
    }
    
    if (!_inTransaction) {
        [[NSNotificationCenter defaultCenter] postNotificationName:CSMemModelDidChangedNotification object:self userInfo:@{@"type": @"stack"}];
    }
}

#pragma mark - Data Segment Related Methods

- (void)setValueInData:(id)value named:(NSString *)key;
{
    [self.dataSegArray addObject:@{key: value}];
}

- (NSArray *)dataSegModelArray
{
    return [self.dataSegArray copy];
}

#pragma mark - Heap-realaetd Methods

- (void)createValue:(id)value named:(NSString *)key sized:(NSUInteger)size
{
    NSDictionary *obj = @{key: [NSMutableDictionary dictionaryWithObjectsAndKeys:value, @"value", [NSNumber numberWithUnsignedInteger:size], @"size", nil]};
    [self.heapArray addObject:obj];
}

- (void)setValueInHeap:(id)value named:(NSString *)key
{
    [self.heapArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([obj objectForKey:key]) {
            NSMutableDictionary *info = [obj objectForKey:key];
            [info setObject:value forKey:@"value"];
            *stop = YES;
        }
    }];
}

- (NSArray *)heapInfoArray
{
    return [self.heapArray copy];
}

- (void)releaseValueNamed:(NSString *)key
{
    [self.heapArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop){
        if ([obj objectForKey:key]) {
            [self.heapArray removeObjectAtIndex:idx];
            *stop = YES;
        }
    }];
}

@end
