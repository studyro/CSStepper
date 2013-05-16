//
//  CSArrowLayer.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-18.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSArrowView : UIView

@property (nonatomic, readonly) CGPoint fromPoint;
@property (nonatomic, readonly) CGPoint toPoint;

@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

// temporary for verticle arrows only
@property (nonatomic, copy) NSString *arrowName;

- (instancetype)initFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

- (CGRect)frameContainsArrowFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint;

- (void)moveParallelyPointingToPoint:(CGPoint)newToPoint animated:(BOOL)animated;

- (void)setFromPoint:(CGPoint)fromPoint toPoint:(CGPoint )toPoint animated:(BOOL)animated;
@end
