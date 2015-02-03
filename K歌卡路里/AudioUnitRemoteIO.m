//
//  AudioRecord.m
//  recorder1
//
//  Created by amber on 14-10-27.
//  Copyright (c) 2014年 lkwuxian. All rights reserved.
//

#import "AudioUnitRemoteIO.h"

@implementation AudioUnitRemoteIO

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isMute = YES;
        [self initRemoteIO];
    }
    return self;
}

static OSStatus	PerformThru(
							void						*inRefCon,
							AudioUnitRenderActionFlags 	*ioActionFlags,
							const AudioTimeStamp 		*inTimeStamp,
							UInt32 						inBusNumber,
							UInt32 						inNumberFrames,
							AudioBufferList 			*ioData)
{
    AudioUnitRemoteIO *THIS=(__bridge AudioUnitRemoteIO *)inRefCon;
    
    OSStatus renderErr = AudioUnitRender(THIS->remoteIOUnit, ioActionFlags,
                                         inTimeStamp, 1, inNumberFrames, ioData);
    
    if (THIS->_isMute == YES){
        //Clear two channel mData
        for (UInt32 i=0; i < ioData->mNumberBuffers; i++)
        {
            memset(ioData->mBuffers[i].mData, 0, ioData->mBuffers[i].mDataByteSize);
        }
    }
    
	if (renderErr < 0) {
		return renderErr;
	}
    
    
    return noErr;
}


- (void) initRemoteIO
{
    audioSession = [AVAudioSession sharedInstance];
    
    NSError *error;
    // set Category for Play and Record
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    [audioSession setPreferredSampleRate:(double)44100.0 error:&error];
    //init RemoteIO
    CheckError (NewAUGraph(&auGraph),"couldn't NewAUGraph");
    CheckError(AUGraphOpen(auGraph),"couldn't AUGraphOpen");
    //
    AudioComponentDescription componentDesc;
    componentDesc.componentType = kAudioUnitType_Output;
    componentDesc.componentSubType = kAudioUnitSubType_RemoteIO;
    componentDesc.componentManufacturer = kAudioUnitManufacturer_Apple;
    componentDesc.componentFlags = 0;
    componentDesc.componentFlagsMask = 0;
    //
    CheckError (AUGraphAddNode(auGraph,&componentDesc,&remoteIONode),"couldn't add remote io node");
    CheckError(AUGraphNodeInfo(auGraph,remoteIONode,NULL,&remoteIOUnit),"couldn't get remote io unit from node");
    
    //set BUS
    UInt32 oneFlag = 1;
    UInt32 busZero = 0;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Output,
                                    busZero,
                                    &oneFlag,
                                    sizeof(oneFlag)),"couldn't kAudioOutputUnitProperty_EnableIO with kAudioUnitScope_Output");
    //
    UInt32 busOne = 1;
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioOutputUnitProperty_EnableIO,
                                    kAudioUnitScope_Input,
                                    busOne,
                                    &oneFlag,
                                    sizeof(oneFlag)),"couldn't kAudioOutputUnitProperty_EnableIO with kAudioUnitScope_Input");
    
    AudioStreamBasicDescription effectDataFormat;
    UInt32 propSize = sizeof(effectDataFormat);
    CheckError(AudioUnitGetProperty(remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    0,
                                    &effectDataFormat,
                                    &propSize),"couldn't get kAudioUnitProperty_StreamFormat with kAudioUnitScope_Output");
    
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Output,
                                    1,
                                    &effectDataFormat,
                                    propSize),"couldn't set kAudioUnitProperty_StreamFormat with kAudioUnitScope_Output");
    
    CheckError(AudioUnitSetProperty(remoteIOUnit,
                                    kAudioUnitProperty_StreamFormat,
                                    kAudioUnitScope_Input,
                                    0,
                                    &effectDataFormat,
                                    propSize),"couldn't set kAudioUnitProperty_StreamFormat with kAudioUnitScope_Input");
    
    
    inputProc.inputProc = PerformThru;
    inputProc.inputProcRefCon = (__bridge void *)(self);
    CheckError(AUGraphSetNodeInputCallback(auGraph, remoteIONode, 0, &inputProc),"Error setting io output callback");
    //
    CheckError(AUGraphInitialize(auGraph),"couldn't AUGraphInitialize" );
    CheckError(AUGraphUpdate(auGraph, NULL),"couldn't AUGraphUpdate" );
    CheckError(AUGraphStart(auGraph),"couldn't AUGraphStart");
    //
    
    //解决录音时，MP3音乐声音小
    //[[AVAudioSession sharedInstance] setActive:YES error:nil];
    //[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

    CAShow(auGraph);
    
    
    //OSErr status = NewAUGraph(&auGraph);
    //status = AudioUnitSetParameter(remoteIOUnit, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, 0, 1.0, 0);
    
}

- (void)print
{
    NSLog(@"print output");
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


@end
