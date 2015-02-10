//
//  SingViewController.m
//  K歌卡路里
//
//  Created by amber on 14-9-24.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SingViewController.h"
#import "RegexKitLite.h"
#import "PopSongListViewController.h"

#define kChannels   2
#define kOutputBus  0
#define kInputBus   1


@interface SingViewController ()

@end

@implementation SingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isRecording=FALSE;
        isPlaying=FALSE;
        //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(retrunSongID) name:kSendSongIDNotification object:nil];
        
        //初始化AVAudioRecorder的采样率
        self.recordSettings = @{AVFormatIDKey : @(kAudioFormatLinearPCM), AVEncoderBitRateKey:@(1),AVEncoderAudioQualityKey : @(AVAudioQualityMax), AVSampleRateKey : @(10.0), AVNumberOfChannelsKey : @(1)};
        for(int i=0; i<SOUND_METER_COUNT; i++) {
            soundMeters[i] = SILENCE_VOLUME;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configAudio];
    appDelegate = [[UIApplication sharedApplication]delegate];
    singView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:singView];
    
    arrContent = [[NSMutableArray alloc]init];
    
    _buttons = [[NSMutableArray alloc]initWithCapacity:6];  //数组数量为6(图片数量)
    
    self.singOverVC = [[SingOverViewController alloc]init];
    
    if (ScreenHeight == 480) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,ScreenHeight - 390, ScreenWidth, kDeviceHeight - 300) style:UITableViewStylePlain];
    }else if (ScreenHeight >= 568){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,480 - 380, ScreenWidth, ScreenHeight - 330) style:UITableViewStylePlain];
    }
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.scrollEnabled = NO;   //禁止手滚动cell
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    scrollView = [[UIScrollView alloc]init];
    scrollView.delaysContentTouches = NO;
    [singView addSubview:scrollView];
    
    categoryListVC = [[CategoryListViewController alloc]init];
    //----------------LRC function------------------
    isPlay = YES;
    lrcLineNumber = 0;
    
    audioSession = [AVAudioSession sharedInstance];
    
    //初始化要加载的曲目
    [self initMusic];
    
    //初始化音量和音量进度条
    _voluSlider = [[UISlider alloc]init];
    [_voluSlider setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateNormal];
    [_voluSlider setThumbImage:[UIImage imageNamed:@"soundSlider.png"] forState:UIControlStateHighlighted];
    
    //让_voluSlider垂直显示
    CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * -0.5);
    _voluSlider.transform = trans;
    
    _voluSlider.minimumValue = 0;
    _voluSlider.maximumValue = 1;
    _voluSlider.value = 0.2;
    [_voluSlider addTarget:self action:@selector(volumeAction) forControlEvents:UIControlEventValueChanged];
    
    //初始化歌词词典
    timeArray = [[NSMutableArray alloc] initWithCapacity:10];
    LRCDictionary = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    
    //初始化播放进度条
    _timerSlider = [[UISlider alloc]init];
    _timerSlider.frame = CGRectMake(0, ScreenHeight - 170, ScreenWidth, 2);
    _timerSlider.minimumValue = 0;
    _timerSlider.maximumValue = 1;
    _timerSlider.value = 0.1;
    [_timerSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small.png"] forState:UIControlStateNormal];
    [_timerSlider setThumbImage:[UIImage imageNamed:@"sliderThumb_small.png"] forState:UIControlStateHighlighted];
    _timerSlider.enabled = NO;  //禁止UISlider拖动
    [self.view addSubview:_timerSlider];
    
    
    [self initLRC];
    
    
    animationFrame = ScreenWidth;
    
    UIColor* color = [UIColor colorWithRed:197.0/255 green:187.0/255 blue:187.0/255 alpha:1];
    
    _currentTimeLabel = [[UILabel alloc]init];
    _currentTimeLabel.frame = CGRectMake(160, 45, 50, 40);
    _currentTimeLabel.font = [UIFont systemFontOfSize:14];
    _currentTimeLabel.textColor = color;
    
    _totalTimeLabel = [[UILabel alloc]init];
    _totalTimeLabel.frame = CGRectMake(202, 45, 60, 40);
    _totalTimeLabel.font = [UIFont systemFontOfSize:14];
    _totalTimeLabel.textColor = color;
    
    _textLabel = [[UILabel alloc]init];
    _textLabel.frame = CGRectMake(94, 45, 60, 40);
    _textLabel.text = @"正在录制";
    _textLabel.font = [UIFont systemFontOfSize:14];
    _textLabel.textColor = color;
    
    recodImage = [[UIImageView alloc]initWithFrame:CGRectMake(78, 45+12, 15, 15)];
    recodImage.image = [UIImage imageNamed:@"recod_image@2x.png"];
    
    songNameLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 23, ScreenWidth-20, 40)];
    songNameLable.font = [UIFont systemFontOfSize:17.0];
    songNameLable.textColor = color;
    songNameLable.textAlignment = NSTextAlignmentCenter;
    songNameLable.text = [NSString stringWithFormat:@"%@ - %@",self.songsName,self.singerName];
    NSLog(@"song Name :%@",self.songsName);
    
    [self.view addSubview:songNameLable];
    [self.view addSubview:_textLabel];
    [self.view addSubview:recodImage];
    [self.view addSubview:_currentTimeLabel];
    [self.view addSubview:_totalTimeLabel];
    
    [self beginSingView];
    [self initBeginTime];
    [self singScoreView];
    [self kcalView];
    
    OSErr status = NewAUGraph(&auGraph);
    status = AudioUnitSetParameter(remoteIOUnit, kMultiChannelMixerParam_Volume, kAudioUnitScope_Output, 0, 0.1, 0);
    
    //设置监控 每秒刷新一次时间
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3f
                                             target:self
                                           selector:@selector(showTime)
                                           userInfo:nil
                                            repeats:YES];
    beginTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beginSing) userInfo:nil repeats:YES];
    
    
    //[timer invalidate];
    
    [self singBackgroundView];
    [self singViewShow];
    //[self singView];
    [self backView];
    [self questionView];
    [self customToolbarShow];
    [self singAnimationView];
    [self scoreAnimationView];
    
    static dispatch_once_t predicate;
    if(!audioRemote)
        dispatch_once(&predicate, ^{
            audioRemote = [[AudioUnitRemoteIO alloc] init];
        });
    
    //audioRemote.isMute = NO;
    crrentScore = 0;
    crrentKCAL = 0;
    
    NSString *sourcePath = [self fullPathAtCache:@"recorde.wav"];
    [self startForFilePath:sourcePath];
    [self lrcLastTime];
    
    BOOL isMicphone = [self hasMicphone];
    if (isMicphone == NO) {
        NSLog(@"当前是外置麦克风");
    }else if(isMicphone == YES){
        NSLog(@"当前是设备麦克风");
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self startSing];
    audioRemote.isMute = NO;
    
    //解决录音时，MP3音乐声音小
    //[audioSession setActive:YES error:nil];
    //[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    
    
    self.navigationController.toolbarHidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    [[UIApplication sharedApplication]setIdleTimerDisabled:YES]; //让屏幕保持常亮
}

- (void)retrunSongID
{
    NSLog(@"歌曲ID:%@",self.urlString);
}

#pragma mark -- AudioPlayer and LRC show funciton
#pragma mark 载入歌曲数组
- (void)initMusic {
    NSString *sourcePaths = [NSString stringWithFormat:@"%@/%@_01.mp3",appDelegate.sourcePath,self.urlString];
    NSLog(@"mp3 path :%@",sourcePaths);
    NSData *data = [NSData dataWithContentsOfFile:sourcePaths];
    //加载MP3路径。 //musicArray：表示mp3的名称对象
    audioPlayer = [[AVAudioPlayer alloc]initWithData:data error:nil];
    audioPlayer.delegate = self;
    
    NSLog(@"id:%@",self.recordName);
}

- (void)playTimeOver
{
    [self singOverTips];
    [self.navigationController pushViewController:self.singOverVC animated:YES];
    self.singOverVC.songID = self.urlString;
    self.singOverVC.songsName = self.songsName;
    self.singOverVC.singerName = self.singerName;
    self.singOverVC.recordID = self.recordName;
    self.singOverVC.scoreCount = scoreStr;
    self.singOverVC.kaclCount = kcalStr;
    self.singOverVC.runCount = runCount;
    self.singOverVC.recordTime  =  self.recordTime;

    
    CheckError(AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListener,self),"couldn't remove a route change listener");
    [audioPlayer stop];
    [self stopSing];
    AudioUnitUninitialize(remoteIOUnit);
    if (inMemoryAudioFile!=nil) {
        [inMemoryAudioFile release],inMemoryAudioFile=nil;
    }
    audioRemote.isMute = YES;
}

