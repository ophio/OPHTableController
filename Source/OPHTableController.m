//
//  OPHTableController.m
//  OPHTableController
//
//  Created by Ritesh Gupta on 22/07/14.
//  Copyright (c) 2014 Ophio. All rights reserved.
//

#import "OPHTableController.h"

@interface OPHTableController ()
@property (strong, nonatomic) SSPullToRefreshView* pullToRefreshView;
@property (strong, nonatomic) OPHLoadMore* loadMore;
@end

@implementation OPHTableController

- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<OPHTableControllerDelegate>)delegate {
  return [self initWithScrollView:scrollView delegate:delegate withPullToRefresh:YES withLoadMore:YES];
}

- (instancetype)initWithScrollView:(UIScrollView *)scrollView delegate:(id<OPHTableControllerDelegate>)delegate withPullToRefresh:(BOOL)isPullToRefresh withLoadMore:(BOOL)isLoadMore {
  if (isPullToRefresh) {
    self.pullToRefreshView = [[SSPullToRefreshView alloc] initWithScrollView:scrollView delegate:delegate];
  }

  if (isLoadMore) {
    self.loadMore = [[OPHLoadMore alloc] initWithScrollView:scrollView delegate:delegate];
  }
  return self;
}

- (void)pullToRefreshFinishLoading {
  [self.pullToRefreshView finishLoading];
}

- (void)configCustomLoadMoreView:(UIView *)customView {
  [self.loadMore configCustomLoadMoreView:customView];
}

@end
