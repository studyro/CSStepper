//
//  CSStepperViewController.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-3-2.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSStepperViewController.h"
#import "CSMemViewController.h"
#import "CSCodeView.h"
#import "CSInterface.h"
#import <QuartzCore/QuartzCore.h>

// Panning direction recognize
#define VERTICLE_MORE(p) ABS(p.y) > 1.2*ABS(p.x)
#define HORIZONTAL_MORE(p) ABS(p.x) > 1.2*ABS(p.y)
#define HORIZONTAL_TO_RIGHT(p) (p.x > 0 && HORIZONTAL_MORE(p))
#define HORIZONTAL_TO_LEFT(p) (p.x < 0 && HORIZONTAL_MORE(p))
#define VERTICLE_TO_BOTTOM(p) (p.y > 0 && VERTICLE_MORE(p))

// View Coordinates
#define CODEVIEW_WIDTH 240.0

// Panning end recognize
#define VELOCITY_FAST_THRESHOLD 300.0

typedef enum {
    kCSGestureTypeUndefined = 0,
    kCSGestureTypeStepper = 1,
    kCSGestureTypeCodeView = 2,
    kCSGestureTypeMemView = 3
}kCSGestureType;

@interface CSStepperViewController () <UIGestureRecognizerDelegate>
{
    kCSGestureType _gestureType;
    CGRect _codeScrollViewDefaultFrame;
    CGRect _memViewDefaultFrame;
    CGPoint _startLocationInSideView;
}
@property (nonatomic, strong) CSInterface *interfaceHolder;
@property (nonatomic, strong) CSMemViewController *memViewController;
@property (nonatomic, strong) CSCodeView *codeView;
@property (nonatomic, strong) UIScrollView *codeScrollView;

@property (strong, nonatomic) UIPanGestureRecognizer *codeViewDismissGesture;
@property (strong, nonatomic) UIPanGestureRecognizer *memViewDismissGesture;
@end

@implementation CSStepperViewController

- (id)init
{
    if (self = [super init]) {
        _gestureType = kCSGestureTypeUndefined;
    }
    return self;
}

- (instancetype)initWithCase:(NSString *)caseString
{
    if (self = [super init]) {
        _gestureType = kCSGestureTypeUndefined;
        [[CSProgram sharedProgram] reloadProgram:caseString error:nil];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _codeScrollViewDefaultFrame = CGRectMake(-CODEVIEW_WIDTH, 114.0, CODEVIEW_WIDTH, 540.0);
    _memViewDefaultFrame = CGRectMake(1224, 0.0, 200.0, 768.0);
    
    self.codeScrollView = [[UIScrollView alloc] initWithFrame:_codeScrollViewDefaultFrame];
    self.codeScrollView.contentSize = CGSizeMake(self.codeScrollView.frame.size.width, self.codeScrollView.frame.size.height + 50.0);
    self.codeScrollView.backgroundColor = [UIColor grayColor];
    self.codeScrollView.layer.cornerRadius = 4.0;
    self.codeScrollView.layer.shadowOffset = CGSizeMake(6.0, 10.0);
    self.codeScrollView.layer.masksToBounds = YES;
    self.codeScrollView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    self.codeView = [[CSCodeView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.codeScrollView.contentSize.width, self.codeScrollView.contentSize.height)];
    
    [self.codeScrollView addSubview:self.codeView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *programCase = kCSProgramCaseStructElection;
    
    [[CSProgram sharedProgram] reloadProgram:programCase error:nil];
    [CSProgram sharedProgram].codeView = self.codeView;
    
    self.interfaceHolder = [CSUtils interfaceWithCase:programCase];
    [self.interfaceHolder acceptBackgroundView:self.view];
	[self.interfaceHolder construct];
    
    self.memViewController = [[CSMemViewController alloc] initWithMemViewFrame:_memViewDefaultFrame];
    
    [self.view addSubview:self.memViewController.view];
    [self.view addSubview:self.codeScrollView];
    
    UIPanGestureRecognizer *panGesutre = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panning:)];
    [self.view addGestureRecognizer:panGesutre];
    
    self.codeViewDismissGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panningSideView:)];
    self.codeViewDismissGesture.delegate = self;
    [self.codeScrollView addGestureRecognizer:self.codeViewDismissGesture];
    
    self.memViewDismissGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panningSideView:)];
    self.memViewDismissGesture.delegate = self;
    [self.memViewController.view addGestureRecognizer:self.memViewDismissGesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.memViewController.view.frame = _memViewDefaultFrame;
}

