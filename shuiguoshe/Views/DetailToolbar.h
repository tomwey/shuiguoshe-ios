//
//  DetailToolbar.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef BOOL (^CheckUserLoginBlock)(void);

@class ItemDetail;
@interface DetailToolbar : UIView

@property (nonatomic, retain) ItemDetail* itemDetail;

@property (nonatomic, copy) CheckUserLoginBlock checkUserLoginBlock;

@end
