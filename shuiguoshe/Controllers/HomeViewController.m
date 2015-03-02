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

@property (nonatomic, copy) NSArray* dataSource;

@end

@implementation HomeViewController
{
    BannerView* _bannerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条左边按钮
    ForwardCommand* aCommand = [[[ForwardCommand alloc] init] autorelease];
    aCommand.forward = [Forward buildForwardWithType:ForwardTypeModal from:self toControllerName:@"UserViewController"];
    aCommand.forward.loginCheck = YES;
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
    
    [[DataService sharedService] loadEntityForClass:@"Section"
                                                URI:@"/sections"
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
                                                 self.dataSource = result;
                                                 tableView.hidden = NO;
                                                 [tableView reloadData];
                                             } else {
                                                 tableView.hidden = YES;
                                             }
                                         }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_bannerView startLoop];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_bannerView stopLoop];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"row:%ld", indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Section* s = [self.dataSource objectAtIndex:indexPath.row];
    
    if ( s.name.length > 0 ) {
        SectionView* sv = (SectionView *)[cell.contentView viewWithTag:1002];
        if ( !sv ) {
            sv = [[[SectionView alloc] init] autorelease];
            [cell.contentView addSubview:sv];
            sv.tag = 1002;
            
            CGRect frame = sv.frame;
            frame.origin = CGPointMake(20, 20);
            sv.frame = frame;
        }
        
        [sv setSectionName:s.name];
    }
    
    if ( [s.identifier isEqualToString:@"banners"] ) {
        [self addBanner:cell atIndex:indexPath.row];
    }
    
    if ( [s.identifier isEqualToString:@"catalogs"] ) {
        [self addCatalog:cell atIndex:indexPath.row];
    }
    
    if ( [s.identifier isEqualToString:@"hot_items"] ) {
        [self addItems:cell atIndex:indexPath.row];
    }
    
    return cell;
}

- (void)addBanner:(UITableViewCell *)cell atIndex:(NSInteger)index
{
    BannerView* banner = (BannerView *)[cell.contentView viewWithTag:1001];
    if ( !banner ) {
        banner = [[[BannerView alloc] init] autorelease];
        [cell.contentView addSubview:banner];
        banner.tag = 1001;
        
        CGRect frame = banner.bounds;
        banner.frame = frame;
    }
    
    _bannerView = banner;
    
    Section* s = [self.dataSource objectAtIndex:index];
    [banner setDataSource:s.data];
    
}

- (void)addCatalog:(UITableViewCell *)cell atIndex:(NSInteger)index
{
    // 分类
    Section* s = [self.dataSource objectAtIndex:index];
    
    int numberOfCol = 2;
    CGFloat padding = 20;
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - ( numberOfCol + 1 ) * padding ) / numberOfCol;
    CGFloat height = 48;
    
    for (int i=0; i<[s.data count]; i++) {
        
        Catalog* cata = [s.data objectAtIndex:i];
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
                               30 + 20 + ( padding + height ) * n,
                               width, height);
        
        ForwardCommand* fc = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypePush
                                                                                              from:self
                                                                                  toControllerName:@"ItemsViewController"]];
        btn.command = fc;
        fc.userData = cata;
        
    }
}

- (void)addItems:(UITableViewCell *)cell atIndex:(NSInteger)index
{
    Section* s = [self.dataSource objectAtIndex:index];
        
    int numberOfCol = 2;
    CGFloat padding = 20;
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - numberOfCol * padding - padding / 2 ) / numberOfCol;
    
    CGFloat factor = [self factorForDevice];
    
    for (int i=0; i<[s.data count]; i++) {
        ItemView* itemView = (ItemView *)[cell.contentView viewWithTag:3000+i];
        if ( !itemView ) {
            itemView = [[[ItemView alloc] init] autorelease];
            itemView.tag = 3000 + i;
            [cell.contentView addSubview:itemView];
        }
        
        itemView.item = [s.data objectAtIndex:i];
        
        int m = i % numberOfCol;
        int n = i / numberOfCol;
        
        itemView.frame = CGRectMake(padding + (width + padding/2) * m,
                                    30 + 20 + ( 230 + factor + padding ) * n,
                                    width, 230 + factor);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Section* s = [self.dataSource objectAtIndex:indexPath.row];
    if ( [s.identifier isEqualToString:@"banners"] ) {
        return s.height * ( CGRectGetWidth(mainScreenBounds) / 320.0 );
    }
    
    if ( [s.identifier isEqualToString:@"catalogs"] ) {
        return s.height;
    }
    
    if ( [s.identifier isEqualToString:@"hot_items"] ) {
        return s.height + ( ( [s.data count] + 1 ) / 2 ) * [self factorForDevice];
    }
    
    return s.height * ( CGRectGetWidth(mainScreenBounds) / 320.0 );
}

- (CGFloat)factorForDevice
{
    CGFloat factor = 0;
    if ( CGRectGetHeight(mainScreenBounds) > 568 ) {
        factor = 24;
    }
    
    if ( CGRectGetHeight(mainScreenBounds) > 667 ) {
        factor = 38;
    }
    
    return factor;
}

@end
