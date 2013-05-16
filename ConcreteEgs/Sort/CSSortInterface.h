//
//  CSSortInterface.h
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-1.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSInterface.h"
#import "CSBlockView.h"
#import "CSArrowView.h"
#import "CSConsoleView.h"

@interface CSSortInterface : CSInterface

@property (nonatomic, strong) CSArrowView *arrowI;
@property (nonatomic, strong) UILabel *labelI;
@property (nonatomic, strong) CSArrowView *arrowK;
@property (nonatomic, strong) UILabel *labelK;
@property (nonatomic, strong) CSBlockView *leftComparisonBlockView;
@property (nonatomic, strong) UILabel *comparisonResultLabel;
@property (nonatomic, strong) CSBlockView *rightComparisonBlockView;

@property (strong, nonatomic) NSMutableArray *numberBlockViews;
@property (assign, nonatomic) NSUInteger number;

@property (strong, nonatomic) CSConsoleView *consoleView;

//- (instancetype)initWithNumber:(NSUInteger)number;

- (NSUInteger)numberInBlockViewAtIndex:(NSUInteger)index;

- (void)setBlockViewAtIndex:(NSUInteger)index withNumber:(NSUInteger)number;

- (void)setRandomizedNumberToBlockViewAtIndex:(NSUInteger)index;

- (void)pointArrowIToIndex:(NSUInteger)index;

- (void)pointArrowKToIndex:(NSUInteger)index;

- (void)setBlockViewStatus:(BVStatus)status atIndex:(NSUInteger)index;

@end
