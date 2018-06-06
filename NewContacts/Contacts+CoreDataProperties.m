//
//  Contacts+CoreDataProperties.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/30.
//  Copyright © 2018年 aduning. All rights reserved.
//
//

#import "Contacts+CoreDataProperties.h"

@implementation Contacts (CoreDataProperties)

+ (NSFetchRequest<Contacts *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"Contacts"];
}

@dynamic id;
@dynamic name;
@dynamic number;
@dynamic hasHeadImg;

@end
