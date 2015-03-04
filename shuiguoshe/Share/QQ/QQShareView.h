//
//  QQShareView.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

FOUNDATION_EXTERN NSString * const kShareViewDidSendNotification;

@interface QQShareView : UIView

@property (nonatomic, copy) NSMutableDictionary* shareInfo;

- (void)show;

@end
