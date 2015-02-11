//
//  DetailToolbar.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "DetailToolbar.h"

@implementation DetailToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.bounds = CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), 49);
        
        UIView* maskView = [[UIView alloc] initWithFrame:self.bounds];
        maskView.backgroundColor = [UIColor blackColor];
        maskView.alpha = 0.8;
        
        [self addSubview:maskView];
        [maskView release];
        
        UIButton* addToCart = createButton(@"btn_add_to_cart.png", self, @selector(addToCart));
        [self addSubview:addToCart];
        
        addToCart.center = CGPointMake(CGRectGetWidth(self.bounds) - 10 - CGRectGetWidth(addToCart.bounds) / 2,
                                       CGRectGetHeight(self.bounds) / 2);
        
        UIButton* cart = createButton(@"btn_cart.png", self, @selector(showCart));
        [self addSubview:cart];
        cart.center = CGPointMake(CGRectGetWidth(self.bounds)/2, CGRectGetHeight(self.bounds)/2);
        
        
    }
    
    return self;
}

- (void)dealloc
{
    self.item = nil;
    [super dealloc];
}

- (void)addToCart
{
    [[DataService sharedService] post:@"/cart/add_item"
                               params:@{ @"token": @"dc74a76f96062cdbaf17:10", @"pid": NSStringFromInteger(self.item.iid) }
                           completion:^(id result, BOOL succeed) {
        
    }];
}

- (void)showCart
{
    
}

@end
