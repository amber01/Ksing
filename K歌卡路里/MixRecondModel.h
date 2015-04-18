//
//  MixRecondModel.h
//  K歌卡路里
//
//  Created by amber on 15/2/12.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MixRecondModel : NSObject
{
    NSMutableArray  *audioMixParams;
}

/**
 *  合成的歌曲名称和伴奏名称，最后输出要保存的录音名字
 *
 *  @param mp3Name        MP3名称
 *  @param mixRescordName 录音名称
 *  @param recordName     保存的录音名称
 */

- (void)exportAudioName:(NSString *)mp3Name setMixRecordName:(NSString *)mixRescordName setSaveRecordName:(NSString *)recordName;

@end
