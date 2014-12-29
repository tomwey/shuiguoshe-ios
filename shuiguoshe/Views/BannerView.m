//
//  BannerView.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "BannerView.h"
#import "Defines.h"
#import "UIImageView+AFNetworking.h"
#import "InfinitePagingView.h"

@interface BannerView () <InfinitePagingViewDelegate>
{
    UIPageControl* pager;
    InfinitePagingView* pagingView;
    int total;
    NSTimer* timer;
}

@end

@implementation BannerView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.bounds = CGRectMake(0, 0, mainScreenBounds.size.width,
                                 mainScreenBounds.size.width * 360 / 994);
        pagingView = [[InfinitePagingView alloc] initWithFrame:
                                    self.bounds];
        [self addSubview:pagingView];
        [pagingView release];
        
        pagingView.delegate = self;
        
        pager = [[[UIPageControl alloc] init] autorelease];
//        pager.bounds = CGRectMake(0, 0, 300, 20);
        pager.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, 30);
        [self addSubview:pager];
        pager.currentPage = 1;
        [self bringSubviewToFront:pager];
        pager.currentPageIndicatorTintColor = [UIColor redColor];//RGB(99, 185, 76);
        
        timer = [NSTimer scheduledTimerWithTimeInterval:2.0
                                                 target:self
                                               selector:@selector(onTimer:)
                                               userInfo:nil
                                                repeats:YES];
        [timer setFireDate:[NSDate distantFuture]];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager GET:@"http://shuiguoshe.com/api/v1/banners.json"
          parameters:nil
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
//            NSLog(@"JSON: %@", responseObject);
                 if ( [[responseObject objectForKey:@"code"] intValue] == 0 ) {
                     NSArray* banners = [responseObject objectForKey:@"data"];
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         for ( int i=0; i<[banners count]; i++) {
                             [self addImageViewAtPosition:i forURL:[[banners objectAtIndex:i] objectForKey:@"image"]];
                         }
                         
                         [pagingView layoutPages];
                         
                         [timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
                     });
                 } else {
                     NSLog(@"加载失败");
                 }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
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
                                 CGRectGetWidth(pagingView.frame),
                                 CGRectGetHeight(pagingView.frame));
    
    [pagingView addPageView:imageView];
    [imageView release];
    

    
    [imageView setImageWithURL:[NSURL URLWithString:url]];
}

- (void)pagingView:(InfinitePagingView *)pagingView didEndDecelerating:(UIScrollView *)scrollView atPageIndex:(NSInteger)pageIndex
{
    pager.currentPage = pageIndex;
}

@end
