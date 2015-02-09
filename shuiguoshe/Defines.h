//
//  Defines.h
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#ifndef shuiguoshe_Defines_h
#define shuiguoshe_Defines_h

#define RGB(r,g,b)     [UIColor colorWithRed:(r)/255.0 \
                                       green:(g)/255.0 \
                                        blue:(b)/255.0 \
                                       alpha:1.0]
#define mainScreenBounds [[UIScreen mainScreen] bounds]

#import "AFNetworking.h"

#import "DataService.h"

#import "Banner.h"
#import "Sale.h"
#import "Item.h"

#import "UIImageView+AFNetworking.h"
#import "InfinitePagingView.h"

#import "BannerView.h"

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "UserViewController.h"
#import "ItemsViewController.h"
#import "CartViewController.h"
#import "ApartmentsViewController.h"


#endif
