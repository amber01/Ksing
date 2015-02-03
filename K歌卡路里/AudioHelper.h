//
//  AudioHelper.h
//  K歌卡路里
//
//  Created by amber on 15/1/15.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioHelper : NSObject{
    BOOL recording;
}

- (void)initSession;
- (BOOL)hasHeadset;
- (BOOL)hasMicphone;
- (void)cleanUpForEndRecording;
- (BOOL)checkAndPrepareCategoryForRecording;

@end
