//
//  MainTableView.m
//  Contacts
//
//  Created by 宁玉文 on 2018/5/22.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "MainTableView.h"
#import "Contacts+CoreDataClass.h"
#import "Contacts+CoreDataProperties.h"
#import "AppDelegate.h"
#import "AppUtil.h"
#import <objc/runtime.h>
#import "CustomTableViewCell.h"


@interface MainTableView() <CustomTableViewCellDelegate>

@end

@implementation MainTableView 

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
        
//        self.rowHeight = 60.0;
//        self.estimatedRowHeight = 60.0;
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}

// 加载数据
- (void)loadData{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _tableDataArr = nil;
//    _tableDataArr = [AppUtil loadContactsData];
    _tableDataArr = delegate.contactData.contactDataArray;
    
    // 需要对联系人按照姓氏拼音排序
//    for (Contacts *contact in _tableDataArr) {
//        NSLog(@"%d, %@, %@", contact.id, contact.name, contact.number);
//    }
    
    _indexArray = [BMChineseSort IndexWithArray:_tableDataArr Key:@"name"];
    _tableDataArr = [BMChineseSort sortObjectArray:_tableDataArr Key:@"name"];
}

//重新加载数据，刷新
//- (void)reloadData{
//    
//}

// 分组头部
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [_indexArray objectAtIndex:section];
}

// 分组数量
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_indexArray count];
}

// 每个分组的cell数目
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[_tableDataArr objectAtIndex:section] count];
}

// section右侧index数组
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return _indexArray;
}

// 点击右侧索引表项时调用 索引与section的对应关系
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

// 选中第几个cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选中第 %li个cell", (long)indexPath.row);
    [self deselectRowAtIndexPath:indexPath animated:YES];
    [_mainTableDelegate clickItem:[[_tableDataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
//    [self.mainTableDelegate clickItem:(Contacts *)self.tableDataArr[(long)indexPath.row]];
}

// 返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"cellID";
    CustomTableViewCell *cell = [self dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate = self;
    cell.contact = [[_tableDataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [cell initViewCell];
    return cell;
    
    
//    static NSString *cellID = @"cellID";
//    UITableViewCell *tableViewCell = [self dequeueReusableCellWithIdentifier:cellID];
//    if (tableViewCell == nil) {
//        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
//    }
//    // 获取index对应的Contact对象
//    Contacts *contact = [[_tableDataArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
//
////    [tableViewCell.imageView setImage:[UIImage imageNamed:@"cirolong.png"]];
//
//    // 将单元格的边框设置为圆角
//    tableViewCell.layer.cornerRadius = 12;
//    tableViewCell.layer.masksToBounds = YES;
//    //UITableView声明了一个NSIndexPath的类别，主要用 来标识当前cell的在tableView中的位置，该类别有section和row两个属性，section标识当前cell处于第几个section中，row代表在该section中的第几行。
//    // 从IndexPath参数获取当前行的行号
////    NSUInteger rowNo = indexPath.row;
//    // 取出cityList中索引为rowNo的元素作为UITableViewCell的文本标题
//    tableViewCell.textLabel.text = [contact name];
//    // 设置UITableViewCell的详细内容
//    tableViewCell.detailTextLabel.text = [contact number];
//    if ([contact.number isEqualToString:@""]) {
//        tableViewCell.detailTextLabel.text = @"  ";
//    }
//    // 设置tableViewCell的右边按钮
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 100, 0, 80, tableViewCell.frame.size.height);
//    [btn setTitle:@"call" forState:UIControlStateNormal];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellHeight;
}

// 点击拨打按钮
- (void)callBtn:(UIButton *)btn{
//    NSLog(@"拨打电话 %@ ", [self.tableDataArr[btn.tag] number]);
//    if (self.mainTableDelegate respondsToSelector ) {
//        [self.mainTableDelegate callTelPhone:self.tableDataArr[btn.tag]];
//    }
    [_mainTableDelegate callTelPhone:objc_getAssociatedObject(btn, @"call_contact")];
}

//- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.tableDataArr;
//}

// 自定义cell中的点击事件
- (void)callTelPhone:(Contacts *)contact{
    [_mainTableDelegate callTelPhone:contact];
}

@end
