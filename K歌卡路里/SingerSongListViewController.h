//
//  SingerSongListViewController.h
//  K歌卡路里
//
//  Created by amber on 15/1/27.
//  Copyright (c) 2015年 amber. All rights reserved.
//


#import "BaseViewController.h"
#import "ASIHTTPRequest.h"
#import "SongListTableViewCell.h"
#import "SingViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface SingerSongListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UITableView    *_tableView;
    ASIHTTPRequest *_request;
    SongListTableViewCell *cell;
    NSString       *songStr;
    NSString       *lrcStr;
    UILabel        *loadingLabel;
    SingViewController  *singVC;
    ASIHTTPRequest     *_loadRequest;  //下载MP3的
    ASIHTTPRequest     *_loadLRCRequest;  //下载lrc的
    ASINetworkQueue *networkQueue;   //网络请求队列
}

@property (nonatomic,copy) NSString  *singer;
@property (nonatomic,copy) NSArray   *data;
@property (nonatomic,retain) NSDictionary *dicData;

@property (nonatomic,copy) NSString   *songName;
@property (nonatomic,copy) NSString   *singerName;
@property (nonatomic,copy) NSString   *songID;
@property (nonatomic,copy) NSString   *coverURL;

@property (nonatomic,copy)  NSString  *recordName;
@property (nonatomic,copy)  NSString  *recordTime;
@property (nonatomic,copy)  NSString  *recordTimeValue;
@property (nonatomic,copy)  NSString  *loadProgress;  //当前文件的下载百分比
@property (nonatomic)double fileSiz; //文件全部大小
@property (nonatomic)long long downLoadLenth; //已经下载的文件大小

@end
