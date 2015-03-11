//
//  PaymentShipmentInfo.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "PaymentShipmentInfo.h"
#import "Defines.h"

@implementation PaymentShipmentInfo

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        NSMutableArray* temp = [NSMutableArray array];
        for (id dict in [jsonObj objectForKey:@"payment_type"]) {
            [temp addObject:[[[PaymentInfo alloc] initWithDictionary:dict] autorelease]];
        }
        
        self.paymentInfos = temp;
        
        temp = [NSMutableArray array];
        for (id dict in [jsonObj objectForKey:@"shipment_type"]) {
            [temp addObject:[[[ShipmentInfo alloc] initWithDictionary:dict] autorelease]];
        }
        
        self.shipmentInfos = temp;
    }
    return self;
}

- (void)dealloc
{
    self.paymentInfos = nil;
    self.shipmentInfos = nil;
    
    [super dealloc];
}

@end
