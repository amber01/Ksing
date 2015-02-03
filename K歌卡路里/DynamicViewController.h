//
//  DynamicViewController.h
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "AppDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "LoginUserModel.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "MySpaceViewController.h"

@interface DynamicViewController : BaseViewController<TencentSessionDelegate,UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate>
{
    UIView *view;
    UITableView  *_tableView;
    ASIFormDataRequest  *_loadRequest;
    MySpaceViewController   *mySpaceVC;
    AppDelegate         *appDelegate;
    UIView              *tipsView;
}

@property (nonatomic,retain)TencentOAuth *tencentOAuth;
@property (nonatomic,retain)NSArray      *permissions; //置应用需要用户授权的API列表
@property (nonatomic,retain)LoginUserModel *loginUser;
@property (nonatomic,retain)NSDictionary *root;

- (void)addUserOpenID:(NSString *)openidKey opeinIDValue:(NSString *)opeinIDValue;

@end
