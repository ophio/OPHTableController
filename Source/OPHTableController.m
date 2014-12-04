//
//  OPHTableController.m
//  OPHTableController
//
//  Created by Ritesh Gupta on 22/07/14.
//  Copyright (c) 2014 Ophio. All rights reserved.
//

#import "OPHTableController.h"

@interface OPHTableController ()
@end

@implementation OPHTableController

- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<OPHTableControllerDelegate>)delegate {
  return [self initWithScrollView:scrollView delegate:delegate withPullToRefresh:YES withLoadMore:YES];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<OPHTableControllerDelegate>)delegate withPullToRefresh:(BOOL)isPullToRefresh withLoadMore:(BOOL)isLoadMore {
  self = [super init];
  if (self){
    if (isPullToRefresh) {
      self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:scrollView delegate:delegate];
    }
    if (isLoadMore) {
      self.loadMore = [[OPHLoadMore alloc] initWithScrollView:scrollView delegate:delegate];
    }
  }
  return self;
}

- (id)init{
  return [self initWithScrollView:nil delegate:nil withPullToRefresh:NO withLoadMore:NO];
}

- (void)pullToRefreshFinishLoading {
  [self.pullToRefreshView finishLoading];
}

- (void)configCustomLoadMoreView:(UIView *)customView {
  [self.loadMore configCustomLoadMoreView:customView];
}

- (void)configCustomPullToRefreshView:(UIView<OPHPullToRefreshCustomView>*)customView{
  self.pullToRefreshView.contentView = customView;
  self.pullToRefreshView.expandedHeight =customView.frame.size.height;
}

@end
