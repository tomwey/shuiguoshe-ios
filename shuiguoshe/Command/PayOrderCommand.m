//
//  PayOrderCommand.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "PayOrderCommand.h"
#import "Defines.h"

@implementation PayOrderCommand

- (void)execute:(void (^)(id))result
{
    NSString* description = [self.userData description];

    DLog(@"order description: %@", description);
    
    id<DataSigner> signer = CreateRSADataSigner([self.userData privateKey]);
    NSString *signedString = [signer signString:description];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       description, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:@"alipay-shuiguoshe" callback:^(NSDictionary *resultDic) {
            DLog(@"reslut = %@",resultDic);
            
            [[DataVerifierManager sharedManager] saveAlipayPublicKey:[self.userData publicKey]];
            
            if ( [[DataVerifierManager sharedManager] verifyResult:resultDic] ) {
                DLog(@"验证成功");
            } else {
                DLog(@"验证失败");
            }
            
        }];
        
    }
}

@end
