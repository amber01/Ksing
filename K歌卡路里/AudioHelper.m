////
////  AudioHelper.m
////  K歌卡路里
////
////  Created by amber on 15/1/15.
////  Copyright (c) 2015年 amber. All rights reserved.
////
//
//#import "AudioHelper.h"
//#import <AVFoundation/AVFoundation.h>
//#import <AudioToolbox/AudioToolbox.h>
//
//@implementation AudioHelper
//
//- (BOOL)hasMicphone {
//    return [[AVAudioSession sharedInstance] inputIsAvailable];
//}
//
//- (BOOL)hasHeadset {
//#if TARGET_IPHONE_SIMULATOR
//#warning *** Simulator mode: audio session code works only on a device
//    return NO;
//#else
//    CFStringRef route;
//    UInt32 propertySize = sizeof(CFStringRef);
//    AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, ute);
//    
//    if((route == NULL) || (CFStringGetLength(route) == 0)){
//        // Silent Mode
//        NSLog(@"AudioRoute: SILENT, do nothing!");
//    } else {
//        NSString* routeStr = (NSString*)route;
//        NSLog(@"AudioRoute: %@", routeStr);
//        
//        /* Known values of route:
//         * "Headset"
//         * "Headphone"
//         * "Speaker"
//         * "SpeakerAndMicrophone"
//         * "HeadphonesAndMicrophone"
//         * "HeadsetInOut"
//         * "ReceiverAndMicrophone"
//         * "Lineout"
//         */
//        
//        NSRange headphoneRange = [routeStr rangeOfString : @"Headphone"];
//        NSRange headsetRange = [routeStr rangeOfString : @"Headset"];
//        if (headphoneRange.location != NSNotFound) {
//            return YES;
//        } else if(headsetRange.location != NSNotFound) {
//            return YES;
//        }
//    }
//    return NO;
//#endif
//    
//}
//
//- (void)resetOutputTarget {
//    BOOL hasHeadset = [self hasHeadset];
//    NSLog (@"Will Set output target is_headset = %@ .", hasHeadset ? @"YES" : @"NO");
//    UInt32 audioRouteOverride = hasHeadset ?
//kAudioSessionOverrideAudioRoute_None:kAudioSessionProperty_OverrideAudioRoute;
//    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(audioRouteOverride), &audioRouteOverride);
//    [self hasHeadset];
//}
//
//- (BOOL)checkAndPrepareCategoryForRecording {
//    recording = YES;
//    BOOL hasMicphone = [self hasMicphone];
//    //NSLog(@"Will Set category for recording! hasMicophone = %@", Micphone?@"YES":@"NO");
//    if (hasMicphone) {
//        [[AVAudioSession sharedInstance] Category:AVAudioSessionCategoryPlayAndRecord
//                                            error:nil];
//    }
//    [self resetOutputTarget];
//    return hasMicphone;
//}
//
//- (void)resetCategory {
//    if (!recording) {
//        NSLog(@"Will Set category to static value = udioSessionCategoryPlayback!");
//        [[AVAudioSession sharedInstance] Category:AVAudioSessionCategoryPlayback
//                                            error:nil];
//    }
//}
//
//- (void)resetSettings {
//    [self resetOutputTarget];
//    [self resetCategory];
//    BOOL isSucced = [[AVAudioSession sharedInstance] setActive: YES error:NULL];
//    if (!isSucced) {
//        NSLog(@"Reset audio session settings failed!");
//    }
//}
//
//- (void)cleanUpForEndRecording {
//    recording = NO;
//    [self resetSettings];
//}
//
//- (void)printCurrentCategory {
//    
//    return;
//    
//    UInt32 audioCategory;
//    UInt32 size = sizeof(audioCategory);
//    AudioSessionGetProperty(kAudioSessionProperty_AudioCategory, &size, dioCategory);
//    
//    if ( audioCategory == kAudioSessionCategory_UserInterfaceSoundEffects ){
//        NSLog(@"current category is : dioSessionCategory_UserInterfaceSoundEffects");
//    } else if ( audioCategory == kAudioSessionCategory_AmbientSound ){
//        NSLog(@"current category is : kAudioSessionCategory_AmbientSound");
//    } else if ( audioCategory == kAudioSessionCategory_AmbientSound ){
//        NSLog(@"current category is : kAudioSessionCategory_AmbientSound");
//    } else if ( audioCategory == kAudioSessionCategory_SoloAmbientSound ){
//        NSLog(@"current category is : kAudioSessionCategory_SoloAmbientSound");
//    } else if ( audioCategory == kAudioSessionCategory_MediaPlayback ){
//        NSLog(@"current category is : kAudioSessionCategory_MediaPlayback");
//    } else if ( audioCategory == kAudioSessionCategory_LiveAudio ){
//        NSLog(@"current category is : kAudioSessionCategory_LiveAudio");
//    } else if ( audioCategory == kAudioSessionCategory_RecordAudio ){
//        NSLog(@"current category is : kAudioSessionCategory_RecordAudio");
//    } else if ( audioCategory == kAudioSessionCategory_PlayAndRecord ){
//        NSLog(@"current category is : kAudioSessionCategory_PlayAndRecord");
//    } else if ( audioCategory == kAudioSessionCategory_AudioProcessing ){
//        NSLog(@"current category is : kAudioSessionCategory_AudioProcessing");
//    } else {
//        NSLog(@"current category is : unknow");
//    }
//}
//
//void audioRouteChangeListenerCallback (
//                                       void                      *inUserData,
//                                       AudioSessionPropertyID    inPropertyID,
//                                       UInt32                    inPropertyValueS,
//                                       const void                *inPropertyValue
//                                       ) {
//    
//    if (inPropertyID != kAudioSessionProperty_AudioRouteChange) return;
//    // Determines the reason for the route change, to ensure that it is not
//    //      because of a category change.
//    CFDictionaryRef routeChangeDictionary = inPropertyValue;
//    
//    CFNumberRef routeChangeReasonRef =
//    CFDictionaryGetValue (routeChangeDictionary,
//                          CFSTR (kAudioSession_AudioRouteChangeKey_Reason));
//    
//    SInt32 routeChangeReason;
//    
//    CFNumberGetValue (routeChangeReasonRef, kCFNumberSInt32Type, uteChangeReason);
//    NSLog(@" ===================================== RouteChangeReason : %d", teChangeReason);
//    AudioHelper *_self = (AudioHelper *) inUserData;
//    if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable)
//        [_self resetSettings];
//    if (![_self hasHeadset]) {
//        [[NSNotificationCenter defaultCenter] tNotificationName:@"ununpluggingHeadse"
//                                                         object:nil];
//    }
//} else if (routeChangeReason == dioSessionRouteChangeReason_NewDeviceAvailable) {
//    [_self resetSettings];
//    if (![_self hasMicphone]) {
//        [[NSNotificationCenter defaultCenter] tNotificationName:@"pluggInMicrophone"
//                                                         object:nil];
//    }
//} else if (routeChangeReason == dioSessionRouteChangeReason_NoSuitableRouteForCategory) {
//    [_self resetSettings];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"lostMicroPhone"
//                                                        object:nil];
//}
////else if (routeChangeReason == kAudioSessionRouteChangeReason_CategoryChange  )
////    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
////}
//
//[_self printCurrentCategory];
//}
//
//- (void)initSession {
//    recording = NO;
//    AudioSessionInitialize(NULL, NULL, NULL, NULL);
//    [self resetSettings];
//    AudioSessionAddPropertyListener (kAudioSessionProperty_AudioRouteChange,
//                                     audioRouteChangeListenerCallback,
//                                     self);
//    [self printCurrentCategory];
//    [[AVAudioSession sharedInstance] setActive: YES error:NULL];
//}
//
//- (void)dealloc {
//}
//
//@end