- (BOOL)hasMicphone {
    return [audioSession inputIsAvailable];
}

#pragma audio unit remoteIOUnit

void audioInterruptionListener(void *inClientData,UInt32 inInterruptionState){
    //printf("Interrupted! inInterruptionState=%ld\n",inInterruptionState);
    //SingViewController *appDelegate=(SingViewController *)inClientData;
    switch (inInterruptionState) {
        case kAudioSessionBeginInterruption:
            break;
        case kAudioSessionEndInterruption:
            
            break;
        default:
            break;
    }
}

void audioRouteChangeListener(  void                    *inClientData,
                              AudioSessionPropertyID	inID,
                              UInt32                    inDataSize,
                              const void                *inData){
    printf("audioRouteChangeListener");
    
    
    
    UIAlertView *alertView1;
    UIAlertView *alertView2;
    //检测当前是否插入或拔出耳机
    CFStringRef routeStr;
    UInt32 properSize=sizeof(routeStr);
    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &properSize, &routeStr);
    NSString *routeNSStr=(NSString *)routeStr;
    NSLog(@"audioRouteChange::%@",routeNSStr);//none:ReceiverAndMicrophone ipod:HeadphonesAndMicrophone iphone:HeadsetInOut xiaomi:HeadsetInOut
    
    
    if([routeNSStr isEqualToString:@"ReceiverAndMicrophone"]||[routeNSStr isEqualToString:@"SpeakerAndMicrophone"] ){
        
        audioRemote.isMute = YES;
        CheckError(AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListener, NULL),"couldn't remove a route change listener");
        
        
        //设置为扩音器播放
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute
                                 , sizeof (audioRouteOverride)
                                 , &audioRouteOverride);
    }else if ([routeNSStr isEqualToString:@"HeadsetInOut"]){
        audioRemote.isMute = NO;
    }
    
    /*
     int lenth = routeNSStr.length;
     lenth ++;
     if (lenth == 22) {
     NSLog(@"未插入耳机");
     alertView1 =[[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"抱歉,系统没有检测到你插入外置麦克风,请插入后再进入演唱" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
     [alertView1 show];
     }else if (routeNSStr.length == 12){
     NSLog(@"耳机插入");
     }
     */
}
OSStatus recordCallback(void                                        *inRefCon,
                        AudioUnitRenderActionFlags        *ioActionFlags,
                        const AudioTimeStamp              *inTimeStamp,
                        UInt32                            inBusNumber,
                        UInt32                            inNumberFrames,
                        AudioBufferList                   *ioData){
    //printf("record::%ld,",inNumberFrames);
    //double timeInSeconds = inTimeStamp->mSampleTime / kSampleRate;
    //printf("\n%fs inBusNumber:%lu inNumberFrames:%lu", timeInSeconds, inBusNumber, inNumberFrames);
    
    AudioBufferList bufferList;
    UInt16 numSamples=inNumberFrames*kChannels;
    UInt16 samples[numSamples];
    memset (&samples, 0, sizeof (samples));
    bufferList.mNumberBuffers = 1;
    bufferList.mBuffers[0].mData = samples;
    bufferList.mBuffers[0].mNumberChannels = kChannels;
    bufferList.mBuffers[0].mDataByteSize = numSamples*sizeof(UInt16);
    SingViewController* THIS = (SingViewController *)inRefCon;
    CheckError(AudioUnitRender(THIS->remoteIOUnit,
                               ioActionFlags,
                               inTimeStamp,
                               kInputBus,
                               inNumberFrames,
                               &bufferList),"AudioUnitRender failed");
    
    //读取缓冲区buffer
    ExtAudioFileWriteAsync(THIS->mAudioFileRef, inNumberFrames, &bufferList);
    return noErr;
}
OSStatus playCallback(void                                      *inRefCon,
                      AudioUnitRenderActionFlags      *ioActionFlags,
                      const AudioTimeStamp            *inTimeStamp,
                      UInt32							inBusNumber,
                      UInt32							inNumberFrames,
                      AudioBufferList                 *ioData){
    //printf("play::%ld,",inNumberFrames);
    SingViewController* this = (SingViewController *)inRefCon;
    
    UInt32 *frameBuffer = ioData->mBuffers[0].mData;
    UInt32 count=inNumberFrames;
    for (int j = 0; j < count; j++){
        frameBuffer[j] = [this->inMemoryAudioFile getNextFrame];//Stereo channels
    }
    
    return noErr;
}

//初始化audio session，该应用程序会自动获取一个单独的音频会话。
- (void)audioInit
{
    AudioSessionInitialize(NULL, kCFRunLoopDefaultMode, audioInterruptionListener, self);
    //    CheckError(AudioSessionInitialize(NULL, kCFRunLoopDefaultMode, audioInterruptionListener, self), "couldn't initialize the audio session");
}

-(void)configAudio{
    [self audioInit];
    
    //添加AudioRouteChange监听器
    CheckError(AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListener, self),"couldn't add a route change listener");
    
    //检测是否有可用的音频输入设备
    UInt32 inputAvailable;
    UInt32 propSize=sizeof(inputAvailable);
    CheckError(AudioSessionGetProperty(kAudioSessionProperty_AudioInputAvailable, &propSize, &inputAvailable), "not available for the current input audio device");
    if (!inputAvailable) {
        /*
         UIAlertView *noInputAlert =[[UIAlertView alloc] initWithTitle:@"error" message:@"not available for the current input audio device" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
         [noInputAlert show];
         [noInputAlert release];
         */
        return;
    }
    
    //调整音频的I/O缓冲时间。
    Float32 ioBufferDuration = .005;
    CheckError(AudioSessionSetProperty(kAudioSessionProperty_PreferredHardwareIOBufferDuration, sizeof(ioBufferDuration), &ioBufferDuration),"couldn't set the buffer duration on the audio session");
    
    //设置音频类别
    UInt32 audioCategory = kAudioSessionCategory_PlayAndRecord;
    CheckError(AudioSessionSetProperty(kAudioSessionProperty_AudioCategory, sizeof(audioCategory), &audioCategory), "couldn't set the category on the audio session");
    
    UInt32 override=true;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryDefaultToSpeaker, sizeof(override), &override);
    
    //获取硬件采样率，并设置音频格式
    Float64 sampleRate;
    UInt32 sampleRateSize=sizeof(sampleRate);
    CheckError(AudioSessionGetProperty(kAudioSessionProperty_CurrentHardwareSampleRate, &sampleRateSize, &sampleRate), "Couldn't get hardware samplerate");
    mAudioFormat.mSampleRate         =44100;  //设置录音采样率8Khz
    mAudioFormat.mFormatID           = kAudioFormatLinearPCM;
    mAudioFormat.mFormatFlags        = kAudioFormatFlagIsSignedInteger | kAudioFormatFlagIsPacked;
    mAudioFormat.mFramesPerPacket    = 1;
    mAudioFormat.mChannelsPerFrame   = kChannels;
    mAudioFormat.mBitsPerChannel     = 16;
    mAudioFormat.mBytesPerFrame      = mAudioFormat.mBitsPerChannel*mAudioFormat.mChannelsPerFrame/8;
    mAudioFormat.mBytesPerPacket     = mAudioFormat.mBytesPerFrame*mAudioFormat.mFramesPerPacket;
    mAudioFormat.mReserved           = 0;
    
    //获取RemoteIO单元实例
    AudioComponentDescription acd;
    acd.componentType = kAudioUnitType_Output;
    acd.componentSubType = kAudioUnitSubType_RemoteIO;
    acd.componentFlags = 0;
    acd.componentFlagsMask = 0;
    acd.componentManufacturer = kAudioUnitManufacturer_Apple;
    AudioComponent inputComponent = AudioComponentFindNext(NULL, &acd);
    CheckError(AudioComponentInstanceNew(inputComponent, &remoteIOUnit), "Couldn't new AudioComponent instance");
    
    //remote I/O默认情况下输出与输入禁用
    UInt32 enable = 1;
    UInt32 disable=0;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,
                                    kInputBus,
                                    &enable,
                                    sizeof(enable))
               , "kAudioOutputUnitProperty_EnableIO::kAudioUnitScope_Input::kInputBus");
    
    //应用格式输入总线的录音输出范围。
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    kInputBus,
                                    &mAudioFormat,
                                    sizeof(mAudioFormat))
               , "kAudioUnitProperty_StreamFormat::kAudioUnitScope_Output::kInputBus");
    
    //禁用缓冲区分配录制（可选）
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_ShouldAllocateBuffer,
                                    kAudioUnitScope_Output,
                                    kInputBus,
                                    &disable,
                                    sizeof(disable))
               , "kAudioUnitProperty_ShouldAllocateBuffer::kAudioUnitScope_Output::kInputBus");
    
    //应用格式输出总线的输入范围
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    kOutputBus,
                                    &mAudioFormat,
                                    sizeof(mAudioFormat)), "kAudioUnitProperty_StreamFormat::kAudioUnitScope_Input::kOutputBus");
    
    //AudioUnitInitialize
    CheckError(AudioUnitInitialize(remoteIOUnit), "AudioUnitInitialize");
}

