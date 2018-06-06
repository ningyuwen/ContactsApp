//
//  AddOrEditContactsInfoViewController.m
//  Contacts
//
//  Created by 宁玉文 on 2018/5/22.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "AddOrEditContactsInfoViewController.h"
#import "AddOrEditContactsView.h"
#import "Contacts+CoreDataClass.h"
#import "Contacts+CoreDataProperties.h"
#import "AppDelegate.h"
#import "AppUtil.h"
#import "ShowContactViewController.h"
#import "Toast.h"
#import "ViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "PictureChooseViewController.h"
#import "CollectionViewController.h"


@interface AddOrEditContactsInfoViewController ()<AddOrEditContactsDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

- (void)addLeftItem;
- (void)addRightItem;
- (void)addAddOrEditContactsView;

- (void)updateContact:(Contacts *)contact;

// 判断联系人是否存在
- (Contacts *)existOfUserName:(NSString *)name;

@property (nonatomic, strong) AddOrEditContactsView *addOrEditContactsView;

@end

@implementation AddOrEditContactsInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.title = @"New Contact";
//    [self addScrollView];
    [self addLeftItem];
    [self addRightItem];
    [self addAddOrEditContactsView];
//    [self addButton];
    
    //注册广播接收器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getEmployeeImgSuccess:) name:@"getEmployeeImgSuccess" object:nil];
}

// 选择了员工头像
- (void)getEmployeeImgSuccess:(NSNotification *)notification{
    NSDictionary *info = [notification object];
    NSString *name = [info objectForKey:@"employeeName"];
    [_addOrEditContactsView replaceImage:[UIImage imageNamed:((void)((@"%@.png")), name)]];
}

- (void)addScrollView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [self.view addSubview:scrollView];
}

- (void)addButton{
    UIButton *btn = [[UIButton alloc] init];
    [btn setFrame:CGRectMake(100, 200, 100, 60)];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)addAddOrEditContactsView{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    [scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height + 160)];
    
    _addOrEditContactsView = [[AddOrEditContactsView alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    _addOrEditContactsView.contact = self.contact;
    _addOrEditContactsView.delegate = self;
    [_addOrEditContactsView initUIView];
    [scrollView addSubview:_addOrEditContactsView];
    [self.view addSubview:scrollView];
}

//接收view层传过来的Name和TelNumber,进行存储,存储到数据库
- (void)pushName:(NSString *)name andTelNumber:(NSString *)telNumber headImage:(UIImage *)image{
    NSLog(@"pushName %@ %@", name, telNumber);
    
    //插入数据之前要对数据格式做判断，名字中不能出现数字，特殊符号
    //电话中不能出现中文字符
    if ([self nameIsRight:name numberIsRight:telNumber] == NO) {
        //弹窗提示
        NSLog(@"姓名或手机号码格式不正确");
        [[Toast makeText:@"姓名不能为空"] show];
        return;
    }
    
    // 新建联系人时需要： 检查联系人姓名是否已存在，如果存在，则弹窗提示用户是否覆盖，点击否，则取消弹窗，是，则更新数据
    Contacts *contact = [self existOfUserName:name];
    // 不为-1则存在
    if (contact != NULL) {
        // 存在
        // 封装contact对象，更新联系人数据
        [contact setName:name];
        [contact setNumber:telNumber];
        
        [self addDialogShowUserExist:contact isEdit:NO];
        return;
    }
    
    //插入数据
//    [DB insertContactWithName:name userNumber:telNumber];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [self insertName:name andNumber:telNumber headImage:image];
        [AppUtil insertName:name andNumber:telNumber headImage:image];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 返回主线程
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRootView" object:nil];
        });
    });
//    [NSThread detachNewThreadWithBlock:^{
//        [self insertName:name andNumber:telNumber headImage:image];
//        // 执行完毕回调，通知页面刷新
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRootView" object:nil];
//    }];
    
    
//    [self insertName:name andNumber:telNumber headImage:image];
    
    //finish
    [self.navigationController popViewControllerAnimated:true];
    [self backToRootView];
}

- (BOOL)nameIsRight:(NSString *)name numberIsRight:(NSString *)number{
    if ([name isEqualToString:@""]) {
        return NO;
    }
//    NSString *mobile = @"^1[1-9]\\d{9}$";
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
//    return [regextestmobile evaluateWithObject:number];
    return YES;
}

