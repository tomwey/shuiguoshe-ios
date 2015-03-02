//
//  BannerView.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "BannerView.h"
#import "Defines.h"

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
        
        
//        _pagingView = [[InfinitePagingView alloc] initWithFrame:
//                                    self.bounds];
//        [self addSubview:_pagingView];
//        [_pagingView release];
//        
//        _pagingView.delegate = self;
        
        _pager = [[[UIPageControl alloc] init] autorelease];
        _pager.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5,
                                    CGRectGetHeight(self.bounds) * 0.9);
        [self addSubview:_pager];
        _pager.currentPage = 1;
        [self bringSubviewToFront:_pager];
        _pager.pageIndicatorTintColor = [UIColor blackColor];
        _pager.currentPageIndicatorTintColor = [UIColor redColor];//RGB(99, 185, 76);
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                 target:self
                                               selector:@selector(onTimer:)
                                               userInfo:nil
                                                repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
        
    }
    
    return self;
}

- (void)setDataSource:(NSArray *)data
{
    _pager.numberOfPages = [data count];
    
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
//    [_pagingView layoutPages];
}

- (void)onTimer:(id)sender
{
//    [_pagingView scrollToNextPage];
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
    }
    [imageView setImageWithURL:[NSURL URLWithString:banner.imageUrl]];
}

//- (void)pagingView:(InfinitePagingView *)pagingView didEndDecelerating:(UIScrollView *)scrollView atPageIndex:(NSInteger)pageIndex
//{
//    _pager.currentPage = pageIndex;
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger pageIndex = scrollView.contentOffset.x / CGRectGetWidth(scrollView.bounds) - 1;
//    NSLog(@"%d", pageIndex);
    // 3 1 2 3 1
    // 0 1 2 3 4
    NSLog(@"min:%f, max:%f, offset: %f", CGRectGetMinX(scrollView.bounds), CGRectGetMaxX(scrollView.bounds), scrollView.contentOffset.x);
    if ( scrollView.contentOffset.x == 0 ) {
        CGRect frame = scrollView.frame;
        frame.origin.x = scrollView.contentSize.width - CGRectGetWidth(frame) * 2;
        [scrollView scrollRectToVisible:frame animated:NO];
        pageIndex = _pager.numberOfPages;
    } else if ( scrollView.contentOffset.x == scrollView.contentSize.width - CGRectGetWidth(scrollView.frame) ) {
        CGRect frame = scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame);
        [scrollView scrollRectToVisible:frame animated:NO];
        pageIndex = 1;
    }
    
    _pager.currentPage = pageIndex;
}

@end