//开始录音
-(void)startToRecord{
    
    //audioRemote.isMute = NO;
    
    //添加一个回调记录
    AURenderCallbackStruct recorderStruct;
    recorderStruct.inputProc = recordCallback;
    recorderStruct.inputProcRefCon = self;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioOutputUnitProperty_SetInputCallback,
                                    kAudioUnitScope_Input,
                                    kInputBus,
                                    &recorderStruct,
                                    sizeof(recorderStruct))
               , "kAudioOutputUnitProperty_SetInputCallback::kAudioUnitScope_Input::kInputBus");
    //删除回调记录
    AURenderCallbackStruct playStruct;
    playStruct.inputProc=0;
    playStruct.inputProcRefCon=0;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_SetRenderCallback,
                                    kAudioUnitScope_Input,
                                    kOutputBus,
                                    &playStruct,
                                    sizeof(playStruct)), "kAudioUnitProperty_SetRenderCallback::kAudioUnitScope_Input::kOutputBus");
    
    //创建一个音频文件录音
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    //NSLog(@"time:%@",self.recordName);
    NSString *destinationFilePath = [[NSString stringWithFormat:@"%@/record",documentDir]stringByAppendingPathComponent:self.recordName];
    
    //将录音ID写入plist文件中
    //[self Modify:self.songsName :self.recordName];
    
    
    CFURLRef destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)destinationFilePath, kCFURLPOSIXPathStyle, false);
    CheckError(ExtAudioFileCreateWithURL(destinationURL, kAudioFileCAFType, &mAudioFormat, NULL, kAudioFileFlags_EraseFile, &mAudioFileRef),"Couldn't create a file for writing");
    
    
    CFRelease(destinationURL);
    AudioOutputUnitStart(remoteIOUnit);
}
-(void)stopToRecord{
    AudioOutputUnitStop(remoteIOUnit);
    //处置的音频文件
    [audioSession setActive:NO error:nil];
    CheckError(ExtAudioFileDispose(mAudioFileRef),"ExtAudioFileDispose failed");
    
    
}
-(void)startToPlay{
    //删除输入回调
    AURenderCallbackStruct recorderStruct;
    recorderStruct.inputProc = 0;
    recorderStruct.inputProcRefCon = 0;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioOutputUnitProperty_SetInputCallback,
                                    kAudioUnitScope_Input,
                                    kInputBus,
                                    &recorderStruct,
                                    sizeof(recorderStruct))
               , "kAudioOutputUnitProperty_SetInputCallback::kAudioUnitScope_Input::kInputBus");
    //添加回调播放
    AURenderCallbackStruct playStruct;
    playStruct.inputProc=playCallback;
    playStruct.inputProcRefCon=self;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_SetRenderCallback,
                                    kAudioUnitScope_Input,
                                    kOutputBus,
                                    &playStruct,
                                    sizeof(playStruct)), "kAudioUnitProperty_SetRenderCallback::kAudioUnitScope_Input::kOutputBus");
    inMemoryAudioFile=[[InMemoryAudioFile alloc] init];
    NSString *filepath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"testa.caf"];
    [inMemoryAudioFile open:filepath];
    AudioOutputUnitStart(remoteIOUnit);
}
-(void)stopToPlay{
    AudioOutputUnitStop(remoteIOUnit);
}


#pragma mark -- UI
- (void) singBackgroundView
{
    singBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"singBackground.png"]];
    singBackground.frame = CGRectMake(0, 0, ScreenWidth,ScreenHeight);
    [singView addSubview:singBackground];
    [singBackground release];
}

/*
 - (void)toolbarShow
 {
 self.navigationController.toolbarHidden = YES;
 
 UIToolbar *toolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, singView.height - 49, singView.width, 49)];
 UIBarButtonItem *backItem1 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"toolbar_back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
 
 UIBarButtonItem *backItem2 = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"toolbar_stop.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
 
 NSArray *items = @[backItem1,backItem2];
 toolbar.items = items;
 [singView addSubview:toolbar];
 
 [backItem1 release];
 [backItem2 release];
 }
 */

#pragma mark -- 歌曲演唱时显示的动画
- (void)singViewShow
{
    singAnimationBackground = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animation.png"]];
    singAnimationBackground.frame = CGRectMake(0, ScreenHeight - 124 - 45, singView.width, 124);
    [singView addSubview:singAnimationBackground];
    [singAnimationBackground release];
}

- (void)singAnimationView
{
    UIView *showView = [[UIView alloc]initWithFrame:CGRectMake(107, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animation_image.png"]];
    imageView1.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:showView];
    [showView addSubview:imageView1];
    
    animationView = [[UIView alloc]initWithFrame:CGRectMake(96, ScreenHeight - 131, 40.5, 40.5)];
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animation_image_hig.png"]];
    imageView2.frame =  CGRectMake(0, 0, 40.5, 40.5);
    [self.view addSubview:animationView];
    [animationView addSubview:imageView2];
    
    [UIView beginAnimations:@"testAnimation" context:nil];
    [UIView setAnimationDuration:1]; //设置动画的持续时间
    [UIView setAnimationCurve:UIViewAnimationCurveLinear]; //设置动画效果方式
    [UIView setAnimationRepeatCount:1000];     //设置循环方式
    [UIView setAnimationDelegate:self]; //UIView设置动画的delegate
    
    //[UIView setAnimationDidStopSelector:@selector(animationStop)]; //设置动画结束后结束的方法
    //点击按钮时，移动myView的y轴，让它移动到400位置
    //CGRect frame = animationView.frame; //拿到myView的frame
    //frame.origin.y = ScreenHeight - 70;
    
    animationView.alpha = 0.5;  //点击时，让view的透明度变为0
    //animationView.frame = frame;
    //改变view的frame; //暂时注释一下，目的是为了演示淡入淡出
    //设置缩放效果
    animationView.transform = CGAffineTransformScale(animationView.transform, 0.5, 0.5);
    [UIView commitAnimations];
}

- (void)scoreAnimationView
{
    scoreView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView1.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:scoreView];
    [scoreView addSubview:imageView1];
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView2.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view1];
    [view1 addSubview:imageView2];
    
    view2 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView3.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view2];
    [view2 addSubview:imageView3];
    
    view3 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView4.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view3];
    [view3 addSubview:imageView4];
    
    view4 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView5.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view4];
    [view4 addSubview:imageView5];
    
    view5 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView6 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView6.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view5];
    [view5 addSubview:imageView6];
    
    view6 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView7 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView7.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view6];
    [view6 addSubview:imageView7];
    
    view7 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView8 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView8.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view7];
    [view7 addSubview:imageView8];
    
    view8 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView9 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView9.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view8];
    [view8 addSubview:imageView9];
    
    view9 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView10 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView10.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view9];
    [view9 addSubview:imageView10];
    
    view10 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView11 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView11.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view10];
    [view10 addSubview:imageView11];
    
    view11 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView12 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView12.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view11];
    [view11 addSubview:imageView12];
    
    view12 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView13 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView13.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view12];
    [view12 addSubview:imageView13];
    
    view13 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView14 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView14.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view13];
    [view13 addSubview:imageView14];
    
    view14 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView15 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView15.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view14];
    [view14 addSubview:imageView15];
    
    view15 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView16 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView16.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view15];
    [view15 addSubview:imageView16];
    
    view16 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView17 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView17.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view16];
    [view16 addSubview:imageView17];
    
    view17 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView18 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView18.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view17];
    [view17 addSubview:imageView18];
    
    view18 = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 120, 18, 18)];
    UIImageView *imageView19 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animationScore_image"]];
    imageView19.frame = CGRectMake(0, 0, 18, 18);
    [self.view addSubview:view18];
    [view18 addSubview:imageView19];
    
    /*
     for (int i = 301; i <= 307; i++) {
     
     [self.view addSubview:view1];
     [self.view addSubview:view2];
     [self.view addSubview:view3];
     [self.view addSubview:view4];
     [self.view addSubview:view5];
     [self.view addSubview:view6];
     [self.view addSubview:view7];
     
     scoreView = (UIView *)[self.view viewWithTag:i];
     UIImageView *imageView1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sing_animation_image.png"]];
     imageView1.frame = CGRectMake(0, 0, 18, 18);
     [self.view addSubview:scoreView];
     [scoreView addSubview:imageView1];
     }
     */
    
}

