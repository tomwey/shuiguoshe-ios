//
//  BaseViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "BaseViewController.h"
#import "Defines.h"

@interface BaseViewController ()

@end

@implementation BaseViewController


- (BOOL)shouldShowingCart
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ( [self shouldShowingCart] ) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"btn_cart.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(gotoCart) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        
        UILabel* cartLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn.bounds) - 20,
                                                                       0, 22, CGRectGetHeight(btn.bounds))];
        [btn addSubview:cartLabel];
        [cartLabel release];
        
        cartLabel.textColor = RGB(217, 79, 16);
        cartLabel.backgroundColor = [UIColor clearColor];
        cartLabel.text = @"0";
        cartLabel.font = [UIFont systemFontOfSize:15];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
    }
}

- (void)gotoCart
{
    
}

- (void)setLeftBarButtonWithImage:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
}

- (void)setRightBarButtonWithImage:(NSString *)imageName target:(id)target action:(SEL)action
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
