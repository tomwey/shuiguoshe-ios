//
//  BaseViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ (UIViewController *)viewControllerWithClassName:(NSString *)clzName
{
    BaseViewController* ctl = [[[NSClassFromString(clzName) alloc] init] autorelease];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:ctl];
    return [nav autorelease];
}

@end
