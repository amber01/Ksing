//
//  UIUtils.h
//  SinaWeiBo
//
//  Created by amber on 14-8-19.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject

//获取documents下的文件路径
+ (NSString *)getDocumentsPath:(NSString *)fileName;
// date 格式化为 string
+ (NSString*) stringFromFomate:(NSDate*)date formate:(NSString*)formate;
// string 格式化为 date
+ (NSDate *) dateFromFomate:(NSString *)datestring formate:(NSString*)formate;

//格式化这样的日期：Mon Sep 08 20:29:11 +0800 2014
+ (NSString *)fomateString:(NSString *)datestring;

//字符串链接等解析方法
+ (NSString *)parseLink:(NSString *)text;

@end
