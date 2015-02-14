//
//  Checkbox.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-14.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "Checkbox.h"
#import "Defines.h"

@implementation Checkbox
{
    UIImageView* _contentView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.bounds = CGRectMake(0, 0, 44, 44);
        
        _contentView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_check.png"]];
        [self addSubview:_contentView];
        [_contentView release];
        
        [_contentView sizeToFit];
        
        _contentView.center = CGPointMake(CGRectGetMidX(self.bounds),
                                          CGRectGetMidY(self.bounds));
        
        
        UIButton* btn = createButton(nil, self, @selector(btnClicked));
        [self addSubview:btn];
        btn.frame = self.bounds;
        
        self.checked = YES;
    }
    return self;
}

- (void)setChecked:(BOOL)checked
{
    _checked = checked;
    
    if ( _checked ) {
        _contentView.image = [UIImage imageNamed:@"btn_checked.png"];
    } else {
        _contentView.image = [UIImage imageNamed:@"btn_check.png"];
    }
}

- (void)setLabel:(NSString *)label
{
    [_label release];
    _label = [label copy];
    
    if ( label ) {
        UILabel* realLabel = (UILabel *)[self viewWithTag:1024];
        if ( !realLabel ) {
            realLabel = createLabel(CGRectZero, NSTextAlignmentLeft, [UIColor blackColor], [UIFont systemFontOfSize:16]);
            [self addSubview:realLabel];
            realLabel.tag = 1024;
            
            CGSize size = [label sizeWithFont:realLabel.font
                            constrainedToSize:CGSizeMake(5000, CGRectGetHeight(self.bounds))
                                lineBreakMode:realLabel.lineBreakMode];
            
            realLabel.frame = CGRectMake(CGRectGetMaxX(_contentView.frame) + 5,
                                         0, size.width, CGRectGetHeight(self.bounds));
        }
        realLabel.text = label;
        CGRect frame = self.frame;
        frame.size.width += CGRectGetWidth(realLabel.frame);
        self.frame = frame;
    }
}

- (void)btnClicked
{
    self.checked = !self.checked;
}

- (void)dealloc
{
    [_label release];
    [super dealloc];
}

@end
