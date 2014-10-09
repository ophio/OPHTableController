# OPHTableController
 
**Pull-to-refresh** and **Pagination** (load-more) have become ubiquitous in the contemporary iOS applications. And there are numerous libraries that provide either pull-to-refresh or pagination but not both. So we decided to write our own custom table manager that can handle both the functionalities. So now you just have to write your views and forget about the actual pull-to-refresh and pagination details.
<br/>

**OPHTableController** is an UITABLEVIEW manager for iOS which provides **Pull-To-Refresh** & **Pagination** functionality (along with default views) to your tableView with just one line of code.
```
self.tableController = [[OPHTableController alloc] 
     initWithScrollView:self.tableView delegate:self];
```
It uses [SSPullToRefresh](https://github.com/soffes/sspulltorefresh) for all the pull-to-refresh functionality.


##Installation with CocoaPods
[CocoaPods](http://cocoapods.org/) is a dependency manager for Objective-C, which automates and simplifies the process of using 3rd-party libraries like OPHTableController in your project. Add OPHTableController into your pod file and run ```pod install```. 

###Podfile
```
pod 'OPHTableController', :git => 'https://github.com/ophio/OPHTableController.git', :branch => 'master'
```

##Architecture
 - OPHLoadMore
```
It handles all the pagination functionality.
```
 - SSPullToRefresh
```
It handles all the pull to refresh functionality.
```
 - OPHTablController
```
It manages both the above classes and your viewcontroller or another manager should only interact with this class.
```


##How to use it
- Initialization methods

```
- (void)viewDidLoad {
   [super viewDidLoad];
     self.tableController = [[OPHTableController alloc] 
     initWithScrollView:self.tableView delegate:self];
}
```
<br/>

- Protocol to follow

```
OPHLoadMoreDelegate
```
<br/>

- **OPHTableController** manager Public methods

```
/* this method will by default add pull to refresh and loader into the table. */
- (instancetype)initWithScrollView:(UIScrollView*)scrollView delegate:(id<OPHTableControllerDelegate>)delegate;

/* this method can be used if you want to selectively add pull to refresh OR loader into the table. */
- (instancetype)initWithScrollView:(UIScrollView*)scrollView delegate:(id<OPHTableControllerDelegate>)delegate withPullToRefresh:(BOOL)isPullToRefresh withLoadMore:(BOOL)isLoadMore;

/* this method will stop the pull to refresh, have to call explicitly */
- (void)pullToRefreshFinishLoading;

/* this method should be called when using a custom view; you can handle the animation of the custom loader in the delegate methods */
- (void)configCustomLoadMoreView:(UIView*)customView;

```
<br/>

- Delegate Methods of **OPHLoadMore**

```
/* it should return YES if you want to use load more functionality */
- (BOOL)loadMoreShouldStartLoading:(OPHLoadMore *)loadMore;

/* you can perform API calls i.e. update data source; you should call the completion block explicitly after you have updated the data source. */
- (void)loadMoreDidStartLoading:(OPHLoadMore *)loadMore withCompletionBlock:(OPHCompletionBlock)block;

@optional
/* you can perform further actions after the loader stops */
- (void)loadMoreDidFinishLoading:(OPHLoadMore *)loadMore;
```
<br/>

- Custom view for Load-More

```
/* this method should be called when using a custom view; you can handle the animation of the custom loader in the delegate methods */
- (void)configCustomLoadMoreView:(UIView*)customView;
```
<br/>

- Checkout [**SSPullToRefresh**](https://github.com/soffes/sspulltorefresh) for its documentation.

## Contributing

Open an issue or send pull request [here](https://github.com/ophio/OPHTableController/issues/new). Read the contributring guidelines [here](https://github.com/ophio/OPHTableController/blob/master/CONTRIBUTING.md).


## Licence

OPHTableController is available under the MIT license. See the LICENSE file for more info.

##Thanks