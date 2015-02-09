//
//  ViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "HomeViewController.h"
#import "UIImageView+AFNetworking.h"

@interface HomeViewController ()

@end

@implementation HomeViewController
{
    CGFloat _currentHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"水果社";
    
    UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenBounds.size.width, mainScreenBounds.size.height - 0 - 49)] autorelease];
    [self.view addSubview:scrollView];
//    scrollView.backgroundColor = [UIColor redColor];
    BannerView* banner = [[[BannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)] autorelease];
    [scrollView addSubview:banner];
    
    _currentHeight = CGRectGetMaxY(banner.frame) + 10;
    
    // 今日特卖区
    UILabel* discountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _currentHeight, 200, 40)];
    [scrollView addSubview:discountLabel];
    [discountLabel release];
    discountLabel.text = @"今日特卖区";
    
    discountLabel.textColor = RGB(83, 83, 83);
    discountLabel.font = [UIFont boldSystemFontOfSize:18];
    
    _currentHeight = CGRectGetMaxY(discountLabel.frame) + 5;
    
    [[DataService sharedService] loadEntityForClass:@"Item"
                                                URI:@"/items/discounted"
                                         completion:^(id result, BOOL succeed) {
                                             if ( !succeed ) {
                                                 NSLog(@"Load Item Error");
                                             } else {
                                                 CGFloat dt = 0;
                                                 for (int i=0; i<[result count]; i++) {
                                                     UIImageView* imageView = [[UIImageView alloc] init];
                                                     [scrollView addSubview:imageView];
                                                     [imageView release];
                                                     
                                                     imageView.frame = CGRectMake((100+10) * i, CGRectGetMaxY(discountLabel.frame) + 5, 100, 83);
                                                     
                                                     Item* item = [result objectAtIndex:i];
                                                     [imageView setImageWithURL:[NSURL URLWithString:item.thumbImageUrl]];
                                                     
                                                     CGRect frame = imageView.frame;
                                                     frame.size.height = 40;
                                                     frame.origin.y = CGRectGetMaxY(imageView.frame) + 5;
                                                     UILabel* label = [[UILabel alloc] initWithFrame:frame];
                                                     [scrollView addSubview:label];
                                                     [label release];
                                                     
                                                     label.textColor = [UIColor blackColor];
                                                     label.textAlignment = NSTextAlignmentCenter;
                                                     label.text = item.title;
                                                     
                                                     dt = CGRectGetMaxY(label.frame);
                                                 }
                                             }
                                         }];
    
    // 鲜果专卖区
    UILabel* saleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _currentHeight + 120, 200, 40)];
    [scrollView addSubview:saleLabel];
    [saleLabel release];
    saleLabel.text = @"鲜果专卖区";
    
    saleLabel.textColor = RGB(83, 83, 83);
    saleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    _currentHeight = CGRectGetMaxY(saleLabel.frame) + 10;
    
    [[DataService sharedService] loadEntityForClass:@"Sale"
                                                URI:@"/sales"
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
//                                                 UILabel* titleLabel = [[UILabel alloc] initW
                                             } else {
                                                 
                                             }
                                         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
