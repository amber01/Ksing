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

@interface SquareViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    AppDelegate     *appDelegate;
    UITableView     *_tableView;
}

@property (nonatomic,retain)NSArray   *data;

- (void)reloadTableViewDataSource;   //开始重新加载时调用
- (void)doneLoadingTableViewData;    //完成加载时调用


@end
