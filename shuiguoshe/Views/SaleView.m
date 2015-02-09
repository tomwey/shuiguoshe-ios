//
//  SaleView.m
//  shuiguoshe
//
//  Created by tomwey on 12/29/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "SaleView.h"

@implementation SaleView

- (void)dealloc
{
    self.sale = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
    }
    return self;
}

@end
