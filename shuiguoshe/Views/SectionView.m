//
//  SectionView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView
{
    UIImageView* _iconView;
    UILabel*     _sectionLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"section_icon.png"]];
        [self addSubview:_iconView];
        [_iconView sizeToFit];
        
        self.bounds = CGRectMake(0, 0, 200, CGRectGetHeight(_iconView.frame));
        
        _sectionLabel = createLabel(CGRectMake(CGRectGetMaxY(_iconView.frame), ( CGRectGetHeight(self.bounds) - 37 ) / 2,
                                               200 - CGRectGetWidth(_iconView.frame), 37),
                                    NSTextAlignmentLeft,
                                    COMMON_TEXT_COLOR,
                                    [UIFont boldSystemFontOfSize:18]);
        [self addSubview:_sectionLabel];
    }
    return self;
}

- (void)setSectionName:(NSString *)sectionName
{
    _sectionLabel.text = sectionName;
}

@end
