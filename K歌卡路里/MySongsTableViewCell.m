//
//  MyTableViewCell.m
//  K歌卡路里
//
//  Created by amber on 14/12/11.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "MySongsTableViewCell.h"

@implementation MySongsTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageView setFrame:CGRectMake(10, 5, 40, 40)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //cell中显示的文字距离
    int cellHeight = self.frame.size.height;
    int cellWidth = self.frame.size.width;
    self.textLabel.frame = CGRectMake(60, -5 , cellWidth, cellHeight-10);
    self.detailTextLabel.frame = CGRectMake(60, 17, cellWidth, cellHeight-10);
    
    self.detailTextLabel.textColor = [UIColor grayColor];
    UIColor *color = [UIColor colorWithRed:54.0/255 green:53.0/255 blue:52.0/255 alpha:1];
    self.textLabel.textColor = color;
    self.textLabel.font = [UIFont systemFontOfSize:15];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
