//
//  ViewController.m
//  Contacts
//
//  Created by 宁玉文 on 2018/5/22.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "ViewController.h"
#import "AddOrEditContactsInfoViewController.h"
#import "Contacts+CoreDataClass.h"
#import "Contacts+CoreDataProperties.h"
#import "MainTableView.h"
#import "CallPhoneViewController.h"
#import "ShowContactViewController.h"
#import "SearchViewController.h"
#import "AppUtil.h"
#import "UIImage+TextToImage.h"
#import "CollectionViewController.h"
//#import <ContactsUI/ContactsUI.h>
@import Contacts;
@import ContactsUI;
#import "UIImage+TextToImage.h"
#import "Toast.h"

@interface ViewController () <MainAcitivityViewDelegate, MainTableViewDelegate, CNContactPickerDelegate>

- (void)receiveNotificationToRefreshView:(NSNotification *)notification;

@property (nonatomic, strong, nullable) MainActivityView *mainView;
@property (nonatomic, strong) UIButton *button;

@end

@implementation ViewController

// 接收通知刷新页面
- (void)receiveNotificationToRefreshView:(NSNotification *)notification{
    [self.mainView reloadTableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _mainView = [[MainActivityView alloc]init];
    [_mainView setFrame:self.view.frame];
    self.view = _mainView;
    _mainView.delegate = self;

    [self initAddContactsBtn];
    [self initGetPhoneContactsBtn];

    //注册广播接收器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNotificationToRefreshView:) name:@"refreshRootView" object:nil];
    
}

// 初始化添加按钮
- (void)initAddContactsBtn{
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addContactsBtn:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

// 获取手机通讯录中的联系人按钮
- (void)initGetPhoneContactsBtn{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(addGetPhoneContactsBtn:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

// 添加系统通讯录联系人按钮
- (void)addGetPhoneContactsBtn:(UIButton *)button{
    // 弹窗，提示用户是否导入系统联系人数据
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否导入系统联系人数据?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self chooseContacts];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addContactsBtn:(UIButton *)button{
    NSLog(@"添加联系人信息");
    
    AddOrEditContactsInfoViewController *addOrEditContactsInfoVC = [[AddOrEditContactsInfoViewController alloc]init];
    addOrEditContactsInfoVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:addOrEditContactsInfoVC animated:YES];
    
}

- (void)chooseContacts{
//    NSMutableArray *array = [AppUtil getContactsFromContactsAll];

    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"点击同意");
                [self openContact];
            }else{
                NSLog(@"点击拒绝");
            }
        }];
    } else if (status == CNAuthorizationStatusAuthorized) {
        NSLog(@"已经授权");
        [self openContact];
    } else {
        NSLog(@"没有授权");
        UIAlertController *alert =[UIAlertController alertControllerWithTitle:@"We Need Permission To Access Your Contacts"
                                                                      message:@"Settings on iphone >Privacy>Photos>seagullstudio" preferredStyle:UIAlertControllerStyleAlert];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];
        
        [alert addAction:[UIAlertAction actionWithTitle:@"Setting" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{UIApplicationOpenSettingsURLString:@YES} completionHandler:^(BOOL success) {
                if (success) {
                    // NSLog(@"成功打开");
                } else {
                    // NSLog(@"打开失败");
                }
            }];
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

// 打开系统通讯录页面
- (void)openContact {
//    CNContactViewController *
    
    CNContactPickerViewController *contactVC = [CNContactPickerViewController new];
//    CNContactViewController *contactVC = [CNContactViewController new];
    contactVC.delegate = self;
    [self presentViewController:contactVC animated:YES completion:nil];
}

// 点击的其中的条目，实现跳转
- (void)clickItem:(Contacts *)contact{
    ShowContactViewController *controller = [[ShowContactViewController alloc] init];
    controller.contact = contact;
    controller.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)callTelPhone:(Contacts *)contact{
    [AppUtil callTelPhone:contact viewController:self];
}

// 跳转搜索页面
- (void)enterSearchViewController{
    SearchViewController *controller = [[SearchViewController alloc] init];
    controller.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:controller animated:NO];
}


//选择单个联系人，不展开联系人的详细信息，获取后推出CNContactPickerViewController
//- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
//    [self parseAddressWithContact:contact];
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}

#pragma mark - 选中多个联系人
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts{

    NSLog(@"contactscontacts:%@",contacts);
    // 选中多个联系人，如果有重复的联系人存在于数据库中，则直接覆盖
    // 插入数据
    //    [DB insertContactWithName:name userNumber:telNumber];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        for (CNContact *contact in contacts) {
            [self saveContact:contact delegate:delegate];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            // 返回主线程
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRootView" object:nil];
        });
    });
}

// 保存从系统通讯录获取的联系人信息
-  (void)saveContact:(CNContact *)contact delegate:(AppDelegate *)delegate {
    // 姓名
    NSString *userName = [contact.familyName stringByAppendingString:contact.givenName];
    // 号码
    NSString *phoneNumber = @"";
    NSArray<CNLabeledValue *> *phoneArray = contact.phoneNumbers;
    for (CNLabeledValue *phoneElement in phoneArray) {
        CNPhoneNumber *phone = phoneElement.value;
        NSLog(@"phone: %@ ", phone.stringValue);
        phoneNumber = phone.stringValue;
        break;
    }
    
    // 需要判断用户名是否存在，如果存在则直接覆盖
    if ([@"" isEqualToString:userName]) {
        return;
    }
    
    for (Contacts *con in delegate.contactData.contactDataArray) {
        if ([con.name isEqualToString:userName]) {
            // 姓名出现重复的，覆盖，做法依然是删除之前的，修改内存中的数据
            con.number = phoneNumber;       //
            // 为了简单起见，这里只取了第一个号码作为用户的手机号
            UIImage *image = [[UIImage imageFormColor:[UIColor colorWithRed:40.0/255 green:43.0/255 blue:53.0/255 alpha:1.0] frame:CGRectMake(0, 0, 120, 120)] imageWithTitle:[userName substringToIndex:1] fontSize:36.0];
            // 修改coredata中的数据
            [AppUtil updateContact:con];
            // 保存图片
            [AppUtil saveImage:image userId:con.id];
            return;
        }
    }
    
    // 为了简单起见，这里只取了第一个号码作为用户的手机号
    UIImage *image = [[UIImage imageFormColor:[UIColor colorWithRed:40.0/255 green:43.0/255 blue:53.0/255 alpha:1.0] frame:CGRectMake(0, 0, 120, 120)] imageWithTitle:[userName substringToIndex:1] fontSize:36.0];
    [AppUtil insertName:userName andNumber:phoneNumber headImage:image];
}
//取消选择的回调
- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
