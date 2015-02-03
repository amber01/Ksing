//
//  MySpaceViewController.h
//  K歌卡路里
//
//  Created by amber on 15/1/28.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "BaseViewController.h"
#import "ASIHTTPRequest.h"

@interface MySpaceViewController : UITableViewController<ASIHTTPRequestDelegate>
{
    ASIHTTPRequest   *_request;
    NSData           *imageData;
    NSTimer          *timer;
}

@property (nonatomic,retain)NSDictionary  *dicData;
@property (nonatomic,retain)NSArray       *data;
@property (nonatomic,retain)NSDictionary       *root;

@property (nonatomic,copy)NSString  *openid;
@property (nonatomic,copy)NSString  *nickname;
@property (nonatomic,copy)NSString  *gender;
@property (nonatomic,copy)NSString  *figureurl;
@property (nonatomic,copy)NSString  *city;
@property (nonatomic,copy)NSString  *age;

- (void)initUser:(NSString *)openid;

@end
