//
//  OPHTableController.h
//  OPHTableController
//
//  Created by Ritesh Gupta on 22/07/14.
//  Copyright (c) 2014 Ophio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSPullToRefresh.h"
#import "OPHLoadMore.h"

@protocol OPHTableControllerDelegate;
@protocol OPHPullToRefreshCustomView;

@interface OPHTableController : NSObject

@property (strong, nonatomic) SSPullToRefreshView* pullToRefreshView;
@property (strong, nonatomic) OPHLoadMore* loadMore;

/* this method will by default add pull to refresh and loader into the table. */
- (instancetype)initWithScrollView:(UIScrollView*)scrollView delegate:(id<OPHTableControllerDelegate>)delegate;

/* this method can be used if you want to selectively add pull to refresh OR laoder into the table. */
- (instancetype)initWithScrollView:(UIScrollView*)scrollView delegate:(id<OPHTableControllerDelegate>)delegate withPullToRefresh:(BOOL)isPullToRefresh withLoadMore:(BOOL)isLoadMore;

/* this method will stop the pull to refresh, have to call explicitly */
- (void)pullToRefreshFinishLoading;

/* this method should be called when using a custom load more view; you can handle the animation of the custom loader in the delegate methods */
- (void)configCustomLoadMoreView:(UIView*)customView;

/* this method should be called when using a custom pull to refresh view; you can handle the animation of the custom loader and respond to the state changes in the delegate methods */
- (void)configCustomPullToRefreshView:(UIView<OPHPullToRefreshCustomView>*)customView;
@end

@protocol OPHTableControllerDelegate <SSPullToRefreshViewDelegate, OPHLoadMoreDelegate>
@end

@protocol OPHPullToRefreshCustomView <SSPullToRefreshContentView>
@end