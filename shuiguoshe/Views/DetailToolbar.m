//
//  DetailToolbar.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-11.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "DetailToolbar.h"
#import "Defines.h"

@interface DetailToolbar ()

@property (nonatomic, assign) BOOL liked;

@end

@implementation DetailToolbar
{
    UIImageView* _bgView;
    UIImageView* _likeView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toolbar_bg.png"]];
        [_bgView sizeToFit];
        [self addSubview:_bgView];
        [_bgView release];
        
        self.bounds = CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds), CGRectGetHeight(_bgView.frame));
        
        _bgView.frame = self.bounds;
        
        UIButton* addToCart = createButton(@"btn_add_to_cart.png", self, @selector(addToCart:));
        [self addSubview:addToCart];
        
        addToCart.center = CGPointMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(mainScreenBounds) * 28 / 320 - CGRectGetWidth(addToCart.bounds) / 2,
                                       CGRectGetHeight(self.bounds) / 2);
        
        
        UIButton* shareBtn = createButton(@"btn_share.png", self, @selector(share));
        [self addSubview:shareBtn];
        
        shareBtn.center = CGPointMake(CGRectGetWidth(self.bounds) * 124 / 320 , CGRectGetHeight(self.bounds)/2);
        
        _likeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 35)];
        _likeView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_likeView];
        [_likeView release];
        
        _likeView.userInteractionEnabled = YES;

        _likeView.center = CGPointMake(CGRectGetWidth(self.bounds) * 40 / 320 , CGRectGetHeight(self.bounds)/2);
        
        UITapGestureRecognizer* tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleLike)] autorelease];
        [_likeView addGestureRecognizer:tap];
    }
    
    return self;
}

- (void)dealloc
{
    self.itemDetail = nil;
    self.checkUserLoginBlock = nil;
    
    [super dealloc];
}

- (void)setItemDetail:(ItemDetail *)itemDetail
{
    if ( _itemDetail != itemDetail ) {
        [_itemDetail release];
        _itemDetail = [itemDetail retain];
        
        self.liked = itemDetail.likesCount > 0;
        
    }
}

- (void)setLiked:(BOOL)liked
{
    _liked = liked;
    if ( _liked ) {
        _likeView.image = [UIImage imageNamed:@"btn_liked.png"];
    } else {
        _likeView.image = [UIImage imageNamed:@"btn_like.png"];
    }
}

- (void)share
{
    
}

- (void)handleLike
{
    if ( self.checkUserLoginBlock && !self.checkUserLoginBlock() ) {
        return;
    }
    
    _likeView.userInteractionEnabled = NO;
    
    if ( !self.liked ) {
        [self doLike];
    } else {
        [self doUnLike];
    }
}

- (void)doLike
{
    [[DataService sharedService] post:@"/likes"
                               params:@{ @"id" : NSStringFromInteger(self.itemDetail.itemId), @"type" : @"Product", @"token" : [[UserService sharedService] token] }
                           completion:^(id result, BOOL succeed) {
                               _likeView.userInteractionEnabled = YES;
                               if ( succeed && [[result objectForKey:@"code"] integerValue] == 0 ) {
                                   self.liked = YES;
                               }
                           }];
}

- (void)doUnLike
{
    [[DataService sharedService] post:[NSString stringWithFormat:@"/likes/%d", self.itemDetail.itemId]
                               params:@{ @"token" : [[UserService sharedService] token], @"type": @"Product" }
                           completion:^(id result, BOOL succeed) {
                               _likeView.userInteractionEnabled = YES;
                               if ( succeed && [[result objectForKey:@"code"] integerValue] == 0 ) {
                                   self.liked = NO;
                               } else {
                                   
                               }
                           }];
}

- (void)addToCart:(UIButton *)sender
{
    if ( self.checkUserLoginBlock && !self.checkUserLoginBlock() ) {
        return;
    }
    
    sender.userInteractionEnabled = NO;
    
    [[DataService sharedService] post:@"/cart/add_item"
                               params:@{ @"token": [[UserService sharedService] token], @"pid": NSStringFromInteger(self.itemDetail.itemId) }
                           completion:^(id result, BOOL succeed) {
                               sender.userInteractionEnabled = YES;
                               
                               if ( succeed ) {
                                   if ( [[result objectForKey:@"code"] integerValue] == 0 ) {
                                       [[NSNotificationCenter defaultCenter] postNotificationName:kAddToCartNotification object:nil];
                                   } else {
                                       
                                   }
                               } else {
                                   
                               }
    }];
}

@end
