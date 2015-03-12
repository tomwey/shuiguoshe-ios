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
@property (nonatomic, retain) UITableView* tableView;
@property (nonatomic, retain) UIRefreshControl* refreshControl;

@end

@implementation HomeViewController
{
    BannerView* _bannerView;
    
    HomeTitleView* _titleView;
    
    NSInteger _dtHeight;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置导航条左边按钮
    ForwardCommand* aCommand = [[[ForwardCommand alloc] init] autorelease];
    aCommand.forward = [Forward buildForwardWithType:ForwardTypeModal from:self toControllerName:@"UserViewController"];
    aCommand.forward.loginCheck = YES;
    [self setLeftBarButtonWithImage:@"btn_user.png" command:aCommand];
    
    // 标题
    HomeTitleView* titleView = [[[HomeTitleView alloc] init] autorelease];
    self.navigationItem.titleView = titleView;
    _titleView = titleView;
    
    titleView.titleDidClickBlock = ^{
        ForwardCommand* aCommand =
        [ForwardCommand buildCommandWithForward:
         [Forward buildForwardWithType:ForwardTypeModal
                                  from:self
                      toControllerName:@"AreaListViewController"]];
        
        aCommand.userData = @"Home";
        [aCommand execute];
    };
    
    _dtHeight = 0;
    
    [self initTable];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateTable)
                                                 name:kAreaDidSelectNotification2Home
                                               object:nil];
    
    [self loadData:YES];
}

- (void)updateTable
{
    _dtHeight = 64;
    
    [self initTable];
    
    _bannerView = nil;
    
    [self loadData:YES];
}

- (void)initTable
{
    // 创建表视图
    [self.refreshControl removeFromSuperview];
    [self.tableView removeFromSuperview];
    if ( [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0 ) {
        _dtHeight = 0;
    }
    self.tableView = [[[UITableView alloc] initWithFrame:
                       CGRectMake(0, _dtHeight,
                                  CGRectGetWidth(mainScreenBounds),
                                  CGRectGetHeight(mainScreenBounds) -
                                  NavigationBarAndStatusBarHeight() -
                                  _dtHeight)
                                                   style:UITableViewStylePlain] autorelease];
    
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.refreshControl = [[[UIRefreshControl alloc] init] autorelease];
    [self.tableView addSubview:self.refreshControl];

    [self.refreshControl addTarget:self
                            action:@selector(refreshTable)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)refreshTable
{
    [self loadData:NO];
}

- (void)loadData:(BOOL)yesOrNo
{
    [[DataService sharedService] loadEntityForClass:@"Section"
                                                URI:[NSString stringWithFormat:@"/sections?area_id=%ld", [[[DataService sharedService] areaForLocal] oid]]
                                         completion:^(id result, BOOL succeed) {
                                             [_refreshControl endRefreshing];
                                             
                                             if ( succeed ) {
                                                 self.dataSource = result;
                                                 self.tableView.hidden = NO;
                                                 
                                                 self.tableView.dataSource = self;
                                                 self.tableView.delegate   = self;
                                                 
                                                 [self.tableView reloadData];
                                             } else {
                                                 if ( result ) {
                                                     
                                                 } else {
                                                     
                                                 }
                                             }
                                         } showLoading:yesOrNo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_bannerView startLoop];
    
    _titleView.title = [[[DataService sharedService] areaForLocal] name];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
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
//        cell.backgroundColor = [UIColor redColor];
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
        
        // 更多按钮
        if ( s.data.count > 2 ) {
            CommandButton* moreBtn = (CommandButton *)[cell.contentView viewWithTag:888];
            if ( !moreBtn ) {
                moreBtn = [[CoordinatorController sharedInstance] createCommandButton:nil command:nil];
                moreBtn.tag = 888;
                [cell.contentView addSubview:moreBtn];
                [moreBtn setTitle:@"查看更多〉" forState:UIControlStateNormal];
                [moreBtn setTitleColor:GREEN_COLOR forState:UIControlStateNormal];
                moreBtn.frame = CGRectMake(CGRectGetWidth(mainScreenBounds) - 10 - 90, 10, 90, 30);
            }
            
            Catalog* cata = [[[Catalog alloc] init] autorelease];
            cata.name = s.name;
            cata.cid = [[[s.identifier componentsSeparatedByString:@"-"] lastObject] integerValue];
            
            Forward* aForward = [Forward buildForwardWithType:ForwardTypePush
                                                         from:self
                                             toControllerName:@"ItemsViewController"];
            aForward.userData = cata;
            ForwardCommand* aCommand = [ForwardCommand buildCommandWithForward:aForward];
            moreBtn.command = aCommand;
        }
    }
    
    if ( [s.identifier isEqualToString:@"banners"] ) {
        [self addBanner:cell atIndex:indexPath.row];
    } else {
        _bannerView = nil;
        
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

- (void)addItems:(UITableViewCell *)cell atIndex:(NSInteger)index
{
    Section* s = [self.dataSource objectAtIndex:index];
        
    int numberOfCol = 2;
    CGFloat padding = 10;
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - (numberOfCol + 1) * padding ) / numberOfCol;
    
    CGFloat height = width / [self factorForDevice];
    
    CGFloat factor = 0.0;//[self factorForDevice];
    
    CGRect frame = CGRectZero;
    if ( [cell.contentView viewWithTag:1002] ) {
        frame = [[cell.contentView viewWithTag:1002] frame];
    }
    
    for (int i=0; i<[self itemsCountFor:s]; i++) {
        ItemView* itemView = (ItemView *)[cell.contentView viewWithTag:3000+i];
        if ( !itemView ) {
            itemView = [[[ItemView alloc] init] autorelease];
            itemView.tag = 3000 + i;
            [cell.contentView addSubview:itemView];
        }
        
        int m = i % numberOfCol;
        int n = i / numberOfCol;
        
        itemView.frame = CGRectMake(padding + (width + padding) * m,
                                    CGRectGetMaxY(frame) + 10 + ( height + factor + padding ) * n,
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
    
    CGFloat dtRowHeight = indexPath.row == self.dataSource.count - 1 ? 20 : 0;
    
    int numberOfCol = 2;
    CGFloat padding = 10;
    CGFloat width = ( CGRectGetWidth(mainScreenBounds) - (numberOfCol + 1) * padding ) / numberOfCol;
    
    
    CGFloat height = width / [self factorForDevice];
    NSInteger row = 1;//(s.data.count + 1 ) / 2;
    
    return dtRowHeight + (row * (height + padding)) + 25 + 20;
}

- (NSInteger)itemsCountFor:(Section*)sec
{
    return MIN(2, sec.data.count);
}

- (CGFloat)factorForDevice
{
    CGFloat factor = 0.6;
    
    if ( CGRectGetHeight(mainScreenBounds) > 568 ) {
        factor = 0.65;
    }
    
    if ( CGRectGetHeight(mainScreenBounds) > 667 ) {
        factor = 0.68;
    }
    
    return factor;
}

@end
