//
//  ForwardCommand.h
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-12.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Command.h"

@class Forward;
@interface ForwardCommand : Command

@property (nonatomic, retain) Forward* forward;

+ (ForwardCommand *)buildCommandWithForward:(Forward *)aForward;

@end
