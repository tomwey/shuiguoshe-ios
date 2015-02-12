//
//  Command.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Command : NSObject

@property (nonatomic, retain) id userData;

- (void)execute;

- (void)execute:( void (^)(id result))result;

@end
