//
//  OPHLoadMore.h
//  OPHTableController
//
//  Created by Ritesh Gupta on 22/07/14.
//  Copyright (c) 2014 Ophio. All rights reserved.
//

#import <Foundation/Foundation.h>

// load more states
typedef enum {
  OPHLoadMoreViewStateNormal,
  OPHLoadMoreViewStateReady,
  OPHLoadMoreViewStateLoading,
} OPHLoadMoreViewState;

// scrollview states
typedef enum {
  OPHScrollViewPullToRefreshState,
  OPHScrollViewScrollingState,
  OPHScrollViewLoadMoreState,
} OPHScrollViewState;

@protocol OPHLoadMoreDelegate;
typedef void (^OPHCompletionBlock)(BOOL);

@interface OPHLoadMore : NSObject
@property (nonatomic, assign, readonly) UIScrollView *scrollView;
@property (nonatomic, weak) id<OPHLoadMoreDelegate> delegate;
@property (nonatomic, assign, readonly) OPHScrollViewState scrollViewState;
@property (nonatomic, assign, readonly) OPHLoadMoreViewState state;
@property (nonatomic, strong) OPHCompletionBlock block;
@property (nonatomic, assign) BOOL showAboveBottomInset;

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<OPHLoadMoreDelegate>)delegate;

/*
 Add & remove observer when view appears & disappears.
 Not removing observer was crashing the app.
*/
- (void)addScrollViewObserver;
- (void)removeScrollViewObserver;

/* this method should be called when using a custom view; you can handle the animation of the custom loader in the delegate methods */
- (void)configCustomLoadMoreView:(UIView*)customView;

- (void)finishLoading;

- (void)startLoading;
@end

@protocol OPHLoadMoreDelegate <NSObject>

@optional

/* it should return YES if you want to show loader */
- (BOOL)loadMoreShouldStartLoading:(OPHLoadMore *)loadMore;

/* you can perform API calls i.e. update data source; you should call the completion block explicitly after you update data source. */
- (void)loadMoreDidStartLoading:(OPHLoadMore *)loadMore withCompletionBlock:(OPHCompletionBlock)block;

/* you can perform further actions after the loader stops */
- (void)loadMoreDidFinishLoading:(OPHLoadMore *)loadMore;
@end
