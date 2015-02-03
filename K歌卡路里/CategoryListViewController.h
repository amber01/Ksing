//
//  CategoryListViewController.h
//  K歌卡路里
//
//  Created by amber on 14/11/25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "BaseViewController.h"

@interface CategoryListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView  *_tableView;
    UITableViewCell *_cell;
}

@end
