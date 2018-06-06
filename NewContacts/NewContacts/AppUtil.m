//
//  AppUtil.m
//  NewContacts
//  工具类
//  Created by 宁玉文 on 2018/5/24.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "AppUtil.h"
#import "AppDelegate.h"
#import <ContactsUI/ContactsUI.h>

@implementation AppUtil

// 由于coredata不能方便的实现primary key，所以此处存储一个相当于sharedpreference的int值，用于保存当前ID最大值，用于新建联系人时添加ID字段
+ (NSInteger )ID{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    NSInteger integer = [userDef integerForKey:@"maxID"];
    return integer;
}

+ (void)setID{
    NSInteger integer = [self ID];
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setInteger:(integer + 1) forKey:@"maxID"];
    [userDef synchronize];
}

// 修改联系人,修改的是coredata中的数据
+ (void)updateContact:(Contacts *)contact{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //找到联系人
    NSMutableArray *array = [self findContactInCoreData:contact delegate:delegate];
    for (Contacts *con in array) {
        if (con.id == contact.id) {
            con.name = contact.name;
            con.number = contact.number;
        }
        [delegate.persistentContainer.viewContext updatedObjects];
    }
    [delegate saveContext];
}

// 因为删除、修改联系人都需要先在coredata中找到此联系人，所以提取成一个函数
+ (NSMutableArray *)findContactInCoreData:(Contacts *)contact delegate:(AppDelegate *)delegate{
    /** 查询要删除带有输入的关键字的对象 */
    NSPredicate * pre = [NSPredicate predicateWithFormat:@"id == %i", (int32_t)contact.id];
    
    /** 根据上下文获取查询数据库实体的请求参数---要查询的entity(实体) */
    NSEntityDescription * des = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:delegate.persistentContainer.viewContext];
    
    /** 查询请求 */
    NSFetchRequest * request = [NSFetchRequest new];
    
    /** 根据参数获取查询内容 */
    request.entity = des;
    request.predicate = pre;
    
    /**
     1.获取所有被管理对象的实体---根据查询请求取出实体内容
     2.获取的查询内容是数组
     3.删掉所有查询到的内容
     3.1.这里是模糊查询 即 删除包含要查询内容的字母的内容
     */
    NSMutableArray *array = [NSMutableArray arrayWithArray:[delegate.persistentContainer.viewContext executeFetchRequest:request error:NULL]];
    return array;
}

// 获取所有联系人信息
+ (NSMutableArray *)loadContactsData{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    mutableArray = [NSMutableArray arrayWithArray:[appDelegate.persistentContainer.viewContext executeFetchRequest:request error:nil]];
    return mutableArray;
}

// 删除联系人，传入contact
+ (void)deleteContact:(Contacts *)contact{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //找到联系人
    NSMutableArray *array = [self findContactInCoreData:contact delegate:delegate];
    
    /** 对查询的内容进行操作 */
    for (Contacts *c in array) {
        [delegate.persistentContainer.viewContext deleteObject:c];
    }
    NSLog(@"删除完成");
    [delegate saveContext];
}

// 搜索数据，根据输入的文字，直接从内存中查找，不再从coredata中查找
+ (NSMutableArray *)searchContact:(NSString *)string{
    AppDelegate * delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSMutableArray *array = [NSMutableArray new];
    for (Contacts *con in delegate.contactData.contactDataArray) {
        // name 或 手机号满足一个就行
        if ([con.name containsString:string] || [con.number containsString:string]) {
            [array addObject:con];
        }
    }
//    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contacts"];
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"name CONTAINS %@", string];
//    request.predicate = pre;
//    request.fetchOffset = 0;
//    NSMutableArray *array = [NSMutableArray arrayWithArray:[delegate.persistentContainer.viewContext executeFetchRequest:request error:nil]];
    return array;
}

// 获取头像，根据用户id
+ (UIImage *)getImage:(Contacts *)contact{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%i.png", contact.id]];
    // 保存文件的名称
    UIImage *img = [UIImage imageWithContentsOfFile:filePath];
    NSLog(@"=== %@", img);
    if (img == nil) {
        img = [UIImage imageNamed:@"black.png"];
    }
    return img;
}

// 点击拨打电话按钮,暂时跳转页面，将电话号码信息传递过去
+ (void)callTelPhone:(Contacts *)contact viewController:(UIViewController *)viewController{
    NSLog(@"拨打电话 %@ ", [contact number]);
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel://%@", contact.number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:nil completionHandler:^(BOOL success){
        
    }];
    
    
