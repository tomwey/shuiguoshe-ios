//
//  Defines.h
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#ifndef shuiguoshe_Defines_h
#define shuiguoshe_Defines_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define RGB(r,g,b)     [UIColor colorWithRed:(r)/255.0 \
                                       green:(g)/255.0 \
                                        blue:(b)/255.0 \
                                       alpha:1.0]
#define mainScreenBounds [[UIScreen mainScreen] bounds]

#define GREEN_COLOR RGB(7, 156, 22)

#define kAPIHost @"http://10.0.16.11:3000/api/v1"

static inline UIButton* createButton(NSString* imageName, id target, SEL action)
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.exclusiveTouch = YES;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
};

static inline UIBarButtonItem* createLeftBarButton(NSString* imageName, id target, SEL action)
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.exclusiveTouch = YES;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    return [item autorelease];
};

static inline UILabel* createLabel(CGRect frame, NSTextAlignment alignment, UIColor* textColor, UIFont* font)
{
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = textColor;
    label.font = font;
    label.textAlignment = alignment;
    return [label autorelease];
};

static inline NSString* NSStringFromInteger(NSInteger value)
{
    return [NSString stringWithFormat:@"%ld", value];
};

static inline UIImage* resizeImageForImage(UIImage* srcImage, CGSize newSize)
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, [[UIScreen mainScreen] scale]);
    [srcImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
};

#import "AFNetworking.h"

#import "Banner.h"
#import "Sale.h"
#import "Item.h"
#import "Catalog.h"
#import "User.h"
#import "OrderState.h"
#import "ItemDetail.h"
#import "Photo.h"
#import "Forward.h"
#import "FormItem.h"

#import "GTMBase64.h"

#import "Command.h"
#import "ForwardCommand.h"
#import "CommandButton.h"

#import "CoordinatorController.h"

#import "DataService.h"
#import "UserService.h"

#import "UIImageView+AFNetworking.h"
#import "UIView+Toast.h"
#import "InfinitePagingView.h"
#import "MBProgressHUD.h"
#import "ModalAlert.h"

#import "BannerView.h"
#import "UserProfileView.h"
#import "OrderStateView.h"
#import "SectionView.h"
#import "ItemView.h"
#import "LogoTitleView.h"
#import "PhoneNumberView.h"
#import "LPLabel.h"
#import "CustomButton.h"
#import "DetailToolbar.h"
#import "InputTextField.h"

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "UserViewController.h"
#import "ItemsViewController.h"
#import "CartViewController.h"
#import "ApartmentsViewController.h"
#import "ItemDetailViewController.h"
#import "LoginViewController.h"

#endif
