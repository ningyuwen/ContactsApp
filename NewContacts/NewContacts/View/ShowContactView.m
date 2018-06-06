//
//  ShowContactView.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/24.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "ShowContactView.h"
#import "AppUtil.h"

@interface ShowContactView()

- (void)addUILabelContactName;
- (void)addUILabelContactNumber;

@property (nonatomic, retain) UILabel *nameLabel;
@property (nonatomic, retain) UILabel *numberLabel;
@property (nonatomic, strong) UIImageView *userHeadImgView;

@end

@implementation ShowContactView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    return [super initWithFrame:frame];
}

- (void)initUIView{
    [self addUILabelContactName];
    [self addUILabelContactNumber];
    [self addUserHeadImgView];
}

- (void)addUILabelContactName{
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"姓名"];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [label setFrame:CGRectMake(50, 260, [[UIScreen mainScreen] bounds].size.width - 100, 30)];
    [self addSubview:label];
    
    _nameLabel = [[UILabel alloc] init];
    [_nameLabel setFrame:CGRectMake(50, 270, [[UIScreen mainScreen] bounds].size.width - 100, 60)];
    [_nameLabel setText:_contact.name];
    [_nameLabel setTextColor:[UIColor blueColor]];
    [self addSubview:_nameLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 320, [[UIScreen mainScreen] bounds].size.width - 100, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
}

- (void)addUILabelContactNumber{
    UILabel *label = [[UILabel alloc] init];
    [label setText:@"号码"];
    [label setFont:[UIFont systemFontOfSize:12.0]];
    [label setFrame:CGRectMake(50, 340, [[UIScreen mainScreen] bounds].size.width - 100, 30)];
    [self addSubview:label];
    
    _numberLabel = [[UILabel alloc] init];
    [_numberLabel setFrame:CGRectMake(50, 350, [[UIScreen mainScreen] bounds].size.width - 100, 60)];
    [_numberLabel setText:_contact.number];
    [_numberLabel setTextColor:[UIColor blueColor]];
    [self addSubview:_numberLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(50, 400, [[UIScreen mainScreen] bounds].size.width - 100, 0.5)];
    lineView.backgroundColor = [UIColor grayColor];
    [self addSubview:lineView];
}

- (void)refreshView{
    _nameLabel.text = _contact.name;
    _numberLabel.text = _contact.number;
    [_userHeadImgView setImage:[AppUtil getImage:_contact]];
}

// 添加用户头像
- (void)addUserHeadImgView{
    _userHeadImgView = [[UIImageView alloc] init];
    [_userHeadImgView setFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width / 2 - 60, 120, 120, 120)];
    _userHeadImgView.layer.cornerRadius = _userHeadImgView.frame.size.width / 2;
    _userHeadImgView.layer.masksToBounds = YES;
    [_userHeadImgView.layer setBorderWidth:0.5];
    [_userHeadImgView.layer setBorderColor:[[UIColor grayColor] CGColor]];
    UIImage *img = [AppUtil getImage:_contact];
    [_userHeadImgView setImage:img];
    [self addSubview:_userHeadImgView];
}

@end
