//
//  CSArrowLayer.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-18.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSArrowView.h"
#import <QuartzCore/QuartzCore.h>

@interface CSArrowView()
@end

@implementation CSArrowView

- (CGRect)frameContainsArrowFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    if (fromPoint.x - toPoint.x == 0)
        return CGRectMake(toPoint.x - 10.0, toPoint.y, 20.0, ABS(fromPoint.y - toPoint.y));
    return CGRectMake(MIN(fromPoint.x, toPoint.x), MIN(fromPoint.y, toPoint.y), ABS(toPoint.x - fromPoint.x), ABS(toPoint.y - fromPoint.y));
}

- (instancetype)initFromPoint:(CGPoint)fromPoint toPoint:(CGPoint)toPoint
{
    CGRect frame = [self frameContainsArrowFromPoint:fromPoint toPoint:toPoint];
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        
        _fromPoint = fromPoint;
        _toPoint = toPoint;
        
        [self setLineWidth:4.0];
        [self setLineColor:[UIColor blackColor]];
    }
    
    return self;
}

- (void)moveParallelyPointingToPoint:(CGPoint)newToPoint animated:(BOOL)animated
{
    CGPoint arrowVector = CGPointMake(_toPoint.x - _fromPoint.x, _toPoint.y - _fromPoint.y);
    CGPoint newFromPoint = CGPointMake(newToPoint.x - arrowVector.x, newToPoint.y - arrowVector.y);
    
    CGRect newFrame = [self frameContainsArrowFromPoint:newFromPoint toPoint:newToPoint];
    
    if (animated) {
        [UIView animateWithDuration:1.0 animations:^(){self.frame = newFrame;}];
    }
    else {
        self.frame = newFrame;
    }
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (_lineColor) [_lineColor release];
    if (!lineColor) {
        _lineColor = [UIColor blackColor];
        return;
    }
    
    _lineColor = [lineColor retain];
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint fromPointInSelfSystem = CGPointMake(_fromPoint.x-self.frame.origin.x, _fromPoint.y-self.frame.origin.y);
    CGPoint toPointInSelfSystem = CGPointMake(_toPoint.x-self.frame.origin.x, _toPoint.y-self.frame.origin.y);

    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGContextSetLineWidth(context, _lineWidth);
    
    CGPoint vectorArrow = CGPointMake(toPointInSelfSystem.x - fromPointInSelfSystem.x, toPointInSelfSystem.y - fromPointInSelfSystem.y);
    CGFloat lengthVector = sqrtf(vectorArrow.x * vectorArrow.x + vectorArrow.y * vectorArrow.y);
    CGFloat angleArrowVector = acosf(vectorArrow.x / lengthVector)*(vectorArrow.y<0?-1:1);
    CGFloat angleLeaf_1 = angleArrowVector+M_PI_4*3;
    CGFloat angleLeaf_2 = angleArrowVector-M_PI_4*3;
    
    CGFloat leafLength = 10.0;
    CGPoint leafPoint_1 = CGPointMake(leafLength*cosf(angleLeaf_1) + toPointInSelfSystem.x, leafLength*sinf(angleLeaf_1) + toPointInSelfSystem.y);
    CGPoint leafPoint_2 = CGPointMake(leafLength*cosf(angleLeaf_2) + toPointInSelfSystem.x, leafLength*sinf(angleLeaf_2) + toPointInSelfSystem.y);
    
    CGContextSetLineJoin(context, kCGLineJoinBevel);
    CGContextMoveToPoint(context, fromPointInSelfSystem.x, fromPointInSelfSystem.y);
    CGContextAddLineToPoint(context, toPointInSelfSystem.x, toPointInSelfSystem.y);
    CGContextAddLineToPoint(context, leafPoint_1.x, leafPoint_1.y);
    CGContextAddLineToPoint(context, toPointInSelfSystem.x, toPointInSelfSystem.y);     //duplicatedly go back toPoint
    CGContextAddLineToPoint(context, leafPoint_2.x, leafPoint_2.y);
    
    CGContextStrokePath(context);
}

@end
