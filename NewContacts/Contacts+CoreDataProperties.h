//
//  Contacts+CoreDataProperties.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/30.
//  Copyright © 2018年 aduning. All rights reserved.
//
//

#import "Contacts+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Contacts (CoreDataProperties)

+ (NSFetchRequest<Contacts *> *)fetchRequest;

@property (nonatomic) int32_t id;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *number;
@property (nonatomic) BOOL hasHeadImg;

@end

NS_ASSUME_NONNULL_END
