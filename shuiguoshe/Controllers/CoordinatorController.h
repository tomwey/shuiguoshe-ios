//
//  CoordinatorController.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Defines.h"

@class Command;
@class CommandButton;
@interface CoordinatorController : NSObject

+ (id)sharedInstance;

- (void)forwardTo:(Forward *)aForward;

- (UINavigationController *)navController;
- (UIViewController *)homeViewController;

- (CommandButton *)createCommandButton:(NSString*)imageName command:(Command *)aCommand;

- (CommandButton *)createTextButton:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)color command:(Command *)aCommand;

@end
