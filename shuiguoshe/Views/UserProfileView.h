//
//  UserProfileView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@interface UserProfileView : UIView

- (void)setUser:(User *)aUser;

@property (nonatomic, assign) UIViewController* imagePickerContainer;

@end
