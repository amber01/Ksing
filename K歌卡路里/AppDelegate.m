//
//  AppDelegate.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "BaseNavigationController.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    MainViewController *mainViewController = [[MainViewController alloc]init];
    
    BaseNavigationController *rootNavigationController = [[BaseNavigationController alloc]initWithRootViewController:mainViewController];
    
    self.window.rootViewController = rootNavigationController;
    
    //--------------------------------------------------
    //自定义缓存
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    self.myCache = cache;
    
    //设置缓存路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    _documentDirectory = [paths objectAtIndex:0];
    
    [self.myCache setStoragePath:[_documentDirectory stringByAppendingPathComponent:@"resource"]];
    //设置缓存方式，目前是只要有本地缓存，就先读取本地的
    [self.myCache setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];
    
    //---------------------------------------------------
    self.path = NSHomeDirectory();//主目录
    NSLog(@"NSHomeDirectory:%@",self.path);
    
    //在这里获取应用程序Documents文件夹里的文件及文件夹列表
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    _sourcePath = [NSString stringWithFormat:@"%@/DownLoad",documentDir];
    
    NSError *error = nil;
    _fileList = [[NSArray alloc] init];
    //fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
    _fileList = [fileManager contentsOfDirectoryAtPath:_sourcePath error:&error];
    //以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in _fileList) {
        NSString *path = [_sourcePath stringByAppendingPathComponent:file];
        [fileManager fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
        _filePath = [NSString stringWithString:file];
        //NSLog(@"filestring:%@",_filePath);  //输出DownLoad目录里面的文件名
    }
    
    //创建一个录音record文件夹
    if(![fileManager fileExistsAtPath:_filePath]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"record"];
        [fileManager createDirectoryAtPath:directryPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:directryPath contents:nil attributes:nil];
    }
    
    //在Documents目录中创建一个plist文件
    if(![fileManager fileExistsAtPath:_documentDirectory]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"RecordList.plist"];
        [fileManager createFileAtPath:directryPath contents:nil attributes:nil];
    }
    
    //在Documents目录中创建一个plist文件
    if(![fileManager fileExistsAtPath:_documentDirectory]){//如果不存在,则说明是第一次运行这个程序，那么建立这个文件夹
        NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSString *directryPath = [path stringByAppendingPathComponent:@"UserInfoList.plist"];
        [fileManager createFileAtPath:directryPath contents:nil attributes:nil];
    }
    
    [self.window makeKeyAndVisible];
    [self testString];
    
    return YES;
}


- (void)testString
{
    self.str1 = @"hello everbody";
    self.str2 = @"value";
    /*
     NSMutableString *string = [[NSMutableString alloc]init];
     [string appendString:@"hell everbody with Jack"];
     
     NSRange range = [string rangeOfString:@"Jack"];
     
     [string deleteCharactersInRange:range];
     
     NSLog(@"%@",string);
     */
    //NSArray *myArray = [NSArray arrayWithObjects:@"one",@"two",@"three",self.window, nil];
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.str1,@"122",self.str2,@"332", nil];
    //NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.str1,@"332", nil];
    //NSDictionary *dict = @{@"332": self.str1,@"222": self.str2};
    NSMutableDictionary *dict = [NSMutableDictionary new];
    [dict setObject:self.str1 forKey:@"332"];
    //NSString *str = [dict objectForKey:@"222"];
    //[dict removeObjectForKey:@"332"];
    NSArray *str = dict[@"332"];
    NSLog(@"%@",str);
    
}

//通过该方法调用第三方的软件，如QQ等
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [TencentOAuth HandleOpenURL:url];
}

//应用和应用之间的调用
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [TencentOAuth HandleOpenURL:url];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

//禁止横屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
