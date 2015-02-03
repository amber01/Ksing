//
//  MyViewController.h
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "SingOverViewController.h"
#import "MySpaceViewController.h"
#import "SourcePathModel.h"

@interface MyViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}

@property (nonatomic,retain)NSArray  *data;
@property (nonatomic,retain)NSDictionary  *dataDic;
@property (nonatomic,retain)NSArray  *imagesArr;
@property (nonatomic,retain)NSDictionary  *imageDic;
@property (nonatomic,retain)NSDictionary  *root;
@property (nonatomic,retain)MySpaceViewController *mySpaceVC;


@end
