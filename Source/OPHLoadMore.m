//
//  OPHLoadMore.m
//  OPHTableController
//
//  Created by Ritesh Gupta on 22/07/14.
//  Copyright (c) 2014 Ophio. All rights reserved.
//

#import "OPHLoadMore.h"

#define kLoadMoreDefaultHeight 64.0f
#define kReloadDistance 44.0f
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface OPHLoadMore()
@property (nonatomic, assign, readwrite) UIScrollView *scrollView;
@property (nonatomic, assign, readwrite) OPHScrollViewState scrollViewState;
@property (nonatomic, assign, readwrite) OPHLoadMoreViewState state;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
@property (nonatomic, strong) UIView *customLoadMore;
@property (nonatomic, assign) CGFloat loadMoreCellHeight;
@property (nonatomic, assign) CGFloat previousContentHeight;
@end

@implementation OPHLoadMore

- (id)initWithScrollView:(UIScrollView *)scrollView delegate:(id<OPHLoadMoreDelegate>)delegate {
  if (self != nil) {
    
    self.scrollView = scrollView;
    self.delegate = delegate;
    self.state = OPHLoadMoreViewStateNormal;
    self.loadMoreCellHeight = kLoadMoreDefaultHeight;
    
    [self addDefaultLoadMore];
    [self loadMoreViewHidden:YES];
    
    void *context = (__bridge void *)self;
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:context];
  }
  return self;
}

- (id)init{
  return [self initWithScrollView:nil delegate:nil];
}

- (void)addDefaultLoadMore {
  self.activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
  self.activityView.clipsToBounds = NO;
  self.activityView.frame = CGRectMake(0, 0, kScreenWidth, self.loadMoreCellHeight);
  [self.scrollView addSubview:self.activityView];
}

- (void)loadMoreViewHidden:(BOOL)hidden {
  if (self.customLoadMore == nil) {
    self.activityView.hidden = hidden;
    if (hidden) {
      [self.activityView stopAnimating];
    } else {
      [self.activityView startAnimating];
    }
  } else {
    self.customLoadMore.hidden = hidden;
  }
}

- (void)configCustomLoadMoreView:(UIView *)customView {
  self.activityView = nil;
  self.customLoadMore = customView;
  self.loadMoreCellHeight = customView.frame.size.height;
  [self.scrollView addSubview:self.customLoadMore];
}

- (void)setloadMoreCellFrame {
  if (self.customLoadMore == nil) {
    self.activityView.frame = CGRectMake(0,
                                         self.scrollView.contentSize.height + self.scrollView.contentInset.bottom,
                                         kScreenWidth,
                                         self.loadMoreCellHeight);
    
  } else {
    self.customLoadMore.frame = CGRectMake((kScreenWidth - self.customLoadMore.frame.size.width)/2.0f,
                                           self.scrollView.contentSize.height + self.scrollView.contentInset.bottom,
                                           self.customLoadMore.frame.size.width,
                                           self.customLoadMore.frame.size.height);
  }
}

- (void)adjustScrollViewState {
  if (self.scrollView.contentOffset.y < 0) {
    self.scrollViewState = OPHScrollViewPullToRefreshState;
  } else if ([self calculateIfLoadMore:self.scrollView] && self.scrollView.contentOffset.y > 0) {
    self.scrollViewState = OPHScrollViewLoadMoreState;
  } else {
    self.scrollViewState = OPHScrollViewScrollingState;
  }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  // Call super if we didn't register for this notification
  if (context != (__bridge void *)self) {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    return;
  }
  
  // Get the offset out of the change notification
  CGFloat y = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue].y + self.scrollView.contentInset.top + self.scrollView.frame.size.height;
  
  // adjusts scroll view state i.e. OPHScrollViewState
  [self adjustScrollViewState];
  
  // loader will trigger only if user scrolls enough
  CGFloat minLoadMoreHeight = self.scrollView.contentSize.height + kReloadDistance + self.scrollView.contentInset.bottom;
  
  if (self.scrollView.isDragging && self.scrollViewState == OPHScrollViewLoadMoreState) {
    if (self.state == OPHLoadMoreViewStateNormal) {
      if (y > minLoadMoreHeight) {
        self.state = OPHLoadMoreViewStateReady;
      }
    } else if (self.state == OPHLoadMoreViewStateReady) {
      if (y < minLoadMoreHeight) {
        self.state = OPHLoadMoreViewStateNormal;
      }
    }
    
  } else if (self.scrollView.isDecelerating  && self.scrollViewState == OPHScrollViewLoadMoreState) {
    if (self.state == OPHLoadMoreViewStateReady) {
      [self handleLoadMoreReadyState];
      
    } else if (self.state == OPHLoadMoreViewStateNormal){
    }
  }
}


