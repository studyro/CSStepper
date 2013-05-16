//
//  CSStackCell.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-8.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSStackCell.h"

@interface CSStackCell ()
@property (strong, nonatomic) UIControl *control;
@property (strong, nonatomic) NSString *variableName;
@property (strong, nonatomic) id variableValue;
@end

@implementation CSStackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.level = 1;
        self.variableName = @"残值";
    }
    return self;
}

- (void)setExpandBlock:(void ((^)(NSIndexPath *)))expandBlock
{
    _expandBlock = [expandBlock copy];
    
    self.control = [[UIControl alloc] initWithFrame:CGRectMake(8.0, self.bounds.size.height/2.0 - 4.0, 8.0, 8.0)];
    [self.control addTarget:self action:@selector(expandControlTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.control.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:self.control];
}

- (void)setVariable:(NSDictionary *)variable
{
    _variable = variable;
    
    for (NSString *key in [variable keyEnumerator]) {
        self.variableName = key;
        self.variableValue = variable[key];
        break;
    }
    [self setNeedsDisplay];
}

- (void)expandControlTapped:(id)sender
{
    self.expandBlock(self.indexPath);
}

+ (UIFont *)varFont
{
    return [UIFont systemFontOfSize:14.5];
}

- (void)drawRect:(CGRect)rect
{
    // TODO : names
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    CGFloat offset = 8.0;
    CGFloat startX = offset * self.level;
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 3.0);
    CGContextMoveToPoint(context, startX, 0.0);
    CGContextAddLineToPoint(context, startX, height - 3.0);
    CGContextAddLineToPoint(context, width - startX, height - 3.0);
    CGContextAddLineToPoint(context, width - startX, 0.0);
    CGContextStrokePath(context);
    
    CGSize nameSize = [self.variableName sizeWithFont:[[self class] varFont]];
    [self.variableName drawAtPoint:CGPointMake(self.center.x - nameSize.width * 0.5, 8.0) forWidth:width - 20.0 withFont:[[self class] varFont] lineBreakMode:NSLineBreakByCharWrapping];
}

@end
