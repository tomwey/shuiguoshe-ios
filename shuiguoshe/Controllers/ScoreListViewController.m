//
//  ScoreListViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ScoreListViewController.h"

@interface ScoreListViewController ()

@end

@implementation ScoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的积分";
}

- (BOOL)shouldShowingCart { return NO; }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
