//
//  MixRecondModel.m
//  K歌卡路里
//
//  Created by amber on 15/2/12.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "MixRecondModel.h"
#import "SourcePathModel.h"

@implementation MixRecondModel

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark -- initAudioAtPath
- (void) setUpAndAddAudioAtPath:(NSURL*)assetURL toComposition:(AVMutableComposition *)composition start:(CMTime)start dura:(CMTime)dura offset:(CMTime)offset setVolume:(float )volume{
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    AVMutableCompositionTrack *track = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    AVAssetTrack *sourceAudioTrack = [[songAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    NSError *error = nil;
    BOOL ok = NO;
    
    CMTime startTime = start;
    
    CMTime trackDuration = dura;
    CMTimeRange tRange = CMTimeRangeMake(startTime, trackDuration);
    
    //Set Volume
    AVMutableAudioMixInputParameters *trackMix = [AVMutableAudioMixInputParameters audioMixInputParametersWithTrack:track];
    [trackMix setVolume:volume atTime:startTime];
    
    [audioMixParams addObject:trackMix];
    
    //Insert audio into track  //offset CMTimeMake(0, 44100)
    ok = [track insertTimeRange:tRange ofTrack:sourceAudioTrack atTime:offset error:&error];
}

- (void)exportAudioName:(NSString *)mp3Name setMixRecordName:(NSString *)mixRescordName setSaveRecordName:(NSString *)recordName {
    
    AVMutableComposition *composition = [AVMutableComposition composition];
    audioMixParams = [[NSMutableArray alloc] initWithObjects:nil];
    
    //Add Audio Tracks to Composition
    NSString *mp3Path = [SourcePathModel sourcePath:[NSString stringWithFormat:@"/DownLoad/%@_01.mp3",mp3Name]];
    //NSString *path = [[NSBundle mainBundle]pathForResource:[NSString stringWithFormat:@"%@",mp3Name] ofType:@"mp3"];
    NSURL *assetURL1 = [NSURL fileURLWithPath:mp3Path];
    
    
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL1 options:nil];
    CMTime startTime = CMTimeMakeWithSeconds(0, 1);
    CMTime trackDuration = songAsset.duration;
    
    [self setUpAndAddAudioAtPath:assetURL1 toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(9800, 44100) setVolume:0.7];  //6100 value
    NSString *recordPath = [SourcePathModel sourcePath:[NSString stringWithFormat:@"/record/%@",mixRescordName]];
    //path = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@",mixRescordName] ofType:@"caf"];
    NSURL *assetURL2 = [NSURL fileURLWithPath:recordPath];
    
    [self setUpAndAddAudioAtPath:assetURL2 toComposition:composition start:startTime dura:trackDuration offset:CMTimeMake(0, 44100) setVolume:2.3];
    
    AVMutableAudioMix *audioMix = [AVMutableAudioMix audioMix];
    audioMix.inputParameters = [NSArray arrayWithArray:audioMixParams];
    
    //If you need to query what formats you can export to, here's a way to find out
    NSLog (@"compatible presets for songAsset: %@",
           [AVAssetExportSession exportPresetsCompatibleWithAsset:composition]);
    
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]
                                      initWithAsset: composition
                                      presetName: AVAssetExportPresetAppleM4A];
    exporter.audioMix = audioMix;
    exporter.outputFileType = @"com.apple.m4a-audio";
    
    NSString *fileName = [NSString stringWithFormat:@"%@",recordName];
    NSString *exportFile = [NSHomeDirectory() stringByAppendingFormat: @"/Documents/audio/%@.m4a", fileName];
    
    // set up export
    if ([[NSFileManager defaultManager] fileExistsAtPath:exportFile]) {
        [[NSFileManager defaultManager] removeItemAtPath:exportFile error:nil];
    }
    NSURL *exportURL = [NSURL fileURLWithPath:exportFile];
    exporter.outputURL = exportURL;
    
    // do the export
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        int exportStatus = exporter.status;
        switch (exportStatus) {
            case AVAssetExportSessionStatusFailed:{
                NSError *exportError = exporter.error;
                NSLog (@"AVAssetExportSessionStatusFailed: %@", exportError);
                break;
            }
                
                /*
                 case AVAssetExportSessionStatusCompleted: NSLog (@"AVAssetExportSessionStatusCompleted"); break;
                 case AVAssetExportSessionStatusUnknown: NSLog (@"AVAssetExportSessionStatusUnknown"); break;
                 case AVAssetExportSessionStatusExporting: NSLog (@"AVAssetExportSessionStatusExporting"); break;
                 case AVAssetExportSessionStatusCancelled: NSLog (@"AVAssetExportSessionStatusCancelled"); break;
                 case AVAssetExportSessionStatusWaiting: NSLog (@"AVAssetExportSessionStatusWaiting"); break;
                 default:  NSLog (@"didn't get export status"); break;
                 */
        }
    }];
    
    //    // start up the export progress bar
    //    progressView.hidden = NO;
    //    progressView.progress = 0.0;
    //    [NSTimer scheduledTimerWithTimeInterval:0.1
    //                                     target:self
    //                                   selector:@selector (updateExportProgress:)
    //                                   userInfo:exporter
    //                                    repeats:YES];
    
}

@end