//
//  ViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "HomeViewController.h"
#import "Defines.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条左边按钮
    ForwardCommand* aCommand = [[[ForwardCommand alloc] init] autorelease];
    if ( [[UserService sharedService] isLogin] ) {
        aCommand.forward = [Forward buildForwardWithType:ForwardTypeModal from:self toControllerName:@"UserViewController"];
    } else {
        aCommand.forward = [Forward buildForwardWithType:ForwardTypeModal from:self toControllerName:@"LoginViewController"];
    }
    
    [self setLeftBarButtonWithImage:@"btn_user.png" command:aCommand];
    
    // 设置导航条标题视图
    LogoTitleView* titleView = [[[LogoTitleView alloc] init] autorelease];
    self.navigationItem.titleView = titleView;
    
    PhoneNumberView* pnv = [PhoneNumberView currentPhoneNumberView];
    titleView.didClickBlock = ^(BOOL closed) {
        if ( closed ) {
            [pnv dismiss];
        } else {
            [pnv showInView:self.view];
        }
    };
    
    // 创建表视图
    UITableView* tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds),
                                                                           CGRectGetHeight(mainScreenBounds))
                                                          style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.dataSource = self;
    tableView.delegate   = self;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"row:%ld", indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            [self addBanner:cell];
            break;
        case 1:
            [self addCatalog:cell];
            break;
        case 2:
            [self addItems:cell];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)addBanner:(UITableViewCell *)cell
{
    BannerView* banner = (BannerView *)[cell.contentView viewWithTag:1001];
    if ( !banner ) {
        banner = [[[BannerView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)] autorelease];
        [cell.contentView addSubview:banner];
        banner.tag = 1001;
    }
    
}

- (void)addCatalog:(UITableViewCell *)cell
{
    SectionView* sv = (SectionView *)[cell.contentView viewWithTag:1002];
    if ( !sv ) {
        sv = [[[SectionView alloc] init] autorelease];
        [cell.contentView addSubview:sv];
        sv.tag = 1002;
        
        CGRect frame = sv.frame;
        frame.origin = CGPointMake(20, 20);
        sv.frame = frame;
        
        [sv setSectionName:@"分类选购"];
    }
    
    // 分类
    [[DataService sharedService] loadEntityForClass:@"Catalog"
                                                URI:@"/catalogs"
                                         completion:^(id result, BOOL succeed) {
        
        int numberOfCol = 2;
        CGFloat padding = 20;
        CGFloat width = ( CGRectGetWidth(mainScreenBounds) - ( numberOfCol + 1 ) * padding ) / numberOfCol;
        CGFloat height = 0.318 * width;
        
        for (int i=0; i<[result count]; i++) {
            
            Catalog* cata = [result objectAtIndex:i];
            NSUInteger tag = 2000 + cata.cid;
            CommandButton* btn = (CommandButton *)[cell.contentView viewWithTag:tag];
            if ( !btn ) {
                btn = [[CoordinatorController sharedInstance] createCommandButton:nil command:nil];
                btn.tag = tag;
                [cell.contentView addSubview:btn];
            }
            
            [btn setTitle:cata.name forState:UIControlStateNormal];
            btn.backgroundColor = RGB(232,233,232);
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
            int m = i % numberOfCol;
            int n = i / numberOfCol;
            btn.frame = CGRectMake(padding + ( padding + width ) * m,
                                   CGRectGetMaxY(sv.frame) + 20 + ( padding + height ) * n,
                                   width, height);
            
            ForwardCommand* fc = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                                  from:self
                                                                                      toControllerName:@"ItemsViewController"]];
            btn.command = fc;
            fc.userData = cata;
            
        }
    }];
}

- (void)addItems:(UITableViewCell *)cell
{
    SectionView* sv = (SectionView *)[cell.contentView viewWithTag:1003];
    if ( !sv ) {
        sv = [[[SectionView alloc] init] autorelease];
        [cell.contentView addSubview:sv];
        sv.tag = 1003;
        
        CGRect frame = sv.frame;
        frame.origin = CGPointMake(20, 20);
        sv.frame = frame;
        
        [sv setSectionName:@"热门订购"];
    }
    
    // 热门订购
    [[DataService sharedService] loadEntityForClass:@"Item"
                                                URI:@"/items/hot"
                                         completion:^(id result, BOOL succeed) {
        
        int numberOfCol = 2;
        CGFloat padding = 20;
        CGFloat width = ( CGRectGetWidth(mainScreenBounds) - numberOfCol * padding - padding / 2 ) / numberOfCol;
                                            
        for (int i=0; i<[result count]; i++) {
            ItemView* itemView = (ItemView *)[cell.contentView viewWithTag:3000+i];
            if ( !itemView ) {
                itemView = [[[ItemView alloc] init] autorelease];
                itemView.tag = 3000 + i;
                [cell.contentView addSubview:itemView];
            }
            
            itemView.item = [result objectAtIndex:i];
            
            int m = i % numberOfCol;
            int n = i / numberOfCol;
            
            itemView.frame = CGRectMake(padding + (width + padding/2) * m,
                                        CGRectGetMaxY(sv.frame) + 20 + ( 230 + padding ) * n, width, 230);
        }
    }];
}

static CGFloat heights[] = { 120, 160, 800 };
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return heights[indexPath.row];
}

@end
