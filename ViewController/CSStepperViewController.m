//
//  CSStepperViewController.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-3-2.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSStepperViewController.h"
#import "CSSelectionSortInterface.h"

@interface CSStepperViewController ()
@property (nonatomic, retain) CSSelectionSortInterface *interfaceHolder;
@end

@implementation CSStepperViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [_interfaceHolder release];
    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interfaceHolder = [[CSSelectionSortInterface alloc] init];
    [self.interfaceHolder acceptBackgroundView:self.view];
	[self.interfaceHolder buildInterface];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"next" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, 0.0, 100.0, 40.0);
    [button addTarget:self action:@selector(nextButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
}

- (void)nextButtonTapped:(id)sender
{
    [self.interfaceHolder nextStep];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
