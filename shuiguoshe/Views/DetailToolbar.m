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
    UIButton* addToCart;
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
        
        addToCart = createButton(@"btn_add_to_cart.png", self, @selector(addToCart:));
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(timerDidEnd)
                                                     name:@"kTimerDidEndNotification"
                                                   object:nil];
    }
    
    return self;
}

- (void)timerDidEnd
{
    addToCart.enabled = NO;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    ShareView* shareView = [[[ShareView alloc] init] autorelease];
    shareView.itemDetail = self.itemDetail;
    [shareView showInView:AppWindow()];
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
                           completion:^(NetworkResponse* resp) {
                               _likeView.userInteractionEnabled = YES;
                               if ( !resp.requestSuccess ) {
                                   [Toast showText:@"呃，系统出错了"];
                               } else {
                                   if ( resp.statusCode == 0 ) {
                                       self.liked = YES;
                                   } else {
                                       [Toast showText:@"收藏失败"];
                                   }
                               }
                           }];
}

- (void)doUnLike
{
    [[DataService sharedService] post:[NSString stringWithFormat:@"/likes/%d", self.itemDetail.itemId]
                               params:@{ @"token" : [[UserService sharedService] token], @"type": @"Product" }
                           completion:^(NetworkResponse* resp) {
                               _likeView.userInteractionEnabled = YES;
                               if ( !resp.requestSuccess ) {
                                   [Toast showText:@"呃，系统出错了"];
                               } else {
                                   if ( resp.statusCode == 0 ) {
                                       self.liked = NO;
                                   } else {
                                       [Toast showText:@"取消收藏失败"];
                                   }
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
                               params:@{ @"token": [[UserService sharedService] token], @"pid": NSStringFromInteger(self.itemDetail.itemId),
                                         @"area_id": NSStringFromInteger([[[DataService sharedService] areaForLocal] oid])}
                           completion:^(NetworkResponse* resp)
    {
       sender.userInteractionEnabled = YES;
       
       if ( !resp.requestSuccess ) {
           [Toast showText:@"呃，系统出错了"];
       } else {
           if ( resp.statusCode == 0 ) {
               [Toast showText:@"成功添加到购物车"];
               [[NSNotificationCenter defaultCenter] postNotificationName:kCartTotalDidChangeNotification object:@(1)];
           } else {
               [Toast showText:@"添加到购物车失败"];
           }
       }
    }];
}

@end
