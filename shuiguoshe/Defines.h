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
#define COMMON_TEXT_COLOR RGB(56,56,56)

// 家里
//#define kAPIHost @"http://192.168.1.131:3000/api/v1"

// 公司
//#define kAPIHost @"http://10.0.16.11:3000/api/v1"

// 产品
#define kAPIHost @"http://shuiguoshe.com/api/v1"

// 微信分享
#define kWechatAppID @"wx4accd427c1693a84"
#define kWechatAppSecret @"d78c7620e1590330159ff4f3255ee7b5"

// QQ分享
#define kQQOpenAppId @"1104304977"

static inline CGFloat NavigationBarAndStatusBarHeight()
{
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        return 0;
    }
    
    return 64.0;
};

static inline CGFloat NavigationBarHeight()
{
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ) {
        return 0;
    }
    
    return 44.0;
};

static inline NSString* formatFee(CGFloat fee)
{
    return [NSString stringWithFormat:@"￥%.2f", fee];
};

static inline UIButton* createButton(NSString* imageName, id target, SEL action)
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn sizeToFit];
    btn.exclusiveTouch = YES;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
};

static inline UIButton* createButton2(NSString* imageName, NSString* title, id target, SEL action)
{
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn sizeToFit];
    [btn setTitle:title forState:UIControlStateNormal];
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

static inline UIWindow* AppWindow()
{
    return [[[UIApplication sharedApplication] windows] objectAtIndex:0];
};

#import "AFNetworking.h"

#import "WXApi.h"

#import "KKShareWeiXin.h"
#import "KKShareQQZone.h"
#import "QQShareManager.h"

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
#import "Cart.h"
#import "LineItem.h"
#import "DeliverInfo.h"
#import "NewOrderInfo.h"
#import "Order.h"
#import "OrderInfo.h"
#import "OrderCollection.h"
#import "ScoreTrace.h"
#import "Like.h"
#import "Apartment.h"
#import "Section.h"

#import "GTMBase64.h"
#import "NSString+Additions.h"

#import "Command.h"
#import "ForwardCommand.h"
#import "CommandButton.h"

#import "CoordinatorController.h"

#import "DataService.h"
#import "UserService.h"
#import "CartService.h"

#import "UIImageView+AFNetworking.h"
#import "InfinitePagingView.h"
#import "MBProgressHUD.h"
#import "ModalAlert.h"
#import "Toast.h"

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
#import "Checkbox.h"
#import "NumberControl.h"
#import "UpdateValueLabel.h"
#import "OrderCellView.h"
#import "TimerLabel.h"
#import "ShareView.h"
#import "QQShareView.h"

#import "BaseViewController.h"
#import "HomeViewController.h"
#import "UserViewController.h"
#import "ItemsViewController.h"
#import "CartViewController.h"
#import "ApartmentsViewController.h"
#import "ItemDetailViewController.h"
#import "LoginViewController.h"

#endif
