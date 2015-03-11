//
//  DataVerifierManager.m
//  shuiguoshe
//
//  Created by tomwey on 3/11/15.
//  Copyright (c) 2015 shuiguoshe. All rights reserved.
//

#import "DataVerifierManager.h"
#import "Defines.h"

@interface DataVerifierManager ()

@property (nonatomic, copy) NSString* publicKey;

@end

@implementation DataVerifierManager

+ (id)sharedManager
{
    static DataVerifierManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !instance ) {
            instance = [[DataVerifierManager alloc] init];
        }
    });
    return instance;
}

- (void)saveAlipayPublicKey:(NSString *)publicKey
{
    [[NSUserDefaults standardUserDefaults] setObject:publicKey
                                              forKey:@"shuiguoshe.mykey"];
}

- (BOOL)verifyResult:(NSDictionary *)resultDic
{
    NSString* result = [resultDic objectForKey:@"result"];
    NSArray* array = [result componentsSeparatedByString:@"&"];
    
    NSMutableArray* temp = [NSMutableArray array];
    NSString* string = nil;
    NSString* successString = nil;
    for (NSString* kv in array) {
        if ( [kv rangeOfString:@"sign_type="].location != NSNotFound ||
            [kv rangeOfString:@"sign="].location != NSNotFound) {
            if ( [kv rangeOfString:@"sign="].location != NSNotFound ) {
                string = [NSString stringWithString:kv];
            }
            continue;
        }
        
        if ( [kv rangeOfString:@"success="].location != NSNotFound ) {
            successString = [NSString stringWithString:kv];
        }
        
        [temp addObject:kv];
    }
    
    NSString* pubKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"shuiguoshe.mykey"];
    
    //@"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCnxj/9qwVfgoUh/y2W89L6BkRAFljhNhgPdyPuBV64bfQNN1PjbCzkIM6qRdKBoLPXmKKMiFYnkd6rAoprih3/PrQEB/VsW8OoM8fxn67UDYuyBTqA23MML9q1+ilIZwBC2AQ2UBVOrFXfFl75p6/B5KsiNG9zpgmLCUYuLkxpLQIDAQAB";
    
    NSString* neededToSign = [temp componentsJoinedByString:@"&"];

    NSString* serverSign = [string substringWithRange:NSMakeRange(6,
                                                                  string.length - 6 - 1)];
    id<DataVerifier> verifier = CreateRSADataVerifier(pubKey);
    BOOL verified = [verifier verifyString:neededToSign
                                  withSign:serverSign];
    
    NSInteger code = [[resultDic objectForKey:@"resultStatus"] integerValue];
    NSString* msg = nil;
    switch (code) {
        case 9000:
            msg = @"订单支付成功";
            break;
        case 8000:
            msg = @"正在处理中";
            break;
        case 4000:
            msg = @"订单支付失败";
            break;
        case 6001:
            msg = @"用户中途取消";
            break;
        case 6002:
            msg = @"网络连接出错";
            break;
            
        default:
            break;
    }
    
    if ( msg ) {
        [Toast showText:msg];
    }
    
    successString = [successString substringFromIndex:8];
    
    BOOL flag = ( verified && ( code == 9000 ) && [successString isEqualToString:@"\"true\""] );
    
    if ( flag ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kOrderFinishedPaymentNotification"
                                                            object:nil];
    }
    
    return flag;
}

@end