- (void)handleLoadMoreReadyState {
  if ([self.delegate respondsToSelector:@selector(loadMoreShouldStartLoading:)]) {
    if (![self.delegate loadMoreShouldStartLoading:self]) {
      self.state = OPHLoadMoreViewStateNormal;
    } else {
      [self handleLoadMoreLoadingState];
    }
  }
}

- (void)handleLoadMoreLoadingState {
  self.state = OPHLoadMoreViewStateLoading;
  [self setloadMoreCellFrame];
  [self loadMoreViewHidden:NO];
  self.previousContentHeight = self.scrollView.contentSize.height;
  
  UIEdgeInsets loadMoreEdgeInsets = self.scrollView.contentInset;
  loadMoreEdgeInsets.bottom += self.loadMoreCellHeight;
  
  [UIView animateWithDuration:0.5 animations:^{
    self.scrollView.contentInset = loadMoreEdgeInsets;
    
  } completion:^(BOOL finished) {
    
        if ([self.delegate respondsToSelector:@selector(loadMoreShouldStartLoading:)]) {
            BOOL shouldLoad = [self.delegate loadMoreShouldStartLoading:self];
            if (shouldLoad) {
                if ([self.delegate respondsToSelector:@selector(loadMoreDidStartLoading:withCompletionBlock:)]) {
                    [self.delegate loadMoreDidStartLoading:self withCompletionBlock:^(BOOL success) {
                        [self finishLoading];
                      }];
                  }
              }
        }
  }];
}

- (BOOL)calculateIfLoadMore:(UIScrollView*)scrollView {
  CGPoint currentOffset = scrollView.contentOffset;
  CGRect scrollViewBounds = scrollView.bounds;
  CGSize scrollViewContentSize = scrollView.contentSize;
  UIEdgeInsets scrollViewInsets = scrollView.contentInset;
  
  CGFloat bottomScrolledYPosition = currentOffset.y + scrollViewBounds.size.height + scrollViewInsets.bottom;
  CGFloat scrollViewContentHeight = scrollViewContentSize.height;
  CGFloat reloadDistance = 0;
  return ((bottomScrolledYPosition - scrollViewContentHeight + reloadDistance) > 0);
}

- (void)startLoading {
  [self handleLoadMoreLoadingState];
}

- (void)finishLoading {
  UIEdgeInsets loadMoreEdgeInsets = self.scrollView.contentInset;
  loadMoreEdgeInsets.bottom -= self.loadMoreCellHeight;
  CGPoint loadMoreoffset = self.scrollView.contentOffset;
  CGPoint finalOffset;
  if (self.scrollView.contentSize.height >= self.previousContentHeight) {
    finalOffset = loadMoreoffset;
    CGFloat currentContentHeight = self.scrollView.contentSize.height;
    CGFloat extraHeight = self.loadMoreCellHeight - (currentContentHeight - self.previousContentHeight);
    
    if (extraHeight > 0 && self.scrollView.contentSize.height - self.scrollView.frame.size.height > 0) {
      CGPoint currentoffset = self.scrollView.contentOffset;
      currentoffset.y -= extraHeight;
      finalOffset = currentoffset;
    }
  }
  
  [UIView animateWithDuration:0.5 animations:^{
    if ([self calculateIfLoadMore:self.scrollView]) {
      self.scrollView.contentInset = loadMoreEdgeInsets;
      self.scrollView.contentOffset = finalOffset;
    }
  } completion:^(BOOL finished) {
    [self loadMoreViewHidden:YES];
    [self setloadMoreCellFrame];
    self.state = OPHLoadMoreViewStateNormal;
    if ([self.delegate respondsToSelector:@selector(loadMoreDidFinishLoading:)]) {
      [self.delegate loadMoreDidFinishLoading:self];
    }
  }];
}

@end
