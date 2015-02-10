//
//  ThemeTwoSongViewController.h
//  K歌卡路里
//
//  Created by amber on 15/2/7.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface ThemeFiveSongViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UITableView        *_tableView;
    
    ASIHTTPRequest     *_request; //请求接口的
    ASIHTTPRequest     *_loadRequest;  //下载MP3的
    ASIHTTPRequest     *_loadLRCRequest;  //下载lrc的
    NSString           *urlStr;
    UIActivityIndicatorView *activityView;
    UIView                  *loadingView;
    UILabel                 *loaingLabel;
    //NSString *progress;
    //UIButton                 *songLoadBtn;
    UIButton                 *startLoadBtn;
    UIAlertView              *alertView;
    UILabel                  *loadingLabel;
    NSString                 *songStr;
    NSString                 *lrcStr;
    NSString                  *urlFileStr;  //歌曲ID
    
    
    NSIndexPath              *_indexPath;
    
    ASINetworkQueue *networkQueue;   //网络请求队列
    NSFileManager *fileManager;    //文件管理对象
    NSString* cellStr;
    NSMutableArray           *arrayData;
    NSString                 *filesPath;
    
    NSString                 *fileName;
    
    SingViewController       *singVC;
}

@property (nonatomic,retain) NSArray *data;
@property (nonatomic,copy)  NSString *songID;
@property (nonatomic,copy)  NSString *songName;
@property (nonatomic,copy)  NSString *singger;
@property (nonatomic,copy)  NSString *category;
@property (nonatomic,copy)  NSString *songFile;
@property (nonatomic)double fileSiz; //文件全部大小
@property (nonatomic)long long downLoadLenth; //已经下载的文件大小
@property (nonatomic,copy)  NSString  *loadProgress;  //当前文件的下载百分比
@property (nonatomic,copy)  NSString  *urlString;     //存储用户点击唱歌时返回该歌曲的ID
@property (nonatomic,copy)  NSString  *printStr;

@property (nonatomic,copy)  NSString  *songsName;   //歌曲名
@property (nonatomic,copy)  NSString  *singerName; //歌手名

@property (nonatomic,copy)  NSString  *recordName;
@property (nonatomic,copy)  NSString  *recordTime;
@property (nonatomic,copy)  NSString  *recordTimeValue;  //歌曲录制时间


- (void)startDownloadMP3:(UIButton *)button;
+ (BOOL)isFileExist:(NSString *)fileNames;


@end
