//
//  User.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "User.h"

@implementation User
{
    NSMutableArray* _errors;
}

- (void)dealloc
{
    self.name = nil;
    self.avatarUrl = nil;
    self.password = nil;
    self.code = nil;
    self.codeType = nil;
    [_errors release];
    
    [super dealloc];
}

- (id)initWithDictionary:(NSDictionary *)jsonObj
{
    if ( self = [super init] ) {
        self.oid = [[jsonObj objectForKey:@"id"] integerValue];
        self.name = [jsonObj objectForKey:@"mobile"];
        self.avatarUrl = [jsonObj objectForKey:@"avatar_url"];
        self.score = [[jsonObj objectForKey:@"score"] integerValue];
        
        self.deliveringCount = [[jsonObj objectForKey:@"delivering_orders_count"] integerValue];
        self.completedCount = [[jsonObj objectForKey:@"completed_orders_count"] integerValue];
        self.canceledCount = [[jsonObj objectForKey:@"canceled_orders_count"] integerValue];
        
        self.currentDeliverInfoId = [[jsonObj objectForKey:@"current_deliver_info_id"] integerValue];
    }
    
    return self;
}

- (NSArray *)errors
{
    return _errors;
}

- (BOOL)checkValue
{
    if ( !_errors ) {
        _errors = [[NSMutableArray alloc] init];
    }
    
    [_errors removeAllObjects];
    
    if ( self.name.length == 0 ) {
        [_errors addObject:@{ @"name": @"手机号不能为空" }];
    } else {
        
        NSString *phoneRegex = @"\\A1[3|4|5|8][0-9]\\d{8}\\z";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        BOOL matches = [test evaluateWithObject:self.name];
        if ( !matches ) {
            [_errors addObject:@{ @"name": @"不正确的手机号" }];
        }
    }
    
    if ( self.password.length < 6 ) {
        [_errors addObject:@{ @"password": @"密码至少为6位" }];
    }
    
    return [_errors count] == 0;
}

- (BOOL)checkMobile
{
    if ( !_errors ) {
        _errors = [[NSMutableArray alloc] init];
    }
    
    [_errors removeAllObjects];
    
    if ( self.name.length == 0 ) {
        [_errors addObject:@{ @"name": @"手机号不能为空" }];
    } else {
        
        NSString *phoneRegex = @"\\A1[3|4|5|8][0-9]\\d{8}\\z";
        NSPredicate *test = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
        BOOL matches = [test evaluateWithObject:self.name];
        if ( !matches ) {
            [_errors addObject:@{ @"name": @"不正确的手机号" }];
        }
    }
    
    return [_errors count] == 0;
}

@end
