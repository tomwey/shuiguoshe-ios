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
{
    UILabel* _cartLabel;
}

- (BOOL)shouldShowingCart
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if ( [self shouldShowingCart] ) {
        ForwardCommand* aCommand = [[[ForwardCommand alloc] init] autorelease];
        Forward* aForward = [Forward buildForwardWithType:ForwardTypeModal from:self toControllerName:@"CartViewController"];
        aForward.loginCheck = YES;
        aCommand.forward = aForward;
        CommandButton* btn = [[CoordinatorController sharedInstance] createCommandButton:@"btn_cart.png" command:aCommand];
        
        _cartLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(btn.bounds) - 20,
                                                                       0, 22, CGRectGetHeight(btn.bounds))];
        [btn addSubview:_cartLabel];
        [_cartLabel release];
        
        _cartLabel.textColor = RGB(217, 79, 16);
        _cartLabel.backgroundColor = [UIColor clearColor];
        _cartLabel.text = NSStringFromInteger([[CartService sharedService] totalCount]);
        _cartLabel.font = [UIFont systemFontOfSize:15];
        
        self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:btn] autorelease];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didAddToCart)
                                                     name:kAddToCartNotification
                                                   object:nil];
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)didAddToCart
{
    NSInteger total = _cartLabel.text.integerValue;
    total += 1;
    [[CartService sharedService] setTotalCount:total];
    _cartLabel.text = NSStringFromInteger(total);
}

- (void)swipe
{
    ForwardCommand* aCommand = nil;
    if ( [@"OrderResultViewController" isEqualToString:NSStringFromClass([self class])] ) {
        aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePopTo
                                                                                    from:self
                                                                            toControllerName:@"CartViewController"]];
    } else {
        aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePop
                                                                                    from:self
                                                                            toController:nil]];
    }

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.userData = nil;
    [super dealloc];
}

@end
