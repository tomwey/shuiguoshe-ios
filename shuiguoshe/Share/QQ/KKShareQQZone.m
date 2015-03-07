//
//  KKShareQQZone.m
//  KKShareKit
//
//  Created by beartech on 13-6-6.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKShareQQZone.h"
#import "Defines.h"

@interface KKShareQQZone ()<TencentSessionDelegate,TencentLoginDelegate>

@end

@implementation KKShareQQZone
@synthesize tencentOAuth;
@synthesize userInfo;
@synthesize willShareInfomation;

+ (KKShareQQZone *)sharedManager{
    
    static KKShareQQZone *sharedKKShareQQZoneInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedKKShareQQZoneInstance =  [[KKShareQQZone alloc] init];
    });
    return sharedKKShareQQZoneInstance;
}

-(id)init{
    self = [super init];
    if(self){
        tencentOAuth = [[TencentOAuth alloc] initWithAppId:kQQOpenAppId andDelegate:self];
//        tencentOAuth.redirectURI = kAppRedirectURI_QQZone;
        
        willShareInfomation = [[NSMutableArray alloc]init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doSend:)
                                                     name:kShareViewDidSendNotification
                                                   object:nil];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *QQZoneInfo = [defaults objectForKey:@"QQZoneAuthData"];
        if ([QQZoneInfo objectForKey:@"accessToken"] &&
            [QQZoneInfo objectForKey:@"openId"] &&
            [QQZoneInfo objectForKey:@"expirationDate"])
        {
            [tencentOAuth setAccessToken:[QQZoneInfo objectForKey:@"accessToken"]] ;
            [tencentOAuth setOpenId:[QQZoneInfo objectForKey:@"openId"]] ;
            [tencentOAuth setExpirationDate:[QQZoneInfo objectForKey:@"expirationDate"]];
            [self getUserInfo];
        }
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url{
    return [TencentOAuth HandleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url{
    KKShareQQZone *qqZone = [KKShareQQZone sharedManager];
    id<QQApiInterfaceDelegate> qqApiDelegate = qqZone;
    return [QQApiInterface handleOpenURL:url delegate:qqApiDelegate] | [TencentOAuth HandleOpenURL:url];
}

- (void)isOnlineResponse:(NSDictionary *)response
{
    
}

#pragma mark ============================================================
#pragma mark == 授权相关
#pragma mark ============================================================
- (void)storeAuthData{
    NSMutableDictionary *QQZoneInfo = [NSMutableDictionary dictionary];
    [QQZoneInfo setObject:[tencentOAuth accessToken] forKey:@"accessToken"];
    [QQZoneInfo setObject:[tencentOAuth openId] forKey:@"openId"];
    [QQZoneInfo setObject:[tencentOAuth expirationDate] forKey:@"expirationDate"];
    [[NSUserDefaults standardUserDefaults] setObject:QQZoneInfo forKey:@"QQZoneAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_KKShareQQZoneDidLogin object:nil];

    [self getUserInfo];
    
    
    
    if (willShareInfomation && [willShareInfomation count]>0) {
        NSDictionary *dic = [willShareInfomation objectAtIndex:0];
        if ([dic isKindOfClass:[TCAddShareDic class]]) {
            [self addShare:[willShareInfomation objectAtIndex:0]];
        }
        else if ([dic isKindOfClass:[TCUploadPicDic class]]) {
            [self uploadPic:[willShareInfomation objectAtIndex:0]];
        }
        else if ([dic isKindOfClass:[TCAddOneBlogDic class]]) {
            [self addBlog:[willShareInfomation objectAtIndex:0]];
        }
        else if ([dic isKindOfClass:[TCAddTopicDic class]]) {
            [self addTopic:[willShareInfomation objectAtIndex:0]];
        }
        else{
        
        }
        [willShareInfomation removeAllObjects];
    }
}

- (void)removeAuthData{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"QQZoneAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [userInfo release];userInfo = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:Notification_KKShareQQZoneDidLogout object:nil];
}

- (BOOL)isAuthValid{
    return [tencentOAuth isSessionValid];
}

- (void)logIn{
    [self removeAuthData];
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
    
    [tencentOAuth authorize:_permissions  inSafari:NO];
}

- (void)logOut{
    [tencentOAuth logout:self];
}

#pragma mark ============================================================
#pragma mark == QQApiInterfaceDelegate
#pragma mark ============================================================
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req{
    switch (req.type)
    {
        case EGETMESSAGEFROMQQREQTYPE:
        {
            break;
        }
        default:
        {
            break;
        }
    }
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
//            SendMessageToQQResp* sendResp = (SendMessageToQQResp*)resp;
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:sendResp.result message:sendResp.errorDescription delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//            [alert release];
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark ============================================================
#pragma mark == TencentLoginDelegate
#pragma mark ============================================================
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    if (tencentOAuth.accessToken
        && 0 != [tencentOAuth.accessToken length])
    {
        [self storeAuthData];
    }
    else
    {
        [Toast showText:@"登录失败"];
//        NSLog(@"登录不成功 没有获取accesstoken");
    }
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled)
    {
        NSLog(@"用户取消登录");
        [Toast showText:@"用户取消登录"];
    }
    else
    {
//        NSLog(@"登录失败");
        [Toast showText:@"登录失败"];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSLog(@"无网络连接，请设置网络");
}

- (BOOL)getUserInfo{
    if ([self isAuthValid]) {
        return [tencentOAuth getUserInfo];
    }
    else{
        [self logIn];
        return NO;
    }
}

#pragma mark ============================================================
#pragma mark == 发送到QQ会话
#pragma mark ============================================================
- (void) sendTextMessage:(NSString*)text{
    QQApiTextObject* txt = [QQApiTextObject objectWithText:text];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txt];
    
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void) sendImageMessage:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description{
    QQApiImageObject* img = [QQApiImageObject objectWithData:previewImageData previewImageData:previewImageData title:title description:description];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    BOOL sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void) sendNewsMessageURL:(NSString*)url previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description{
    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:previewImageData];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    BOOL sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void) sendAudioMessageURL:(NSString*)url previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description{
    QQApiAudioObject* img =
    [QQApiAudioObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:previewImageData];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    BOOL sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void) sendVideoMessageURL:(NSString*)url previewImageData:(NSData*)previewImageData title:(NSString*)title description:(NSString*)description{
    QQApiVideoObject* img = [QQApiVideoObject objectWithURL:[NSURL URLWithString:url] title:title description:description previewImageData:previewImageData];
    
    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
    
    BOOL sent = [QQApiInterface sendReq:req];
    [self handleSendResult:sent];
}

- (void)handleSendResult:(QQApiSendResultCode)sendResult{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            [msgbox release];
            
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark ============================================================
#pragma mark == 发送到QQ空间
#pragma mark ============================================================
/**
 * 分享
 */
- (BOOL)addShare:(TCAddShareDic*)params{
    if ([self isAuthValid]) {
        
//        QQShareView* shareView = [[[QQShareView alloc] init] autorelease];
//        
//        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
//        
//        [dict setObject:params.paramTitle forKey:@"title"];
//        [dict setObject:params.paramSummary forKey:@"summary"];
//        [dict setObject:params.paramImages forKey:@"imageUrl"];
//        [dict setObject:@"" forKey:@"message"];
//        [dict setObject:params.paramUrl forKey:@"link"];
//        
//        shareView.shareInfo = dict;
//        
//        [shareView show];
        
        NSString *previewImageUrl = params.paramImages;
        QQApiNewsObject *newsObj = [QQApiNewsObject
                                    objectWithURL:
                                    [NSURL URLWithString:params.paramUrl]
                                    title: params.paramTitle
                                    description:params.paramSummary
                                    previewImageURL:[NSURL URLWithString:previewImageUrl]];
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
        //将内容分享到qq
        //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
        //将内容分享到qzone
        QQApiSendResultCode sendResult = [QQApiInterface SendReqToQZone:req];
        
//        if ( sent == EQQAPISENDSUCESS ) {
//            [Toast showText:@"分享成功"];
//        } else {
//            [Toast showText:@"分享失败"];
//        }
        
        switch (sendResult)
        {
            case EQQAPIAPPNOTREGISTED:
            {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [msgbox show];
                [msgbox release];
                
                break;
            }
            case EQQAPIMESSAGECONTENTINVALID:
            case EQQAPIMESSAGECONTENTNULL:
            case EQQAPIMESSAGETYPEINVALID:
            {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [msgbox show];
                [msgbox release];
                
                break;
            }
            case EQQAPIQQNOTINSTALLED:
            {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [msgbox show];
                [msgbox release];
                
                break;
            }
            case EQQAPIQQNOTSUPPORTAPI:
            {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [msgbox show];
                [msgbox release];
                
                break;
            }
            case EQQAPISENDFAILD:
            {
                UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
                [msgbox show];
                [msgbox release];
                
                break;
            }
            default:
            {
                break;
            }
        }
        
        return YES;
        
//        return [tencentOAuth addShareWithParams:params];
    }
    else{
        [willShareInfomation removeAllObjects];
        [willShareInfomation addObject:params];
        [self logIn];
        return NO;
    }
}

- (void)doSend:(NSNotification *)noti
{
    QQShareView* view = noti.object;
    
//    [MBProgressHUD showHUDAddedTo:AppWindow() animated:YES];
//
//    TCAddShareDic *params = [TCAddShareDic dictionary];
//    params.paramTitle = [view.shareInfo objectForKey:@"title"];
//    params.paramSummary =  [view.shareInfo objectForKey:@"summary"];
//    params.paramImages = [view.shareInfo objectForKey:@"imageUrl"];
//    params.paramComment = [view.shareInfo objectForKey:@"message"];
//    params.paramUrl = [view.shareInfo objectForKey:@"link"];
//    
//    [tencentOAuth addShareWithParams:params];
    
    //分享跳转URL
//    NSString *url = @"http://xxx.xxx.xxx/";
    //分享图预览图URL地址
    NSString *previewImageUrl = [view.shareInfo objectForKey:@"imageUrl"];
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:[view.shareInfo objectForKey:@"link"]]
                                title: [view.shareInfo objectForKey:@"title"]
                                description:[view.shareInfo objectForKey:@"summary"]
                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    if ( sent == EQQAPISENDSUCESS ) {
        [Toast showText:@"分享成功"];
    } else {
        [Toast showText:@"分享失败"];
    }
}

/**
 * 上传图片
 */
- (BOOL)uploadPic:(TCUploadPicDic*)params{
    if ([self isAuthValid]) {
        return [tencentOAuth uploadPicWithParams:params];
    }
    else{
        [willShareInfomation removeAllObjects];
        [willShareInfomation addObject:params];
        [self logIn];
        return NO;
    }
}

/**
 * 发表博客
 */
- (BOOL)addBlog:(TCAddOneBlogDic*)params{
    if ([self isAuthValid]) {
        return [tencentOAuth addOneBlogWithParams:params];
    }
    else{
        [willShareInfomation removeAllObjects];
        [willShareInfomation addObject:params];
        [self logIn];
        return NO;
    }
}

/**
 * 发表说说
 */
- (BOOL)addTopic:(TCAddTopicDic*)params{
    if ([self isAuthValid]) {
        return [tencentOAuth addTopicWithParams:params];
    }
    else{
        [willShareInfomation removeAllObjects];
        [willShareInfomation addObject:params];
        [self logIn];
        return NO;
    }
}

#pragma mark ============================================================
#pragma mark == TencentSessionDelegate
#pragma mark ============================================================
- (void)tencentDidLogout{
    [self removeAuthData];
}

- (BOOL)tencentNeedPerformReAuth:(TencentOAuth *)tencentOAuth{
    [self removeAuthData];
    [self logIn];
    return YES;
}

- (void)tencentDidUpdate:(TencentOAuth *)tencentOAuth{
    [self storeAuthData];
}

- (void)tencentFailedUpdate:(UpdateFailType)reason{
    [self removeAuthData];
}

- (void)getUserInfoResponse:(APIResponse*) response{
	if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
        [userInfo release];userInfo = nil;
        userInfo = [response.jsonResponse retain];
        NSLog(@"【QQ空间】获取用户信息成功！");
	}
	else
    {
        NSLog(@"【QQ空间】获取用户信息失败！");
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取用户信息失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
}

- (void)addShareResponse:(APIResponse*) response{

    [MBProgressHUD hideHUDForView:AppWindow() animated:YES];
    
    if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
        
        NSLog(@"errorMsg: %@", str);
        
        [Toast showText:@"分享到QQ空间成功"];
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"分享到QQ空间成功"];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:[NSString stringWithFormat:@"%@",str]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles:nil];
//		[alert show];
//        [alert release];
	}
	else {
        [Toast showText:@"分享到QQ空间失败"];
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"分享到QQ空间失败"];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
}

