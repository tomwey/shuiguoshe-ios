//
//  OrderInfo.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : NSObject

@property (nonatomic, assign) NSInteger oid;

@property (nonatomic, copy) NSString* no;

@property (nonatomic, copy) NSString* state;

@property (nonatomic, copy) NSString* stateName;

@property (nonatomic, copy) NSString* orderedAt;

@property (nonatomic, copy) NSString* deliveredAt;

@property (nonatomic, assign) float totalPrice;

@property (nonatomic, assign) BOOL canCancel;

@property (nonatomic, copy) NSArray* items;

// 在线支付相关的属性
@property (nonatomic, copy) NSString* partner;
@property (nonatomic, copy) NSString* seller;

@property (nonatomic, copy) NSString* privateKey;
@property (nonatomic, copy) NSString* publicKey;

@property (nonatomic, copy) NSString* orderNo;

@property (nonatomic, copy) NSString* productName;
@property (nonatomic, copy) NSString* productDescription;

@property (nonatomic, copy) NSString* totalFee;

@property (nonatomic, copy) NSString* notifyUrl;

@property (nonatomic, copy) NSString* service;
@property (nonatomic, copy) NSString* paymentType;
@property (nonatomic, copy) NSString* inputCharset;
@property (nonatomic, copy) NSString* itBPay;
@property (nonatomic, copy) NSString* showUrl;

@property (nonatomic, copy) NSString* appScheme;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
