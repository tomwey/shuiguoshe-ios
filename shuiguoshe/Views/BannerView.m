//
//  BannerView.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "BannerView.h"
#import "Defines.h"

NSString * const kBannerViewDidShowNotification = @"kBannerViewDidShowNotification";
NSString * const kBannerViewDidHideNotification = @"kBannerViewDidHideNotification";

@interface CustomImageView : UIImageView

@property (nonatomic, retain) Banner* banner;

@end

@implementation CustomImageView

- (void)dealloc
{
    self.banner = nil;
    [super dealloc];
}

@end

@interface BannerView () <InfinitePagingViewDelegate, UIScrollViewDelegate>
{
    UIPageControl*      _pager;
    InfinitePagingView* _pagingView;
    int                 _total;
    NSTimer*            _timer;
    
    UIScrollView*       _pageView;
    
    BOOL                _canLoop;
    BOOL                _allowLoop;
}

@end

@implementation BannerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, mainScreenBounds.size.width,
                                 mainScreenBounds.size.width * 360 / 994);
        
        _pageView = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self addSubview:_pageView];
        [_pageView release];
        
        _pageView.delegate = self;
        _pageView.pagingEnabled = YES;
        _pageView.showsHorizontalScrollIndicator = NO;
        
        _canLoop = YES;
        _allowLoop = YES;
        
        _pager = [[[UIPageControl alloc] init] autorelease];
        _pager.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5,
                                    CGRectGetHeight(self.bounds) * 0.9);
        [self addSubview:_pager];
        [self bringSubviewToFront:_pager];
        _pager.hidesForSinglePage = YES;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:3.0
                                                 target:self
                                               selector:@selector(onTimer:)
                                               userInfo:nil
                                                repeats:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startTimer)
                                                     name:UIApplicationWillEnterForegroundNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(stopTimer)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)btnClicked:(id)sender
{
    CustomImageView* imageView = (CustomImageView *)[sender superview];
    Banner* banner = imageView.banner;
    
    if ( banner.link.length > 0 ) {
        NSString* uri = [[banner.link componentsSeparatedByString:@"/"] lastObject];
        
        NSString *regex = @"item-\\d+";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL matches = [test evaluateWithObject:uri];
        
        if ( matches ) {
            // 推广产品的广告
            NSString* pid = [[uri componentsSeparatedByString:@"-"] lastObject];
            Item* item = [[[Item alloc] init] autorelease];
            item.iid = [pid integerValue];
            
            ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:
                                        [Forward buildForwardWithType:ForwardTypePush
                                                                 from:[[CoordinatorController sharedInstance] homeViewController]
                                                     toControllerName:@"ItemDetailViewController"]];
            aCommand.userData = item;
            [aCommand execute];
        } else {
            // 普通广告
            ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:
                                        [Forward buildForwardWithType:ForwardTypePush
                                                                 from:[[CoordinatorController sharedInstance] homeViewController]
                                                     toControllerName:@"AdDetailViewController"]];
            aCommand.userData = banner;
            
            [aCommand execute];
        }
    }
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
    [super dealloc];
}

- (void)startLoop
{
    _allowLoop = YES;
    [self startTimer];
}

- (void)stopLoop
{
    _allowLoop = NO;
    [self stopTimer];
}

- (void)startTimer
{
    if ( !_allowLoop ) {
        return;
    }
    
    _canLoop = YES;
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:_timer.timeInterval]];
}

- (void)stopTimer
{
    _canLoop = NO;
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)setDataSource:(NSArray *)data
{
    _pager.numberOfPages = [data count];
    
    if ( [data count] <= 1 ) {
        for (int i=0; i<[data count]; i++) {
            Banner* banner = [data objectAtIndex:i];
            [self addImageViewAtPosition:i forBanner:banner];
        }
        
        _pageView.contentSize = CGSizeMake(CGRectGetWidth(_pageView.frame) * [data count],
                                           CGRectGetHeight(_pageView.frame));
        
        [_timer invalidate];
        _timer = nil;
    } else {
        // 添加最后一个到第一个位置
        Banner* bannerL = [data objectAtIndex:[data count] - 1];
        [self addImageViewAtPosition:0 forBanner:bannerL];
        
        for ( int i=1; i<=[data count]; i++) {
            Banner* banner = [data objectAtIndex:i - 1];
            [self addImageViewAtPosition:i forBanner:banner];
        }
        
        // 添加第一个到最后一个位置
        Banner* banner0 = [data objectAtIndex:0];
        [self addImageViewAtPosition:data.count + 1 forBanner:banner0];
        
        _pageView.contentSize = CGSizeMake(CGRectGetWidth(_pageView.frame) * (_pager.numberOfPages + 2),
                                           CGRectGetHeight(_pageView.frame));
        _pageView.contentOffset = CGPointMake(CGRectGetWidth(_pageView.frame), 0);
    }
}

- (void)onTimer:(id)sender
{
    if ( !_canLoop ) {
        return;
    }
    
    UIScrollView* scrollView = _pageView;
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSInteger pageIndex = page % _pager.numberOfPages;
    _pager.currentPage = pageIndex;
    
    [self handleScroll:_pageView];
    
    CGPoint offset = _pageView.contentOffset;
    offset.x += CGRectGetWidth(_pageView.frame);
    [_pageView setContentOffset:offset animated:YES];
}

- (void)addImageViewAtPosition:(int)index forBanner:(Banner *)banner
{
    CustomImageView* imageView = (CustomImageView *)[_pageView viewWithTag:100 + index];
    if ( !imageView ) {
        imageView = [[CustomImageView alloc] init];
        imageView.frame = CGRectMake(CGRectGetWidth(_pageView.frame) * index, 0,
                                     CGRectGetWidth(_pageView.frame),
                                     CGRectGetHeight(_pageView.frame));
        [_pageView addSubview:imageView];
        [imageView release];
        imageView.tag = 100 + index;
        imageView.banner = banner;
        
        imageView.userInteractionEnabled = YES;
        
//        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(btnClicked:)];
//        [imageView addGestureRecognizer:tap];
//        [tap release];
        
        UIButton* btn = createButton(nil, self, @selector(btnClicked:));
        [imageView addSubview:btn];
        btn.frame = imageView.bounds;
        
    }
    
    [imageView setImageWithURL:[NSURL URLWithString:banner.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)handleScroll:(UIScrollView *)scrollView
{
    if ( scrollView.contentOffset.x == 0 ) {
        CGRect frame = scrollView.frame;
        frame.origin.x = scrollView.contentSize.width - CGRectGetWidth(frame) * 2;
        [scrollView scrollRectToVisible:frame animated:NO];
    } else if ( scrollView.contentOffset.x == scrollView.contentSize.width - CGRectGetWidth(scrollView.frame) ) {
        CGRect frame = scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame);
        [scrollView scrollRectToVisible:frame animated:NO];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ( !_canLoop ) {
        [self startTimer];
    }
    
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    NSInteger pageIndex = page % _pager.numberOfPages;
    if ( pageIndex == 0 ) {
        pageIndex = _pager.numberOfPages;
    }
    
    _pager.currentPage = pageIndex - 1;
    
    [self handleScroll:scrollView];
}

@end
