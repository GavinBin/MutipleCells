//
//  TextCell.m
//  MutipleCells
//
//  Created by la0fu on 16/10/17.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import "TextCell.h"

@interface TextCell ()

@property (nonatomic, strong) UILabel *lb;

@end

@implementation TextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _lb = [[UILabel alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_lb];
    }
    return self;
}

- (void)setPerson:(Person *)p
{
    _lb.text = p.name;
}

@end
