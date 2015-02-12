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
        ForwardCommand* aCommand = [[[ForwardCommand alloc] init] autorelease];
        aCommand.forward = [Forward buildForwardWithType:ForwardTypeModal from:self toControllerName:@"CartViewController"];
        CommandButton* btn = [[CoordinatorController sharedInstance] createCommandButton:@"btn_cart.png" command:aCommand];
        
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
    
    [self setLeftBarButtonWithImage:@"btn_back.png"
                            command:[ForwardCommand buildCommandWithForward:
                                     [Forward buildForwardWithType:ForwardTypePop
                                                              from:self
                                                      toController:nil]]];
    
    UISwipeGestureRecognizer* leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe)];
    [self.view addGestureRecognizer:leftSwipe];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [leftSwipe release];
}

- (void)swipe
{
    ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePop
                                                                                                from:self
                                                                                        toController:nil]];
    [aCommand execute];
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

- (void)setLeftBarButtonWithImage:(NSString *)imageName command:(Command *)aCommand
{
    CommandButton* cmdBtn = [[CoordinatorController sharedInstance] createCommandButton:imageName command:aCommand];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cmdBtn] autorelease];
}

- (void)setRightBarButtonWithImage:(NSString *)imageName command:(Command *)aCommand
{
    CommandButton* cmdBtn = [[CoordinatorController sharedInstance] createCommandButton:imageName command:aCommand];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cmdBtn] autorelease];
}

- (void)dealloc
{
#if DEBUG
    NSLog(@"############# %@ dealloc #############", NSStringFromClass([self class]));
#endif
    self.userData = nil;
    [super dealloc];
}

@end
