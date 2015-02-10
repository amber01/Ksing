//
//  ThemeSongListCell.m
//  K歌卡路里
//
//  Created by amber on 15/2/8.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "ThemeSongListCell.h"

@implementation ThemeSongListCell

- (void)layoutSubviews

{
    
    [super layoutSubviews];
    
    //cell中显示的图片大小
    [self.imageView setFrame:CGRectMake(10, 5, 55, 55)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
}


@end
