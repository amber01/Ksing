//
//  SingOverViewController.m
//  K歌卡路里
//
//  Created by amber on 14/11/18.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SingOverViewController.h"
#import "MySongsViewController.h"


@interface SingOverViewController ()

@end

@implementation SingOverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        appDelegate = [[UIApplication sharedApplication]delegate];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self audioPlay];
    //设置背景图片
    [[self view] setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"singBackground@2x.png"]]];
    [self _initView];
    [self initTipsView];
    [self songNameLableView];
    [self recordingLable];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(showTimer) userInfo:nil repeats:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES]; //让屏幕保持常亮
}

#pragma mark -- UI
- (void) _initView
{
    buttonViewImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buttonView_image.png"]];
    buttonViewImage.frame = CGRectMake(0, ScreenHeight - 160, ScreenWidth,160);
    
    UIImageView *timerViewLineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timerViewLine_view.png"]];
    timerViewLineImage.frame = CGRectMake(0, ScreenHeight - 160-3.5, ScreenWidth,3.5);
    
    
    playTimeView = [[UIView alloc]init];
    playTimeView.frame = CGRectMake(0, ScreenHeight - 160 - 59, ScreenWidth, 55.5);
    UIImageView *timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timeView_image.png"]];
    [self.view addSubview:playTimeView];
    [playTimeView addSubview:timeImageView];
    
    UIImageView *timerLineImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"timerLine_image.png"]];
    timerLineImage.frame = CGRectMake(0, ScreenHeight - 220, ScreenWidth, 1);
    
    UIButton *againSingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    againSingButton.frame = CGRectMake(14, ScreenHeight - 122 , 75, 95);
    [againSingButton setImage:[UIImage imageNamed:@"againSing_button.png"] forState:UIControlStateNormal];
    [againSingButton addTarget:self action:@selector(againSingAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(124, ScreenHeight - 122 , 75, 95);
    [saveButton setImage:[UIImage imageNamed:@"save_button.png"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *uploadingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    uploadingButton.frame = CGRectMake(233, ScreenHeight - 122 , 75, 95);
    [uploadingButton setImage:[UIImage imageNamed:@"uploading_button.png"] forState:UIControlStateNormal];
    [uploadingButton addTarget:self action:@selector(uploadingAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(25, 30, 35, 35);
    [backButton setImage:[UIImage imageNamed:@"back_image@2x.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *playAndStopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    playAndStopBtn.frame = CGRectMake(18,ScreenHeight - 203, 26, 26);
    [playAndStopBtn setImage:[UIImage imageNamed:@"play_button.png"] forState:UIControlStateNormal];
    [playAndStopBtn setImage:[UIImage imageNamed:@"stop_button.png"] forState:UIControlStateSelected];
    playAndStopBtn.selected = YES;
    playAndStopBtn.tag = 101;
    [playAndStopBtn addTarget:self action:@selector(playAndStopAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self volumeSliderView];
    
    UIColor* color = [UIColor colorWithRed:225.0/255 green:221.0/255 blue:218.0/255 alpha:1];
    _currentTimeLabel = [[UILabel alloc]init];
    _currentTimeLabel.frame = CGRectMake(55, 10, 100, 40);
    _currentTimeLabel.font = [UIFont systemFontOfSize:14];
    _currentTimeLabel.textColor = color;
    
    _totalTimeLabel = [[UILabel alloc]init];
    _totalTimeLabel.frame = CGRectMake(282, 10, 60, 40);
    _totalTimeLabel.font = [UIFont systemFontOfSize:14];
    _totalTimeLabel.textColor = color;
    [playTimeView addSubview:_currentTimeLabel];
    [playTimeView addSubview:_totalTimeLabel];
    
    [self.view addSubview:timerLineImage];
    [self.view addSubview:timerViewLineImage];
    [self.view addSubview:buttonViewImage];
    [self.view addSubview:againSingButton];
    [self.view addSubview:saveButton];
    [self.view addSubview:uploadingButton];
    [self.view addSubview:backButton];
    [self.view addSubview:playAndStopBtn];
}

- (void)initTipsView
{
    UIView *tipsView = [[UIView alloc]init];
    if (ScreenHeight == 480) {
        tipsView.frame = CGRectMake(33, 100, 255, 142);
    }else {
        tipsView.frame = CGRectMake(33, 140, 255, 142);
    }
    [self.view addSubview:tipsView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singOverTips_image.png"]];
    imageView.frame = CGRectMake(0, 0, 255, 142);
    [tipsView addSubview:imageView];
    
    UILabel *scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 18,135, 30)];
    scoreLabel.textColor = [UIColor whiteColor];
    scoreLabel.font = [UIFont systemFontOfSize:16];
    NSString *scoreCount = [[NSString alloc]initWithFormat:@"演唱总分: %@",self.scoreCount];
    scoreLabel.text = scoreCount;
    
    UILabel *kcalLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 46,145, 30)];
    kcalLabel.font = [UIFont systemFontOfSize:16];
    NSString *kcalCount = [[NSString alloc]initWithFormat:@"卡路里消耗: %@",self.kaclCount ];
    kcalLabel.textColor = [UIColor whiteColor];
    kcalLabel.text = kcalCount;
    
    UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(44, 74,190, 30)];
    NSString *kcalCountTips = [[NSString alloc]initWithFormat:@"tips: 您消耗%@,大约",self.kaclCount];
    tipsLabel.text = kcalCountTips;
    //tipsLabel.lineBreakMode = UILineBreakModeWordWrap;  //自动换行
    //tipsLabel.numberOfLines = 0;
    tipsLabel.font = [UIFont systemFontOfSize:16];
    tipsLabel.textColor = [UIColor whiteColor];
    
    UILabel *tipsLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(44, 102,150, 30)];
    NSString *runCount = [[NSString alloc]initWithFormat:@"跑了%@米步哦~",self.runCount];
    tipsLabel2.text = runCount;
    tipsLabel2.font = [UIFont systemFontOfSize:16];
    tipsLabel2.textColor = [UIColor whiteColor];
    
    [tipsView addSubview:scoreLabel];
    [tipsView addSubview:kcalLabel];
    [tipsView addSubview:tipsLabel];
    [tipsView addSubview:tipsLabel2];
}

- (void)songNameLableView
{
    UIColor* color = [UIColor colorWithRed:197.0/255 green:187.0/255 blue:187.0/255 alpha:1];
    if (ScreenHeight == 480) {
        songNameLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 36, ScreenWidth-20, 40)];
    }else{
        songNameLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 29, ScreenWidth-20, 40)];
    }
    
    songNameLable.font = [UIFont systemFontOfSize:17.0];
    songNameLable.textColor = color;
    songNameLable.textAlignment = UITextAlignmentCenter;
    songNameLable.text = [NSString stringWithFormat:@"%@ - %@",self.songsName,self.singerName];
    [self.view addSubview:songNameLable];
}

