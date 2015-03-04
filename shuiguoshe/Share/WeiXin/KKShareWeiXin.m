//
//  KKShareWeiXin.m
//  KKShareKit
//
//  Created by beartech on 13-6-5.
//  Copyright (c) 2013年 可可工作室. All rights reserved.
//

#import "KKShareWeiXin.h"
#import "WXApi.h"

@interface UIImage (Extension)

- (UIImage*)convertImageToScale:(double)scale;

@end

@implementation UIImage (Extension)
- (UIImage*)convertImageToScale:(double)scale{
    CGSize newImageSize = CGSizeMake(self.size.width * scale, self.size.height * scale);
    UIGraphicsBeginImageContext(newImageSize);
    [self drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end

@implementation KKShareWeiXin

+ (KKShareWeiXin *)sharedManager{
    
    static KKShareWeiXin *sharedKKShareWeiXinInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedKKShareWeiXinInstance =  [[KKShareWeiXin alloc] init];
    });
    return sharedKKShareWeiXinInstance;
}


#pragma mark ============================================================
#pragma mark == 其他
#pragma mark ============================================================
- (CGFloat) sizeOfData:(NSData*)data{
    CGFloat sizeKB = [data length]/1024.00;
    return sizeKB;
}

- (BOOL)checkWeiXinInstall{
    //判断是否安装微信
    if (![WXApi isWXAppInstalled]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"对不起" message:@"您手机里面还没有安装【微信】客户端" delegate:nil cancelButtonTitle:@"原来如此" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return NO;
    }
    else{
        if (![WXApi isWXAppSupportApi]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"对不起" message:@"您手机里面安装的【微信】客户端，版本太低不支持此操作。" delegate:nil cancelButtonTitle:@"原来如此" otherButtonTitles:nil];
            [alert show];
            [alert release];
            return NO;
        }
    }
    return YES;
}

#pragma mark ============================================================
#pragma mark == 回调
#pragma mark ============================================================
- (void) onReq:(BaseReq*)req{
    
}

- (void) onResp:(BaseResp*)resp{
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
//        NSString *strTitle = [NSString stringWithFormat:@"发送结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"发送媒体消息结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
    }
//    else if([resp isKindOfClass:[SendAuthResp class]])
//    {
//        NSString *strTitle = [NSString stringWithFormat:@"Auth结果"];
//        NSString *strMsg = [NSString stringWithFormat:@"Auth结果:%d", resp.errCode];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//        [alert show];
//        [alert release];
//    }
}

- (BOOL) handleOpenURL:(NSURL *) url{
    return [WXApi handleOpenURL:url delegate:[KKShareWeiXin sharedManager]];
}


#pragma mark ============================================================
#pragma mark == 分享相关
#pragma mark ============================================================
//发送图片
- (BOOL) sendImage:(UIImage*)thumbImage originImage:(UIImage*)originalImage WXSceneType:(WXSceneType)type
{
    if (![self checkWeiXinInstall]) {
        return NO;
    }
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:thumbImage];
    
    //原始图片==================================================
    WXImageObject *originalImageObject = [WXImageObject object];
    UIImage *originalImage_in = [[originalImage copy] autorelease];
    if (!originalImage_in) {
        originalImage_in = [[thumbImage copy] autorelease];
    }
    if (originalImage_in) {
        NSData *originalImageData_in = UIImageJPEGRepresentation(originalImage_in, 1.0);
        
        for (float i=1.0;[self sizeOfData:originalImageData_in]>1024*10; ) {
            i=i-0.05;
            if (i<0) {
                break;
            }
            originalImage_in = [originalImage_in convertImageToScale:i];
            originalImageData_in = UIImageJPEGRepresentation(originalImage_in, 1.0);
        }
        originalImageObject.imageData = originalImageData_in;
        message.mediaObject = originalImageObject;
    }
    else{
        NSLog(@"没有图片");
        return NO;
    }
    
    
    //缩略图片==================================================
    UIImage *thumbImage_in = [[thumbImage copy] autorelease];
    if (!thumbImage_in) {
        thumbImage_in = [[originalImage copy] autorelease];
    }
    if (thumbImage_in) {
        NSData *thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        for (float i=1.0;[self sizeOfData:thumbImageData_in]>32; ) {
            i=i-0.05;
            if (i<0) {
                break;
            }
            thumbImage_in = [thumbImage_in convertImageToScale:i];
            thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        }
        [message setThumbImage:thumbImage_in];
    }
    else{
        NSLog(@"没有图片");
        return NO;
    }

    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    if (type==WXSceneTypeFriend) {
        req.scene = WXSceneSession;
    }
    else{
        req.scene = WXSceneTimeline;
    }
    
   return [WXApi sendReq:req];
}

