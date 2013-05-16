//
//  PZHNExpandableTableView.h
//  ExpannableTableView
//
//  Created by Zhang Studyro on 12-10-30.
//  Copyright (c) 2012年 Studyro Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO : add section support and editing support.

@protocol PZHNExpandableTableViewDataSource;
@protocol PZHNExpandableTableViewDelegate;

@interface PZHNExpandableTableView : UITableView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) id<PZHNExpandableTableViewDelegate> myDelegate;
@property (nonatomic, assign) id<PZHNExpandableTableViewDataSource> myDataSource;

@property (nonatomic, assign, readonly) NSInteger numberOfRows;

- (void)expandOrCollapseAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;
- (NSIndexPath *)parentIndexPathOfItemAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)cellIsExpandedAtIndexPath:(NSIndexPath *)indexPath;
@end

@protocol PZHNExpandableTableViewDataSource <NSObject>

@required
/*
 treePath here is an instace of NSIndexPath typically documented in Apple's Documentation
 
 use   - getIndexes:(NSUInteger *)indexes  to get an array which contains the tree structure information related to the receiver.
 */
- (UITableViewCell *)tableView:(PZHNExpandableTableView *)tableView cellForRowAtTreePath:(NSIndexPath *)treePath indexPath:(NSIndexPath *)indexPath;

- (NSInteger)tableView:(PZHNExpandableTableView *)tableView baseNumberOfRowsInSection:(NSInteger)section; //temporarily support section 0

- (NSUInteger)tableView:(PZHNExpandableTableView *)tableView numberOfChildrenRowsForTreePath:(NSIndexPath *)treePath;

- (void)tableViewDidRefreshed:(PZHNExpandableTableView *)tableView;
@optional
- (CGFloat)tableView:(PZHNExpandableTableView *)tableView heightForFooterInSection:(NSInteger)section;

- (CGFloat)tableView:(PZHNExpandableTableView *)tableView heightForHeaderInSection:(NSInteger)section;

- (NSString *)tableView:(PZHNExpandableTableView *)tableView titleForFooterInSection:(NSInteger)section;

- (NSString *)tableView:(PZHNExpandableTableView *)tableView titleForHeaderInSection:(NSInteger)section;

@end

@protocol PZHNExpandableTableViewDelegate <UITableViewDelegate,UIScrollViewDelegate>

@required
- (CGFloat)tableView:(PZHNExpandableTableView *)tableView heightForRowAtTreePath:(NSIndexPath *)treePath;
@optional
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end