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
    
    // 分类
    [[DataService sharedService] loadEntityForClass:@"Catalog" URI:@"/catalogs" completion:^(id result, BOOL succeed) {
        int numberOfCol = 2;
        CGFloat padding = 20;
        CGFloat width = ( CGRectGetWidth(mainScreenBounds) - ( numberOfCol + 1 ) * padding ) / numberOfCol;
        CGFloat height = 0.318 * width;
        for (int i=0; i<[result count]; i++) {
            
            UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [scrollView addSubview:btn];
            
            Catalog* cata = [result objectAtIndex:i];
            [btn setTitle:cata.name forState:UIControlStateNormal];
            btn.backgroundColor = RGB(7,156,22);
            
            int m = i % numberOfCol;
            int n = i / numberOfCol;
            btn.frame = CGRectMake(padding + ( padding + width ) * m, _currentHeight + ( padding + height ) * n, width, height);
            
            if ( i == [result count] - 1 ) {
                _currentHeight = CGRectGetMaxY(btn.frame) + 10;
            }
            
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
    
    // 限时抢购
    [[DataService sharedService] loadEntityForClass:@"Item" URI:@"items/discounted" completion:^(id result, BOOL succeed) {
        if ( succeed ) {
            for (int i=0; i<[result count]; i++) {
                
            }
        } else {
            
        }
    }];
    
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.bounds), _currentHeight);
}

- (void)btnClicked:(UIButton *)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
