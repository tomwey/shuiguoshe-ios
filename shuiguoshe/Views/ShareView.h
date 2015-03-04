//
//  ShareView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemDetail;
@interface ShareView : UIView

@property (nonatomic, retain) ItemDetail *itemDetail;

- (void)showInView:(UIView *)superView;

@end
