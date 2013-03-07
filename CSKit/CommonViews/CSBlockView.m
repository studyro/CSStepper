//
//  CSBlockView.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-2-18.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSBlockView.h"
#import <QuartzCore/QuartzCore.h>

@interface CSBlockView ()
@end

@implementation CSBlockView

- (void)dealloc
{
    if (_text) [_text release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CALayer *layer = self.layer;
        layer.borderColor = [UIColor blackColor].CGColor;
        layer.borderWidth = 2.0;
    }
    return self;
}

- (void)setText:(NSString *)text
{
    if (_text) [_text release];
    if (!text) {
        _text = nil;
        return;
    }
    
    _text = [text copy];
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = borderWidth;
}

- (void)setStatus:(BVStatus)status
{
    _status = status;
    self.backgroundColor = [self _colorWithStatus:status];
}

- (void)setStatus:(BVStatus)status animated:(BOOL)animated
{
    if (!animated)
        [self setStatus:status];
    else {
        CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
        colorAnimation.duration = 0.3;
        colorAnimation.fromValue = (id)[self _colorWithStatus:self.status].CGColor;
        colorAnimation.toValue = (id)[self _colorWithStatus:status].CGColor;
        colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{[self setStatus:status];}];
        [self.layer addAnimation:colorAnimation forKey:@"colorAnimation"];
        [CATransaction commit];
    }
}

- (UIColor *)_colorWithStatus:(BVStatus)status
{
    switch (status) {
        case BVStatusInactive:
            return [UIColor grayColor];
            break;
            
        case BVStatusToBeActive:
            return [UIColor greenColor];
            break;
            
        case BVStatusActive:
            return [UIColor redColor];
            break;
            
        default:
            return nil;
            break;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    [[UIColor blackColor] set];
    if (_text)
//        [_text drawInRect:CGRectInset(self.bounds, -0.2*self.bounds.size.width, -0.2*self.bounds.size.height) withFont:[UIFont boldSystemFontOfSize:16.0]];
        [_text drawAtPoint:CGPointMake(10.0, 10.0) forWidth:100.0 withFont:[UIFont systemFontOfSize:22.0] lineBreakMode:NSLineBreakByCharWrapping];
}


@end
