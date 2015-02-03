//
//  SourcePathModel.h
//  K歌卡路里
//
//  Created by amber on 15/2/1.
//  Copyright (c) 2015年 amber. All rights reserved.
//


/**
 *  document路径
 *
 *  @param  fileName 文件名字
 *
 *  @return 返回该文件的路径
 */

#import <Foundation/Foundation.h>

@interface SourcePathModel : NSObject

+ (NSString *)sourcePath:(NSString *)fileName;

+ (BOOL)deleteSingleFile:(NSString *)fileName;


@end
