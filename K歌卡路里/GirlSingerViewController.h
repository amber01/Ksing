//
//  GirlSingerViewController.h
//  K歌卡路里
//
//  Created by amber on 15/1/22.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"

@interface GirlSingerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView  *_tableView;
}

@end

