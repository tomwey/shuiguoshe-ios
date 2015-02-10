//
//  PhoneNumberView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Defines.h"

@interface PhoneNumberView : UIView

+ (id)currentPhoneNumberView;

- (void)showInView:(UIView *)superView;
- (void)dismiss;

@end
