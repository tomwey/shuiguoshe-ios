//
//  QQShareManager.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import "TencentOpenAPI/QQApiInterface.h"


@interface QQShareManager : NSObject

+ (id)sharedManager;

- (BOOL)handleOpenURL:(NSURL *)aURL;

- (void)sendThumbImage:(NSString *)imageUrl
                 title:(NSString *)title
           description:(NSString *)summary
               message:(NSString *)otherMessage;

@end
