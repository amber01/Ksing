//
//  SettingViewController.h
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SourcePathModel.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "LoginUserModel.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface SettingViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,TencentSessionDelegate,ASIHTTPRequestDelegate>
{
    UITableView *_tableView;
    ASIFormDataRequest  *_loadRequest;
}

@property (nonatomic,retain)NSArray  *data;
@property (nonatomic,retain)NSDictionary *dataDic;
@property (nonatomic,retain)NSMutableDictionary *root;
@property (nonatomic,retain)TencentOAuth *tencentOAuth;
@property (nonatomic,retain)NSArray      *permissions; //置应用需要用户授权的API列表
@property (nonatomic,retain)LoginUserModel *loginUser;


- (void)addUserOpenID:(NSString *)openidKey opeinIDValue:(NSString *)opeinIDValue;

@end
