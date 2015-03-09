//
//  UserProfileView.m
//  shuiguoshe
//
//  Created by tangwei1 on 15-2-10.
//  Copyright (c) 2015年 shuiguoshe. All rights reserved.
//

#import "UserProfileView.h"

@interface UserProfileView () <UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@end

@implementation UserProfileView
{
    UIImageView* _backgroundView;
    UIImageView* _avatarView;
    UILabel*     _nameLabel;
    UILabel*     _scoreLabel;
    
    UIImagePickerController* _imagePickerController;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if ( self = [super initWithFrame:frame] ) {
        _backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"user_bg.png"]];
        [self addSubview:_backgroundView];
        [_backgroundView release];
        [_backgroundView sizeToFit];
        
        CGFloat factor = CGRectGetWidth(mainScreenBounds) / 320;
        
        self.frame = CGRectMake(0, 0, CGRectGetWidth(mainScreenBounds),
                                CGRectGetHeight(_backgroundView.bounds) * factor);
        _backgroundView.frame = self.bounds;
        
        _avatarView = [[[UIImageView alloc] init] autorelease];
        [self addSubview:_avatarView];
        
        _avatarView.bounds = CGRectMake(0, 0, 89 * factor, 89 * factor);
        _avatarView.layer.cornerRadius = CGRectGetWidth(_avatarView.bounds) * 0.5;
        _avatarView.layer.borderWidth = 5;
        _avatarView.layer.borderColor = [[UIColor whiteColor] CGColor];
        _avatarView.clipsToBounds = YES;
        
        _avatarView.center = CGPointMake(CGRectGetMidX(self.bounds),
                                         CGRectGetMidY(self.bounds));
        
        UIButton* blankButton = createButton(nil, self, @selector(updateAvatar));
        [self addSubview:blankButton];
        blankButton.frame = _avatarView.frame;
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_avatarView.frame) + 5, CGRectGetWidth(mainScreenBounds), 30)];
        [self addSubview:_nameLabel];
        [_nameLabel release];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        
        _scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameLabel.frame), CGRectGetWidth(mainScreenBounds), 30)];
        [self addSubview:_scoreLabel];
        [_scoreLabel release];
        _scoreLabel.backgroundColor = [UIColor clearColor];
        _scoreLabel.textColor = [UIColor whiteColor];
        _scoreLabel.font = [UIFont boldSystemFontOfSize:14];
        _scoreLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

- (void)updateAvatar
{
    UIActionSheet* actionSheet = [[[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册选择", nil] autorelease];
    [actionSheet showInView:self.imagePickerContainer.view];
}

- (void)setUser:(User *)aUser
{
    [_avatarView setImageWithURL:[NSURL URLWithString:aUser.avatarUrl] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    _nameLabel.text = [aUser.name stringByReplacingCharactersInRange:
                                                          NSMakeRange(3, 4)
                                                          withString:@"****"];
    
    _scoreLabel.text = [NSString stringWithFormat:@"您目前拥有的积分是：%ld", aUser.score];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self takePhoto];
            break;
        case 1:
            [self choosePhotoFromAlbum];
            break;
            
        default:
            break;
    }
}

- (void)dealloc
{
    [_imagePickerController release];
    [super dealloc];
}

- (UIImagePickerController *)imagePickerController
{
    if ( !_imagePickerController ) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        _imagePickerController.delegate = self;
        _imagePickerController.allowsEditing = YES;
    }
    
    return _imagePickerController;
}

- (void)takePhoto
{
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.imagePickerContainer presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)choosePhotoFromAlbum
{
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum] ) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self.imagePickerContainer presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* sourceImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [self imagePickerControllerDidCancel:picker];
    
    [[UserService sharedService] uploadAvatar:sourceImage completion:^(BOOL succeed) {
        if ( succeed ) {
            _avatarView.image = sourceImage;
        }
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
