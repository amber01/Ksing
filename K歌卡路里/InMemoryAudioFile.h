//
//  InMemoryAudioFile.h
//  recorder
//
//  Created by luna on 13-7-31.
//  Copyright (c) 2013年 lkwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>
@interface InMemoryAudioFile : NSObject{
    AudioFileID			mAudioFile;
    UInt64              packetCount;
    UInt32				*audioData;
    SInt64				packetIndex;
    Boolean             isPlaying;
}

-(void)open:(NSString *)filePath;
-(UInt32)getNextFrame;
-(void)playOrStop;
@end
