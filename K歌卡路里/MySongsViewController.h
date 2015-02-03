//
//  MySongsViewController.h
//  K歌卡路里
//
//  Created by amber on 14/12/16.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SingOverViewController.h"

@interface MySongsViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView        *_tableView;
    NSString           *urlStr;
    NSString           *songStr;
    UIView             *view;
}

@property (nonatomic,retain)NSMutableArray *data;
@property (nonatomic,retain)NSDictionary *root;
@property (nonatomic,retain) SingOverViewController *singOverVC;

@end
