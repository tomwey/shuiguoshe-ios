//
//  BannerView.h
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kBannerViewDidShowNotification;
extern NSString * const kBannerViewDidHideNotification;

@interface BannerView : UIView

- (void)setDataSource:(NSArray *)data;

- (void)startLoop;
- (void)stopLoop;

@end
