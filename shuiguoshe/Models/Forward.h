//
//  Forward.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Defines.h"

typedef NS_ENUM(NSInteger, ForwardType) {
    ForwardTypePush,
    ForwardTypeModal,
    ForwardTypeDismiss,
    ForwardTypePop,
    ForwardTypePopTo,
    ForwardTypePopHome,
};

@interface Forward : NSObject

@property (nonatomic, assign) ForwardType forwardType;

@property (nonatomic, assign) UIViewController* from;
@property (nonatomic, assign) UIViewController* to;

@property (nonatomic, copy) NSString* toController;

@property (nonatomic, retain) id userData;

+ (id)buildForwardWithType:(ForwardType)type from:(UIViewController *)from toController:(UIViewController *)to;
+ (id)buildForwardWithType:(ForwardType)type from:(UIViewController *)from toControllerName:(NSString *)toController;

@end