- (void)presentView:(UIView *)v animated:(BOOL)animated
{
    BOOL isCodeView = (v == self.codeScrollView);
    CGFloat deltaX = isCodeView?v.frame.size.width:-v.frame.size.width;
    [UIView animateWithDuration:0.7 animations:^{
        v.frame = CGRectMake(v.frame.origin.x + deltaX, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
    }];
}

- (void)panning:(UIPanGestureRecognizer *)gesture
{
    if (gesture.numberOfTouches > 1) {
        return;
    }
    CGPoint transitionPoint = [gesture translationInView:self.view];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint startLoc = [gesture locationInView:self.view];
            CGFloat distanceFromCenter = self.view.center.y - startLoc.x;
            
            if (ABS(distanceFromCenter) >= 0.9 * self.view.center.x) {
                if (distanceFromCenter > 0 && HORIZONTAL_TO_RIGHT(transitionPoint) && self.codeScrollView.frame.origin.x < 0.0)
                    _gestureType = kCSGestureTypeCodeView;
                else if (distanceFromCenter < 0 && HORIZONTAL_TO_LEFT(transitionPoint) && self.memViewController.view.frame.origin.x >= 1024.0)
                    _gestureType = kCSGestureTypeMemView;
            }
            
            if (VERTICLE_TO_BOTTOM(transitionPoint)) {
                _gestureType = kCSGestureTypeStepper;
            }
            
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            // TODO : make a tip when next-step gesture activated.
            
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            if (_gestureType == kCSGestureTypeStepper && VERTICLE_TO_BOTTOM(transitionPoint))
                [self.interfaceHolder nextStep];
            else if (_gestureType == kCSGestureTypeCodeView && HORIZONTAL_TO_RIGHT(transitionPoint))
                [self presentView:self.codeScrollView animated:YES];
            else if (_gestureType == kCSGestureTypeMemView && HORIZONTAL_TO_LEFT(transitionPoint))
                [self presentView:self.memViewController.view animated:YES];
                
            _gestureType = kCSGestureTypeUndefined;
            break;
        }
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.codeView = nil;
    [CSProgram sharedProgram].codeView = nil;
}

#pragma mark - Side Gestures

- (void)panningSideView:(UIPanGestureRecognizer *)gesture
{
    BOOL isCodeView = (gesture == self.codeViewDismissGesture);
    UIView *v = isCodeView?self.codeScrollView:self.memViewController.view;
    
    CGPoint transitionPoint = [gesture translationInView:v];
    CGPoint velocityPoint = [gesture velocityInView:v];
    static CGFloat posXLastTime = 0.0;
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            _startLocationInSideView = [gesture locationInView:self.codeView];
            posXLastTime = transitionPoint.x;
            break;
        }
            
        case UIGestureRecognizerStateChanged:
        {
            CGFloat deltaX = transitionPoint.x - posXLastTime;
            posXLastTime = transitionPoint.x;
            CGFloat newPosX = v.frame.origin.x + deltaX;
            
            CGFloat maxPos = isCodeView ? 0.0 : (1024.0 - v.frame.size.width);
            BOOL exceedMaxPos = isCodeView ? newPosX > maxPos : newPosX < maxPos;
            newPosX = exceedMaxPos ? maxPos: newPosX;
            if (isCodeView) {
                [UIView animateWithDuration:0.2 animations:^{
                    v.frame = CGRectMake(newPosX, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
                }];
            }
            else if (!isCodeView) {
                [UIView animateWithDuration:0.2 animations:^{
                    v.frame = CGRectMake(newPosX, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
                }];
            }
            break;
        }
            
        case UIGestureRecognizerStateEnded:
        {
            if (isCodeView) {
                CGFloat s = -v.frame.size.width - v.frame.origin.x;
                if (velocityPoint.x < -VELOCITY_FAST_THRESHOLD) {
                    // move too fast to hide the view
                    NSTimeInterval time = s / velocityPoint.x;
                    [UIView animateWithDuration:time animations:^{
                        v.frame = CGRectMake(-v.frame.size.width, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
                    }];
                }
                else if (transitionPoint.x < - v.frame.size.width / 2.0) {
                    CGFloat va = - (v.frame.size.width / 2.0) / 0.5;
                    NSTimeInterval time = s / va;
                    [UIView animateWithDuration:time animations:^{
                        v.frame = CGRectMake(-v.frame.size.width, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
                    }];
                }
                else {
                    [UIView animateWithDuration:0.5 animations:^{
                        v.frame = CGRectMake(0.0, v.frame.origin.y, v.frame.size.width, v.frame.size.height);
                    }];
                }
            }
            else {
                CGFloat s = 1024.0 - v.frame.origin.x;
                if (velocityPoint.x > VELOCITY_FAST_THRESHOLD) {
                    NSTimeInterval time = s / velocityPoint.x;
                    [UIView animateWithDuration:time animations:^{
                        v.frame = CGRectMake(1024.0, 0.0, v.frame.size.width, v.frame.size.height);
                    }];
                }
                else if (transitionPoint.x > v.frame.size.width / 2.0) {
                    CGFloat va = v.frame.size.width / 2.0 / 0.5;
                    NSTimeInterval time = s / va;
                    [UIView animateWithDuration:time animations:^{
                        v.frame = CGRectMake(1024.0, 0.0, v.frame.size.width, v.frame.size.height);
                    }];
                }
                else {
                    [UIView animateWithDuration:0.5 animations:^{
                        v.frame = CGRectMake(1024-v.frame.size.width, 0.0, v.frame.size.width, v.frame.size.height);
                    }];
                }
            }
            
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - UIGestureRecognizer Delegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.codeViewDismissGesture) {
        CGPoint transition = [self.codeViewDismissGesture translationInView:self.codeView];
        if (HORIZONTAL_MORE(transition)) {
            return YES;
        }
        else {
            return NO;
        }
    }
    if (gestureRecognizer == self.memViewDismissGesture) {
        CGPoint transition = [self.memViewDismissGesture translationInView:self.memViewController.view];
        if (HORIZONTAL_MORE(transition)) {
            return YES;
        }
        else {
            return NO;
        }
    }
    
    return YES;
}

@end
