//
//  UserSongListCellTableViewCell.m
//  K歌卡路里
//
//  Created by amber on 15/2/9.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "UserSongListCellTableViewCell.h"

@implementation UserSongListCellTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.sign.lineBreakMode = UILineBreakModeWordWrap;  //自动换行
    self.sign.numberOfLines = 0;
    
    //让图片呈圆形展示
    //self.avatarView.frame = CGRectMake(20, 50, 50, 50);
    self.avatarView.layer.masksToBounds = YES;
    self.avatarView.layer.cornerRadius = 25;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone; //选中时无颜色
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    /*
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"SongList" ofType:@"plist"];
    NSArray *dataArr = [NSArray arrayWithContentsOfFile:plistPath];
    
    for (int i = 0; i < dataArr.count; i++) {
        NSDictionary *dataDic = [dataArr objectAtIndex:i];
        self.userName.text = [dataDic objectForKey:@"userName"];
        NSLog(@"name:%@",[dataDic objectForKey:@"userName"]);
    }
     */
    
}


@end