- (void)scoreAnimationAction
{
    
    //获取一个随机整数范围在：[10,50)包括0，不包括100
    int x = arc4random() % 50+10;
    animationFrame -= x;
    if (animationFrame<=50) {
        animationFrame = ScreenWidth;
    }
    CGRect frame = scoreView.frame;
    frame.origin.x = animationFrame;
    scoreView.frame = frame;
    scoreView.hidden = NO;
    
    CGRect frame1 = view1.frame;
    frame1.origin.x = animationFrame - ScreenWidth;
    view1.frame = frame1;
    view1.hidden = NO;
    
    CGRect frame2 = view2.frame;
    frame2.origin.x = animationFrame - 280;
    view2.frame = frame2;
    view2.hidden = NO;
    
    CGRect frame3 = view3.frame;
    frame1.origin.x = animationFrame - 240;
    view3.frame = frame3;
    view3.hidden = NO;
    
    CGRect frame4 = view4.frame;
    frame4.origin.x = animationFrame - 200;
    view4.frame = frame4;
    view4.hidden = NO;
    
    CGRect frame5 = view5.frame;
    frame5.origin.x = animationFrame - 160;
    view5.frame = frame5;
    view5.hidden = NO;
    
    CGRect frame6 = view6.frame;
    frame6.origin.x = animationFrame - 120;
    view6.frame = frame6;
    view6.hidden = NO;
    
    CGRect frame7 = view7.frame;
    frame7.origin.x = animationFrame - 80;
    view7.frame = frame7;
    view7.hidden = NO;
    
    CGRect frame8 = view8.frame;
    frame8.origin.x = animationFrame - 40;
    view8.frame = frame8;
    view8.hidden = NO;
    
    CGRect frame9 = view9.frame;
    frame9.origin.x = animationFrame;
    view9.frame = frame9;
    view9.hidden = NO;
    
    CGRect frame10 = view10.frame;
    frame10.origin.x = animationFrame + 40;
    view10.frame = frame10;
    view10.hidden = NO;
    
    CGRect frame11 = view11.frame;
    frame11.origin.x = animationFrame + 80;
    view11.frame = frame11;
    view11.hidden = NO;
    
    CGRect frame12 = view12.frame;
    frame12.origin.x = animationFrame + 120;
    view12.frame = frame12;
    view12.hidden = NO;
    
    CGRect frame13 = view13.frame;
    frame13.origin.x = animationFrame + 160;
    view13.frame = frame13;
    view13.hidden = NO;
    
    CGRect frame14 = view14.frame;
    frame14.origin.x = animationFrame + 200;
    view14.frame = frame14;
    view14.hidden = NO;
    
    CGRect frame15 = view15.frame;
    frame15.origin.x = animationFrame + 240;
    view15.frame = frame15;
    view15.hidden = NO;
    
    CGRect frame16 = view16.frame;
    frame16.origin.x = animationFrame + 280;
    view16.frame = frame16;
    view16.hidden = NO;
    
    CGRect frame17 = view17.frame;
    frame17.origin.x = animationFrame + 320;
    view17.frame = frame17;
    view17.hidden = NO;
    
    CGRect frame18 = view18.frame;
    frame18.origin.x = animationFrame + ScreenWidth;
    view18.frame = frame18;
    view18.hidden = NO;
    
    
    //NSLog(@"%d",animationFrame);
    //[self scoreAnimationView];
    //NSLog(@"scoreFrame:%f",frame.origin.x);
}

- (void)animationSingStop
{
    scoreView.hidden = YES;
    view2.hidden = YES;view3.hidden = YES;view4.hidden = YES;view5.hidden = YES;view6.hidden = YES;view7.hidden = YES;view8.hidden = YES;view9.hidden = YES;
    view1.hidden = YES;view10.hidden = YES;view11.hidden = YES;view12.hidden = YES;view13.hidden = YES;view14.hidden = YES;view15.hidden = YES;view16.hidden = YES;view17.hidden = YES;view18.hidden = YES;
}

//动画结束后，点击按钮让它再继续动画
- (void)animationStop
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5]; //设置动画的持续时间
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut]; //设置动画效果方式
    
    //点击按钮时，移动myView的y轴，让它移动到400位置
    CGRect frame = scoreView.frame; //拿到myView的frame
    frame.origin.x = 74;
    
    scoreView.frame = frame; //改变view的frame;
    
    scoreView.alpha = 1; //动画结束后，点击按钮让透明度变为1
    //动画播放完后，让缩放的尺寸恢复为原始尺寸
    //scoreView.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

- (void)lrcLastTime
{
    NSString *str = [timeArray lastObject];
    double  timeMin = [[str substringWithRange:NSMakeRange(0,2)] intValue];
    //截取秒钟
    double  timeSecond = [[str substringWithRange:NSMakeRange(3,2)] intValue]; //第3个字符开始截取，截取2位数的数字
    lrcLastTime = timeMin * 60 + timeSecond;
    //NSLog(@"lastObject:%i",lrcLastTime);
}

#pragma mark -- 通过AVAudioRecod框架获取当前麦克风的音量大小

- (void)startForFilePath:(NSString *)filePath{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    self.recordPath = filePath;
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSDate *existedData = [NSData dataWithContentsOfFile:[url path] options:NSDataReadingMapped error:&err];
    if (existedData) {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:self.recordSettings error:&err];
    [_recorder recordForDuration:(NSTimeInterval) lrcLastTime];  //设置录音的持续时间
    [self.recorder setDelegate:self];
    [self.recorder prepareToRecord];
    [self.recorder setMeteringEnabled:YES];
    [self.recorder recordForDuration:MAX_RECORD_DURATION];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    NSLog(@"%@",url);
}

- (NSString *)fullPathAtCache:(NSString *)fileName{
    NSError *error;
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSFileManager *fm = [NSFileManager defaultManager];
    if (YES != [fm fileExistsAtPath:path]) {
        if (YES != [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error]) {
            NSLog(@"create dir path=%@, error=%@", path, error);
        }
    }
    return [path stringByAppendingPathComponent:fileName];
}


- (void)commitRecording{
    [self.recorder stop];
}

#pragma mark -- 歌曲演唱得分以及卡路里消耗
#warning 音量大小输出,得分算法
- (void)updateMeters{
    [self.recorder updateMeters];
    
    int volume = [self.recorder averagePowerForChannel:0];
    
    if (self.recordTimes >= lrcLastTime) {
        [self.recorder stop];
    }
    self.recordTimes += WAVE_UPDATE_FREQUENCY;
    
    //NSLog(@"length:%d",lrcContent.length);
    
    if (lrcContent.length == 0 && lrcLineNumber == 0) {
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        
    }else if (lrcContent.length > 0 && volume > -44 < -34){
        crrentScore = crrentScore + crrentScoreValue * 0.1;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + crrentKcalValue*0.3;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }else if(lrcContent.length > 0 && volume > -34 && volume < -30){
        crrentScore = crrentScore + crrentScoreValue * 0.7 ;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + crrentKcalValue * 1.1;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }else if(lrcContent.length > 0 && volume > -30 && volume < -24){
        crrentScore = crrentScore + crrentScoreValue * 0.9 ;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + crrentKcalValue * 1.5;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }else if (lrcContent.length > 0 && volume > -24 && volume < -17){   //该区间为正常演唱的音量大小
        crrentScore = crrentScore + crrentScoreValue * 1.5;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + crrentKcalValue * 1.5;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }else if (lrcContent.length > 0 && volume > -17 && volume < -10){   //该区间为正常演唱的音量大小
        crrentScore = crrentScore + crrentScoreValue * 1.5;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + crrentKcalValue * 1.8;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }else if(lrcContent.length > 0 && volume > -10 && volume < -5){   /////
        crrentScore = crrentScore + crrentScoreValue * 0.7;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + crrentKcalValue * 2.0;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }else if (lrcContent.length > 0 && volume > -5 && volume < 5){   //最大值目前是4 1
        crrentScore = crrentScore + crrentScoreValue * 0.5;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + crrentKcalValue * 3.0;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }else if(lrcContent.length > 0 && volume > 5 && volume < 10){
        crrentScore = crrentScore + 0 ;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + crrentKcalValue * 2.5;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }else{
        crrentScore = crrentScore + 0;
        scoreStr = [[NSString alloc]initWithFormat:@"%i",crrentScore];
        scoreLable.text = scoreStr;
        
        crrentKCAL = crrentKCAL + 0;
        kcalStr = [[NSString alloc]initWithFormat:@"%.1f卡",crrentKCAL];
        kcalLable.text = kcalStr;
        //NSLog(@"crrentKCAL:%f",crrentKCAL);
    }
    
    
    if ([self.recorder averagePowerForChannel:0] < -SILENCE_VOLUME) {
        [self addSoundMeterItem:SILENCE_VOLUME];
        return;
    }
    [self addSoundMeterItem:[self.recorder averagePowerForChannel:0]];
    //NSLog(@"volume:%d",volume);
}

