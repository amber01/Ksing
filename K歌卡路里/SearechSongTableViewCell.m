//
//  SearechSongTableViewCell.m
//  K歌卡路里
//
//  Created by amber on 14-9-26.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SearechSongTableViewCell.h"

@implementation SearechSongTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self _initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)_initViews
{
    [self barImage];
}

- (void)barImage
{
//    _barImageVeiw = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barView_image.png"]];
//    _barImageVeiw.frame = CGRectMake(0, 0, self.width, 130);
//    self.data = @[_barImageVeiw,@"hello"];
//
//    [self.contentView addSubview:_barImageVeiw];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