//添加左边取消按钮
- (void)addLeftItem{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

//添加右边确认按钮
- (void)addRightItem{
    UIBarButtonItem *rightItem = nil;
    rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
    rightItem.tintColor = [UIColor blueColor];
    self.navigationItem.rightBarButtonItem = rightItem;
}

//取消按钮，返回
- (void)cancel:(UIButton *)button{
    NSLog(@"cancel");
    
    [self.navigationController popViewControllerAnimated:false];
}

//done，需要保存数据
- (void)done:(UIButton *)button{
    NSLog(@"done");
    NSLog(@"0");
    [AppUtil getCurrentDate];
    
    // 为空，则是添加联系人，不为空，则是编辑联系人
    if (_contact == nil) {
        // 新建
        [_addOrEditContactsView needNameAndTelNumber];
    }else{
        // 编辑
        [self edit:button];
    }
    
    NSLog(@"4");
    [AppUtil getCurrentDate];
}

// 编辑完成
- (void)edit:(UIButton *)button{
//    NSLog(@"edit");
    
    _contact = [_addOrEditContactsView needContact];
    
    // 检查姓名是否为空
    if ([self nameIsRight:_contact.name numberIsRight:_contact.number] == NO) {
        //弹窗提示
//        NSLog(@"姓名或手机号码格式不正确");
        [[Toast makeText:@"姓名不能为空"] show];
        return;
    }
    
    // 新建联系人时需要： 检查联系人姓名是否已存在，如果存在，则弹窗提示用户是否覆盖，点击否，则取消弹窗，是，则更新数据
    Contacts *contact = [self existOfUserNameFromEdit:_contact];
    // 不为-1则存在
    if (contact != NULL) {
        // 存在
        // 封装contact对象，更新联系人数据
        [contact setNumber:_contact.number];
        
        [self addDialogShowUserExist:contact isEdit:YES];
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 编辑功能，替换联系人时，返回到上一页面，需要刷新ShowContactViewController页面
        // 替换之前的联系人信息
        [self updateContact:self->_contact];
        dispatch_async(dispatch_get_main_queue(), ^{
            // 执行完毕回调，通知页面刷新
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshShowContactView" object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRootView" object:self];
        });
    });
    
    // 返回上一页面
    ShowContactViewController *controller = (ShowContactViewController *)[self.navigationController.viewControllers objectAtIndex:(self.navigationController.viewControllers.count - 2)];
    controller.contact = _contact;
    [self.navigationController popToViewController:controller animated:YES];
}

// 弹窗告诉用户联系人已存在，是否是编辑，编辑用户信息出现的姓名重复，需要删除之前的那个用户信息
- (void)addDialogShowUserExist:(Contacts *)contact isEdit:(BOOL)isEdit{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"联系人已存在，是否覆盖" message:contact.name preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            // 覆盖联系人信息，调用刷新函数
            // 更新数据
            [self updateContact:contact];
            if (isEdit) {
                //删除编辑之前的那个用户的信息
                [AppUtil deleteContact:self->_contact];
                AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
                [delegate.contactData.contactDataArray removeObject:self->_contact];
                self->_contact = contact;
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // 执行完毕回调，通知页面刷新
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRootView" object:self];
//            });
        });
        
        [self backToRootView];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

// 检查联系人姓名是否已存在
- (Contacts *)existOfUserName:(NSString *)name{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (Contacts *con in delegate.contactData.contactDataArray) {
        if ([con.name isEqualToString:name]) {
            return con;
        }
    }
    // 没有则返回-1
    return NULL;
}

// 编辑联系人，确认之后，需要判断联系人姓名是否已存在，首先要排除自己
- (Contacts *)existOfUserNameFromEdit:(Contacts *)contact{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (Contacts *con in delegate.contactData.contactDataArray) {
        if (con.id == contact.id) {
            // 这是自己，不做判断
            continue;
        }
        if ([con.name isEqualToString:contact.name]) {
            //编辑成功时，找到另一个姓名相同的联系人
            return con;
        }
    }
    // 没有则返回-1
    return NULL;
}

// 更新联系人信息，根据id替换之前的数据
- (void)updateContact:(Contacts *)contact{
    // 更新联系人
    [AppUtil updateContact:contact];
    
    // 图片,先去view获取,保存图片花费时间太长
    [AppUtil saveImage:[self->_addOrEditContactsView getUserHeadImg] userId:contact.id];
    
    // 内存
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    for (int i = 0; i < delegate.contactData.contactDataArray.count; i++) {
        Contacts *con = [delegate.contactData.contactDataArray objectAtIndex:i];
        if (con.id == contact.id) {
            [delegate.contactData.contactDataArray replaceObjectAtIndex:i withObject:contact];
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 回退到根view
- (void)backToRootView{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// 删除联系人
- (void)deleteContact:(Contacts *)contact{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //删除coredata中的
        [AppUtil deleteContact:self->_contact];
        NSLog(@"删除联系人成功");
        [[Toast makeText:@"删除联系人成功"] show];
        //删除内存缓存中的
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate.contactData.contactDataArray removeObject:self->_contact];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 返回主线程
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshRootView" object:nil];
        });
    });
}

- (void)chooseImage:(UIButton *)button{
    //弹出系统相册
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    
    //设置照片来源
    pickVC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}

// 选择系统图片之后
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //获得编辑过的图片
    UIImage* photo = [info objectForKey:UIImagePickerControllerEditedImage];
    [self dismissModalViewControllerAnimated:YES];
    
    NSLog(@"size: %f  %f", photo.size.width, photo.size.height);
    
    
//    NSURL *url = [info objectForKey:UIImagePickerControllerReferenceURL];
//    NSLog(@"url:  %@", url);
    
    
    
    
//    UIImage *photo = info[UIImagePickerControllerOriginalImage];
    
    [_addOrEditContactsView replaceImage:photo];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    NSMutableDictionary * dict= [NSMutableDictionary dictionaryWithDictionary:editingInfo];
    [dict setObject:image forKey:UIImagePickerControllerEditedImage];
    //直接调用3.x的处理函数
    [self imagePickerController:picker didFinishPickingMediaWithInfo:dict];
}

- (void)backToLastView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//- (void)jumpToUIImagePickerController{
//    [self presentViewController:pickVC animated:YES completion:nil];
//}

// 改为从相册选择或者跳转默认图片页面
- (void)chooseImage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"选择从以下位置选择图片" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self chooseImageFromSystem];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];  //返回之前的界面
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)chooseImageFromSystem{
    //弹出系统相册
    UIImagePickerController *pickVC = [[UIImagePickerController alloc] init];
    
    //设置照片来源
    pickVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickVC.allowsEditing = YES;
    pickVC.allowsImageEditing = YES;
    pickVC.delegate = self;
    [self presentViewController:pickVC animated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
