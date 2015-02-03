//
//  SingViewController.h
//  K歌卡路里
//
//  Created by amber on 14-9-24.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
#import "BaseToolbar.h"
#import "AudioUnitRemoteIO.h"
#import "InMemoryAudioFile.h"
#import "SingOverViewController.h"
#import "AppDelegate.h"
#import "CategoryListViewController.h"

#define MAX_RECORD_DURATION 60.0
#define WAVE_UPDATE_FREQUENCY   0.3
#define SILENCE_VOLUME   45.0
#define SOUND_METER_COUNT  6
#define HUD_SIZE  320.0

@class PopSongListViewController;

#define ANIMATE_DURATION                        0.3f

static AudioUnitRemoteIO *audioRemote = nil;
@interface SingViewController : BaseViewController<UIActionSheetDelegate,UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate,AVAudioPlayerDelegate,AVAudioRecorderDelegate>
{
    BaseToolbar *_toolbar;
    UIView      *singView;
    UIImageView *singBackground;
    UIButton    *_leftButton;
    UIButton    *_rightButton;
    UIScrollView *scrollView;
    
    
    
    AudioStreamBasicDescription mAudioFormat;
    AudioUnit                   remoteIOUnit;
    ExtAudioFileRef             mAudioFileRef;
    Boolean                     isRecording;
    Boolean                     isPlaying;
    InMemoryAudioFile           *inMemoryAudioFile;
    
    UIButton *menuButton;
    UIButton *audioEqButton;
    UIButton *voiceButton;
    
    AVAudioSession *audioSession;
    AUGraph auGraph;
    AUNode remoteIONode;
    AURenderCallbackStruct inputProc;
    
    NSMutableArray *_buttons;  //存放按钮的个数
    
    UITableView    *_tableView;  //存放歌词的TableView
    AVAudioPlayer *audioPlayer;
    NSMutableArray *musicArray;
    BOOL isPlay;
    BOOL isCircle;
    float tempVolume;
    NSMutableArray *timeArray;
    NSMutableDictionary *LRCDictionary;
    NSUInteger lrcLineNumber;
    NSUInteger musicArrayNumber;
    NSTimer *timer;
    NSTimer *singTimer;
    UIImageView *recodImage;
    UILabel     *songNameLable;
    NSString    *regexStr;
    NSString    *timeStr;
    NSArray     *arrayTime;
    NSString *contentStr;  //歌词内容
    NSMutableArray *arrContent;
    NSDateFormatter *formatter;
    NSDate *curDate;
    
    int     scoreTime;
    int     singValue;
    double lrcLastTime;
    
    UIImageView *voiceView;
    UIView *view;
    
    UIAlertView *alerView;
    UIAlertView *closeAlerView;
    UIAlertView *againAlerView;
    
    AppDelegate *appDelegate;
    PopSongListViewController *popSongListVC;
    CategoryListViewController *categoryListVC;
    
    UIView *animationView;
    UIView *scoreView;
    UIImageView *singAnimationBackground;
    
    int animationFrame;
    
    UIView *view1,*view2,*view3,*view4,*view5,*view6,*view7,
    *view8,*view9,*view10,*view11,*view12,*view13,*view14,
    *view15,*view16,*view17,*view18;
    
    UIView *redView;
    UIView *yellowView;
    UIView *greenView;
    
    NSTimer *beginTimer;
    UILabel *scoreLable;  //显示得分
    UILabel *kcalLable;   //卡路里消耗显示
    
    NSString *scoreStr;
    NSString *kcalStr;
    NSString *runCount;
    
    NSString *lrcContent;   //每一行歌词的长度
    
    int soundMeters[SOUND_METER_COUNT];
    
    int crrentScore;    //记录得分的值
    int crrentScoreValue;
    int lrcTimeVlaue;
    double crrentKCAL;  //记录卡路里消耗的值
    double crrentKcalValue;
}



@property (nonatomic,retain) UIActionSheet *actionSheet;

@property (nonatomic,retain) UIButton *playBtton;
@property (nonatomic,retain) UISlider *timerSlider; //播放进度滑块
@property (nonatomic,retain) UISlider *voluSlider;   //音量滑块

@property (nonatomic,retain) UILabel *currentTimeLabel;  //当前时间显示
@property (nonatomic,retain) UILabel *totalTimeLabel;
@property (nonatomic,retain) UILabel *textLabel;

@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,assign) CGFloat LXActivityHeight;

@property (nonatomic,copy)  NSString  *urlString;  //歌曲ID
@property (nonatomic,copy)  NSString  *songsName;   //歌曲名
@property (nonatomic,copy)  NSString  *singerName; //歌手名

@property (nonatomic,copy)  NSString  *recordName;
@property (nonatomic,copy)  NSString  *recordTime;
@property (nonatomic,copy)  NSString  *recordTimeValue;  //歌曲录制时间

@property (nonatomic,retain) SingOverViewController *singOverVC;

@property(readwrite, nonatomic, strong) NSDictionary *recordSettings;
@property(readwrite, nonatomic, strong) AVAudioRecorder *recorder;
@property(readwrite, nonatomic, strong) NSString *recordPath;
@property(readwrite, nonatomic, strong) NSTimer *timer;
@property(readwrite, nonatomic, assign) double recordTimes;  //录音时间


- (void)startSing;
- (NSMutableDictionary*)Modify:(NSString *)getvalue :(NSString *)key;
- (void)addSongNameKey:(NSString *)songName songValue:(NSString *)songValue recordName:(NSString *)recordName recordValue:(NSString *)recordValue recordTimeKye:(NSString *)timeKey recordTimeValue:(NSString *)timeValue songIDKey:(NSString *)songIDKey songIDValue:(NSString *)songIDValue singerKey:(NSString *)singerKey singerValue:(NSString *)singerValue songListName:(NSString *)listName scoreKey:(NSString *)scoreKey scoreValue:(NSString *)scoreValue  kcalKey:(NSString *)kaclKey kcalValue:(NSString *)kcalValue runKey:(NSString *)runKey runValue:(NSString *)runValue;

- (void)startForFilePath:(NSString *)filePath;
- (void)commitRecording;

@end
