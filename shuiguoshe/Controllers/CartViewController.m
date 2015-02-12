//
//  CartViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "CartViewController.h"

@interface CartViewController ()

@end

@implementation CartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的购物车";
    
    [self setLeftBarButtonWithImage:@"btn_close.png"
                            command:[ForwardCommand buildCommandWithForward:
                                     [Forward buildForwardWithType:ForwardTypeDismiss
                                                              from:self
                                                      toController:nil]]];
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
