//
//  SearchResultViewController.m
//  K歌卡路里
//
//  Created by amber on 14/12/28.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SearchResultViewController.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"

#define kLoadLableNotification @"kLoadLableNotification"
#define FileSavePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface SearchResultViewController ()

@end

@implementation SearchResultViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"搜索结果";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initURL];
}

#pragma mark -- UI

- (void)initView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //分割线隐藏
    [self.view addSubview:_tableView];
    
    for (int i = 0; i < 15; i++) {
        UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, (i+1) * 65 /* i乘以高度*/, ScreenWidth, 0.5)];
        separator.backgroundColor = [UIColor colorWithRed:205/255.0 green:208/255.0 blue:212/255.0 alpha:1];
        [_tableView addSubview:separator];
    }

}

- (void)initURL
{
    urlStr =  @"http://120.27.49.100:8000/res/cover/";
    songStr = @"http://120.27.49.100:8000/res/mp3/";
    lrcStr  = @"http://120.27.49.100:8000/res/lrc/";
}

- (void)intDwonloadButton:(NSIndexPath *)indexPath
{
    UIButton *songLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    songLoadBtn.frame = CGRectMake(ScreenWidth - 75, 19, 64, 29);
    [songLoadBtn setBackgroundImage:[UIImage imageNamed:@"songDownload_Butnon.png"] forState:UIControlStateNormal];
    [songLoadBtn setBackgroundImage:[UIImage imageNamed:@"songDownloadSelectBtn.png"] forState:UIControlStateSelected];
    [songLoadBtn setTitle:@"点歌" forState:UIControlStateNormal];
    songLoadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    songLoadBtn.selected = NO;
    [songLoadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [songLoadBtn addTarget:self action:@selector(songLoadAction:) forControlEvents:UIControlEventTouchUpInside];
    cell. accessoryView = songLoadBtn;
    songLoadBtn.tag = indexPath.row;
}

#pragma mark -- action
- (void)songLoadAction:(UIButton *)button
{
    NSString *mp3Names = [NSString stringWithFormat:@"%@_01.mp3",self.songID];
    BOOL isFile = [SearchResultViewController isFileExist:mp3Names];
    
    
    if (button.selected == NO && isFile == NO) {
        
        button.selected = YES;
        [button setTitle:nil forState:UIControlStateNormal];
        [self startDownloadMP3:button];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifShow) name:kLoadLableNotification object:nil];
        
        loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, -1, 40, 30)];
        loadingLabel.textColor = [UIColor orangeColor];
        loadingLabel.text = @"0%";
        loadingLabel.textAlignment = UITextAlignmentCenter;
        loadingLabel.font = [UIFont systemFontOfSize:13];
        [button addSubview:loadingLabel];
        
        
    }else if (isFile == YES){
        [self currentTimeShow];
        singVC = [[SingViewController alloc]init];
        singVC.urlString = self.songID;
        singVC.songsName = self.songName;
        singVC.singerName = self.singer;
        singVC.recordName = self.recordName;
        singVC.recordTime = self.recordTime;
        singVC.recordTimeValue = self.recordTimeValue;
        
        [button setTitle:@"演唱" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"songDownloadSelectBtn.png"] forState:UIControlStateNormal];
        [kNavigationController pushViewController:singVC animated:YES];
        
    }else if (button.selected == YES)
    {
       UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"歌曲正在下载中,无法取消哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)notifShow
{
    loadingLabel.text = _loadProgress;
    
    if ([loadingLabel.text isEqualToString:@"100%"]) {
        loadingLabel.text = @"演唱";
        return;
    }
}

- (void)startDownloadMP3:(UIButton *)button
{
    NSString *songFile = [NSString stringWithFormat:@"%@%@_01.mp3",songStr,self.songID];
    NSString *lrcFile = [NSString stringWithFormat:@"%@%@.lrc",lrcStr,self.songID];
    
    NSURL *songURL = [NSURL URLWithString:songFile];
    NSURL *lrcURL = [NSURL URLWithString:lrcFile];
    
    if (!networkQueue) {
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    [networkQueue setShowAccurateProgress:YES]; // 进度精确显示
    [networkQueue setDelegate:self]; // 设置队列的代理对象
    [networkQueue setMaxConcurrentOperationCount:1];   //设置最大并发连接数，也就是同时几个任务在下载
    
    //初始化保存路径
    NSString *saveMP3Path = [FileSavePath  stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@_01.mp3",self.songID]];
    NSString *saveLRCPath = [FileSavePath  stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@.lrc",self.songID]];
    
    _loadRequest = [ASIHTTPRequest requestWithURL:songURL];
    _loadRequest.delegate = self;
    _loadRequest.tag = 1002;
    
    _loadLRCRequest = [ASIHTTPRequest requestWithURL:lrcURL];
    _loadLRCRequest.delegate = self;
    _loadLRCRequest.tag = 1003;
    
    NSString *tempMP3Path = [FileSavePath stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/temp/%@_01.mp3.temp",self.songID]];
    NSString *tempLRCPath = [FileSavePath stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/temp/%@.lrc.temp",self.songID]];
    
    if (_loadRequest) {
        [_loadRequest setDownloadDestinationPath:saveMP3Path];
        [_loadRequest setTemporaryFileDownloadPath:tempMP3Path];
        [_loadRequest setDownloadProgressDelegate:self];
        [networkQueue addOperation:_loadRequest];  //添加队列对象
        [networkQueue go];     //开始队列
    }
    
    if (_loadLRCRequest) {
        [_loadLRCRequest setDownloadDestinationPath:saveLRCPath];
        [_loadLRCRequest setTemporaryFileDownloadPath:tempLRCPath];
        [networkQueue addOperation:_loadLRCRequest];
        [networkQueue go];
    }
}

- (void)currentTimeShow
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYYMMDDHHmmss"];
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];
    self.recordName = [NSString stringWithFormat:@"%@ID%@.caf",date,self.songID];
    self.recordTime = date;
    NSLog(@"timer:%@",self.recordTime);
    
    NSDateFormatter *nsdf3=[[NSDateFormatter alloc] init];
    [nsdf3 setDateStyle:NSDateFormatterShortStyle];
    [nsdf3 setDateFormat:@"MM-dd HH:mm"];
    NSString *date2=[nsdf3 stringFromDate:[NSDate date]];
    self.recordTimeValue = date2;
}

#pragma mark -- ASIHTTPRequestDelegate
//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小，可以显示下载进度多少字节
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    if (request.tag == 1002){
        //下载新任务前清空上一个任务下载的数据量
        self.downLoadLenth = 0;
        
        double fileLenth = [[responseHeaders valueForKey:@"Content-Length"] doubleValue];
        self.fileSiz = fileLenth;
    }
}
//下载中,显示下载的进度条
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    if (request.tag == 1002){
        self.downLoadLenth += bytes;
        double progress = self.downLoadLenth / self.fileSiz;
        _loadProgress = [NSString stringWithFormat:@"%.0f%%",progress * 100];
        //NSLog(@"%@",loadProgress);
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoadLableNotification object:nil];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    if (request.tag == 1002) {
        if (request.didUseCachedResponse) {
            NSLog(@"数据来自缓存");
        } else {
            NSLog(@"数据来自网络");
        }
    }else if (request.tag == 1003){
        if (request.didUseCachedResponse) {
            NSLog(@"数据来自缓存");
        } else {
            NSLog(@"数据来自网络");
        }
    }
}


#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifyCell;
    cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (cell == nil) {
        cell = [[SongListTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifyCell];
    }
    NSString *songImageName = [NSString  stringWithFormat:@"%@%@.jpg",urlStr,self.songID];
    [cell.imageView setImageWithURL:[NSURL URLWithString:songImageName]placeholderImage:[UIImage imageNamed:@"default_CDimage.png"]];
    cell.textLabel.text = self.songName;
    cell.detailTextLabel.text = self.singer;
    
    [self intDwonloadButton:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark -- other
//判断沙盒中是否有该文件存在
+ (BOOL)isFileExist:(NSString *)fileNames
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    NSString *sourcePath = [NSString stringWithFormat:@"%@/DownLoad/",documentDir];
    NSString *filesPaths = [sourcePath stringByAppendingFormat:fileNames,nil];
    BOOL result = [fileManager fileExistsAtPath:filesPaths];
    return result;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [request cancel];
    [_loadRequest cancel];
    [_loadLRCRequest cancel];
}

@end
