//
//  OrderInfo.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "OrderInfo.h"
#import "LineItem.h"

@implementation OrderInfo

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.oid = [[jsonObj objectForKey:@"id"] integerValue];
        self.no = [jsonObj objectForKey:@"order_no"];
        self.state = [jsonObj objectForKey:@"state"];
        self.orderedAt = [jsonObj objectForKey:@"ordered_at"];
        self.deliveredAt = [jsonObj objectForKey:@"delivered_at"];
        
        self.totalPrice = [[jsonObj objectForKey:@"total_price"] floatValue];
        
        self.canCancel = [[jsonObj objectForKey:@"can_cancel"] boolValue];
        
        self.stateName = [jsonObj objectForKey:@"state_name"];
        
        // 在线支付相关
        self.partner = [jsonObj objectForKey:@"partner"];
        self.seller = [jsonObj objectForKey:@"seller_id"];
        self.privateKey = [jsonObj objectForKey:@"private_key"];
        self.orderNo = [jsonObj objectForKey:@"order_no"];
        self.productName = [jsonObj objectForKey:@"subject"];
        self.productDescription = [jsonObj objectForKey:@"body"];
        self.totalFee = [jsonObj objectForKey:@"total_fee"];
        self.notifyUrl = [jsonObj objectForKey:@"notify_url"];
        
        self.service = [jsonObj objectForKey:@"service"];
        self.paymentType = [jsonObj objectForKey:@"payment_type"];
        self.inputCharset = [jsonObj objectForKey:@"_input_charset"];
        self.itBPay = [jsonObj objectForKey:@"it_b_pay"];
        self.showUrl = [jsonObj objectForKey:@"show_url"];
        
        self.appScheme = @"alipay-shuiguoshe";
        
        NSMutableArray* temp = [NSMutableArray array];
        for (id val in [jsonObj objectForKey:@"items"]) {
            LineItem* item = [[LineItem alloc] initWithDictionary:val];
            [temp addObject:item];
            [item release];
        }
        self.items = temp;
    }
    return self;
}

- (void)dealloc
{
    self.no = nil;
    self.state = nil;
    self.orderedAt = nil;
    self.deliveredAt = nil;
    self.items = nil;
    self.stateName = nil;
    
    self.partner = nil;
    self.seller = nil;
    self.privateKey = nil;
    
    self.orderNo = nil;
    
    self.productName = nil;
    self.productDescription = nil;
    
    self.totalFee = nil;
    
    self.notifyUrl = nil;
    
    self.service = nil;
    self.paymentType = nil;
    self.inputCharset = nil;
    self.itBPay = nil;
    self.showUrl = nil;
    
    self.appScheme = nil;
    
    [super dealloc];
}

- (NSString *)description
{
    NSMutableString * discription = [NSMutableString string];
    if (self.partner) {
        [discription appendFormat:@"partner=\"%@\"", self.partner];
    }
    
    if (self.seller) {
        [discription appendFormat:@"&seller_id=\"%@\"", self.seller];
    }
    if (self.orderNo) {
        [discription appendFormat:@"&out_trade_no=\"%@\"", self.orderNo];
    }
    if (self.productName) {
        [discription appendFormat:@"&subject=\"%@\"", self.productName];
    }
    
    if (self.productDescription) {
        [discription appendFormat:@"&body=\"%@\"", self.productDescription];
    }
    if (self.totalFee) {
        [discription appendFormat:@"&total_fee=\"%@\"", self.totalFee];
    }
    if (self.notifyUrl) {
        [discription appendFormat:@"&notify_url=\"%@\"", self.notifyUrl];
    }
    
    if (self.service) {
        [discription appendFormat:@"&service=\"%@\"",self.service];//mobile.securitypay.pay
    }
    if (self.paymentType) {
        [discription appendFormat:@"&payment_type=\"%@\"",self.paymentType];//1
    }
    
    if (self.inputCharset) {
        [discription appendFormat:@"&_input_charset=\"%@\"",self.inputCharset];//utf-8
    }
    if (self.itBPay) {
        [discription appendFormat:@"&it_b_pay=\"%@\"",self.itBPay];//30m
    }
    if (self.showUrl) {
        [discription appendFormat:@"&show_url=\"%@\"",self.showUrl];//m.alipay.com
    }
    return discription;
}


@end