- (void)uploadPicResponse:(APIResponse*) response{
    if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
        
        [Toast showText:@"上传图片成功"];
        
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"上传图片成功"];

//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传图片成功" message:[NSString stringWithFormat:@"%@",str]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
	else {
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"上传图片失败"];
        [Toast showText:@"上传图片失败"];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"上传图片失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}

}

- (void)addOneBlogResponse:(APIResponse*) response{
    if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"发送博客成功"];
        [Toast showText:@"发送博客成功"];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//		[alert release];
	}
	else
    {
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"发送博客失败"];
        [Toast showText:@"发送博客失败"];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
}

- (void)addTopicResponse:(APIResponse*) response{
    if (response.retCode == URLREQUEST_SUCCEED)
	{
		NSMutableString *str=[NSMutableString stringWithFormat:@""];
		for (id key in response.jsonResponse) {
			[str appendString: [NSString stringWithFormat:@"%@:%@\n",key,[response.jsonResponse objectForKey:key]]];
		}
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"发送说说成功"];
        [Toast showText:@"发送说说成功"];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作成功" message:[NSString stringWithFormat:@"%@",str]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
	else
    {
//        [[TKAlertCenter defaultCenter] postAlertWithMessage:@"发送说说失败"];
        [Toast showText:@"发送说说失败"];
//		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"操作失败" message:[NSString stringWithFormat:@"%@", response.errorMsg]
//							  
//													   delegate:self cancelButtonTitle:@"我知道啦" otherButtonTitles: nil];
//		[alert show];
//        [alert release];
	}
}



@end