- (void)addSoundMeterItem:(int)lastValue{
    for(int i=0; i<SOUND_METER_COUNT - 1; i++) {
        soundMeters[i] = soundMeters[i+1];
    }
    soundMeters[SOUND_METER_COUNT - 1] = lastValue;
    //[self setNeedsDisplay];
}

- (void)singScoreView
{
    UIView *scoreViewShow = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 70, ScreenHeight - 83.2, 70, 40)];
    scoreLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    scoreLable.text = @"0";
    scoreLable.textAlignment = NSTextAlignmentCenter;  //text文本水平居中
    scoreLable.textColor = [UIColor whiteColor];
    scoreLable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:scoreViewShow];
    [scoreViewShow addSubview:scoreLable];
}

- (void)kcalView
{
    UIView *kcalView = [[UIView alloc]initWithFrame:CGRectMake(82, ScreenHeight - 83.2, 70, 40)];
    kcalLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 40)];
    kcalLable.text = @"0卡";
    kcalLable.textAlignment = NSTextAlignmentCenter;  //text文本水平居中
    kcalLable.textColor = [UIColor whiteColor];
    kcalLable.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:kcalView];
    [kcalView addSubview:kcalLable];
}

//自定义tabBar方法
- (void)customToolbarShow
{
    /*
     _toolbar = [[BaseToolbar alloc]initWithFrame:CGRectMake(0, singView.height - 49, singView.width, 49)];
     
     //2.创建左右两边的buttonItem
     _leftButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 5, 33, 40)];
     [_leftButton setImage:[UIImage imageNamed:@"toolbar_back.png"] forState:UIControlStateNormal];
     [_leftButton setImage:[UIImage imageNamed:@"toolbar_back_highlighted.png"] forState:UIControlStateHighlighted];
     [_leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
     
     _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(singView.width-160-34/2, 4.5, 40, 40)];
     [_rightButton setImage:[UIImage imageNamed:@"toolbar_stop.png"] forState:UIControlStateNormal];
     [_rightButton setImage:[UIImage imageNamed:@"toolbar_stop.png"] forState:UIControlStateHighlighted];
     [_rightButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
     
     //4.添加到当前视图中
     //[_toolbar addSubview:_titleLabel];
     [_toolbar addSubview:_leftButton];
     [_toolbar addSubview:_rightButton];
     [singView addSubview:_toolbar];
     */
    menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    menuButton.frame = CGRectMake(0, ScreenHeight - 44, 90, 44);
    [menuButton setImage:[UIImage imageNamed:@"toolBar_menu@2x.png"] forState:UIControlStateNormal];
    [menuButton addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    menuButton.showsTouchWhenHighlighted = YES;
    
    /*
     NSArray *imageNames = @[@"toolBar_audioEQ@2x.png",@"toolBar_voice@2x.png"];
     NSArray *imageHighted = @[@"toolBar_audioEQ_highlighted@2x.png",@"toolBar_voice_highlighted@2x.png"];
     for (int i=0; i<imageNames.count; i++) {
     NSString *imageName = [imageNames objectAtIndex:i];
     NSString *hightedName = [imageHighted objectAtIndex:i];
     UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
     [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
     [button setImage:[UIImage imageNamed:hightedName] forState:UIControlStateSelected];
     button.tag = (10 + i);
     [button addTarget:self action:@selector(buttonShowAction:) forControlEvents:UIControlEventTouchUpInside];
     button.userInteractionEnabled = YES;
     [singView addSubview:button];
     [_buttons addObject:button];
     [button release];
     if (button.tag == 10) {
     button.frame = CGRectMake(90, ScreenHeight - 44, 140, 44);
     }
     if (button.tag == 11)
     {
     button.frame = CGRectMake(230, ScreenHeight - 44,90, 44);
     }
     button.showsTouchWhenHighlighted = YES;
     }
     [singView addSubview:menuButton];
     [menuButton release];
     */
    
    audioEqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioEqButton.frame = CGRectMake(90, ScreenHeight - 44, 140, 44);
    [audioEqButton setImage:[UIImage imageNamed:@"toolBar_audioEQ@2x.png"] forState:UIControlStateNormal];
    [audioEqButton setImage:[UIImage imageNamed:@"toolBar_audioEQ_highlighted@2x.png"] forState:UIControlStateSelected];
    audioEqButton.adjustsImageWhenHighlighted = NO;
    audioEqButton.showsTouchWhenHighlighted = YES;
    audioEqButton.selected = NO;
    audioEqButton.tag = 101;
    [audioEqButton addTarget:self action:@selector(audioEQAction:) forControlEvents:UIControlEventTouchUpInside];
    
    voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    voiceButton.frame = CGRectMake(230, ScreenHeight - 44,90, 44);
    [voiceButton setImage:[UIImage imageNamed:@"toolBar_voice@2x.png"] forState:UIControlStateNormal];
    [voiceButton setImage:[UIImage imageNamed:@"toolBar_voice_highlighted@2x.png"] forState:UIControlStateSelected];
    voiceButton.adjustsImageWhenHighlighted = NO;
    voiceButton.showsTouchWhenHighlighted = YES;
    voiceButton.selected = NO;
    voiceButton.tag = 102;
    [voiceButton addTarget:self action:@selector(voiceAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [singView addSubview:menuButton];
    [singView addSubview:audioEqButton];
    [singView addSubview:voiceButton];
    
}

- (void)singView
{
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame=CGRectMake(70, 360, 80, 30);
    button1.tag=1;
    [button1 setTitle:@"开始录音" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [singView addSubview:button1];
    
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame=CGRectMake(200, 360, 80, 30);
    button2.tag=2;
    [button2 setTitle:@"开始播放" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [singView addSubview:button2];
    [singView addSubview:button1];
    [button1 release];
    [button2 release];
}

- (void)backView
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(20, 30, 35, 35);
    [backButton setImage:[UIImage imageNamed:@"back_image@2x.png"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [singView addSubview:backButton];
    [backButton release];
}

- (void)questionView
{
    UIButton *questionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    questionButton.frame = CGRectMake(ScreenWidth - 37, ScreenHeight - 207, 30, 30);
    [questionButton setImage:[UIImage imageNamed:@"question_image@2x.png"] forState:UIControlStateNormal];
    [questionButton addTarget:self action:@selector(questionAction) forControlEvents:UIControlEventTouchUpInside];
    [singView addSubview:questionButton];
    [questionButton release];
}

#pragma mark -- actions

//该方法控制选中和取消的功能选项
- (void)menuAction:(UIButton *)button
{
    [self initWithActionSheet];
}

/*
 //该方法控制按钮选中的方法，多个按钮只允许一个按钮被选中
 - (void)buttonShowAction:(UIButton *)btn
 {
 if (_tmpButton == nil){
 btn.selected = YES;
 _tmpButton = btn;
 }
 else if (_tmpButton !=nil && _tmpButton == btn){
 btn.selected = YES;
 
 }
 else if (_tmpButton!= btn && _tmpButton!=nil){
 _tmpButton.selected = NO;
 btn.selected = YES;
 _tmpButton = btn;
 }
 }
 */

- (void)audioEQAction:(UIButton *)button
{
    UIButton *but = (UIButton *)[self.view viewWithTag:102];
    if (audioEqButton.selected) {
        [audioEqButton setSelected:NO];
        but.selected = NO;
        [self voiceDismiss];
    }else{
        [audioEqButton setSelected:YES];
        [self voiceDismiss];
        but.selected = NO;
    }
}

- (void)voiceAction:(UIButton *)button
{
    UIButton *but = (UIButton *)[self.view viewWithTag:101];
    if (voiceButton.selected) {
        [voiceButton setSelected:NO];
        [self voiceDismiss];
        but.selected = NO;
    }else{
        [voiceButton setSelected:YES];
        [self voiceButtonShow];
        but.selected = NO;
    }
}

- (void)voiceButtonShow
{
    view = [[UIView alloc]initWithFrame:CGRectMake (ScreenWidth - 115, ScreenHeight - 190 - 44, 115, 190)];
    UIColor *bgColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"voiceBackground_image.png"]];
    view.backgroundColor = bgColor;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(43, 6, 60, 40)];
    label.textColor = [UIColor whiteColor];
    label.text = @"伴奏";
    label.font = [UIFont systemFontOfSize:14];
    
    _voluSlider.frame = CGRectMake(47, 40, 20, 132);
    [view addSubview:_voluSlider];
    
    [self.view addSubview:view];
    [view addSubview:label];
}

- (void)voiceDismiss
{
    [view removeFromSuperview];
}

- (void)questionAction
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"反馈伴奏音质差",@"反馈卡路里计算问题",@"反馈歌词错误,与伴奏对不牢", nil];
    self.actionSheet.delegate = self;
    //UIColor *color = [UIColor colorWithPatternImage:[UIImage imageNamed:@"actionSheet_image@2x.png"]];
    //self.actionSheet.backgroundColor = color;
    _actionSheet.actionSheetStyle =UIActionSheetStyleAutomatic;
    [_actionSheet showInView:singView];
    [_actionSheet release];
}

- (void)backAction
{
    alerView = [[UIAlertView alloc]initWithTitle:nil message:@"你正在录音中，切换会导致当前歌曲无法被保存哦!" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alerView.tag = 201;
    //[alerView buttonTitleAtIndex:1];
    [alerView show];
    [alerView release];
}

#pragma mark -- AVAudioPlayerDelegate
//播放结束后的操作
- (void ) audioPlayerDidFinishPlaying: (AVAudioPlayer *) player successfully: (BOOL ) flag {
    
    if  (player == audioPlayer && flag == YES) {
        [self playTimeOver];
        [self commitRecording];
    }
}

#pragma mark -- UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1){
        if (alerView.tag == 201 || closeAlerView.tag == 202) {
            [audioPlayer stop];
            [self commitRecording];
            if (inMemoryAudioFile!=nil) {
                [inMemoryAudioFile release],inMemoryAudioFile=nil;
            }
            
            audioRemote.isMute = YES;
            [kNavigationController popViewControllerAnimated:YES];
        }else if (againAlerView.tag == 203){
            NSLog(@"重新演唱");
        }
    }
}

