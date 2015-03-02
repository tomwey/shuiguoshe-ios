//
//  TimerLabel.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-3-2.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "TimerLabel.h"
#import "Defines.h"

@implementation TimerLabel
{
    UILabel* _realLabel;
    NSTimer* _timer;
    
    BOOL _hasStart;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        self.frame = CGRectMake(0, 0, 288, 30);
        
        _realLabel = createLabel(self.bounds,
                                 NSTextAlignmentLeft,
                                 [UIColor blackColor],
                                 [UIFont systemFontOfSize:12]);
        [self addSubview:_realLabel];
        _realLabel.adjustsFontSizeToFitWidth = YES;
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                          target:self
                                                        selector:@selector(update)
                                                        userInfo:nil
                                                         repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
        
        _hasStart = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(pause)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)pause
{
    _hasStart = NO;
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void)update
{
    long long seconds = _leftSeconds;
    
    NSInteger days = seconds / ( 60 * 60 * 24 );
    seconds -= days * ( 60 * 60 * 24 );
    
    NSInteger hours = seconds / ( 60 * 60 );
    seconds -= hours * ( 60 * 60 );
    
    NSInteger minutes = seconds / 60;
    seconds -= minutes * 60;
    
    if ( _leftSeconds == 0 ) {
        _realLabel.text = @"活动已结束";
        [_timer invalidate];
        _timer = nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kTimerDidEndNotification" object:nil];
    } else {
        _realLabel.text = [NSString stringWithFormat:@"剩余%02d天%02d小时%02d分钟%02d秒", days, hours, minutes, seconds];
    }
    
    _leftSeconds -= 1;
}

- (void)setLeftSeconds:(long long)leftSeconds
{
    if ( !_hasStart ) {
        _leftSeconds = leftSeconds;
        
        _hasStart = YES;
        [_timer setFireDate:[NSDate date]];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
    [super dealloc];
}

@end
