//
//  ImageCell.m
//  MutipleCells
//
//  Created by la0fu on 16/10/17.
//  Copyright © 2016年 la0fu. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

- (void)setPerson:(Person *)p
{
    _imgView.image = [UIImage imageNamed:p.avatar];
}

@end
