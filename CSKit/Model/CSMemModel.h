//
//  CSMemModel.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-7.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSStack.h"

extern NSString *const CSMemModelDidChangedNotification;

extern NSString *const kCSStackNameMain;

extern NSString *const kCSVariableValueUnassigned;

@interface CSMemModel : NSObject

+ (instancetype)sharedMemModel;

- (void)flushData;

- (void)beginTransaction;

- (void)commitTransaction;

#pragma mark - Stack-relasted APIs

- (void)openStackWithName:(NSString *)name
  collapseFormerVariables:(BOOL)shouldCollapse;

- (void)pushValue:(id)value named:(NSString *)key;

- (void)setValueInStack:(id)value named:(NSString *)key;

- (NSArray *)stackModelArray;

- (void)recycleStackActivatingLevel:(NSUInteger)lvlCount;

#pragma mark - Data Segment related APIs

- (void)setValueInData:(id)value named:(NSString *)key;

- (NSArray *)dataSegModelArray;

#pragma mark - Heap-related APIs

- (void)createValue:(id)value
              named:(NSString *)key
              sized:(NSUInteger)size;

- (void)setValueInHeap:(id)value named:(NSString *)key;

/* Array of name -> "value" : value
 *               -> "size"  : size
 */
- (NSArray *)heapInfoArray;

- (void)releaseValueNamed:(NSString *)key;

@end
