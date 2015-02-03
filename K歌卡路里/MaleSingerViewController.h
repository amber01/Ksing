//
//  MaleSingerViewController.h
//  K歌卡路里
//
//  Created by amber on 15/1/22.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest.h"

@interface MaleSingerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UITableView    *_tableView;
    ASIHTTPRequest *_request;
    NSString       *_songName;
    NSString       *_singger;
    NSString       *_songID;
}

@property (nonatomic,retain)NSArray *data;
@property (nonatomic,retain)NSDictionary *dicData;

@end