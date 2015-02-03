//
//  SearchResultViewController.h
//  K歌卡路里
//
//  Created by amber on 14/12/28.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "SongListTableViewCell.h"
#import "SingViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface SearchResultViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>
{
    UITableView      *_tableView;
    NSString         *urlStr;
    NSString         *songStr;
    NSString         *lrcStr;
    SongListTableViewCell *cell;
    UILabel          *loadingLabel;
    SingViewController *singVC;
    ASIHTTPRequest   *request;
    ASIHTTPRequest     *_loadRequest;  //下载MP3的
    ASIHTTPRequest     *_loadLRCRequest;  //下载lrc的
    ASINetworkQueue *networkQueue;   //网络请求队列
}

@property (nonatomic,copy)  NSString  *songName;
@property (nonatomic,copy)  NSString  *singer;
@property (nonatomic,copy)  NSString  *songID;
@property (nonatomic,copy)  NSString  *recordName;
@property (nonatomic,copy)  NSString  *recordTime;
@property (nonatomic,copy)  NSString  *recordTimeValue;
@property (nonatomic,copy)  NSString  *loadProgress;  //当前文件的下载百分比
@property (nonatomic)double fileSiz; //文件全部大小
@property (nonatomic)long long downLoadLenth; //已经下载的文件大小


@end
