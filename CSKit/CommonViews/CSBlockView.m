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
        _status = status;
//        [CATransaction setAnimationDuration:1.0];
        self.layer.backgroundColor = [self _colorWithStatus:self.status].CGColor;
//        [CATransaction setAnimationDuration:0.5];
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
    if (_text) {
        CGRect rect = CGRectInset(self.bounds, 0.15*self.bounds.size.width, 0.35*self.bounds.size.height);
        
        CGSize textSize = [_text sizeWithFont:[UIFont boldSystemFontOfSize:18.0]];
        
        if (CGRectGetHeight(rect) < textSize.height) {
            rect = self.bounds;
        }
        
        [_text drawInRect:rect withFont:[UIFont boldSystemFontOfSize:18.0] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
    }
}


@end
