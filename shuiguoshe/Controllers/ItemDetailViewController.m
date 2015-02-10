//
//  ItemDetailViewController.m
//  shuiguoshe
//
//  Created by tomwey on 2/10/15.
//  Copyright (c) 2015 shuiguoshe. All rights reserved.
//

#import "ItemDetailViewController.h"

@implementation ItemDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = self.item.title;
    
    [self setLeftBarButtonWithImage:@"btn_back.png"
                             target:self
                             action:@selector(back)];
    
    
}

@end
