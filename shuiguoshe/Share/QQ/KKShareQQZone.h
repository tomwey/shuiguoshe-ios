//
//  KKShareQQZone.h
//  KKShareKit
//
//  Created by beartech on 13-6-6.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import "TencentOpenAPI/QQApiInterface.h"

/**将下面注释取消，并定义自己的app key，app secret以及授权跳转地址uri
 此demo即可编译运行**/

#define kAppID_QQZone              @"222222"
#define kAppKey_QQZone             @"60f3e45be48f073648b7ee842a94dbc6"
#define kAppRedirectURI_QQZone     @"http://www.kekestudio.com"
#define Notification_KKShareQQZoneDidLogin  @"Notification_KKShareQQZoneDidLogin"
#define Notification_KKShareQQZoneDidLogout @"Notification_KKShareQQZoneDidLogout"

#ifndef kAppID_QQZone
#error
#endif

#ifndef kAppKey_QQZone
#error
#endif

#ifndef kAppRedirectURI_QQZone
#error
#endif

#define kUserDefaultKeyListAlbumId @"kUserDefaultKeyListAlbumId"


@interface KKShareQQZone : NSObject<QQApiInterfaceDelegate>

@property (retain, nonatomic) TencentOAuth *tencentOAuth;
@property (retain, nonatomic) NSDictionary *userInfo;
@property (retain, nonatomic) NSMutableArray *willShareInfomation;

+ (KKShareQQZone *)sharedManager;
- (BOOL)handleOpenURL:(NSURL *)url;
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url;

#pragma mark ============================================================
#pragma mark == 授权相关
#pragma mark ============================================================
- (BOOL)isAuthValid;
- (void)logIn;
- (void)logOut;

#pragma mark ============================================================
#pragma mark == 分享到QQ空间相关
#pragma mark ============================================================
/**
 * 分享
 */
- (BOOL)addShare:(TCAddShareDic*)params;

/**
 * 上传图片 【高级接口 需要权限】
 */
- (BOOL)uploadPic:(TCUploadPicDic*)params;

/**
 * 发表博客 【高级接口 需要权限】
 */
- (BOOL)addBlog:(TCAddOneBlogDic*)params;

/**
 * 发表说说 【高级接口 需要权限】
 */
- (BOOL)addTopic:(TCAddTopicDic*)params;

#pragma mark ============================================================
#pragma mark == 发送到QQ相关
#pragma mark ============================================================
- (void) sendTextMessage:(NSString*)text;

- (void) sendImageMessage:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description;

- (void) sendNewsMessageURL:(NSString*)url previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description;


- (void) sendAudioMessageURL:(NSString*)url previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description;

- (void) sendVideoMessageURL:(NSString*)url previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description;

@end

