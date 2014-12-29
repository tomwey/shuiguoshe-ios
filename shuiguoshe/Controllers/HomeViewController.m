//
//  ViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"水果社";
    
    UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, mainScreenBounds.size.width, mainScreenBounds.size.height - 64 - 49)] autorelease];
    [self.view addSubview:scrollView];
    
    BannerView* banner = [[[BannerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(scrollView.bounds), CGRectGetHeight(banner.bounds))] autorelease];
    [scrollView addSubview:banner];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
