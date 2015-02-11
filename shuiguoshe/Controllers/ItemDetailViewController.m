//
//  ItemDetailViewController.m
//  shuiguoshe
//
//  Created by tomwey on 2/10/15.
//  Copyright (c) 2015 shuiguoshe. All rights reserved.
//

#import "ItemDetailViewController.h"

#define kTitleLabelFont [UIFont boldSystemFontOfSize:16]
#define kPriceLabelFont [UIFont boldSystemFontOfSize:18]

#define kLeftMargin 15

@interface ItemDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) ItemDetail* itemDetail;

@end

@implementation ItemDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"商品详情";
    
    [self setLeftBarButtonWithImage:@"btn_back.png"
                             target:self
                             action:@selector(back)];
    
    
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                          style:UITableViewStylePlain];
    
    [self.view addSubview:tableView];
    [tableView release];
    
    tableView.dataSource = self;
    tableView.delegate = self;
    
//    if ( [tableView respondsToSelector:@selector(setSeparatorInset:)] ) {
//        tableView.separatorInset = UIEdgeInsetsZero;
//    }
//    
//    if ( [tableView respondsToSelector:@selector(setLayoutMargins:)] ) {
//        tableView.layoutMargins = UIEdgeInsetsZero;
//    }
    
    __block ItemDetailViewController* me = self;
    
    [[DataService sharedService] loadEntityForClass:@"ItemDetail"
                                                URI:[NSString stringWithFormat:@"/items/%d", self.item.iid]
                                         completion:^(id result, BOOL succeed) {
                                             me.itemDetail = result;
                                             [tableView reloadData];
                                         }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* cellId = [NSString stringWithFormat:@"cell:%d", indexPath.row];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if ( !cell ) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId] autorelease];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    switch (indexPath.row) {
        case 0:
            [self addContentForOneCell:cell];
            break;
        case 1:
            [self addContentForTwoCell:cell];
            break;
        case 2:
            [self addContentForThreeCell:cell];
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)addContentForOneCell:(UITableViewCell *)cell
{
    CGFloat width = CGRectGetWidth(mainScreenBounds);
    
    // 大图
    UIImageView* largeImageView = (UIImageView *)[cell.contentView viewWithTag:1001];
    if ( !largeImageView ) {
        largeImageView = [[[UIImageView alloc] init] autorelease];
        largeImageView.tag = 1001;
        [cell.contentView addSubview:largeImageView];
        
        largeImageView.frame = CGRectMake(0, 0, width,
                                          width * 10 / 13);
        
        
    }
    
    [largeImageView setImageWithURL:[NSURL URLWithString:self.itemDetail.largeImage] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    
    // 标题
    UILabel* titleLabel = (UILabel *)[cell.contentView viewWithTag:1002];
    if ( !titleLabel ) {
        titleLabel = createLabel(CGRectZero, NSTextAlignmentLeft, [UIColor blackColor], kTitleLabelFont);
        [cell.contentView addSubview:titleLabel];
        titleLabel.tag = 1002;
        titleLabel.numberOfLines = 0;
        titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        CGSize size = [self.item.title sizeWithFont:kTitleLabelFont
                                  constrainedToSize:CGSizeMake(width - kLeftMargin * 2, 1000)
                                      lineBreakMode:titleLabel.lineBreakMode];
        titleLabel.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(largeImageView.frame) + 5, size.width, size.height);
        titleLabel.text = self.item.title;
    }
    
    // 价格
    UILabel* priceLabel = (UILabel *)[cell.contentView viewWithTag:1003];
    if ( !priceLabel ) {
        priceLabel = createLabel(CGRectZero, NSTextAlignmentLeft, GREEN_COLOR, kPriceLabelFont);
        [cell.contentView addSubview:priceLabel];
        priceLabel.tag = 1003;
        
        NSString* text = self.item.lowPriceText;
        priceLabel.text = text;
        
        CGSize size = [text sizeWithFont:kPriceLabelFont
                                  constrainedToSize:CGSizeMake(width - kLeftMargin * 2, 1000)
                                      lineBreakMode:priceLabel.lineBreakMode];
        priceLabel.frame = CGRectMake(kLeftMargin, CGRectGetMaxY(titleLabel.frame) + 5, size.width, size.height);
    }
    
    LPLabel* originPriceLabel = (LPLabel *)[cell.contentView viewWithTag:1004];
    if ( !originPriceLabel ) {
        originPriceLabel = [[LPLabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(priceLabel.frame) + 5,
                                                                     CGRectGetMinY(priceLabel.frame) + 2,
                                                                     100, CGRectGetHeight(priceLabel.frame))];
        originPriceLabel.tag = 1004;
        [cell.contentView addSubview:originPriceLabel];
        
        originPriceLabel.strikeThroughColor = RGB(137,137, 137);
        originPriceLabel.textColor = originPriceLabel.strikeThroughColor;
        originPriceLabel.font = [UIFont systemFontOfSize:14];
        
        originPriceLabel.text = self.item.originPriceText;
    }
}

