//
//  ItemView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-9.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defines.h"

@class ItemView;
typedef void (^ItemViewDidSelectBlock)(ItemView*);
@interface ItemView : UIView

@property (nonatomic, assign) BOOL discounted;
@property (nonatomic, retain) Item *item;
@property (nonatomic, copy) ItemViewDidSelectBlock didSelectBlock;

@end
