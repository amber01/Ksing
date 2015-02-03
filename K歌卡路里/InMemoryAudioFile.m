//
//  InMemoryAudioFile.m
//  recorder
//
//  Created by luna on 13-7-31.
//  Copyright (c) 2013年 lkwuxian. All rights reserved.
//

#import "InMemoryAudioFile.h"
#pragma mark Core Audio
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

@implementation InMemoryAudioFile
-(id)init{
    self=[super init];
    if (self!=nil) {
        packetIndex = 0;
        isPlaying = YES;
    }
    return self;
}

-(void)playOrStop{
    if(isPlaying){
		isPlaying = NO;
	} else{
		isPlaying = YES;
	}
}
-(void)open:(NSString *)filePath{
    //Open a file for playing
    
    CFURLRef destinationURL = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)filePath, kCFURLPOSIXPathStyle, false);
    CheckError(AudioFileOpenURL(destinationURL, kAudioFileReadPermission, 0, &mAudioFile), "AudioFileOpen failed");
    CFRelease(destinationURL);
    
    UInt32 dataSize = sizeof(packetCount);
    CheckError(AudioFileGetProperty(mAudioFile, kAudioFilePropertyAudioDataPacketCount, &dataSize, &packetCount),"Get packetcount failed");
    audioData = (UInt32 *)malloc(sizeof(UInt32) * packetCount);
    //read the packets
    UInt32 numBytesRead = -1;
    UInt32 packetsRead = packetCount;
    CheckError(AudioFileReadPackets(mAudioFile, false, &numBytesRead, NULL, 0, &packetsRead, audioData),"Read packet failed");
}
-(UInt32)getNextFrame{
	if (packetIndex >= packetCount){
		packetIndex = 0;
		isPlaying = YES;
	}
	if(isPlaying){
		return audioData[packetIndex++];
	}else{
		return 0;
	}
}

@end
