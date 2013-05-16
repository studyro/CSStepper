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
    if (fromPoint.x - toPoint.x == 0) {
        // these configure is only for little arrows in sort example.
        CGFloat x = toPoint.x - 25.0;
        CGFloat y = fromPoint.y > toPoint.y ? (fromPoint.y - 1.1*ABS(fromPoint.y - toPoint.y)) : fromPoint.y - 20.0;
        CGFloat w = 50.0;
        CGFloat h = 2.0 * ABS(fromPoint.y - toPoint.y);
        
//        return CGRectMake(toPoint.x - 10.0, fromPoint.y > toPoint.y ? fromPoint.y -  ABS(fromPoint.y - toPoint.y) : fromPoint.y, 20.0, ABS(fromPoint.y - toPoint.y));
        return CGRectMake(x, y, w, h);
    }
    
    CGFloat x = MIN(fromPoint.x, toPoint.x);
    CGFloat y = MIN(fromPoint.y, toPoint.y);
    CGFloat h = ABS(toPoint.y - fromPoint.y);
    if (fromPoint.y - toPoint.y == 0) {
        y = y - 15.0;
        h = 30.0;
    }
    
    return CGRectMake(x, y, ABS(toPoint.x - fromPoint.x) + 5.0, h);
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
    
    _fromPoint = newFromPoint;
    _toPoint = newToPoint;
    
    if (animated) {
        [UIView animateWithDuration:1.0 animations:^(){self.frame = newFrame;}];
    }
    else {
        self.frame = newFrame;
    }
}

- (void)setFromPoint:(CGPoint)fromPoint toPoint:(CGPoint )toPoint animated:(BOOL)animated
{
    _fromPoint = fromPoint;
    _toPoint = toPoint;
    
    CGRect newFrame = [self frameContainsArrowFromPoint:fromPoint toPoint:toPoint];
    
    if (animated) {
        [UIView animateWithDuration:1.0 animations:^(){self.frame = newFrame;}];
    }
    else {
        self.frame = newFrame;
    }
    // need?
    [self setNeedsDisplay];
}

- (void)setArrowName:(NSString *)arrowName
{
    _arrowName = [arrowName copy];
    
    CGSize size = [arrowName sizeWithFont:[UIFont systemFontOfSize:16.0]];
    self.frame = CGRectMake(_toPoint.x - (size.width + 15.0) / 2.0, self.frame.origin.y, size.width + 15.0, self.bounds.size.height);
    
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor
{
    if (!lineColor) {
        lineColor = [UIColor blackColor];
    }
    
    _lineColor = lineColor;
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
    
//    CGPoint fromPointInSelfSystem = CGPointMake(_fromPoint.x-self.frame.origin.x, _fromPoint.y-self.frame.origin.y);
    CGPoint fromPointInSelfSystem = [self.superview convertPoint:_fromPoint toView:self];
//    CGPoint toPointInSelfSystem = CGPointMake(_toPoint.x-self.frame.origin.x, _toPoint.y-self.frame.origin.y);
    CGPoint toPointInSelfSystem = [self.superview convertPoint:_toPoint toView:self];

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
    
    if (self.arrowName) {
        CGRect rect;
        if (fromPointInSelfSystem.y > toPointInSelfSystem.y)
            rect = CGRectMake(0.0, fromPointInSelfSystem.y, self.bounds.size.width, self.bounds.size.height - (fromPointInSelfSystem.y - toPointInSelfSystem.y));
        else {
            rect = CGRectMake(0.0, 4.0, self.bounds.size.width, self.bounds.size.height - (toPointInSelfSystem.y - fromPointInSelfSystem.y));
        }
//        [self.arrowName drawInRect:rect withFont:[UIFont systemFontOfSize:14.0]];
        [self.arrowName drawInRect:rect withFont:[UIFont systemFontOfSize:16.0] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    }
}

@end
