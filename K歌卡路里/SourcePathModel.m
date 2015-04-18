//
//  SourcePathModel.m
//  K歌卡路里
//
//  Created by amber on 15/2/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "SourcePathModel.h"

@implementation SourcePathModel

/**
 *  返回document目录
 *
 *  @param fileName 文件名
 *
 *  @return 返回文件名对应的路径
 */
+ (NSString *)sourcePath:(NSString *)fileName
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    NSString *plistPath = [NSString stringWithFormat:@"%@/%@",documentDir,fileName];
    return plistPath;
}

/**
 *  删除指定的plist文件
 *
 *  @param fileName plist文件名
 *
 *  @return 返回BOOL类型，是否存在
 */

+ (BOOL)deleteSingleFile:(NSString *)fileName
{
    NSError *err = nil;
    if (nil == fileName) {
        return NO;
    }
    NSFileManager *appFileManager = [NSFileManager defaultManager];
    if (![appFileManager fileExistsAtPath:fileName]) {
        return YES;
    }
    if (![appFileManager isDeletableFileAtPath:fileName]) {
        return NO;
    }
    return [appFileManager removeItemAtPath:fileName error:&err];
}

@end
