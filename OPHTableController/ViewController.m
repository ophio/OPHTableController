//
//  ViewController.m
//  OPHTableController
//
//  Created by Ritesh Gupta on 18/07/14.
//  Copyright (c) 2014 Ophio. All rights reserved.
//

#import "ViewController.h"
#import "OPHTableController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, OPHTableControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) OPHTableController *tableController;
@property (strong, nonatomic) UIImageView *animationImageView;
@end

@implementation ViewController{
  NSInteger dataCount;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
  dataCount = 10;

  self.tableController = [[OPHTableController alloc] initWithScrollView:self.tableView delegate:self];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
  cell.textLabel.text = [NSString stringWithFormat:@"%lu", indexPath.row];
  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  return 44.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return dataCount;
}

- (void)pullToRefreshViewDidStartLoading:(SSPullToRefreshView *)view {
  [self performSelector:@selector(finishPullToRefresh) withObject:nil afterDelay:2.0];
}

- (void)finishPullToRefresh {
  [self.tableController pullToRefreshFinishLoading];
}

- (BOOL)loadMoreShouldStartLoading:(OPHLoadMore *)loadMore {
  BOOL shouldLoadMore;
  if (dataCount < 25) {
    shouldLoadMore = YES;
  }
  return shouldLoadMore;
}

- (void)loadMoreDidStartLoading:(OPHLoadMore *)loadMore withCompletionBlock:(OPHCompletionBlock)block {
  [self.animationImageView startAnimating];

  /* this method mimics API call */
  [self loadMoreWithCompletion:^(BOOL success){
    if (success) {
      [self.tableView reloadData];
    }
    [self.animationImageView stopAnimating];
    block(success);
  }];
}

- (void)loadMoreDidFinishLoading:(OPHLoadMore *)laodMore {
}

- (void)loadMoreWithCompletion:(void (^)(BOOL success))block {
  [self performSelector:@selector(finishLoadMoreLoading:) withObject:block afterDelay:2.0];
}

- (void)finishLoadMoreLoading:(void (^)(BOOL success))block {
  dataCount += 10;
  if (block) {
    block(YES);
  }
}

@end
