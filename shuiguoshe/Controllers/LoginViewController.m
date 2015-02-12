//
//  LoginViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "LoginViewController.h"
#import "Defines.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self setLeftBarButtonWithImage:@"btn_close.png"
                            command:[ForwardCommand buildCommandWithForward:
                                     [Forward buildForwardWithType:ForwardTypeDismiss
                                                              from:self
                                                      toController:nil]]];
}

- (BOOL)shouldShowingCart
{
    return NO;
}

@end
