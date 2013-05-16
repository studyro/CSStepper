//
//  CSStackCell.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-8.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSStackCell : UITableViewCell

@property (copy, nonatomic) void ((^expandBlock)(NSIndexPath *indexPath));

@property (assign, nonatomic) BOOL isStackTop;

@property (strong, nonatomic) NSDictionary *variable;

@property (assign, nonatomic) NSUInteger level;

@property (strong, nonatomic) NSIndexPath *indexPath;

@end
