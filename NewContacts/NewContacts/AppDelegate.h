//
//  AppDelegate.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/23.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ContactData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

- (void)saveContext;

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

// ContactData全局变量
@property (nonatomic, strong) ContactData *contactData;

@end

