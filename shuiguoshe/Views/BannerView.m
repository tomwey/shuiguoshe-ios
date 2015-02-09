//
//  BannerView.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "BannerView.h"
#import "Defines.h"

@interface BannerView () <InfinitePagingViewDelegate>
{
    UIPageControl*      _pager;
    InfinitePagingView* _pagingView;
    int                 _total;
    NSTimer*            _timer;
}

@end

@implementation BannerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, mainScreenBounds.size.width,
                                 mainScreenBounds.size.width * 360 / 994);
        _pagingView = [[InfinitePagingView alloc] initWithFrame:
                                    self.bounds];
        [self addSubview:_pagingView];
        [_pagingView release];
        
        _pagingView.delegate = self;
        
        _pager = [[[UIPageControl alloc] init] autorelease];
        _pager.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, 30);
        [self addSubview:_pager];
        _pager.currentPage = 1;
        [self bringSubviewToFront:_pager];
        _pager.currentPageIndicatorTintColor = [UIColor redColor];//RGB(99, 185, 76);
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                 target:self
                                               selector:@selector(onTimer:)
                                               userInfo:nil
                                                repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
        
        [[DataService sharedService] loadEntityForClass:@"Banner"
                                                    URI:@"/banners"
                                             completion:^(id result, BOOL succeed) {
                                                 if ( !succeed ) {
                                                     NSLog(@"Load Data Error");
                                                 } else {
                                                     for ( int i=0; i<[result count]; i++) {
                                                         Banner* banner = [result objectAtIndex:i];
                                                         [self addImageViewAtPosition:i forURL:banner.imageUrl];
                                                     }
                                                     
                                                     [_pagingView layoutPages];
                                                 }
                                             }];
    }
    
    return self;
}

- (void)onTimer:(id)sender
{
//    [pagingView scrollToNextPage];
}

- (void)addImageViewAtPosition:(int)index forURL:(NSString *)url
{
    UIImageView* imageView = [[UIImageView alloc] init];
    imageView.frame = CGRectMake(0, 0,
                                 CGRectGetWidth(_pagingView.frame),
                                 CGRectGetHeight(_pagingView.frame));
    
    [_pagingView addPageView:imageView];
    [imageView release];
    

    
    [imageView setImageWithURL:[NSURL URLWithString:url]];
}

- (void)pagingView:(InfinitePagingView *)pagingView didEndDecelerating:(UIScrollView *)scrollView atPageIndex:(NSInteger)pageIndex
{
    _pager.currentPage = pageIndex;
}

@end
