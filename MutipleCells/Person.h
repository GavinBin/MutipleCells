//
//  Person.h
//  MutipleCells
//
//  Created by la0fu on 16/10/17.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *avatar;
// 创建Cell类型
@property (nonatomic, copy) NSString * cellClassName;
// 返回tableViewCell
- (UITableViewCell *)createdTableViewCell:(UITableView *)tableView;
@end
