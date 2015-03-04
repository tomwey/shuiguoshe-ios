//
//  Share2WeiXinCommand.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-4.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Command.h"

typedef NS_ENUM(NSInteger, ShareWeiXinType) {
    ShareWeiXinTypeFriend,
    ShareWeiXinTypeAllFriends,
};

@interface Share2WeiXinCommand : Command

@property (nonatomic, assign) ShareWeiXinType shareType;

@end
