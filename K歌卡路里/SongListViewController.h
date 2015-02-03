//
//  SongListViewController.h
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongsTableViewCell.h"
#import "SearechSongTableViewController.h"
#import "SingViewController.h"
#import "CategoryListViewController.h"
#import "BaseViewController.h"
#import "ASIHTTPRequest.h"
#import "SDWebImageDownloaderDelegate.h"
#import "SongListTableViewCell.h"
#import "ASINetworkQueue.h"
#import "EGORefreshTableHeaderView.h"
#import "StarSongViewController.h"
#import "SearchResultViewController.h"


@interface SongListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,SDWebImageDownloaderDelegate,EGORefreshTableHeaderDelegate,UISearchBarDelegate,UISearchDisplayDelegate>
{
    
    UIView          *view;
    UIView          *naviView;
    CategoryListViewController *categoryListVC;
    UITableView     *_tableView;
    UITableView     *_searchTableView;
    UIButton        *_button;
    UIButton        *_searchButton;
    UISearchBar     *_searechBar;
    UISearchDisplayController *searchDisplayController;
    UIButton        *_starSongButton;
    UIButton        *_categorySongButton;
    UIImageView     *_imageLineView;
    UIImageView     *_imageNewsLine;

    NSArray         *_dataArray;
    
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
    NSArray                 *filterData;
    
    
    NSIndexPath              *_indexPath;
    
    ASINetworkQueue *networkQueue;   //网络请求队列
    NSFileManager *fileManager;    //文件管理对象
    NSString* cellStr;
    NSMutableArray           *arrayData;
    NSString                 *filesPath;
    
    NSString                 *fileName;
    
    SingViewController       *singVC;
    BOOL                     isLoadData;
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;   //当前是否是正在加载
    UIButton *_moreButton;  //下拉时的button
    
    NSArray   *dataArray;
    
    SearchResultViewController   *searchResultVC;
    
}

@property (nonatomic,assign)BOOL refreshHeader;   //是否需要下拉效果

@property (nonatomic,retain)NSDictionary  *dataDic;
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

@property (nonatomic,copy)  NSString  *searchURL;
@property (nonatomic,retain)NSDictionary   *searchData;   //返回搜索结果
@property (nonatomic,copy)  NSString  *searchName;
@property (nonatomic,copy)  NSString  *searchSinger;
@property (nonatomic,copy)  NSString  *searchSongID;
@property (nonatomic,retain)NSArray   *songData;
@property (nonatomic,retain)NSArray   *songsData;

//@property (nonatomic,retain)NSDictionary *dic;

@property (nonatomic,retain)UITableViewCell *cell;
@property (nonatomic,retain)StarSongViewController *starSongVC;

- (void)startDownloadMP3:(UIButton *)button;
+ (BOOL)isFileExist:(NSString *)fileNames;
- (void)searchResult:(NSString *)songNameStr;

@end

