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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"水果社";
    
    UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenBounds.size.width, mainScreenBounds.size.height - 64 - 49)] autorelease];
    [self.view addSubview:scrollView];
    
    BannerView* banner = [[[BannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)] autorelease];
    [scrollView addSubview:banner];
    
    // 今日特卖区
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(banner.frame) + 10, 200, 40)];
    [scrollView addSubview:label];
    [label release];
    label.text = @"今日特卖区";
    
    label.textColor = RGB(83, 83, 83);
    label.font = [UIFont boldSystemFontOfSize:18];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://shuiguoshe.com/api/v1/items/discounted"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
             NSArray* array = [responseObject objectForKey:@"data"];
        for (int i=0; i<[array count]; i++) {
            UIImageView* imageView = [[UIImageView alloc] init];
            [scrollView addSubview:imageView];
            [imageView release];
            
            imageView.frame = CGRectMake((100+10) * i, CGRectGetMaxY(label.frame) + 5, 100, 83);
            
            [imageView setImageWithURL:[NSURL URLWithString:
                                        [[array objectAtIndex:i] objectForKey:@"thumb_image"]]];
            
            CGRect frame = imageView.frame;
            frame.size.height = 40;
            frame.origin.y = CGRectGetMaxY(imageView.frame) + 5;
            UILabel* label = [[UILabel alloc] initWithFrame:frame];
            [scrollView addSubview:label];
            [label release];
            
            label.textColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = [[array objectAtIndex:i] objectForKey:@"low_price"];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@", error);
    }];
    
    [manager GET:@"http://shuiguoshe.com/api/v1/sales"
      parameters:nil
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
//             NSLog(@"%@", responseObject);
             NSArray* array = [responseObject objectForKey:@"data"];
             for (int i=0; i<[array count]; i++) {
                 UIView *container = [[UIView alloc] init];
                 
             }
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             NSLog(@"error:%@", error);
         }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
