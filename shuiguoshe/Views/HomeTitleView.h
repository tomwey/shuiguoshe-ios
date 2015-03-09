//
//  HomeTtitleView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-5.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^TitleViewDidClickBlock)(void);

@interface HomeTitleView : UIView

@property (nonatomic, copy) TitleViewDidClickBlock titleDidClickBlock;
@property (nonatomic, copy) NSString* title;

@end
