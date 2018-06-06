//
//  ShowContactView.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/24.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts+CoreDataClass.h"

@interface ShowContactView : UIView

// 查看页面的联系人信息
@property (nonatomic, assign) Contacts *contact;

- (void)initUIView;

- (void)refreshView;

@end
