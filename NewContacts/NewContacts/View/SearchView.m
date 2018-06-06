//
//  SearchView.m
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/25.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import "SearchView.h"
#import "SearchTableView.h"

@interface SearchView() <UISearchBarDelegate>

@end

@implementation SearchView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.delegate = self;
    [self setReturnKeyType:UIReturnKeyDone];
    return self;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSLog(@"文字9 %@, %@", searchBar.text, searchText);
    if ([_searchViewdelegate respondsToSelector:@selector(searchDataFromString:)]){
        [_searchViewdelegate searchDataFromString:searchText];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"文字0 %@", searchBar.text);
}

//- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    [self resignFirstResponder];
//    return YES;
//}

@end
