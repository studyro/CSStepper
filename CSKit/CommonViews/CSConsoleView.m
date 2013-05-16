//
//  CSConsoleView.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-10.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSConsoleView.h"
#import <QuartzCore/QuartzCore.h>

@interface CSConsoleView ()

@property (strong, nonatomic) UILabel *consoleLabel;

@property (strong, nonatomic) NSMutableString *mutableString;

@end

@implementation CSConsoleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        UIView *backView = [[UIView alloc] initWithFrame:self.bounds];
        backView.backgroundColor = [UIColor blackColor];
        backView.opaque = NO;
        backView.alpha = 0.7;
        
        [self addSubview:backView];
        
        self.consoleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.consoleLabel.backgroundColor = [UIColor clearColor];
        self.consoleLabel.textColor = [UIColor whiteColor];
        self.consoleLabel.font = [UIFont systemFontOfSize:15.5];
        self.consoleLabel.numberOfLines = 10;
        
        [self addSubview:self.consoleLabel];
        
        self.mutableString = [[NSMutableString alloc] init];
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
    }
    return self;
}

+ (NSString *)prefixConsoleString
{
    return @"";
}

- (void)appendSring:(NSString *)string
{
    [self.mutableString appendString:string];
    self.consoleLabel.text = self.mutableString;
}

@end
