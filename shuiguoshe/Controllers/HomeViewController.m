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
    UITableView* _tableView;
    
    UIRefreshControl* _refreshControl;
    
    HomeTitleView* _titleView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条左边按钮
    ForwardCommand* aCommand = [[[ForwardCommand alloc] init] autorelease];
    aCommand.forward = [Forward buildForwardWithType:ForwardTypeModal from:self toControllerName:@"UserViewController"];
    aCommand.forward.loginCheck = YES;
    [self setLeftBarButtonWithImage:@"btn_user.png" command:aCommand];
    
    // 设置导航条标题视图
//    LogoTitleView* titleView = [[[LogoTitleView alloc] init] autorelease];
//    self.navigationItem.titleView = titleView;
//    
//    PhoneNumberView* pnv = [PhoneNumberView currentPhoneNumberView];
//    titleView.didClickBlock = ^(BOOL closed) {
//        if ( closed ) {
//            [pnv dismiss];
//        } else {
//            [pnv showInView:self.view];
//        }
//    };
    
    HomeTitleView* titleView = [[[HomeTitleView alloc] init] autorelease];
    self.navigationItem.titleView = titleView;
    _titleView = titleView;
    
    titleView.titleDidClickBlock = ^{
        ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:[Forward buildForwardWithType:ForwardTypeModal
                                                                                                    from:self
                                                                                        toControllerName:@"AreaListViewController"]];
        [aCommand execute];
    };
    
    // 创建表视图
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds),
                                                                           CGRectGetHeight(mainScreenBounds) -
                                                                           NavigationBarAndStatusBarHeight())
                                                          style:UITableViewStylePlain];
    [self.view addSubview:_tableView];
    [_tableView release];
    
//    _tableView.backgroundColor = [UIColor clearColor];
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    
    _refreshControl = [[UIRefreshControl alloc] init];
    [_tableView addSubview:_refreshControl];
    
    [_refreshControl release];
    
    [_refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    
//    _refreshControl.attributedTitle = [[[NSAttributedString alloc] initWithString:@"下拉刷新"] autorelease];
    
    [self loadData];
}

- (void)refreshTable
{
    [self loadData];
}

- (void)loadData
{
    [[DataService sharedService] loadEntityForClass:@"Section"
                                                URI:[NSString stringWithFormat:@"/sections?area_id=%d", [[[DataService sharedService] areaForLocal] oid]]
                                         completion:^(id result, BOOL succeed) {
//                                             [self doneLoadingTableViewData];
                                             [_refreshControl endRefreshing];
                                             if ( succeed ) {
                                                 self.dataSource = result;
                                                 _tableView.hidden = NO;
                                                 [_tableView reloadData];
                                             } else {
                                                 if ( result ) {
                                                     
                                                 } else {
                                                     
                                                 }
//                                                 _tableView.hidden = YES;
                                             }
                                         }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_bannerView startLoop];
    
    _titleView.title = [[[DataService sharedService] areaForLocal] name];
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
//        cell.backgroundColor = [UIColor whiteColor];
    }
    
    Section* s = [self.dataSource objectAtIndex:indexPath.row];
    
    if ( s.name.length > 0 ) {
        SectionView* sv = (SectionView *)[cell.contentView viewWithTag:1002];
        if ( !sv ) {
            sv = [[[SectionView alloc] init] autorelease];
            [cell.contentView addSubview:sv];
            sv.tag = 1002;
            
            CGRect frame = sv.frame;
            frame.origin = CGPointMake(10, 10);
            sv.frame = frame;
        }
        
        [sv setSectionName:s.name];
    }
    
    if ( [s.identifier isEqualToString:@"banners"] ) {
        [self addBanner:cell atIndex:indexPath.row];
    } else {
        [self addItems:cell atIndex:indexPath.row];
    }
    
//    if ( [s.identifier isEqualToString:@"catalogs"] ) {
//        [self addCatalog:cell atIndex:indexPath.row];
//    }
//    
//    if ( [s.identifier isEqualToString:@"hot_items"] ) {
//        [self addItems:cell atIndex:indexPath.row];
//    }
    
//    cell.backgroundColor = [UIColor whiteColor];
    
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
        
        [btn setTitleColor:COMMON_TEXT_COLOR forState:UIControlStateNormal];
        
        int m = i % numberOfCol;
        int n = i / numberOfCol;
        btn.frame = CGRectMake(padding + ( padding + width ) * m,
                               30 + 10 + ( padding + height ) * n,
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
    CGFloat padding = 10;
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - (numberOfCol + 1) * padding ) / numberOfCol;
    
    CGFloat height = width / 0.618;
    
    CGFloat factor = [self factorForDevice];
    
    for (int i=0; i<[s.data count]; i++) {
        ItemView* itemView = (ItemView *)[cell.contentView viewWithTag:3000+i];
        if ( !itemView ) {
            itemView = [[[ItemView alloc] init] autorelease];
            itemView.tag = 3000 + i;
            [cell.contentView addSubview:itemView];
        }
        
        int m = i % numberOfCol;
        int n = i / numberOfCol;
        
        itemView.frame = CGRectMake(padding + (width + padding) * m,
                                    30 + 20 + ( height + factor + padding ) * n,
                                    width, height + factor);
        
        itemView.item = [s.data objectAtIndex:i];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Section* s = [self.dataSource objectAtIndex:indexPath.row];
    if ( [s.identifier isEqualToString:@"banners"] ) {
        return s.height * ( CGRectGetWidth(mainScreenBounds) / 320.0 );
    }
    
    int numberOfCol = 2;
    CGFloat padding = 10;
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - (numberOfCol + 1) * padding ) / numberOfCol;
    
    CGFloat height = width / 0.618;
    
    int row = (s.data.count + 1 ) / 2;
    
    return row * (height + padding) + 30 * ( self.dataSource.count - 1 );// * ( CGRectGetWidth(mainScreenBounds) / 320.0 );
}

- (CGFloat)factorForDevice
{
    CGFloat factor = 0;
    NSLog(@"%f", CGRectGetHeight(mainScreenBounds));
    if ( CGRectGetHeight(mainScreenBounds) > 568 ) {
        factor = 24;
    }
    
    if ( CGRectGetHeight(mainScreenBounds) > 667 ) {
        factor = 38;
    }
    
    return factor;
}

@end
