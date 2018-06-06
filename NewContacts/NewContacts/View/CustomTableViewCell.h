//
//  CustomTableViewCell.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/6/1.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts+CoreDataClass.h"

// cell的高度
static int _cellHeight = 60;

@protocol CustomTableViewCellDelegate <NSObject>

- (void)callTelPhone:(Contacts *)contact;

@end

@interface CustomTableViewCell : UITableViewCell

@property (nonatomic, weak) Contacts *contact;

@property (nonatomic, weak) id<CustomTableViewCellDelegate> delegate;

- (void)initViewCell;

@end
