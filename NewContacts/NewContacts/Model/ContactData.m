//
//  ContactData.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/29.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "ContactData.h"
#import "AppUtil.h"
#import "AppDelegate.h"

@interface ContactData()

- (void)setDataFromCoreData;

@end

@implementation ContactData

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setDataFromCoreData];
    }
    return self;
}

// 加载全部数据到全局变量 _contactDataArray 中,其他viewController都从此处获取数据

// AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
// array = delegate.contactData.contactDataArray;
- (void)setDataFromCoreData{
    _contactDataArray = [AppUtil loadContactsData];
}

@end
