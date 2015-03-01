//
//  CartService.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kCartTotalDidChangeNotification;

@interface CartService : NSObject

@property (nonatomic, assign) UILabel* cartTotalLabel;

+ (CartService *)sharedService;

- (void)initTotal:(NSInteger)total;

- (NSUInteger)totalCount;

@end
