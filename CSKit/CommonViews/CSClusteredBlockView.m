//
//  CSClusteredBlockView.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-10.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSClusteredBlockView.h"
#import <QuartzCore/QuartzCore.h>

CGRect CGRectMakeWithBlockNumber(CGRect rect, NSUInteger idx, NSUInteger number)
{
    CGFloat w = rect.size.width / (CGFloat)number;
    CGFloat h = rect.size.height;
    CGFloat x = 0 + idx * w;
    CGFloat y = 0.0;
    
    return CGRectMake(x, y, w, h);
}

@interface CSClusteredBlockView ()
@property (nonatomic, strong) NSArray *indexesToHighLight;
@end

@implementation CSClusteredBlockView

- (instancetype)initWithPartition:(NSUInteger)parts andFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _partsNumber = parts;
        self.inlineWidth = 2.0;
        self.boundLineWidth = 2.0;
        self.layer.cornerRadius = 4.0;
    }
    
    return self;
}

- (void)setBoundLineWidth:(CGFloat)boundLineWidth
{
    if (boundLineWidth < 0.0) boundLineWidth = 0.0;
    _boundLineWidth = boundLineWidth;
    
    self.layer.borderWidth = boundLineWidth;
}

- (void)setInlineWidth:(CGFloat)inlineWidth
{
    if (inlineWidth < 0.0) inlineWidth = 0.0;
    _inlineWidth = inlineWidth;
    
    [self setNeedsDisplay];
}

- (void)setTextArray:(NSArray *)textArray
{
    _textArray = textArray;
    
    if (_textArray) {
        [self setNeedsDisplay];
    }
}

- (void)highlightBlockAtIndexes:(NSArray *)indexes
{
    self.indexesToHighLight = indexes;
    
    [self setNeedsDisplay];
}

- (void)recoverBlocks
{
    self.indexesToHighLight = nil;
    
    [self setNeedsDisplay];
}

- (BOOL)highlightArrayContainsIndex:(NSUInteger)index
{
    __block BOOL contains = NO;
    [self.indexesToHighLight enumerateObjectsUsingBlock:^(NSNumber *n, NSUInteger idx, BOOL *stop){
        NSUInteger idxToHighLight = [n unsignedIntegerValue];
        if (index == idxToHighLight) {
            contains = YES;
            *stop = YES;
        }
    }];
    
    return contains;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(context, self.inlineWidth);
    
    CGFloat unitWidth = self.bounds.size.width / (CGFloat)self.partsNumber;
    for (NSUInteger i = 0; i < self.partsNumber - 1; i++) {
        CGContextMoveToPoint(context, unitWidth * (i+1), self.bounds.size.height);
        CGContextAddLineToPoint(context, unitWidth * (i+1), 0.0);
    }
    CGContextStrokePath(context);
    for (NSUInteger i = 0; i < self.partsNumber; i++) {
        CGFloat offsetWhileILargerThanZero = (i > 0) * 0.5 * self.inlineWidth;
        CGRect unitRect = CGRectMake(i * unitWidth + offsetWhileILargerThanZero, 0.0, unitWidth - 0.5 * self.inlineWidth - offsetWhileILargerThanZero, self.bounds.size.height);
        CGContextFillRect(context, unitRect);
        
        if ([self highlightArrayContainsIndex:i]) {
            CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
            
            CGRect unitRect = CGRectMake(i * unitWidth, 0.0, unitWidth, self.bounds.size.height);
            CGContextFillRect(context, unitRect);
        }
    }
    
//    CGContextFillPath(context);
    
    [[UIColor blackColor] set];
    if (self.textArray) {
        for (NSUInteger i = 0; i < self.partsNumber; i++) {
            NSString *str = nil;
            
            if ([self.textArray count] > i) str = self.textArray[i];
            else str = @"";
            CGRect r = CGRectMakeWithBlockNumber(self.bounds, i, self.partsNumber);
            [str drawInRect:CGRectInset(r, 0.25*r.size.width, 0.35*r.size.height) withFont:[UIFont boldSystemFontOfSize:15.0] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
        }
    }
}


@end
