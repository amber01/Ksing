//
//  UserSongListCellTableViewCell.h
//  K歌卡路里
//
//  Created by amber on 15/2/9.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserSongListCellTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *city;
@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *recordDate;
@property (strong, nonatomic) IBOutlet UILabel *sign;
@property (strong, nonatomic) IBOutlet UILabel *songName;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *kaclCount;



@end