//    //    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel://10086"];
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"拨打电话" message:contact.number preferredStyle:UIAlertControllerStyleAlert];
//
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
//
//    }];
//    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:nil completionHandler:^(BOOL success){
//
//        }];
//    }];
//    [alertController addAction:cancelAction];
//    [alertController addAction:otherAction];
//    [viewController presentViewController:alertController animated:YES completion:nil];
}

// 更新contact数据，根据id来查找
//+ (void)updateContact:(Contacts *)contact{
//    NSInteger ID = contact.id;
//    // 查询语句
//    NSPredicate *pre = [NSPredicate predicateWithFormat:@"id contains %ld", ID];
//
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Contacts" inManagedObjectContext:delegate.persistentContainer.viewContext];
//    NSFetchRequest *request = [[NSFetchRequest alloc] init];
//    request.entity = entity;
//    request.predicate = pre;
//
//    NSArray *array = [delegate.persistentContainer.viewContext executeFetchRequest:request error:nil];
//    for (Contacts *con in array) {
//        con.name = contact.name;
//        con.number = contact.number;
//        [delegate.persistentContainer.viewContext updatedObjects];
//    }
//    [delegate saveContext];
//}

+ (void)getCurrentDate{
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss:SSS"];
    NSString *date =  [formatter stringFromDate:[NSDate date]];
    NSString *timeLocal = [[NSString alloc] initWithFormat:@"%@", date];
    NSLog(@"%@", timeLocal);
    
}

// 保存图片
+ (void)saveImage:(UIImage *)image userId:(int32_t) userId{
    NSLog(@"saveImageFirst");
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    
    NSLog(@"saveImageFirst2");
    
    NSString *filePath = [[paths objectAtIndex:0]stringByAppendingPathComponent:
                          [NSString stringWithFormat:@"%i.png", userId]];  // 保存文件的名称
    
    NSLog(@"saveImageFirst3");
    
    BOOL result =[UIImagePNGRepresentation(image)writeToFile:filePath   atomically:YES]; // 保存成功会返回YES
    
    NSLog(@"saveImageFirst4");
    
    if (result == YES) {
        NSLog(@"保存成功");
    }
    
    NSLog(@"saveImageLast");
}

// 获取通讯录所有联系人信息
#pragma mark - Contacts
+ (NSMutableArray *)getContactsFromContactsAll {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    CNContactStore *store = [[CNContactStore alloc] init];
    __block NSMutableArray *contactModels = [NSMutableArray array];
    
    if (status == CNAuthorizationStatusNotDetermined) { // 用户还没有决定是否授权你的程序进行访问
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                contactModels = [self getContactsInfo:store];
            } else {
                NSLog(@"error1");
            }
        }];
        // 用户已拒绝 或 iOS设备上的家长控制或其它一些许可配置阻止程序与通讯录数据库进行交互
    } else if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
        NSLog(@"error");
    } else if (status == CNAuthorizationStatusAuthorized) { // 用户已授权
        contactModels = [self getContactsInfo:store];
    }
    
    return contactModels;
}

+ (NSMutableArray *)getContactsInfo:(CNContactStore *)store {
    NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    NSMutableArray *contactModels = [NSMutableArray array];
    
    [store enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        NSString *name = [NSString stringWithFormat:@"%@%@", contact.familyName == NULL ? @"" : contact.familyName, contact.givenName == NULL ? @"" : contact.givenName];
        NSLog(@"姓名: %@", name);
        
        for (CNLabeledValue *labeledValue in contact.phoneNumbers) {
            CNPhoneNumber *phoneNumber = labeledValue.value;
            NSLog(@"电话号码: %@", phoneNumber.stringValue);
            
        }
    }];
    
    return contactModels;
}

// 新增联系人,id读取出来加1,参数为姓名，号码，头像
+ (void)insertName:(NSString *)name andNumber:(NSString *)number headImage:(UIImage *)image{
    NSInteger maxID = [AppUtil ID];
    [AppUtil setID];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    ///此代码等价于 ==  类的 alloc init
    Contacts *contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contacts" inManagedObjectContext:appDelegate.persistentContainer.viewContext];
    
    // 赋值
    contact.id = (int32_t)(maxID + 1);
    contact.name = name;
    contact.number = number;
    
    // 保存图片
    [AppUtil saveImage:image userId:contact.id];
    NSLog(@"插入成功");
    // 修改的是CoreData中的数据
    [appDelegate saveContext];
    
    // 修改的是内存缓存中的数据，这样可以避免重新读取CoreData中的数据
    [appDelegate.contactData.contactDataArray addObject:contact];
}

@end
