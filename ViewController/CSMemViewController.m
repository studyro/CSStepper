//
//  CSMemViewController.m
//  CSStepper
//
//  Created by Zhang Studyro on 13-4-8.
//  Copyright (c) 2013年 Studyro Studio. All rights reserved.
//

#import "CSMemViewController.h"
#import "PZHNExpandableTableView.h"
#import "CSMemModel.h"
#import "CSStackCell.h"

@interface CSMemViewController () <PZHNExpandableTableViewDataSource, PZHNExpandableTableViewDelegate>
{
    CGRect _memViewFrame;
}

@property (strong, nonatomic) PZHNExpandableTableView *tableView;

@property (strong, nonatomic) NSArray *stackArray;

@end

@implementation CSMemViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CSMemModelDidChangedNotification object:nil];
}

- (instancetype)initWithMemViewFrame:(CGRect)frame
{
    if (self = [super init]) {
        _memViewFrame = frame;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(memModelDidChangedWithInfo:) name:CSMemModelDidChangedNotification object:nil];
        self.stackArray = [[CSMemModel sharedMemModel] stackModelArray];
    }
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    self.tableView = [[PZHNExpandableTableView alloc] initWithFrame:CGRectMake(0.0, 0.0, _memViewFrame.size.width, _memViewFrame.size.height)];
    self.tableView.myDataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.myDelegate = self;
    self.tableView.backgroundColor = [UIColor blueColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.frame = _memViewFrame;
    [self.view addSubview:self.tableView];
}

- (void)memModelDidChangedWithInfo:(NSDictionary *)info
{
    self.stackArray = [[CSMemModel sharedMemModel] stackModelArray];
    [self.tableView reloadData];
}

- (NSDictionary *)_variableInfoAtTreePath:(NSIndexPath *)treePath
{
    NSUInteger indices[32] = {0};
    [treePath getIndexes:indices];
    
    id temp = self.stackArray;
    for (NSUInteger i = 0; i < treePath.length; i++) {
        if ([temp isKindOfClass:[NSArray class]]) {
            temp = [temp objectAtIndex:indices[i]];
        }
        else if ([temp isKindOfClass:[NSDictionary class]]) {
            for (id obj in [temp objectEnumerator]) {
                if ([obj isKindOfClass:[NSArray class]]) {
                    temp = obj[indices[i]];
                }
            }
        }
        else if ([temp isKindOfClass:[CSStack class]]) {
            CSStack *stack = (CSStack *)temp;
            temp = stack.variables[indices[i]];
        }
        
        if ([temp isKindOfClass:[CSStack class]] && i == (treePath.length - 1)) {
            CSStack *stack = (CSStack *)temp;
            temp = @{stack.name: stack.variables};
        }
    }
    
    // always return a dictinary as :  name -> var(maybe array(consist of dics) or string)
    return temp;
}

- (NSUInteger)_childrenCountOfVariable:(id)variable
{
    if ([variable isKindOfClass:[NSDictionary class]]) {
        NSArray *assumedArray = nil;
        for (id obj in [variable objectEnumerator]) {
            assumedArray = obj;
        }
        
        if ([assumedArray isKindOfClass:[NSArray class]])
            return [assumedArray count];
        else
            return 0;
    }
    
    return 0;
}

- (NSUInteger)_childrenCountOfVariableAtTreePath:(NSIndexPath *)treePath
{
    NSDictionary *variable = [self _variableInfoAtTreePath:treePath];
    
    return [self _childrenCountOfVariable:variable];
}

#pragma mark - PZHNExpandableTableView DataSource Methods

- (void)tableViewDidRefreshed:(PZHNExpandableTableView *)tableView
{
    NSArray *cells = [tableView visibleCells];
    
    for (CSStackCell *cell in cells) {
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        cell.indexPath = indexPath;
    }
}

- (CGFloat)tableView:(PZHNExpandableTableView *)tableView heightForRowAtTreePath:(NSIndexPath *)treePath
{
    return 44.0;
}

- (NSInteger)tableView:(PZHNExpandableTableView *)tableView baseNumberOfRowsInSection:(NSInteger)section
{
    return [self.stackArray count];
}

- (UITableViewCell *)tableView:(PZHNExpandableTableView *)tableView cellForRowAtTreePath:(NSIndexPath *)treePath indexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"StackCell";
    
    CSStackCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[CSStackCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *variable = [self _variableInfoAtTreePath:treePath];
    cell.indexPath = indexPath;
    cell.level = treePath.length;
    cell.variable = variable;
    if ([self _childrenCountOfVariable:variable]) {
        cell.expandBlock = ^(NSIndexPath *currentIndexPath){
            [tableView expandOrCollapseAtIndexPath:currentIndexPath animated:YES];
        };
    }
    if (indexPath.row == 0)
        cell.isStackTop = YES;
    
    return cell;
}

- (NSUInteger)tableView:(PZHNExpandableTableView *)tableView numberOfChildrenRowsForTreePath:(NSIndexPath *)treePath
{
    return [self _childrenCountOfVariableAtTreePath:treePath];
}

#pragma mark - PZHNExpandableTableView Delegete Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.tableView = nil;
}

@end
