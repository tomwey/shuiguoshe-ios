//
//  ScoreListViewController.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-28.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "ScoreListViewController.h"
#import "Defines.h"

@interface ScoreListViewController () <UITableViewDataSource>

@property (nonatomic, copy) NSArray* dataSource;

@end

@implementation ScoreListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的积分";
    
    CGRect frame = self.view.bounds;
    UITableView* tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.dataSource = self;
    
    [[DataService sharedService] loadEntityForClass:@"ScoreTrace"
                                                URI:[NSString stringWithFormat:@"/user/score_traces?token=%@", [[UserService sharedService] token]]
                                         completion:^(id result, BOOL succeed) {
                                             if ( succeed ) {
                                                 self.dataSource = result;
                                                 tableView.hidden = NO;
                                                 [tableView reloadData];
                                             } else {
                                                 tableView.hidden = YES;
                                             }
                                             
                                         }];
    
    tableView.tableFooterView = [[[UIView alloc] init] autorelease];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"c%d", indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    ScoreTrace* st = [self.dataSource objectAtIndex:indexPath.row];
    
    CGFloat width = CGRectGetWidth(mainScreenBounds) - 15 * 2;
    // id
    UILabel* idLabel = (UILabel *)[cell.contentView viewWithTag:100];
    if ( !idLabel ) {
        idLabel = createLabel(CGRectMake(15, 0, width * 0.1, 44),
                              NSTextAlignmentCenter,
                              [UIColor blackColor],
                              [UIFont systemFontOfSize:12]);
        idLabel.tag = 100;
        [cell.contentView addSubview:idLabel];
        idLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    idLabel.text = NSStringFromInteger(st.oid);
    
    // 分数
    UILabel* scoreLabel = (UILabel *)[cell.contentView viewWithTag:101];
    if ( !scoreLabel ) {
        scoreLabel = createLabel(CGRectMake(CGRectGetMaxX(idLabel.frame), 0, width * 0.2, 44),
                              NSTextAlignmentCenter,
                              [UIColor blackColor],
                              [UIFont systemFontOfSize:12]);
        scoreLabel.tag = 101;
        [cell.contentView addSubview:scoreLabel];
        scoreLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    scoreLabel.text = [NSString stringWithFormat:@"%@%d", st.operType, st.score];
    
    // 摘要
    UILabel* summaryLabel = (UILabel *)[cell.contentView viewWithTag:102];
    if ( !summaryLabel ) {
        summaryLabel = createLabel(CGRectMake(CGRectGetMaxX(scoreLabel.frame), 0, width * 0.35, 44),
                                 NSTextAlignmentCenter,
                                 [UIColor blackColor],
                                 [UIFont systemFontOfSize:12]);
        summaryLabel.tag = 102;
        [cell.contentView addSubview:summaryLabel];
        summaryLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    summaryLabel.text = st.summary;
    
    // 时间
    UILabel* createdAtLabel = (UILabel *)[cell.contentView viewWithTag:103];
    if ( !createdAtLabel ) {
        createdAtLabel = createLabel(CGRectMake(CGRectGetMaxX(summaryLabel.frame), 0, width * 0.35, 44),
                                   NSTextAlignmentCenter,
                                   [UIColor blackColor],
                                   [UIFont systemFontOfSize:12]);
        createdAtLabel.tag = 103;
        [cell.contentView addSubview:createdAtLabel];
        createdAtLabel.adjustsFontSizeToFitWidth = YES;
    }
    
    createdAtLabel.text = st.createdAt;
    
    return cell;
}

- (BOOL)shouldShowingCart { return NO; }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
