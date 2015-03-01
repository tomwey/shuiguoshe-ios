//
//  CartService.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "CartService.h"
#import "Defines.h"

NSString * const kCartTotalDidChangeNotification = @"kCartTotalDidChangeNotification";

@implementation CartService
{
    NSUInteger _total;
}

+ (CartService *)sharedService
{
    static CartService* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if ( !service ) {
            service = [[CartService alloc] init];
        }
    });
    return service;
}

- (id)init
{
    if ( self = [super init] ) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(cartTotalDidChange:)
                                                     name:kCartTotalDidChangeNotification
                                                   object:nil];
    }
    return self;
}

- (void)initTotal:(NSInteger)total
{
    [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"cart.total"];
    
    [self updateTotal:total];
}

- (void)updateTotal:(NSInteger)total
{
    if ( total > 9 ) {
        self.cartTotalLabel.text = @"9+";
    } else {
        self.cartTotalLabel.text = NSStringFromInteger(total);
    }
}

- (void)cartTotalDidChange:(NSNotification *)noti
{
    NSInteger dt = [noti.object integerValue];
    NSInteger total = [self totalCount];
    total += dt;
    [[NSUserDefaults standardUserDefaults] setInteger:total forKey:@"cart.total"];
    
    [self updateTotal:total];
}

- (void)setCartTotalLabel:(UILabel *)cartTotalLabel
{
    _cartTotalLabel = cartTotalLabel;
    [self updateTotal:[self totalCount]];
}

- (NSUInteger)totalCount
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"cart.total"];
}

@end