/*
 -(void)buttonAction:(UIButton *)button{
 
 if (button.tag==1) {
 UIButton *other=(UIButton *)[button.superview viewWithTag:2];
 if (isRecording) {
 other.enabled=YES;
 [self stopToRecord];
 [button setTitle:@"开始录音" forState:UIControlStateNormal];
 printf("stop record\n");
 audioRemote.isMute = YES;
 [audioPlayer stop];  //加载时默认为播放状态
 
 }else{
 other.enabled=NO;
 [self startToRecord];
 
 audioRemote = [AudioUnitRemoteIO new];
 audioRemote.isMute = NO;
 [audioPlayer play];  //加载时默认为播放状态
 [audioPlayer setCurrentTime:0];  //播放时从头开始播放
 audioPlayer.volume = _voluSlider.value;//重置音量,(每次播放的默认音量好像是1.0)
 
 [button setTitle:@"停止录音" forState:UIControlStateNormal];
 printf("start  record\n");
 }
 isRecording=!isRecording;
 }else if(button.tag==2){
 UIButton *other=(UIButton *)[button.superview viewWithTag:1];
 if (isPlaying) {
 other.enabled=YES;
 [self stopToPlay];
 [button setTitle:@"开始播放" forState:UIControlStateNormal];
 
 [audioPlayer stop];  //加载时默认为播放状
 
 printf("stop play\n");
 }else{
 other.enabled=NO;
 [self startToPlay];
 [button setTitle:@"停止播放" forState:UIControlStateNormal];
 [audioPlayer play];  //加载时默认为播放状态
 [audioPlayer setCurrentTime:0];
 audioPlayer.volume = _voluSlider.value;//重置音量,(每次播放的默认音量好像是1.0)
 printf("start  play\n");
 }
 isPlaying=!isPlaying;
 }
 }
 */

- (void)startSing
{
    [self startToRecord];
    
    [audioPlayer play];  //加载时默认为播放状态
    [audioPlayer setCurrentTime:0];  //播放时从头开始播放
    audioPlayer.volume = _voluSlider.value;//重置音量,(每次播放的默认音量好像是1.0)
    
    printf("start  record\n");
    
}

- (void)stopSing
{
    [self stopToRecord];
    printf("stop record\n");
    //audioRemote.isMute = YES;
    [audioPlayer stop];  //加载时默认为播放状态
}

//
static void CheckError(OSStatus error,const char *operaton){
    if (error==noErr) {
        return;
    }
    char errorString[20]={};
    *(UInt32 *)(errorString+1)=CFSwapInt32HostToBig(error);
    if (isprint(errorString[1])&&isprint(errorString[2])&&isprint(errorString[3])&&isprint(errorString[4])) {
        errorString[0]=errorString[5]='\'';
        errorString[6]='\0';
    }else{
        sprintf(errorString, "%d",(int)error);
    }
    fprintf(stderr, "Error:%s (%s)\n",operaton,errorString);
    exit(1);
}

#pragma mark -- UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        UIAlertView *actionView = [[UIAlertView alloc]initWithTitle:nil message:@"感谢您的反馈意见，我们会尽快处理该首歌曲的伴奏和歌词问题。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [actionView show];
        [actionView release];
    }else if(buttonIndex == 1){
        UIAlertView *actionView = [[UIAlertView alloc]initWithTitle:nil message:@"感谢您的反馈意见，卡路里算法我们正在改进中，改进完成后我们第一时间向您通知。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [actionView show];
        [actionView release];
    }else if(buttonIndex == 2){
        UIAlertView *actionView = [[UIAlertView alloc]initWithTitle:nil message:@"感谢您的反馈意见，我们会尽快处理该首歌曲的伴奏和歌词问题。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [actionView show];
        [actionView release];
    }
}


#pragma mark 0.1秒一次更新 播放时间 播放进度条 歌词 歌曲 自动播放下一首
- (void)showTime {
    //动态更新进度条时间
    
    if ((int)audioPlayer.currentTime % 60 < 10) {
        _currentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d /",(int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60];
    } else {
        _currentTimeLabel.text = [NSString stringWithFormat:@"%d:%d /",(int)audioPlayer.currentTime / 60, (int)audioPlayer.currentTime % 60];
    }
    //
    if ((int)audioPlayer.duration % 60 < 10) {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)audioPlayer.duration / 60, (int)audioPlayer.duration % 60];
    } else {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)audioPlayer.duration / 60, (int)audioPlayer.duration % 60];
    }
    _timerSlider.value = audioPlayer.currentTime / audioPlayer.duration;
    
    [self displaySondWord:audioPlayer.currentTime];//调用歌词函数
    //    NSLog(@"%f",audioPlayer.volume);
}

