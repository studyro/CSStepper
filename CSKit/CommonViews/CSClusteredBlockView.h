//
//  CSClusteredBlockView.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-10.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSClusteredBlockView : UIView

@property (assign, nonatomic, readonly) NSUInteger partsNumber;
@property (assign, nonatomic) CGFloat boundLineWidth;
@property (assign, nonatomic) CGFloat inlineWidth;
@property (strong, nonatomic) UIFont *font;
@property (strong, nonatomic) NSArray *textArray;

- (instancetype)initWithPartition:(NSUInteger)parts andFrame:(CGRect)frame;

- (void)highlightBlockAtIndexes:(NSArray *)indexes;
- (void)recoverBlocks;

// TODO : verticle / horizontal support

@end
