//
//  SingOverViewController.h
//  K歌卡路里
//
//  Created by amber on 14/11/18.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "IOSMD5.h"

@interface SingOverViewController : BaseViewController <ASIHTTPRequestDelegate,AVAudioPlayerDelegate>

{
    UIView *view;
    UISlider *timerSlider;
    UIImageView *buttonViewImage;
    UIView *playTimeView;
    
    AVAudioPlayer   *musicAudioPlayer;
    AVAudioPlayer   *recordAudioPlayer;
    NSArray         *fileList;  //缓存文件名
    
    NSURL *musicURL;      //下载MP3的url地址
    AppDelegate *appDelegate;
    NSString *musicName;    //本地的音乐名字
    NSArray *fileListName;
    NSURL *fileURL;
    
    NSArray *pathUrlAry;    //通过数组来保存URL
    NSMutableArray  *downLoadFlagAry;
    
    NSString *runCount;
    
    UILabel     *songNameLable;
    int       recordTimer;
}
@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic,retain) UILabel *currentTimeLabel;  //当前时间显示
@property (nonatomic,retain) UILabel *totalTimeLabel;    //总时间显示
@property (nonatomic,copy)   NSString *songID;           //歌曲ID
@property (nonatomic,copy)  NSString  *songsName;        //歌曲名
@property (nonatomic,copy)  NSString  *singerName;       //歌手名
@property (nonatomic,copy)  NSString  *recordID;         //录音ID
@property (nonatomic,copy)  NSString  *recordTimeValue;  //录音时间
@property (nonatomic,copy)  NSString  *recordTime;
@property (nonatomic,copy)  NSString  *scoreCount;       //录音得分
@property (nonatomic,copy)  NSString  *kaclCount;        //卡路里消耗
@property (nonatomic,copy)  NSString  *runCount;         //跑步计数

- (void)addSongNameKey:(NSString *)songName songValue:(NSString *)songValue recordName:(NSString *)recordName recordValue:(NSString *)recordValue recordTimeKye:(NSString *)timeKey recordTimeValue:(NSString *)timeValue songIDKey:(NSString *)songIDKey songIDValue:(NSString *)songIDValue singerKey:(NSString *)singerKey singerValue:(NSString *)singerValue songListName:(NSString *)listName scoreKey:(NSString *)scoreKey scoreValue:(NSString *)scoreValue  kcalKey:(NSString *)kaclKey kcalValue:(NSString *)kcalValue runKey:(NSString *)runKey runValue:(NSString *)runValue;


@end
