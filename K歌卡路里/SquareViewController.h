//
//  HomeViewController.h
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "SingerSongListViewController.h"

@interface SquareViewController : BaseViewController
{
    AppDelegate *appDelegate;
    SingerSongListViewController *singerListVC;
}

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) CGFloat LXActivityHeight;

@end
