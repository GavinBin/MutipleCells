//
//  Person.m
//  MutipleCells
//
//  Created by la0fu on 16/10/17.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import "Person.h"
#import "TextCell.h"
#import "ImageCell.h"
#import "TextImageCell.h"
#import "BaseCell.h"

@implementation Person


- (UITableViewCell *)createdTableViewCell:(UITableView *)tableView;
{
    NSString *cellIdentifier = self.cellClassName;

    BaseCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
         cell = [[[NSClassFromString(cellIdentifier) class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell setPerson:self];
    return cell;
}


@end