- (void)recordingLable
{
    UIColor* color = [UIColor colorWithRed:197.0/255 green:187.0/255 blue:187.0/255 alpha:1];
    UILabel *textLabel = [[UILabel alloc]init];
    if (ScreenHeight == 480) {
        textLabel.frame = CGRectMake(ScreenWidth/2-33, 54, 80, 40);
    }else{
        textLabel.frame = CGRectMake(ScreenWidth/2-33, 61, 80, 40);
    }
    textLabel.text = @"正在回放中";
    textLabel.textAlignment = UITextAlignmentCenter;
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.textColor = color;
    [self.view addSubview:textLabel];
}

- (void)volumeSliderView
{
    timerSlider = [[UISlider alloc]initWithFrame:CGRectMake(92, 28, 180, 4)];
    timerSlider.backgroundColor = [UIColor clearColor];
    [timerSlider setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateNormal];
    [timerSlider setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateHighlighted];
    //[volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"VolumeSlider_left.png"] forState:UIControlStateNormal];
    //[volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"VolumeSlider_right.png"] forState:UIControlStateNormal];
    timerSlider.minimumValue = 0;
    timerSlider.maximumValue = (int)musicAudioPlayer.duration;
    NSLog(@"%d",(int)musicAudioPlayer.duration);
    
    [timerSlider addTarget:self action:@selector(currentAction) forControlEvents:UIControlEventValueChanged];
    [playTimeView addSubview:timerSlider];
}