#pragma mark 得到歌词
- (void)initLRC {
    
    NSString *sourcePaths = [NSString stringWithFormat:@"%@/%@.lrc",appDelegate.sourcePath,self.urlString];
    //NSLog(@"lrc:%@",sourcePaths);
    //LRC歌词的路径
    NSString *LRCPath = [[NSBundle mainBundle] pathForAuxiliaryExecutable:sourcePaths];
    //将路径中的LRC歌词文件转成字符串string
    contentStr = [NSString stringWithContentsOfFile:LRCPath encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *array = [contentStr componentsSeparatedByString:@"\n"];
    //NSLog(@"array:%d",[array count]);
    NSString *regexp = @"\\[ti:(.*)\\]";
    NSArray *regexArray = [contentStr componentsMatchedByRegex:regexp];
    regexStr = [regexArray componentsJoinedByString:@""];
    regexStr=[[regexStr stringByReplacingOccurrencesOfString:@"[ti:" withString:@""]stringByReplacingOccurrencesOfString:@"]" withString:@""];
    //NSLog(@"range___lrc: %@ ",regexStr);
    
    /*
     //得到LRC歌词的歌词字数,来计算演唱得分
     int contenLenth = contentStr.length;
     int lrcRow = [array count];
     int lrcRowValue = lrcRow * 11;
     int lrcLength = contenLenth - lrcRowValue;
     crrentScoreValue = 10000 / lrcLength * 0.3;
     */
    
    
    for (int i = 0; i < [array count]; i++) {
        NSString *linStr = [array objectAtIndex:i];
        NSArray *lineArray = [linStr componentsSeparatedByString:@"]"];
        
        //NSLog(@"lineA:%@",linStr);
        
        if ([lineArray[0] length] > 8) {
            //substringWithRange,根据指定范围返回子字符串
            NSString *str1 = [linStr substringWithRange:NSMakeRange(3, 1)];
            NSString *str2 = [linStr substringWithRange:NSMakeRange(6, 1)];
            if ([str1 isEqualToString:@":"] && [str2 isEqualToString:@"."]) {
                NSString *lrcStr = [lineArray objectAtIndex:1];
                timeStr = [[lineArray objectAtIndex:0] substringWithRange:NSMakeRange(1, 5)];//分割区间求歌词时间
                //	NSLog(@"range___lrc: %@ ",timeStr);
                //把时间 和 歌词 加入词典
                [LRCDictionary setObject:lrcStr forKey:timeStr];
                //NSLog(@"%@",lrcStr);
                [timeArray addObject:timeStr];//timeArray的count就是行数
            }
            
            //NSLog(@"ONE:%@",);
            
            
            /*
             int  timeMin = [[timeStr substringWithRange:NSMakeRange(0,2)] intValue];
             //截取秒钟
             int  timeSecond = [[timeStr substringWithRange:NSMakeRange(3,2)] intValue]; //第3个字符开始截取，截取2位数的数字
             int  socreValue;
             socreValue  = timeMin * 60 + timeSecond;
             */
            
        }
        
        //NSLog(@"array = %@",array);
        NSString *string00 = [array objectAtIndex:i];
        int lrcLength = string00.length;
        
        //NSLog(@"STR:%d",lrcLength);  //歌词的个数
        
        NSRange range = NSMakeRange(string00.length - 5, 5);
        NSString *str0 = [string00 substringWithRange:range];
        [arrContent addObject:str0];
        //NSLog(@"arr = %@",arrContent);
    }
}

#pragma mark 动态显示歌词
- (void)displaySondWord:(NSUInteger)time {
    //    NSLog(@"time = %u",time);
    for (int i = 0; i < [timeArray count]; i++) {
        
        NSArray *array = [timeArray[i] componentsSeparatedByString:@":"];//把时间转换成秒
        NSString *timeString = [timeArray objectAtIndex:i];
        
        //NSLog(@"time:%@",timeString);
        
        NSUInteger currentTime = [array[0] intValue] * 60 + [array[1] intValue];
        if (i == [timeArray count]-1) {
            //求最后一句歌词的时间点
            NSArray *array1 = [timeArray[timeArray.count-1] componentsSeparatedByString:@":"];
            NSUInteger currentTime1 = [array1[0] intValue] * 60 + [array1[1] intValue];
            if (time > currentTime1) {
                [self updateLrcTableView:i];
                break;
            }
        } else {
            //求出第一句的时间点，在第一句显示前的时间内一直加载第一句
            NSArray *array2 = [timeArray[0] componentsSeparatedByString:@":"];
            NSUInteger currentTime2 = [array2[0] intValue] * 60 + [array2[1] intValue];
            if (time < currentTime2) {
                [self updateLrcTableView:0];
                //                NSLog(@"马上到第一句");
                break;
            }
            //求出下一步的歌词时间点，然后计算区间
            NSArray *array3 = [timeArray[i+1] componentsSeparatedByString:@":"];
            NSUInteger currentTime3 = [array3[0] intValue] * 60 + [array3[1] intValue];
            
            if (time >= currentTime && time <= currentTime3) {
                [self updateLrcTableView:i];
                break;
            }
            
        }
    }
}

#pragma mark 动态更新歌词表歌词
- (void)updateLrcTableView:(NSUInteger)lineNumber {
    
    //重新载入 歌词列表lrcTabView
    lrcLineNumber = lineNumber;     //当前歌词的indexPath的行数
    [_tableView reloadData];
    //使被选中的行移到中间
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lineNumber inSection:0];
    [_tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    //NSLog(@"%d",lineNumber);
    lrcContent = [LRCDictionary objectForKey:[timeArray objectAtIndex:lineNumber]];
    //NSLog(@"lenth:%d",lrcContent.length);
    NSString *str1 = [timeArray objectAtIndex:lineNumber];
    
    if (lrcContent.length > 0) {
        [self scoreAnimationAction];
    }else{
        [self animationSingStop];
    }
    
    
    //截取分钟
    int  timeMin = [[str1 substringWithRange:NSMakeRange(0,2)] intValue];
    //截取秒钟
    int  timeSecond = [[str1 substringWithRange:NSMakeRange(3,2)] intValue]; //第3个字符开始截取，截取2位数的数字
    scoreTime = timeMin * 60 + timeSecond;
    //NSLog(@"%d",lineNumber);
    
    //NSLog(@"%d",scoreTime);
    
    //NSArray *array = [contentStr componentsSeparatedByString:@"\n"];
    /*
     NSString *regexp = @"\\[0(.*)\\]";
     NSArray *regexArray = [str1 componentsMatchedByRegex:regexp];
     regexStr = [regexArray componentsJoinedByString:@""];
     regexStr=[[regexStr stringByReplacingOccurrencesOfString:@"[" withString:@""]stringByReplacingOccurrencesOfString:@"." withString:@"\n"];
     NSLog(@"range___lrc: %@\n ",regexStr);
     */
    
    //NSArray *array3 = [timeArray[lineNumber] componentsSeparatedByString:@":"];//把时间转换成秒
    //NSString *timeString = [timeArray objectAtIndex:i];
    //NSLog(@"time:%@",array3);
    
}



- (void)volumeAction
{
    audioPlayer.volume = _voluSlider.value;
}

- (void)beginSingView
{
    redView = [[UIView alloc]initWithFrame:CGRectMake(45, 100, 15, 15)];
    UIImageView *redImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"green_image.png"]];
    redImage.frame = CGRectMake(0, 0, 12, 12);
    [redView addSubview:redImage];
    [self.view addSubview:redView];
    redView.hidden = NO;
    
    yellowView = [[UIView alloc]initWithFrame:CGRectMake(65, 100, 15, 15)];
    UIImageView *yellowImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yellow_image.png"]];
    yellowImage.frame = CGRectMake(0, 0, 12, 12);
    [yellowView addSubview:yellowImage];
    [self.view addSubview:yellowView];
    yellowView.hidden = NO;
    
    greenView = [[UIView alloc]initWithFrame:CGRectMake(85, 100, 15, 15)];
    UIImageView *greenImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"red_image.png"]];
    greenImage.frame = CGRectMake(0, 0, 12, 12);
    [greenView addSubview:greenImage];
    [self.view addSubview:greenView];
    greenView.hidden = NO;
}

- (void)initBeginTime
{
    NSString *str1 = [timeArray objectAtIndex:1];
    int  timeMin = [[str1 substringWithRange:NSMakeRange(0,2)] intValue];
    //截取秒钟
    int  timeSecond = [[str1 substringWithRange:NSMakeRange(3,2)] intValue]; //第3个字符开始截取，截取2位数的数字
    singValue = timeMin * 60 + timeSecond;
    
    
    NSString *firstStr = [timeArray objectAtIndex:1];
    NSString *lastStr = [timeArray lastObject];
    int  firstTime1 = [[firstStr substringWithRange:NSMakeRange(0,2)] intValue];
    //截取秒钟
    int  firstTime2 = [[firstStr substringWithRange:NSMakeRange(3,2)] intValue]; //第3个字符开始截取，截取2位数的数字
    int  firstValue = firstTime1 * 60 + firstTime2;
    
    int  lastTime1 = [[lastStr substringWithRange:NSMakeRange(0,2)] intValue];
    //截取秒钟
    int  lastTime2 = [[lastStr substringWithRange:NSMakeRange(3,2)] intValue]; //第3个字符开始截取，截取2位数的数字
    int  lastValue = lastTime1 * 60 + lastTime2;
    
    if (firstValue < 10) {
        firstValue = 20;
        lrcTimeVlaue = lastValue - firstValue * 2.5;
    }else{
        lrcTimeVlaue = lastValue - firstValue * 2.5;
    }
    NSLog(@"firstValue:%d",firstValue);
    
    crrentScoreValue = 10000 / lrcTimeVlaue * 0.2;  //当前演唱的单个得分
    //NSLog(@"length:%d",crrentScoreValue);
    
    crrentKcalValue = 10000 / lrcTimeVlaue * 0.0001;   //当前卡路里的单个消耗
    
    
    NSLog(@"lrcTimeVlaue:%d",lrcTimeVlaue);
    NSLog(@"KCAL:%f",crrentKcalValue);
}

- (void)beginSing
{
    int statTime =  singValue --;
    //NSLog(@"%d",statTime);
    
    if (lrcLineNumber == 0 && statTime == 2) {
        greenView.hidden = YES;
    }else if(lrcLineNumber == 0 && statTime == 1){
        yellowView.hidden = YES;
    }else if (lrcLineNumber == 0 && statTime == 0){
        redView.hidden = YES;
    }else{
        return;
    }
}

#pragma mark -- UITableViewDelegate
#pragma mark -- UITableViewDataSource