- (void)addContentForTwoCell:(UITableViewCell *)cell
{
    CGFloat dtTop = 5;
    CGFloat width = CGRectGetWidth(mainScreenBounds) - kLeftMargin * 2;
    // 促销
    if ( self.item.discountScore > 0 ) {
        UILabel* discountLabel = (UILabel *)[cell.contentView viewWithTag:1005];
        if ( !discountLabel ) {
            discountLabel = createLabel(CGRectMake(kLeftMargin, dtTop, 40, 30),
                                        NSTextAlignmentLeft, RGB(137,137,137), [UIFont boldSystemFontOfSize:14]);
            discountLabel.tag = 1005;
            [cell.contentView addSubview:discountLabel];
            
            discountLabel.text = @"促销";
        }
        
        UILabel* discountInfoLabel = (UILabel *)[cell.contentView viewWithTag:1006];
        if ( !discountInfoLabel ) {
            CGRect frame = discountLabel.frame;
            frame.origin.x = CGRectGetMaxX(frame);
            frame.size.width = width - CGRectGetWidth(frame);
            discountInfoLabel = createLabel(frame, NSTextAlignmentLeft, GREEN_COLOR, [UIFont systemFontOfSize:14]);
            discountInfoLabel.tag = 1006;
            [cell.contentView addSubview:discountInfoLabel];
            discountInfoLabel.text = [NSString stringWithFormat:@"赠送%d积分，抵扣%.2f元", self.item.discountScore, self.item.discountScore/100.0];
        }
        
        dtTop = CGRectGetMaxY(discountLabel.frame);
    }
    // 规格
    UILabel* unitLabel = (UILabel *)[cell.contentView viewWithTag:1007];
    if ( !unitLabel ) {
        unitLabel = createLabel(CGRectMake(kLeftMargin, dtTop, 40, 30),
                                    NSTextAlignmentLeft, RGB(137,137,137), [UIFont boldSystemFontOfSize:14]);
        unitLabel.tag = 1007;
        [cell.contentView addSubview:unitLabel];
        
        unitLabel.text = @"规格";
    }
    
    UILabel* unitLabel2 = (UILabel *)[cell.contentView viewWithTag:1008];
    if ( !unitLabel2 ) {
        unitLabel2 = createLabel(CGRectMake(CGRectGetMaxX(unitLabel.frame), dtTop, 50, 30),
                                NSTextAlignmentLeft, [UIColor blackColor], [UIFont systemFontOfSize:14]);
        unitLabel2.tag = 1008;
        [cell.contentView addSubview:unitLabel2];
        
        unitLabel2.text = self.item.unit;
    }
    
    dtTop = CGRectGetMaxY(unitLabel.frame);
    
    // 配送
    UILabel* deliverLabel = (UILabel *)[cell.contentView viewWithTag:2001];
    if ( !deliverLabel ) {
        deliverLabel = createLabel(CGRectMake(kLeftMargin, dtTop, 40, 30),
                                   NSTextAlignmentLeft, RGB(137,137,137), [UIFont boldSystemFontOfSize:14]);
        deliverLabel.tag = 2001;
        [cell.contentView addSubview:deliverLabel];
        
        deliverLabel.text = @"配送";
    }
    
    UILabel* deliverLabel2 = (UILabel *)[cell.contentView viewWithTag:2002];
    if ( !deliverLabel2 ) {
        deliverLabel2 = createLabel(CGRectMake(CGRectGetMaxX(deliverLabel.frame), dtTop, width - kLeftMargin * 2, 30),
                                    NSTextAlignmentLeft, [UIColor blackColor], [UIFont systemFontOfSize:14]);
        deliverLabel2.tag = 2002;
        deliverLabel2.numberOfLines = 0;
        [cell.contentView addSubview:deliverLabel2];
        deliverLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    }
    
    deliverLabel2.text = self.itemDetail.deliverInfo;
    
    CGSize size = [deliverLabel2.text sizeWithFont:deliverLabel2.font
                                 constrainedToSize:CGSizeMake(CGRectGetWidth(deliverLabel2.frame), 1000)
                                     lineBreakMode:deliverLabel2.lineBreakMode];
    CGRect frame = deliverLabel2.frame;
    frame.size.height = size.height;
    frame.origin.y = dtTop + 5;
    deliverLabel2.frame = frame;
    
    deliverLabel2.baselineAdjustment = UIBaselineAdjustmentNone;
    
    dtTop = CGRectGetMaxY(deliverLabel.frame);

    
    // 销售记录
    UILabel* saleLabel = (UILabel *)[cell.contentView viewWithTag:3001];
    if ( !saleLabel ) {
        saleLabel = createLabel(CGRectMake(kLeftMargin, dtTop + 10, width - kLeftMargin * 2, 30),
                                NSTextAlignmentLeft,
                                unitLabel.textColor,
                                [UIFont boldSystemFontOfSize:16]);
        [cell.contentView addSubview:saleLabel];
        
        saleLabel.tag = 3001;

        NSMutableAttributedString *string =
        [[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已售%d件", self.item.ordersCount]] autorelease];
        [string addAttribute:NSForegroundColorAttributeName value:GREEN_COLOR range:NSMakeRange(2, string.length - 3)];
        saleLabel.attributedText = string;
    }
}

- (void)addContentForThreeCell:(UITableViewCell *)cell
{
    if ( self.itemDetail.photos.count == 0 ) {
        return;
    }
    
    CGFloat width = CGRectGetWidth(mainScreenBounds);
    // 商品简介
    UILabel* tipLabel = (UILabel *)[cell.contentView viewWithTag:4001];
    if ( !tipLabel ) {
        tipLabel = createLabel(CGRectMake(kLeftMargin, 5, width - kLeftMargin * 2, 30),
                               NSTextAlignmentLeft,
                               [UIColor blackColor],
                               [UIFont boldSystemFontOfSize:16]);
        tipLabel.tag = 4001;
        [cell.contentView addSubview:tipLabel];
        tipLabel.text = @"商品简介";
    }
    
    NSArray* photos = self.itemDetail.photos;
    int i = 0;
    CGFloat height = CGRectGetMaxY(tipLabel.frame) + 10;
    for (Photo* p in photos) {
        
        UIImageView* imageView = (UIImageView *)[cell.contentView viewWithTag:6000 + i];
        if ( !imageView ) {
            imageView = [[[UIImageView alloc] init] autorelease];
            imageView.tag = 6000 + i;
            [cell.contentView addSubview:imageView];
        }
        
        imageView.bounds = CGRectMake(0, 0, p.scaledImageWidth, p.scaledImageHeight);
        [imageView setImageWithURL:[NSURL URLWithString:p.imageUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        imageView.center = CGPointMake(width/2, height + CGRectGetHeight(imageView.bounds) / 2);
        
        height = CGRectGetMaxY(imageView.frame);
        
        i++;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = CGRectGetWidth(mainScreenBounds);
    switch (indexPath.row) {
        case 0: {
            CGFloat height = width * 10 / 13;
            
            CGSize size = [self.item.title sizeWithFont:kTitleLabelFont
                                      constrainedToSize:CGSizeMake(width - kLeftMargin * 2, 1000)
                                          lineBreakMode:NSLineBreakByWordWrapping];
            
            CGSize size2 = [self.item.lowPriceText sizeWithFont:kPriceLabelFont
                                              constrainedToSize:CGSizeMake(width - kLeftMargin * 2, 1000)
                                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            return height + size.height + size2.height + 20;
        }
            
        case 1: {
            CGSize size2 = [self.itemDetail.deliverInfo sizeWithFont:[UIFont systemFontOfSize:14]
                                                constrainedToSize:CGSizeMake(width - kLeftMargin * 2 - 40, 1000)
                                                    lineBreakMode:NSLineBreakByWordWrapping];
            
            CGFloat dtHeight = self.item.discountScore > 0 ? 30 : 0;
            
            return 60 + size2.height + 15 + dtHeight;
        }
        
        case 2: {
            return 45 + self.itemDetail.totalHeightForImages;
        }
            
        default:
            return 0;
    }
    
}

@end