#pragma mark -- actions
- (void)againSingAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)saveAction
{
    [self currentTimeShow];
    [self addSongNameKey:@"songName" songValue:self.songsName recordName:@"recordName" recordValue:self.recordID recordTimeKye:@"recordTime" recordTimeValue:self.recordTimeValue songIDKey:@"songID" songIDValue:self.songID singerKey:@"singerName" singerValue:self.singerName songListName:self.recordTime scoreKey:self.scoreCount  scoreValue:@"scoreCount" kcalKey:@"kcalCount" kcalValue:self.kaclCount runKey:@"runCount" runValue:self.runCount ];
}

- (void)uploadingAction
{
    
}

- (void)backAction
{
    MySongsViewController *mySongsVC = [[MySongsViewController alloc]init];
    [musicAudioPlayer stop];
    [recordAudioPlayer stop];
    [self.navigationController pushViewController:mySongsVC animated:YES];
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)playAndStopAction:(UIButton *)button
{
    if (button.selected) {
        [button setSelected:NO];
        [musicAudioPlayer stop];
        [recordAudioPlayer stop];
        NSLog(@"未选中");
    }else{
        [button setSelected:YES];
        button.selected = YES;
        [musicAudioPlayer play];
        [recordAudioPlayer play];
        NSLog(@"选中");
    }
}


- (void)showTimer
{
    recordTimer = recordAudioPlayer.currentTime;
    int time = (int)musicAudioPlayer.currentTime;
    
    if ((int)musicAudioPlayer.currentTime % 60 < 10) {
        _currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)musicAudioPlayer.currentTime / 60, (int)musicAudioPlayer.currentTime % 60];
    } else {
        _currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)musicAudioPlayer.currentTime / 60, (int)musicAudioPlayer.currentTime % 60];
    }
    //
    if ((int)musicAudioPlayer.duration % 60 < 10) {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)musicAudioPlayer.duration / 60, (int)musicAudioPlayer.duration % 60];
    } else {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)musicAudioPlayer.duration / 60, (int)musicAudioPlayer.duration % 60];
    }
    timerSlider.value = time;
}

- (void)currentAction
{
    musicAudioPlayer.currentTime = timerSlider.value;
}

#pragma mark -- data
/*
 - (void)initAvdioPlay {
 
 NSString *urlStr = @"http://exp.ktv.qq.com/song/01/236_01.mp3";
 musicURL = [NSURL URLWithString:urlStr];
 [self aSynchronous:musicURL];
 }
 
 //异步请求
 - (void)aSynchronous:(NSURL *)url{
 
 _request = [ASIFormDataRequest requestWithURL:url];
 _request.delegate = self;
 
 [_request setRequestMethod:@"GET"];
 [_request setTimeOutSeconds:260];
 
 //---------------------设置缓存------------------------
 _request.downloadCache = appDelegate.myCache;
 _request.cacheStoragePolicy = ASICachePermanentlyCacheStoragePolicy;
 [_request startAsynchronous];
 }
 */

