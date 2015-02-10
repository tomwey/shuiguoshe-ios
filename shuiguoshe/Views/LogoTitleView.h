//
//  LogoTitleView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Defines.h"

typedef void (^LogoTitleViewDidClickBlock)(BOOL closed);
@interface LogoTitleView : UIView

@property (nonatomic, copy) LogoTitleViewDidClickBlock didClickBlock;

@end
