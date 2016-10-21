//
//  TextImageCell.m
//  MutipleCells
//
//  Created by la0fu on 16/10/17.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import "TextImageCell.h"

@interface TextImageCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *lb;

@end

@implementation TextImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        self.lb = [[ UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 40)];
        
        [self.contentView addSubview:_imgView];
        [self.contentView addSubview:_lb];
    }
    return self;
}

- (void)setPerson:(Person *)p
{
    _imgView.image = [UIImage imageNamed:p.avatar];
    _lb.text = p.name;
}

@end
