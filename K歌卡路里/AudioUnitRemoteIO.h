//
//  AudioRecord.h
//  recorder1
//
//  Created by amber on 14-10-27.
//  Copyright (c) 2014年 lkwuxian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioUnitRemoteIO : NSObject
{
    AVAudioSession *audioSession;
    AUGraph auGraph;
    AudioUnit remoteIOUnit;
    AUNode remoteIONode;
    AURenderCallbackStruct inputProc;
}

@property (nonatomic,assign)BOOL isMute;

- (void)print;

@end
