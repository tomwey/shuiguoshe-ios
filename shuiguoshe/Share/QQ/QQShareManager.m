//
//  QQShareManager.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "QQShareManager.h"
#import "Defines.h"
#import "QQShareView.h"

@interface QQShareManager () <TencentSessionDelegate>
@end

@implementation QQShareManager
{
    TencentOAuth* _auth;
    NSMutableDictionary* _sendInfos;
}

+ (id)sharedManager
{
    static QQShareManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[QQShareManager sharedManager] init];
        }
    });
    return instance;
}

- (id)init
{
    self = [super init];
    if ( self ) {
        _auth = [[TencentOAuth alloc] initWithAppId:kQQOpenAppId andDelegate:self];
        _sendInfos = [[NSMutableDictionary alloc] init];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *QQZoneInfo = [defaults objectForKey:@"QQZoneAuthData"];
        if ([QQZoneInfo objectForKey:@"accessToken"] &&
            [QQZoneInfo objectForKey:@"openId"] &&
            [QQZoneInfo objectForKey:@"expirationDate"])
        {
            [_auth setAccessToken:[QQZoneInfo objectForKey:@"accessToken"]] ;
            [_auth setOpenId:[QQZoneInfo objectForKey:@"openId"]] ;
            [_auth setExpirationDate:[QQZoneInfo objectForKey:@"expirationDate"]];
//            [self getUserInfo];
        }
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)aURL
{
    return [TencentOAuth HandleOpenURL:aURL];
}

- (void)sendThumbImage:(NSString *)imageUrl
                 title:(NSString *)title
           description:(NSString *)summary
               message:(NSString *)otherMessage
{
    if ( [self isAuthed] ) {
        [self _doSend];
    } else {
        [_sendInfos setObject:imageUrl forKey:@"imageUrl"];
        [_sendInfos setObject:title forKey:@"title"];
        [_sendInfos setObject:otherMessage forKey:@"message"];
        
        [self login];
    }
}

- (void)login
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QQZoneAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSArray *_permissions = [NSArray arrayWithObjects:
                             /** 发表一条说说到QQ空间(<b>需要申请权限</b>) */
                             kOPEN_PERMISSION_ADD_TOPIC,
                             /** 发表一篇日志到QQ空间(<b>需要申请权限</b>) */
                             kOPEN_PERMISSION_ADD_ONE_BLOG,
                             /** 上传一张照片到QQ空间相册(<b>需要申请权限</b>) */
                             kOPEN_PERMISSION_UPLOAD_PIC,
                             /** 同步分享到QQ空间、腾讯微博 */
                             kOPEN_PERMISSION_ADD_SHARE,
                             /** 上传图片并发表消息到腾讯微博 */
                             kOPEN_PERMISSION_ADD_PIC_T,
                             /** 获取登录用户自己的详细信息 */
                             kOPEN_PERMISSION_GET_INFO,
                             /** 获取用户信息 */
                             kOPEN_PERMISSION_GET_USER_INFO,
                             /** 移动端获取用户信息 */
                             kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                             nil];
    
    [_auth authorize:_permissions  inSafari:NO];
}

- (void)_doSend
{
    QQShareView* shareView = [[[QQShareView alloc] init] autorelease];
    shareView.shareInfo = _sendInfos;
    [shareView show];
}

- (BOOL)isAuthed
{
    return [_auth isSessionValid];
}

- (void)handleLoginSuccess
{
    NSMutableDictionary *QQZoneInfo = [NSMutableDictionary dictionary];
    [QQZoneInfo setObject:[_auth accessToken] forKey:@"accessToken"];
    [QQZoneInfo setObject:[_auth openId] forKey:@"openId"];
    [QQZoneInfo setObject:[_auth expirationDate] forKey:@"expirationDate"];
    [[NSUserDefaults standardUserDefaults] setObject:QQZoneInfo forKey:@"QQZoneAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [_auth getUserInfo];
    
    [self _doSend];
}

- (void)getUserInfo
{
    if ( [self isAuthed] ) {
        [_auth getUserInfo];
    }
    else{
        [self login];
    }
}

/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin
{
    // 保存信息
    
    if (_auth.accessToken
        && 0 != [_auth.accessToken length])
    {
        [self handleLoginSuccess];
    }
    else
    {
        NSLog(@"登录不成功 没有获取accesstoken");
        [Toast showText:@"登录失败，没有获取AccessToken"];
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if ( cancelled ) {
        NSLog(@"取消登录");
        [Toast showText:@"取消登录"];
    } else {
        NSLog(@"登录失败");
        [Toast showText:@"登录失败"];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork
{
    NSLog(@"无网络连接，请设置网络");
    [Toast showText:@"无网络连接，请设置网络"];
}

@end
