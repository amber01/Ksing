//
//  SearechSongTableViewController.h
//  K歌卡路里
//  第一版歌星点歌的页面，暂时保留一下
//
//  Created by amber on 14-9-26.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearechSongTableViewCell.h"

@interface SearechSongTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{
    SearechSongTableViewCell *cell;
    UIImageView *_barImageVeiw;
    UIView      *view;
    UIToolbar   *toolbar;
}
@property (nonatomic,retain)NSArray      *data;
@property (nonatomic,retain)UIToolbar    *toobar;
//@property (nonatomic,retain)UITableView  *tableView;

@end
