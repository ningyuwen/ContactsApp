//
//  SearchTableView.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/25.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "SearchTableView.h"
#import <objc/runtime.h>
#import "AppUtil.h"
#import "AppDelegate.h"
#import "CustomTableViewCell.h"

@interface SearchTableView() <UITableViewDelegate, UITableViewDataSource, CustomTableViewCellDelegate>

- (void)loadData;

@end

@implementation SearchTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadData];
        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

// 加载数据
- (void)loadData{
    _tableViewData = nil;
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tableViewData = delegate.contactData.contactDataArray;
//    // 需要对联系人按照姓氏拼音排序
//    for (Contacts *contact in self.tableViewData) {
//        NSLog(@"%d, %@, %@", contact.id, contact.name, contact.number);
//    }
}

// 设置数据，在controller传入
- (void)setData:(NSString *)string{
//    self.tableViewData = nil;
//    NSMutableArray *resultArray = [AppUtil searchContact:string];
    _tableViewData = nil;
}

//- (NSInteger)numberOfRowsInSection:(NSInteger)section{
////    if (self.tableViewData == nil) {
////        return 0;
////    }
////    return [self.tableViewData count];
//
//    return 5;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_tableViewData count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cell";
    CustomTableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    cell.contact = [_tableViewData objectAtIndex:indexPath.row];
    [cell initViewCell];
    return cell;
    
    
//    UITableViewCell *tableViewCell = [self dequeueReusableCellWithIdentifier:cellID];
//    if (tableViewCell == nil) {
//        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];;
//    }
//    Contacts *contact = [_tableViewData objectAtIndex:indexPath.row];
//
//    // 将单元格的边框设置为圆角
//    tableViewCell.layer.cornerRadius = 12;
//    tableViewCell.layer.masksToBounds = YES;
//    //UITableView声明了一个NSIndexPath的类别，主要用 来标识当前cell的在tableView中的位置，该类别有section和row两个属性，section标识当前cell处于第几个section中，row代表在该section中的第几行。
//    // 从IndexPath参数获取当前行的行号
//    //    NSUInteger rowNo = indexPath.row;
//    // 取出cityList中索引为rowNo的元素作为UITableViewCell的文本标题
//    tableViewCell.textLabel.text = [contact name];
//    // 设置UITableViewCell的详细内容
//    tableViewCell.detailTextLabel.text = [contact number];
//    // 设置tableViewCell的右边按钮
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
////    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 80, 10, 40, tableViewCell.frame.size.height - 20);
//    [btn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 60, 7, 44, 36)];
////    [btn setTitle:@"call" forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage imageNamed:@"call.png"] forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [tableViewCell.contentView addSubview:btn];
//    // 点击call按钮时传递contact对象过去，跳转页面拨打电话，btn为关联对象
//    objc_setAssociatedObject(btn, @"call_contact", contact, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [btn addTarget:self action:@selector(callBtn:) forControlEvents:UIControlEventTouchUpInside];
//    // 设置UITableViewCell附加按钮的样式
//    tableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    //返回设置好数据的cell给UITableView对象
//    return tableViewCell;
}

// 点击拨打按钮
- (void)callBtn:(UIButton *)btn{
    //    NSLog(@"拨打电话 %@ ", [self.tableDataArr[btn.tag] number]);
    //    if (self.mainTableDelegate respondsToSelector ) {
    //        [self.mainTableDelegate callTelPhone:self.tableDataArr[btn.tag]];
    //    }
    if ([_searchViewDelegate respondsToSelector:@selector(callTelPhone:)]) {
        [_searchViewDelegate callTelPhone:objc_getAssociatedObject(btn, @"call_contact")];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_searchViewDelegate closeInputKeyBoard];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self deselectRowAtIndexPath:indexPath animated:YES];
}

// 拨打电话delegate,cell中的协议方法
- (void)callTelPhone:(Contacts *)contact{
    if ([_searchViewDelegate respondsToSelector:@selector(callTelPhone:)]) {
        [_searchViewDelegate callTelPhone:contact];
    }
}

@end
