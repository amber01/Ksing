//
//  SongsTableViewCell.h
//  K歌卡路里
//  在当前UITableViewCell中添加一个delegate，用于push到UIViewController


//  Created by amber on 14-9-26.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SearechSongTableViewController.h"

@protocol CellDelegate <NSObject>

@optional
- (void)pushVC:(id)sender;  //让其他类(SongListViewController)实现这个方法，这样就可以调用push了
- (void)pushCategoryVC:(id)sender;
- (void)SongListVC:(id)sender;


@end

@interface SongsTableViewCell : UITableViewCell<UIScrollViewDelegate>
{
    UIImageView     *_imageView;
    UITableView     *_tableView;
    UIButton        *_button;
    UIButton        *_searchButton;
    UISearchBar     *_searechBar;
    UIButton        *_starSongButton;
    UIButton        *_categorySongButton;
    UIImageView     *_imageLineView;
    UIImageView     *_imageNewsLine;
    UIImageView     *_songLineView;
}

@property (nonatomic,assign)id <CellDelegate> cellDelegate;

@property (nonatomic,retain)SearechSongTableViewController *searechSongVC;
@property (nonatomic,retain)BaseViewController *baseViewController;

@end
