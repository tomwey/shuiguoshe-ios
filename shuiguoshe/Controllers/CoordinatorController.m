//
//  CoordinatorController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "CoordinatorController.h"

@implementation CoordinatorController
{
    UINavigationController* _navController;
    HomeViewController*     _homeController;
}

+ (id)sharedInstance
{
    static CoordinatorController* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CoordinatorController alloc] init];
    });
    return instance;
}

- (id)init
{
    if ( self = [super init] ) {
        
        [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
        
        _homeController = [[[HomeViewController alloc] init] autorelease];
        _navController = [[UINavigationController alloc] initWithRootViewController:_homeController];
    }
    return self;
}

- (UINavigationController *)navController
{
    return _navController;
}

- (void)forwardTo:(Forward *)aForward
{
    UINavigationController* nav = aForward.from.navigationController;
    if ( !nav ) {
        nav = _navController;
    }
    
    switch (aForward.forwardType) {
        case ForwardTypePush:
        {
            NSAssert(!!aForward.toController, @"需要一个控制器的名字");
            BaseViewController* to = [[[NSClassFromString(aForward.toController) alloc] init] autorelease];
            to.userData = aForward.userData;
            [nav pushViewController:to animated:YES];
        }
            break;
        case ForwardTypePop:
        {
            [nav popViewControllerAnimated:YES];
        }
            break;
            
        case ForwardTypePopTo:
        {
            NSAssert(!!aForward.toController, @"需要一个控制器的名字");
            for (UIViewController* viewController in _navController.viewControllers) {
                if ( [NSStringFromClass([viewController class]) isEqualToString:aForward.toController] ) {
                    [nav popToViewController:viewController animated:YES];
                    break;
                }
            }
            
        }
            break;
            
        case ForwardTypePopHome:
        {
            [nav popToRootViewControllerAnimated:YES];
        }
            break;
            
        case ForwardTypeModal:
        {
            NSAssert(!!aForward.toController, @"需要设置toController");
            UIViewController* to = [[[NSClassFromString(aForward.toController) alloc] init] autorelease];
            UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:to] autorelease];
            [aForward.from presentViewController:nav animated:YES completion:nil];
        }
            break;
            
        case ForwardTypeDismiss:
        {
            [aForward.from dismissViewControllerAnimated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}

- (CommandButton *)createCommandButton:(NSString*)imageName command:(Command *)aCommand
{
    CommandButton* cmdBtn = [CommandButton buttonWithType:UIButtonTypeCustom];
    
    [cmdBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    cmdBtn.exclusiveTouch = YES;
    [cmdBtn sizeToFit];
    cmdBtn.command = aCommand;
    
    [cmdBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cmdBtn;
}

- (CommandButton *)createTextButton:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color command:(Command *)aCommand
{
    CommandButton* cmdBtn = [CommandButton buttonWithType:UIButtonTypeCustom];
    
    [cmdBtn setTitle:title forState:UIControlStateNormal];
    [cmdBtn setTitleColor:color forState:UIControlStateNormal];
    cmdBtn.exclusiveTouch = YES;
    cmdBtn.titleLabel.font = font;
    
    [cmdBtn sizeToFit];
    cmdBtn.command = aCommand;
    
    [cmdBtn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cmdBtn;
}

- (void)btnClicked:(CommandButton *)sender
{
    [sender.command execute];
}

@end
