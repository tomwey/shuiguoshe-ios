//
//  BaseViewController.h
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (BOOL)shouldShowingCart;

- (void)setLeftBarButtonWithImage:(NSString *)imageName target:(id)target action:(SEL)action;
- (void)setRightBarButtonWithImage:(NSString *)imageName target:(id)target action:(SEL)action;

@end
