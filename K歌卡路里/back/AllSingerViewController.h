//
//  AllSingerViewController.h
//  K歌卡路里
//
//  Created by amber on 15/1/22.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest.h"

@interface AllSingerViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    
    UITableView    *_tableView;
    ASIHTTPRequest *_request;
    NSString       *_songName;
    NSString       *_singger;
    NSString       *_songID;
}

@property (nonatomic,retain)NSMutableArray *data;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;
@property (nonatomic,retain)NSDictionary *dicData;

@end
