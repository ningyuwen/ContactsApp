//
//  CustomTableViewCell.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/6/1.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "CustomTableViewCell.h"
#import "AppUtil.h"
#import <objc/runtime.h>

@interface CustomTableViewCell(){
    
}

@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UIButton *callButton;

@end

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconView = [[UIImageView alloc] init];
        [_iconView setFrame:CGRectMake(10, 5, _cellHeight - 10, _cellHeight - 10)];
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = (_cellHeight - 10) / 2.0f;
        [_iconView.layer setBorderWidth:0.5];
        [_iconView.layer setBorderColor:[[UIColor grayColor] CGColor]];
        [self addSubview:_iconView];
        
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setFrame:CGRectMake(_cellHeight + 10, 5, self.layer.frame.size.width, _cellHeight / 2.0)];
        _nameLabel.font = [UIFont systemFontOfSize: 22.0];
        [self addSubview:_nameLabel];
        
        _numberLabel = [[UILabel alloc] init];
        [_numberLabel setFrame:CGRectMake(_cellHeight + 10, _cellHeight / 2.0 - 3, self.layer.frame.size.width, _cellHeight / 2.0)];
        _numberLabel.font = [UIFont systemFontOfSize: 14.0];
        [_numberLabel setTextColor:[UIColor grayColor]];
        [self addSubview:_numberLabel];
        
        _callButton = [[UIButton alloc] init];
        [_callButton setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 15, 46, _cellHeight - 30)];
//        [_callButton setTitle:@"CALL" forState:UIControlStateNormal];
        [_callButton setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
//        _callButton.layer.masksToBounds = YES;
//        [_callButton.layer setCornerRadius:_callButton.layer.frame.size.width / 2.0];
        [self addSubview:_callButton];
    }
    return self;
}

- (void)callTelPhoneButton:(UIButton *)button{
    [self.delegate callTelPhone:objc_getAssociatedObject(button, @"call_contact")];
}
  
- (void)initViewCell{
    // 图片
    UIImage *img = [AppUtil getImage:_contact];
    [_iconView setImage:img];
    
    // name
    [_nameLabel setText:((void)(@"%@"), _contact.name)];
    
    // number
    [_numberLabel setText:((void)(@"%@"), _contact.number)];
    
    objc_setAssociatedObject(_callButton, @"call_contact", _contact, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [_callButton addTarget:self action:@selector(callTelPhoneButton:) forControlEvents:UIControlEventTouchUpInside];
}

@end
