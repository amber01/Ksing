//
//  AppDelegate.h
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
#import "ASIDownloadCache.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,retain) MainViewController *mainViewController;
@property (nonatomic,retain) ASIDownloadCache   *myCache;
@property (nonatomic,retain) NSString *documentDirectory;  //Documents目录
@property (nonatomic,retain) NSArray *fileList;   //读取缓存文件夹的文件名
@property (nonatomic,copy)   NSString *filePath;   //将目录中的文件以字符串形式输出
@property (nonatomic,copy)   NSString *sourcePath;   //DownLoad目录
@property (nonatomic,copy)   NSString *path;        //Documents目录

@property (nonatomic,copy) NSString *str1;
@property (nonatomic,copy) NSString *str2;
@property (nonatomic,copy) NSString *str3;


@end
