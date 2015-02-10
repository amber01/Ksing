//
//  SingerSongListViewController.m
//  K歌卡路里
//
//  Created by amber on 15/1/27.
//  Copyright (c) 2015年 amber. All rights reserved.
//


#import "SingerSongListViewController.h"
#import "UIImageView+WebCache.h"

#define kLoadLableNotification @"kLoadLableNotification"
#define FileSavePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@interface SingerSongListViewController ()

@end

@implementation SingerSongListViewController
- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    NSLog(@"please");
    [super viewDidLoad];
    [self initView];
    [self initURL];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.title = self.singer;
    [self searchSong:self.singer];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- UI
- (void)initView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;  //是否允许选中cell
    //UIEdgeInsets inset;
    //inset.left = 0;
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:_tableView];
}

#pragma mark -- data
- (void)searchSong:(NSString *)singer
{
    NSString * encodingStr = [singer stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //将中文转换为UTF-8
    NSString *urlStr = [NSString stringWithFormat:@"http://120.27.49.100:8000/api/song/search_by_singer/?keyword=%@&num=200",encodingStr];
    NSURL    *url = [[NSURL alloc]initWithString:urlStr];
    _request = [[ASIHTTPRequest alloc]initWithURL:url];
    _request.delegate = self;
    _request.tag = 1001;
    [_request setRequestMethod:@"GET"];
    [_request setTimeOutSeconds:60];
    [_request startAsynchronous];
}

- (void)initURL
{
    _coverURL = @"http://120.27.49.100:8000/res/cover/";
    songStr = @"http://120.27.49.100:8000/res/mp3/";
    lrcStr  = @"http://120.27.49.100:8000/res/lrc/";
}

- (void)intDwonloadButton:(NSIndexPath *)indexPath withCell:(UITableViewCell *)cell
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
    NSDictionary *dic = [self.data objectAtIndex:button.tag];
    self.songName  = [dic objectForKey:@"name"];
    self.singerName   = [dic objectForKey:@"singer"];
    self.songID    = [dic objectForKey:@"id"];
    
    NSString *mp3Names = [NSString stringWithFormat:@"%@_01.mp3",self.songID];
    BOOL isFile = [SingerSongListViewController isFileExist:mp3Names];
    
    if (button.selected == NO && isFile == NO) {
        
        button.selected = YES;
        [button setTitle:nil forState:UIControlStateNormal];
        if (loadingLabel.text == nil || [_loadProgress isEqualToString:@"100%"]) {
            [self startDownloadMP3:button];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifShow) name:kLoadLableNotification object:nil];
            loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, -1, 40, 30)];
            loadingLabel.textColor = [UIColor orangeColor];
            loadingLabel.text = @"0%";
            loadingLabel.textAlignment = UITextAlignmentCenter;
            loadingLabel.font = [UIFont systemFontOfSize:13];
            [button addSubview:loadingLabel];
        }else{
            [button setTitle:@"点歌" forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:13];
            button.selected = NO;
            UIAlertView *titleAlert = [[UIAlertView alloc]initWithTitle:nil message:@"对不起，你还有歌曲正在下载中,请下载完后再点歌" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [titleAlert show];
        }
        
    }else if (isFile == YES){
        [self currentTimeShow];
        singVC = [[SingViewController alloc]init];
        singVC.urlString = self.songID;
        singVC.songsName = self.songName;
        singVC.singerName = self.singerName;
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
    self.recordName = [NSString stringWithFormat:@"%@ID%@.aac",date,self.songID];
    self.recordTime = date;
    //NSLog(@"timer:%@",self.recordTime);
    
    NSDateFormatter *nsdf3=[[NSDateFormatter alloc] init];
    [nsdf3 setDateStyle:NSDateFormatterShortStyle];
    [nsdf3 setDateFormat:@"MM-dd HH:mm"];
    NSString *date2=[nsdf3 stringFromDate:[NSDate date]];
    self.recordTimeValue = date2;
}

#pragma mark -- ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (request.tag == 1001) {
        NSData *responseData = [request responseData];
        self.dicData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        self.data = [self.dicData objectForKey:@"detail"];
        
        for (int i = 0; i<self.data.count; i++) {
            NSDictionary *dic = [self.data objectAtIndex:i];
            self.songName  = [dic objectForKey:@"name"];
            self.singerName   = [dic objectForKey:@"singer"];
            self.songID = [dic objectForKey:@"id"];
            // NSLog(@"%@",self.songName);
        }
        [_tableView reloadData];
    }else if (request.tag == 1002){
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
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoadLableNotification object:nil];
    }
}


- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    NSLog(@"请求网络出错：%@",error);
    UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"请求超时，请确定网络是否正常" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView1 show];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identify =  [NSString stringWithFormat:@"cell%d",indexPath.row];
    SongListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil) {
        cell = [[SongListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identify];
    }
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    self.songName  = [dic objectForKey:@"name"];
    self.singerName   = [dic objectForKey:@"singer"];
    self.songID    = [dic objectForKey:@"id"];
    
    NSString *songImageName = [NSString  stringWithFormat:@"%@%@.jpg",self.coverURL,self.songID];
    [cell.imageView setImageWithURL:[NSURL URLWithString:songImageName]placeholderImage:[UIImage imageNamed:@"default_CDimage.png"]];
    cell.textLabel.text = self.songName;
    cell.detailTextLabel.text = self.singerName;
    
    [self intDwonloadButton:indexPath withCell:cell];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

#pragma mark -- other

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_request cancel];
    [_loadRequest cancel];
    [_loadLRCRequest cancel];
}

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

@end
