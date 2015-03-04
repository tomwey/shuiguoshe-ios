//
//  KKShareWeiXin.h
//  KKShareKit
//
//  Created by beartech on 13-6-5.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"

/**将下面注释取消，并定义自己的AppID
 此demo即可编译运行**/
#define AppID_WeiXin             @"wx66fbcfacb979e49f"

#ifndef AppID_WeiXin
#error
#endif

typedef enum{
    WXSceneTypeFriend = 11,
    WXSceneTypeAllFriends = 12
}WXSceneType;

@interface KKShareWeiXin : NSObject<WXApiDelegate>

+ (KKShareWeiXin *)sharedManager;

- (BOOL) handleOpenURL:(NSURL *) url;

//发送图片
- (BOOL) sendImage:(UIImage*)thumbImage originImage:(UIImage*)originalImage WXSceneType:(WXSceneType)type;

//发送web网页
- (BOOL) sendNews:(NSString*)title description:(NSString*)description thumbImage:(UIImage*)thumbImage webpageUrl:(NSString*)webpageUrl  WXSceneType:(WXSceneType)type;

//发送音乐
- (BOOL) sendMusic:(NSString*)title description:(NSString*)description thumbImage:(UIImage*)thumbImage musicURL:(NSString*)musicURL musicDataURL:(NSString*)musicDataURL WXSceneType:(WXSceneType)type;

//发送视频
- (BOOL) sendVideo:(NSString*)title description:(NSString*)description thumbImage:(UIImage*)thumbImage videoURL:(NSString*)videoURL WXSceneType:(WXSceneType)type;

//发送文字
- (BOOL) sendText:(NSString*)nsText WXSceneType:(WXSceneType)type;

//发送非GIF表情
- (BOOL) sendEmotionImage:(UIImage*)originalImage thumbImage:(UIImage*)thumbImage WXSceneType:(WXSceneType)wxSceneType;

//发送GIF表情
- (BOOL) sendEmotion:(NSData*)emotionImageData thumbImage:(UIImage*)thumbImage WXSceneType:(WXSceneType)wxSceneType;


@end



