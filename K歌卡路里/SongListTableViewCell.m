//
//  PopSongListTableViewCell.m
//  K歌卡路里
//
//  Created by amber on 14/11/27.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SongListTableViewCell.h"

@implementation SongListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)layoutSubviews

{
    
    [super layoutSubviews];
    
    //cell中显示的图片大小
    [self.imageView setFrame:CGRectMake(10, 5, 55, 55)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //cell中显示的文字距离
    int cellHeight = self.frame.size.height;
    int cellWidth = self.frame.size.width;
    self.textLabel.frame = CGRectMake(80, -5 , cellWidth, cellHeight-10);
    self.detailTextLabel.frame = CGRectMake(80, 20, cellWidth, cellHeight-10);
    self.textLabel.font = [UIFont systemFontOfSize:16];
    UIColor *textColor = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
    self.textLabel.textColor = textColor;
    self.detailTextLabel.textColor = [UIColor grayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
