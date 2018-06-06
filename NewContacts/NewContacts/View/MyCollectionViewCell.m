//
//  MyCollectionViewCell.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/6/5.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 头像
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 2, 180)];
        [self.contentView addSubview:_headImageView];
        
        // 姓名
        _userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 160, [UIScreen mainScreen].bounds.size.width / 2, 20)];
        [_userNameLabel setCenter:_userNameLabel.center];
        [_userNameLabel setTextColor:[UIColor whiteColor]];
        [_userNameLabel setFont:[UIFont systemFontOfSize:15]];
        [self.contentView addSubview:_userNameLabel];
    }
    return self;
}

@end
