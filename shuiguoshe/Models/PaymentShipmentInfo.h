//
//  PaymentShipmentInfo.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaymentShipmentInfo : NSObject

@property (nonatomic, copy) NSArray* paymentInfos;
@property (nonatomic, copy) NSArray* shipmentInfos;

- (id)initWithDictionary:(NSDictionary *)jsonObj;

@end
