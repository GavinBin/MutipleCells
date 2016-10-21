//
//  Person.h
//  MutipleCells
//
//  Created by la0fu on 16/10/17.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PersonShowType) {
    PersonShowText,
    PersonShowAvatar,
    PersonShowTextAndAvatar
};

@interface Person : NSObject

@property (nonatomic, assign) PersonShowType showtype;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSString *avatar;

@property (nonatomic, copy) NSString * cellClassName;
@property (nonatomic, weak) UITableView *tableViewCell;
- (UITableViewCell *)createdTableViewCell:(UITableView *)tableView;
@end
