//
//  ContactData.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/29.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactData : NSObject

// 存储Core Data中的所有联系人数据，
@property (nonatomic, strong) NSMutableArray *contactDataArray;

@end
