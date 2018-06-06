//
//  SearchView.h
//  NewContacts
//
//  Created by 宁玉文 on 2018/5/25.
//  Copyright © 2018年 aduning. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contacts+CoreDataClass.h"

@protocol SearchViewDelegate <NSObject>

- (void)searchDataFromString:(NSString *)string;

@end

@interface SearchView : UISearchBar

@property (nonatomic, strong) id<SearchViewDelegate> searchViewdelegate;

@end
