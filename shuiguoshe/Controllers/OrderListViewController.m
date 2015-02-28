//
//  OrderListViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderListViewController.h"

@interface OrderListViewController ()

@end

@implementation OrderListViewController


- (BOOL) shouldShowingCart { return NO; }

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ( [self.userData isEqualToString:@"1"] ) {
        self.title = @"全部订单";
    }
}

@end
