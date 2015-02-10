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
{
    CGFloat _currentHeight;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBarButtonWithImage:@"btn_user.png" target:self action:@selector(gotoUserProfile)];
    
    LogoTitleView* titleView = [[[LogoTitleView alloc] init] autorelease];
    self.navigationItem.titleView = titleView;
    
    PhoneNumberView* pnv = [PhoneNumberView currentPhoneNumberView];
    titleView.didClickBlock = ^(BOOL closed) {
        if ( closed ) {
            [pnv dismiss];
        } else {
            [pnv showInView:self.view];
        }
    };
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds),
                                                                           CGRectGetHeight(mainScreenBounds))
                                                          style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIScrollView* scrollView = [[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, mainScreenBounds.size.width, mainScreenBounds.size.height - 0 - 49)] autorelease];
//    [self.view addSubview:scrollView];
    BannerView* banner = [[[BannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)] autorelease];
    [scrollView addSubview:banner];
    
    _currentHeight = CGRectGetMaxY(banner.frame) + 10;
    
    
    // 分类选购
    SectionView* sv = [[[SectionView alloc] init] autorelease];
    [scrollView addSubview:sv];
    CGRect frame = sv.bounds;
    frame.origin.y = _currentHeight + 10;
    frame.origin.x = 20;
    sv.frame = frame;
    
    [sv setSectionName:@"分类选购"];
    
    _currentHeight = CGRectGetMaxY(sv.frame) + 10;
    
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
            btn.backgroundColor = RGB(232,233,232);
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            int m = i % numberOfCol;
            int n = i / numberOfCol;
            btn.frame = CGRectMake(padding + ( padding + width ) * m, 160 + 10 + ( padding + height ) * n, width, height);
            
            [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        }
    }];
    
    // 限时抢购
    [[DataService sharedService] loadEntityForClass:@"Item" URI:@"items/discounted" completion:^(id result, BOOL succeed) {
        if ( succeed ) {
            SectionView* sv = [[[SectionView alloc] init] autorelease];
            [scrollView addSubview:sv];
            CGRect frame = sv.bounds;
            frame.origin.y = 280 + 10;
            frame.origin.x = 20;
            sv.frame = frame;
            
            [sv setSectionName:@"限时抢购"];
            
            _currentHeight = CGRectGetMaxY(sv.frame) + 10;
            
            int numberOfCol = 2;
            CGFloat padding = 20;
            CGFloat width = ( CGRectGetWidth(mainScreenBounds) - ( numberOfCol + 1 ) * padding ) / numberOfCol;
            
            for (int i=0; i<[result count]; i++) {
                ItemView* itemView = [[[ItemView alloc] init] autorelease];
                [scrollView addSubview:itemView];
                
                itemView.item = [result objectAtIndex:i];
                
                int m = i % numberOfCol;
                int n = i / numberOfCol;
                
                itemView.frame = CGRectMake(padding + ( padding + width ) * m,
                                            _currentHeight + 10 + (padding + 200) * n,
                                            width, 200);
            }
        } else {
            
        }
    }];
    
    scrollView.contentSize = CGSizeMake(CGRectGetWidth(scrollView.bounds), 1000);
}

- (void)gotoUserProfile
{
    UserViewController* uvc = [[[UserViewController alloc] init] autorelease];
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:uvc] autorelease];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)btnClicked:(UIButton *)sender
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
