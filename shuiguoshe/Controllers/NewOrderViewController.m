//
//  NewOrderViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "NewOrderViewController.h"

@interface NewOrderViewController ()

@end

@implementation NewOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"确认订单";
    
    
}

- (BOOL)shouldShowingCart
{
    return NO;
}


@end
