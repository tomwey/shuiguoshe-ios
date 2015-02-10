//
//  ViewController.m
//  shuiguoshe
//
//  Created by tomwey on 12/27/14.
//  Copyright (c) 2014 shuiguoshe. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setLeftBarButtonWithImage:@"btn_user.png" target:self action:@selector(gotoUserProfile)];
    
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
            CustomButton* btn = (CustomButton *)[cell.contentView viewWithTag:tag];
            if ( !btn ) {
                btn = [CustomButton buttonWithType:UIButtonTypeCustom];
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
            
            btn.userData = cata;
            
            [btn addTarget:self
                    action:@selector(btnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
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
        
        __block HomeViewController* me = self;
                                             
        for (int i=0; i<[result count]; i++) {
            ItemView* itemView = (ItemView *)[cell.contentView viewWithTag:3000+i];
            if ( !itemView ) {
                itemView = [[[ItemView alloc] init] autorelease];
                itemView.tag = 3000 + i;
                [cell.contentView addSubview:itemView];
            }
            
            itemView.item = [result objectAtIndex:i];
            itemView.didSelectBlock = ^(ItemView *itemView) {
                ItemDetailViewController* idvc = [[ItemDetailViewController alloc] init];
                idvc.item = itemView.item;
                [me.navigationController pushViewController:idvc animated:YES];
                [idvc release];
            };
            
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

- (void)gotoUserProfile
{
    UserViewController* uvc = [[[UserViewController alloc] init] autorelease];
    UINavigationController* nav = [[[UINavigationController alloc] initWithRootViewController:uvc] autorelease];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)btnClicked:(CustomButton *)sender
{
    NSAssert([sender.userData isKindOfClass:[Catalog class]], @"不正确的userData");
    ItemsViewController* ivc = [[[ItemsViewController alloc] init] autorelease];
    ivc.catalog = sender.userData;
    [self.navigationController pushViewController:ivc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