//将录音信息添加到plist文件中
- (void)addSongNameKey:(NSString *)songName songValue:(NSString *)songValue recordName:(NSString *)recordName recordValue:(NSString *)recordValue recordTimeKye:(NSString *)timeKey recordTimeValue:(NSString *)timeValue songIDKey:(NSString *)songIDKey songIDValue:(NSString *)songIDValue singerKey:(NSString *)singerKey singerValue:(NSString *)singerValue songListName:(NSString *)listName scoreKey:(NSString *)scoreKey scoreValue:(NSString *)scoreValue  kcalKey:(NSString *)kaclKey kcalValue:(NSString *)kcalValue runKey:(NSString *)runKey runValue:(NSString *)runValue
{
    NSString *dicplistpath = [appDelegate.documentDirectory stringByAppendingPathComponent:@"RecordList.plist"];
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:dicplistpath]mutableCopy];
    
    if (dic == nil) { //如果plist为空的情况自动创建一个
        NSMutableDictionary *rootdicplist=[[NSMutableDictionary alloc]init];
        //定义第一个Dictionary集合
        NSMutableDictionary *childPlist=[[NSMutableDictionary alloc]init];
        [childPlist setObject:songValue forKey:songName];
        [childPlist setObject:recordValue forKey:recordName];
        [childPlist setObject:timeValue forKey:timeKey];
        [childPlist setObject:songIDValue forKey:songIDKey];
        [childPlist setObject:scoreValue forKey:scoreKey];
        [childPlist setObject:kcalValue forKey:kaclKey];
        [childPlist setObject:runValue forKey:runKey];
        
        //添加到根集合中
        [rootdicplist setObject:childPlist forKey:listName];
        //写入文件
        [rootdicplist writeToFile:dicplistpath atomically:YES];
    }else{
        NSMutableDictionary *childPlist=[[NSMutableDictionary alloc]init];
        [childPlist setObject:songValue forKey:songName];
        [childPlist setObject:recordValue forKey:recordName];
        [childPlist setObject:timeValue forKey:timeKey];
        [childPlist setObject:songIDValue forKey:songIDKey];
        [childPlist setObject:scoreKey forKey:scoreValue];
        [childPlist setObject:kcalValue forKey:kaclKey];
        [childPlist setObject:runValue forKey:runKey];
        //添加到根集合中
        [dic setObject:childPlist forKey:listName];
        //写入文件
        [dic writeToFile:dicplistpath atomically:YES];
    }
}

- (void)audioPlay
{
    NSString *mp3Paths = [NSString stringWithFormat:@"%@/%@_01.mp3",appDelegate.sourcePath,self.songID];
    NSLog(@"mp3 path :%@",mp3Paths);
    
    NSString *recordPath = [NSString stringWithFormat:@"%@/Documents/record/%@",appDelegate.path,self.recordID];
    NSLog(@"record:%@",recordPath);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    NSError *error = nil;
    
    NSData *musicData = [NSData dataWithContentsOfFile:mp3Paths];
    NSData *recordData = [NSData dataWithContentsOfFile:recordPath];
    
    //加载MP3路径。 //musicArray：表示mp3的名称对象
    musicAudioPlayer = [[AVAudioPlayer alloc]initWithData:musicData error:nil];
    recordAudioPlayer = [[AVAudioPlayer alloc]initWithData:recordData error:nil];
    //[musicAudioPlayer play];
    musicAudioPlayer.volume = 0.4;
    musicAudioPlayer.delegate = self;
    
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(playSoundsBack) object:musicAudioPlayer];
    NSInvocationOperation *op2 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(playSoundsRecord) object:recordAudioPlayer];
    
    [queue addOperation:op1];
    [queue addOperation:op2];
}

- (void)playSoundsRecord
{
    [recordAudioPlayer prepareToPlay];
    [recordAudioPlayer play];
}

- (void)playSoundsBack
{
    [musicAudioPlayer prepareToPlay];
    [musicAudioPlayer play];
}

/*
 #pragma mark - ASIHTTPRequest delegate
 //请求数据完成
 - (void)requestFinished:(ASIHTTPRequest *)request {
 if (request.didUseCachedResponse) {
 NSLog(@"数据来自缓存");
 } else {
 NSLog(@"数据来自网络");
 }
 [audioPlayer play];
 }
 
 //请求失败
 - (void)requestFailed:(ASIHTTPRequest *)request {
 NSError *error = request.error;
 NSLog(@"请求网络出错：%@",error);
 }
 
 #pragma mark -- NSURLConnectionDelegate
 - (void)connectionDidFinishLoading:(NSURLConnection *)connection
 {
 
 }
 */

#pragma mark -- AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    UIButton *tagBtn = (UIButton *)[self.view viewWithTag:101];
    if  (player == musicAudioPlayer && flag == YES) {
        tagBtn.selected = NO;
    }
}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication]setIdleTimerDisabled:NO]; //取消屏幕保持常亮
}

- (void)currentTimeShow
{
    NSDateFormatter *nsdf3=[[NSDateFormatter alloc] init];
    [nsdf3 setDateStyle:NSDateFormatterShortStyle];
    [nsdf3 setDateFormat:@"MM-dd HH:mm"];
    NSString *date2=[nsdf3 stringFromDate:[NSDate date]];
    self.recordTimeValue = date2;
}

@end