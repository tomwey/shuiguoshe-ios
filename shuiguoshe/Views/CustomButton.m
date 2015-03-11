//
//  CustomButton.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "CustomButton.h"
#import "Defines.h"

@implementation CustomButtonGroup
{
    NSMutableArray* _buttonsContainer;
}

- (id)init
{
    if ( self = [super init] ) {
        _buttonsContainer = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (NSArray *)items { return _buttonsContainer; }

- (void)addCustomButton:(CustomButton *)aButton
{
    if ( aButton && ![_buttonsContainer containsObject:aButton] ) {
        [_buttonsContainer addObject:aButton];
    }
}

- (void)removeAllButtons
{
    [_buttonsContainer removeAllObjects];
}

- (void)dealloc
{
    [_buttonsContainer release];
    [super dealloc];
}

@end

@implementation CustomButton
{
    UIView*   _contentView;
    UILabel*  _contentLabel;
    UIButton* _blankBtn;
}

- (id)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        
        self.backgroundColor = RGB(224, 224, 224);
        
        self.layer.cornerRadius = 2;
        self.clipsToBounds = YES;
        
//        _contentView = [[[UIView alloc] init] autorelease];
//        [self addSubview:_contentView];
        
        _contentLabel = createLabel(frame,
                                    NSTextAlignmentCenter,
                                    [UIColor whiteColor],
                                    [UIFont boldSystemFontOfSize:fontSize(14)]);
        [self addSubview:_contentLabel];
        
        UIButton* btn = createButton(nil, self, @selector(btnClicked));
        [self addSubview:btn];
        
        _blankBtn = btn;
        
    }
    return self;
}

- (void)btnClicked
{
    for (CustomButton* item in [_buttonGroup items]) {
        item.selected = NO;
    }
    
    self.selected = YES;
    
    if ( self.didClickBlock ) {
        self.didClickBlock(self);
    }
}

- (void)setButtonGroup:(CustomButtonGroup *)buttonGroup
{
    _buttonGroup = buttonGroup;
    
    [_buttonGroup addCustomButton:self];
}

- (void)setTitle:(NSString *)title
{
    _contentLabel.text = title;
}

- (NSString *)title { return _contentLabel.text; }

- (void)layoutSubviews
{
    _contentLabel.frame = _blankBtn.frame = self.bounds;
}

- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    self.userInteractionEnabled = !_selected;
    
    if ( _selected ) {
        self.backgroundColor = GREEN_COLOR;
    } else {
        self.backgroundColor = RGB(224, 224, 224);
    }
}

@end
