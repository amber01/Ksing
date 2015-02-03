//
//  SongsTableViewCell.m
//  K歌卡路里
//
//  Created by amber on 14-9-26.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SongsTableViewCell.h"
#import "CategoryListViewController.h"

@implementation SongsTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self _initViews];
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)layoutSubviews

{
    
    [super layoutSubviews];
    
    //cell中显示的图片大小
    [self.imageView setFrame:CGRectMake(10, 5, 50, 50)];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.textLabel.font = [UIFont systemFontOfSize:16];
    UIColor *textColor = [UIColor colorWithRed:45.0/255.0 green:45.0/255.0 blue:45.0/255.0 alpha:1.0];
    self.textLabel.textColor = textColor;

    self.detailTextLabel.textColor = [UIColor grayColor];
    
    //cell中显示的文字距离
    int cellHeight = self.frame.size.height;
    int cellWidth = self.frame.size.width;
    self.textLabel.frame = CGRectMake(80, -5 , cellWidth, cellHeight-10);
    self.detailTextLabel.frame = CGRectMake(80, 20, cellWidth, cellHeight-10);
}

#pragma mark - actions
- (void)starSongAction
{
    [self.cellDelegate pushVC:self];
}

- (void)categorySongAction
{
    [self.cellDelegate pushCategoryVC:self];
}

- (void)searchAction
{
    [self.cellDelegate SongListVC:self];
}


#pragma mark - other
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