#pragma mark 表视图
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1) {
        return [musicArray count];
    } else {
        return [timeArray count];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LRCCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//该表格选中后没有颜色
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.row == lrcLineNumber) {
        cell.textLabel.text = LRCDictionary[timeArray[indexPath.row]];
        cell.textLabel.textColor = [UIColor colorWithRed:0.0 green:1.0 blue:0 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:20];
    } else {
        cell.textLabel.text = LRCDictionary[timeArray[indexPath.row]];
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
    }
    cell.textLabel.backgroundColor = [UIColor clearColor];
    //        cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    //        [cell.contentView addSubview:lable];//往列表视图里加 label视图，然后自行布局
    //NSString *strLabel = LRCDictionary[timeArray[indexPath.row]];
    //NSLog(@"%d",indexPath.row );
    return cell;
}
//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35;
}

//---------------自定义ActionSheet-------------------

#pragma mark - Public method

- (id)initWithActionSheet
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self.view addGestureRecognizer:tapGesture];
        
        singView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        //self.view.userInteractionEnabled = YES;
        [self creatButtons];
        
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.view];
}

#pragma mark - Praviate method

- (void)creatButtons
{
    
    
    //生成LXActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    
    UIImage *image = [UIImage imageNamed:@"actionSheet_image@2x.png"];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 320, 355);
    [self.backGroundView addSubview:imageView];
    
    UIButton *finishRcd = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    finishRcd.frame = CGRectMake(6, 7, ScreenWidth, 85);
    [finishRcd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishRcd.titleLabel.font = [UIFont systemFontOfSize:17];
    [finishRcd setTitle:@"完成录制" forState:UIControlStateNormal];
    [finishRcd addTarget:self action:@selector(finishRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:finishRcd];
    [finishRcd release];
    
    UIButton *againSingBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    againSingBtn.frame = CGRectMake(6, 94, ScreenWidth, 85);
    [againSingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    againSingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [againSingBtn setTitle:@"重新演唱" forState:UIControlStateNormal];
    [againSingBtn addTarget:self action:@selector(againSingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:againSingBtn];
    [againSingBtn release];
    
    UIButton *cancelSingBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    cancelSingBtn.frame = CGRectMake(6, 184, ScreenWidth, 85);
    [cancelSingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelSingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelSingBtn setTitle:@"放弃演唱" forState:UIControlStateNormal];
    [cancelSingBtn addTarget:self action:@selector(closeRecordAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:cancelSingBtn];
    [cancelSingBtn release];
    
    UIButton *cancelBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(6, 270, ScreenWidth, 85);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:cancelBtn];
    [cancelBtn release];
    
    //给LXActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.backGroundView];
    
    self.LXActivityHeight = 355;   //actionSheet的高度
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.LXActivityHeight, [UIScreen mainScreen].bounds.size.width, self.LXActivityHeight)];
    } completion:^(BOOL finished) {
    }];
}

- (void)singOverTips
{
    if (crrentKCAL == 0.0) {
        runCount = @"0";
    }else if (crrentKCAL <0.5 && crrentKCAL>0.1 ){
        runCount = @"5";
    }else if (crrentKCAL <1 && crrentKCAL > 0.5){
        runCount = @"10";
    }else if (crrentKCAL <2 && crrentKCAL >1){
        runCount = @"20";
    }else if (crrentKCAL <3 && crrentKCAL >2){
        runCount = @"30";
    }else if (crrentKCAL <4 && crrentKCAL >3){
        runCount = @"40";
    }else if (crrentKCAL <5 && crrentKCAL > 4){
        runCount = @"50";
    }else if (crrentKCAL <6 && crrentKCAL >5){
        runCount = @"60";
    }else if (crrentKCAL <7 && crrentKCAL >6){
        runCount = @"70";
    }else if (crrentKCAL <8 && crrentKCAL >7){
        runCount = @"80";
    }else if (crrentKCAL <9 && crrentKCAL > 8){
        runCount = @"90";
    }else if (crrentKCAL <10 && crrentKCAL >9){
        runCount = @"100";
    }else if (crrentKCAL <11 && crrentKCAL >10){
        runCount = @"110";
    }else if (crrentKCAL <12 && crrentKCAL >11){
        runCount = @"120";
    }else if (crrentKCAL <13 && crrentKCAL > 12){
        runCount = @"130";
    }else if (crrentKCAL <15 && crrentKCAL >13){
        runCount = @"140";
    }else if (crrentKCAL <18 && crrentKCAL >15){
        runCount = @"160";
    }else if (crrentKCAL <20 && crrentKCAL >18){
        runCount = @"190";
    }else if (crrentKCAL <22 && crrentKCAL > 20){
        runCount = @"200";
    }else if (crrentKCAL <25 && crrentKCAL >22){
        runCount = @"230";
    }else if (crrentKCAL >25){
        runCount = @"300";
    }
}

- (void)finishRecord
{
    [self singOverTips];
    [self addSongNameKey:@"songName" songValue:self.songsName recordName:@"recordName" recordValue:self.recordName recordTimeKye:@"recordTime" recordTimeValue:self.recordTimeValue songIDKey:@"songID" songIDValue:self.urlString singerKey:@"singerName" singerValue:self.singerName songListName:self.recordTime scoreKey:@"scoreCount" scoreValue:scoreStr kcalKey:@"kcalCount" kcalValue:kcalStr runKey:@"runCount" runValue:runCount ];
    
    
    
    //[self stopSing];
    [self playTimeOver];
    [self tappedCancel];
    
}

- (void)cancelRecord
{
    [self tappedCancel];
}

- (void)closeRecordAction
{
    closeAlerView = [[UIAlertView alloc]initWithTitle:nil message:@"你正在录音中，确定要放弃演唱当前歌曲吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    closeAlerView.tag = 202;
    //[alerView buttonTitleAtIndex:1];
    [closeAlerView show];
    [closeAlerView release];
}

- (void)againSingAction
{
    againAlerView = [[UIAlertView alloc]initWithTitle:nil message:@"你正在录音中，确定要重新演唱当前歌曲吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    againAlerView.tag = 203;
    //[alerView buttonTitleAtIndex:3];  //设置alerView的button的index值
    [againAlerView show];
    [againAlerView release];
}

//点击按钮时移除actionSheet对话框
- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        singView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        
    } completion:^(BOOL finished) {
        if (finished) {
            [_backGroundView removeFromSuperview];
        }
    }];
}

- (void)tappedBackGroundView
{
    //
}

#pragma mark -- Other
/*
 - (void)addRecordFileList
 {
 //获得RecordList.plist文件
 NSString *path = [appDelegate.documentDirectory stringByAppendingPathComponent:@"RecordList.plist"];
 NSLog(@"plist :%@",path);
 NSMutableDictionary * dic =[[[NSMutableDictionary alloc]initWithContentsOfFile:path]mutableCopy ];
 
 [dic writeToFile:path atomically:YES];
 }
 */

//写入数据到plist文件
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

- (void)dealloc{
    
    [super dealloc];
    
    [_playBtton release];
    [musicArray release];
    [_timerSlider release];
    [_voluSlider release];
    [_currentTimeLabel release];
    [_totalTimeLabel release];
    [audioPlayer release];
    [audioSession release];
    [_tableView release];
    [musicArray release];
    [timeArray release];
    [LRCDictionary release];
    [singView release];
    [_textLabel release];
    [recodImage release];
    [songNameLable release];
    [menuButton release];
    [audioEqButton release];
    [voiceButton release];
    [voiceView release];
    [view release];
    [_backGroundView release];
    [self.singOverVC release];
    
    CheckError(AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListener, self),"couldn't remove a route change listener");
    AudioUnitUninitialize(remoteIOUnit);
    if (inMemoryAudioFile!=nil) {
        [inMemoryAudioFile release],inMemoryAudioFile=nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    if ([self.view window] == nil)// 是否是正在使用的视图
    {
        self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication]setIdleTimerDisabled:NO]; //取消屏幕保持常亮
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [singTimer invalidate];
    //[timer invalidate];
    [beginTimer invalidate];
    view1.hidden = YES;view2.hidden = YES;view3.hidden = YES;view4.hidden = YES;view5.hidden = YES;view6.hidden = YES;view7.hidden = YES;view8.hidden = YES;view9.hidden = YES;view10.hidden = YES;view11.hidden = YES;view12.hidden = YES;view13.hidden = YES;view14.hidden = YES;view15.hidden = YES;view16.hidden = YES;view17.hidden = YES;view18.hidden = YES;scoreView.hidden = YES;
    audioRemote.isMute = YES;
    
    audioPlayer = nil;
    //audioSession = nil;
    //remoteIOUnit = NULL;
    //audioRemote = nil;
    //inMemoryAudioFile = nil;
    self = nil;
    
    [self.timer invalidate];
    self.timer = nil;
    self.recorder.delegate = nil;
    self.recorder = nil;
    [self.recorder stop];
}

@end