//发送web网页
- (BOOL) sendNews:(NSString*)title description:(NSString*)description thumbImage:(UIImage*)thumbImage webpageUrl:(NSString*)webpageUrl  WXSceneType:(WXSceneType)type
{
    if (![self checkWeiXinInstall]) {
        return NO;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    
    //缩略图片==================================================
    UIImage *thumbImage_in = [[thumbImage copy] autorelease];
    if (thumbImage_in) {
        NSData *thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        for (float i=1.0;[self sizeOfData:thumbImageData_in]>32; ) {
            i=i-0.05;
            if (i<0) {
                break;
            }
            thumbImage_in = [thumbImage_in convertImageToScale:i];
            thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        }
        [message setThumbImage:thumbImage_in];
    }
    else{
        NSLog(@"没有图片");
        return NO;
    }

    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = webpageUrl;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    if (type==WXSceneTypeFriend) {
        req.scene = WXSceneSession;
    }
    else{
        req.scene = WXSceneTimeline;
    }
    
    return [WXApi sendReq:req];
}

//发送音乐
-(BOOL) sendMusic:(NSString*)title description:(NSString*)description thumbImage:(UIImage*)thumbImage musicURL:(NSString*)musicURL musicDataURL:(NSString*)musicDataURL WXSceneType:(WXSceneType)type
{
    if (![self checkWeiXinInstall]) {
        return NO;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    //缩略图片==================================================
    UIImage *thumbImage_in = [[thumbImage copy] autorelease];
    if (thumbImage_in) {
        NSData *thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        for (float i=1.0;[self sizeOfData:thumbImageData_in]>32; ) {
            i=i-0.05;
            if (i<0) {
                break;
            }
            thumbImage_in = [thumbImage_in convertImageToScale:i];
            thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        }
        [message setThumbImage:thumbImage_in];
    }
    else{
        NSLog(@"没有图片");
        return NO;
    }
    
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = musicURL;
    ext.musicDataUrl = musicDataURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    if (type==WXSceneTypeFriend) {
        req.scene = WXSceneSession;
    }
    else{
        req.scene = WXSceneTimeline;
    }
    
    return [WXApi sendReq:req];
}

//发送视频
-(BOOL) sendVideo:(NSString*)title description:(NSString*)description thumbImage:(UIImage*)thumbImage videoURL:(NSString*)videoURL WXSceneType:(WXSceneType)type
{
    if (![self checkWeiXinInstall]) {
        return NO;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    //缩略图片==================================================
    UIImage *thumbImage_in = [[thumbImage copy] autorelease];
    if (thumbImage_in) {
        NSData *thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        for (float i=1.0;[self sizeOfData:thumbImageData_in]>32; ) {
            i=i-0.05;
            if (i<0) {
                break;
            }
            thumbImage_in = [thumbImage_in convertImageToScale:i];
            thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        }
        [message setThumbImage:thumbImage_in];
    }
    else{
        NSLog(@"没有图片");
        return NO;
    }
    
    WXVideoObject *ext = [WXVideoObject object];
    ext.videoUrl = videoURL;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    if (type==WXSceneTypeFriend) {
        req.scene = WXSceneSession;
    }
    else{
        req.scene = WXSceneTimeline;
    }
    
    return [WXApi sendReq:req];
}

//发送文字
- (BOOL) sendText:(NSString*)nsText WXSceneType:(WXSceneType)type
{
    if (![self checkWeiXinInstall]) {
        return NO;
    }
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = YES;
    req.text = nsText;
    if (type==WXSceneTypeFriend) {
        req.scene = WXSceneSession;
    }
    else{
        req.scene = WXSceneTimeline;
    }
    
    return [WXApi sendReq:req];
}

//发送非GIF表情
- (BOOL) sendEmotionImage:(UIImage*)originalImage thumbImage:(UIImage*)thumbImage WXSceneType:(WXSceneType)wxSceneType{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    //缩略图片==================================================
    UIImage *thumbImage_in = [[thumbImage copy] autorelease];
    if (thumbImage_in) {
        NSData *thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        for (float i=1.0;[self sizeOfData:thumbImageData_in]>32; ) {
            i=i-0.05;
            if (i<0) {
                break;
            }
            thumbImage_in = [thumbImage_in convertImageToScale:i];
            thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        }
        [message setThumbImage:thumbImage_in];
    }
    else{
        NSLog(@"没有图片");
        return NO;
    }
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    //原始图片==================================================
    WXImageObject *originalImageObject = [WXImageObject object];
    UIImage *originalImage_in = [[originalImage copy] autorelease];
    if (!originalImage_in) {
        originalImage_in = [[thumbImage copy] autorelease];
    }
    if (originalImage_in) {
        NSData *originalImageData_in = UIImageJPEGRepresentation(originalImage_in, 1.0);
        
        for (float i=1.0;[self sizeOfData:originalImageData_in]>1024*10; ) {
            i=i-0.05;
            if (i<0) {
                break;
            }
            originalImage_in = [originalImage_in convertImageToScale:i];
            originalImageData_in = UIImageJPEGRepresentation(originalImage_in, 1.0);
        }
        ext.emoticonData = originalImageData_in;
        message.mediaObject = originalImageObject;
    }
    else{
        NSLog(@"没有图片");
        return NO;
    }
    
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    if (wxSceneType==WXSceneTypeFriend) {
        req.scene = WXSceneSession;
    }
    else{
        req.scene = WXSceneTimeline;
    }
    
    return [WXApi sendReq:req];
    
}

//发送GIF表情
- (BOOL) sendEmotion:(NSData*)emotionImageData thumbImage:(UIImage*)thumbImage WXSceneType:(WXSceneType)wxSceneType{
    //发送内容给微信
    WXMediaMessage *message = [WXMediaMessage message];
    //缩略图片==================================================
    UIImage *thumbImage_in = [[thumbImage copy] autorelease];
    if (thumbImage_in) {
        NSData *thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        for (float i=1.0;[self sizeOfData:thumbImageData_in]>32; ) {
            i=i-0.05;
            if (i<0) {
                break;
            }
            thumbImage_in = [thumbImage_in convertImageToScale:i];
            thumbImageData_in = UIImageJPEGRepresentation(thumbImage_in, 1.0);
        }
        [message setThumbImage:thumbImage_in];
    }
    else{
        NSLog(@"没有图片");
        return NO;
    }
    
    WXEmoticonObject *ext = [WXEmoticonObject object];
    ext.emoticonData = emotionImageData;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    if (wxSceneType==WXSceneTypeFriend) {
        req.scene = WXSceneSession;
    }
    else{
        req.scene = WXSceneTimeline;
    }
    
    return [WXApi sendReq:req];
}

@end



