//
//  DataVerifierManager.h
//  shuiguoshe
//
//  Created by tomwey on 3/11/15.
//  Copyright (c) 2015 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataVerifierManager : NSObject

+ (id)sharedManager;

- (void)saveAlipayPublicKey:(NSString *)publicKey;

- (BOOL)verifyResult:(NSDictionary *)result;

@end
