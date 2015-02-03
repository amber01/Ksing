//
//  MySpaceViewController.m
//  K歌卡路里
//
//  Created by amber on 15/1/28.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "MySpaceViewController.h"
#import "XHPathCover.h"
#import "UIImageView+WebCache.h"
#import "SDWebImageDownloader.h"
#import "StarSongViewController.h"
#import "CategoryListViewController.h"

@interface MySpaceViewController () {
    
}
@property (nonatomic, strong) XHPathCover *pathCover;

@end

@implementation MySpaceViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        self.title = @"我的空间";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backView];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(startLoadingImage) userInfo:nil repeats:YES];
    
    UIColor *backColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    self.tableView.backgroundColor = backColor;
    
    self.tableView.allowsSelection = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //分割线隐藏
    _pathCover = [[XHPathCover alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 180)];
    [_pathCover setBackgroundImage:[UIImage imageNamed:@"MenuBackground"]];
    self.tableView.tableHeaderView = self.pathCover;
    [_pathCover setAvatarImage:[UIImage imageNamed:@"defaultAvata_image"]];
    MySpaceViewController *wself = self;
    [_pathCover setHandleRefreshEvent:^{
        [wself _refreshing];
    }];
}

- (void)_refreshing {
    // refresh your data sources
    
    MySpaceViewController *wself = self;
    double delayInSeconds = 4.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [wself.pathCover stopRefresh];
    });
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
    [self comparePlistValue];
}

#pragma mark -- UI
- (void)backView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  //自定义返回按钮
    button.frame = CGRectMake(0, 0, 30, 40);
    [button setImage:[UIImage imageNamed:@"naviBack_image.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

- (void)initButtonView:(UITableViewCell *)cell
{
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 420)];
    UIColor *backColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    btnView.backgroundColor = backColor;
    [cell.contentView addSubview:btnView];
    UIColor *textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    
    UILabel *dynamicLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 40, 30)];
    dynamicLabel.textColor = textColor;
    dynamicLabel.font = [UIFont systemFontOfSize:14];
    dynamicLabel.textAlignment = NSTextAlignmentCenter;
    dynamicLabel.text = @"90";
    
    UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 40, 30)];
    recordLabel.textColor = textColor;
    recordLabel.font = [UIFont systemFontOfSize:14];
    recordLabel.textAlignment = NSTextAlignmentCenter;
    recordLabel.text = @"23";
    
    UILabel *careLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 40, 30)];
    careLabel.textColor = textColor;
    careLabel.font = [UIFont systemFontOfSize:14];
    careLabel.textAlignment = NSTextAlignmentCenter;
    careLabel.text = @"23";
    
    UILabel *fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 40, 30)];
    fansLabel.textColor = textColor;
    fansLabel.font = [UIFont systemFontOfSize:14];
    fansLabel.textAlignment = NSTextAlignmentCenter;
    fansLabel.text = @"23";
    
    UIColor *color = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    UIView *linkView1 = [[UIView alloc]init];
    linkView1.frame = CGRectMake(0, 15, 0.5, 30);
    linkView1.backgroundColor = color;
    
    UIView *linkView2 = [[UIView alloc]init];
    linkView2.frame = CGRectMake(0, 15, 0.5, 30);
    linkView2.backgroundColor = color;
    
    UIView *linkView = [[UIView alloc]init];
    linkView.frame = CGRectMake(0, 15, 0.5, 30);
    linkView.backgroundColor = color;
    
    UIView *linkView3 = [[UIView alloc]init];
    linkView3.frame = CGRectMake(0, 124.5, ScreenWidth, 0.5);
    linkView3.backgroundColor = color;
    
    UIView *linkView4 = [[UIView alloc]init];
    linkView4.frame = CGRectMake(72, 0, ScreenWidth, 0.7);
    linkView4.backgroundColor = color;
    
    UIView *linkView8 = [[UIView alloc]init];
    linkView8.frame = CGRectMake(72, 0, ScreenWidth, 0.7);
    linkView8.backgroundColor = color;

    UIView *linkView9 = [[UIView alloc]init];
    linkView9.frame = CGRectMake(72, 0, ScreenWidth, 0.7);
    linkView9.backgroundColor = color;
    
    UIView *linkView10 = [[UIView alloc]init];
    linkView10.frame = CGRectMake(0, 254+110+55, ScreenWidth, 1);
    linkView10.backgroundColor = color;
    
    UIView *linkView5 = [[UIView alloc]init];
    linkView5.frame = CGRectMake(0, 125+55+55, ScreenWidth, 0.7);
    linkView5.backgroundColor = color;
    
    UIView *linkView6 = [[UIView alloc]init];
    linkView6.frame = CGRectMake(0, 254.3, ScreenWidth, 0.7);
    linkView6.backgroundColor = color;
    
    UIView *linkView7 = [[UIView alloc]init];
    linkView7.frame = CGRectMake(0, 224.5+55, ScreenWidth, 0.5);
    linkView7.backgroundColor = color;
    
    UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamicBtn.frame = CGRectMake(0, 0, 81, 115/2);
    [dynamicBtn setImage:[UIImage imageNamed:@"dynamicBtn_image"] forState:UIControlStateNormal];
    [dynamicBtn addTarget:self action:@selector(dynamicAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake(80.5, 0, 80, 115/2);
    [recordBtn setImage:[UIImage imageNamed:@"recordBtn_image"] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    careBtn.frame = CGRectMake(160.5, 0, 80, 115/2);
    [careBtn setImage:[UIImage imageNamed:@"careBtn_image"] forState:UIControlStateNormal];
    [careBtn addTarget:self action:@selector(careAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fansBtn.frame = CGRectMake(240.5, 0, 80, 115/2);
    [fansBtn setImage:[UIImage imageNamed:@"fansBtn_image"] forState:UIControlStateNormal];
    [fansBtn addTarget:self action:@selector(fansAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *singBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singBtn.frame = CGRectMake(30, 70, ScreenWidth - 60, 42);
    [singBtn setBackgroundImage:[UIImage imageNamed:@"singBtn_image"] forState:UIControlStateNormal];
    [singBtn setTitle:@"去唱歌" forState:UIControlStateNormal];
    singBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [singBtn addTarget:self action:@selector(singAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cellBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn1.frame = CGRectMake(0, 125, ScreenWidth, 55);
    [cellBtn1 setBackgroundImage:[UIImage imageNamed:@"cellView_image"] forState:UIControlStateNormal];
    [cellBtn1 addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *findSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findSongBtn.frame = CGRectMake(14, 7.5, 40, 40);
    [findSongBtn setImage:[UIImage imageNamed:@"findSongs"] forState:UIControlStateNormal];
    [findSongBtn addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *findSongLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 7.5, 80, 40)];
    findSongLabel.text = @"找歌曲";
    findSongLabel.textColor = textColor;
    findSongLabel.font = [UIFont systemFontOfSize:18];

    
    UIButton *cellBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn2.frame = CGRectMake(0, 124.5+55, ScreenWidth, 55);
    [cellBtn2 setBackgroundImage:[UIImage imageNamed:@"cellView_image"] forState:UIControlStateNormal];
    [cellBtn2 addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *findfriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    findfriendBtn.frame = CGRectMake(14, 7.5, 40, 40);
    [findfriendBtn setImage:[UIImage imageNamed:@"addFriend"] forState:UIControlStateNormal];
    [findfriendBtn addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *findfriendLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 7.5, 80, 40)];
    findfriendLabel.text = @"找朋友";
    findfriendLabel.textColor = textColor;
    findfriendLabel.font = [UIFont systemFontOfSize:18];

    
    UIButton *cellBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn3.frame = CGRectMake(0, 255, ScreenWidth, 55);
    [cellBtn3 setBackgroundImage:[UIImage imageNamed:@"cellView_image"] forState:UIControlStateNormal];
    [cellBtn3 addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *recordBigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBigBtn.frame = CGRectMake(14, 7.5, 40, 40);
    [recordBigBtn setImage:[UIImage imageNamed:@"recordList"] forState:UIControlStateNormal];
    [recordBigBtn addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *recordBigLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 7.5, 80, 40)];
    recordBigLabel.text = @"录音列表";
    recordBigLabel.textColor = textColor;
    recordBigLabel.font = [UIFont systemFontOfSize:18];

    
    UIButton *cellBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn4.frame = CGRectMake(0, 254.5+55, ScreenWidth, 55);
    [cellBtn4 setBackgroundImage:[UIImage imageNamed:@"cellView_image"] forState:UIControlStateNormal];
    [cellBtn4 addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];

    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(14, 7.5, 40, 40);
    [shareBtn setImage:[UIImage imageNamed:@"loginInfo_Image"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 7.5, 80, 40)];
    shareLabel.text = @"平台信息";
    shareLabel.textColor = textColor;
    shareLabel.font = [UIFont systemFontOfSize:18];

    
    UIButton *cellBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    cellBtn5.frame = CGRectMake(0, 254+110, ScreenWidth, 55);
    [cellBtn5 setBackgroundImage:[UIImage imageNamed:@"cellView_image"] forState:UIControlStateNormal];
    [cellBtn5 addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *hotSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hotSongBtn.frame = CGRectMake(14, 7.5, 40, 40);
    [hotSongBtn setImage:[UIImage imageNamed:@"hotSong_icon"] forState:UIControlStateNormal];
    [hotSongBtn addTarget:self action:@selector(findSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *hotSongLabel = [[UILabel alloc]initWithFrame:CGRectMake(72, 7.5, 80, 40)];
    hotSongLabel.text = @"热门歌曲";
    hotSongLabel.textColor = textColor;
    hotSongLabel.font = [UIFont systemFontOfSize:18];
    
    [btnView addSubview:dynamicBtn];
    [btnView addSubview:recordBtn];
    [btnView addSubview:careBtn];
    [btnView addSubview:fansBtn];
    [btnView addSubview:singBtn];
    [btnView addSubview:linkView3];
    [btnView addSubview:linkView4];
    [btnView addSubview:linkView5];
    [btnView addSubview:linkView6];
    [btnView addSubview:linkView7];
    [btnView addSubview:linkView10];

    [recordBtn addSubview:linkView];
    [careBtn addSubview:linkView1];
    [fansBtn addSubview:linkView2];
    [dynamicBtn addSubview:dynamicLabel];
    [recordBtn addSubview:recordLabel];
    [careBtn addSubview:careLabel];
    [fansBtn addSubview:fansLabel];
    [cellBtn2 addSubview:linkView4];
    [cellBtn4 addSubview:linkView8];
    [cellBtn5 addSubview:linkView9];
    [btnView addSubview:cellBtn1];
    [btnView addSubview:cellBtn2];
    [btnView addSubview:cellBtn3];
    [btnView addSubview:cellBtn4];
    [btnView addSubview:cellBtn5];
    [cellBtn1 addSubview:findSongBtn];
    [cellBtn1 addSubview:findSongLabel];
    [cellBtn2 addSubview:findfriendBtn];
    [cellBtn2 addSubview:findfriendLabel];
    [cellBtn3 addSubview:recordBigBtn];
    [cellBtn3 addSubview:recordBigLabel];
    [cellBtn4 addSubview:shareBtn];
    [cellBtn4 addSubview:shareLabel];
    [cellBtn5 addSubview:hotSongBtn];
    [cellBtn5 addSubview:hotSongLabel];
}

#pragma mark -- data
- (void)initUser:(NSString *)openid
{
    NSString *urlStr = [NSString stringWithFormat:@"http://120.27.49.100:8000/api/user/get_user/?openid=%@",openid];
    NSURL *url = [NSURL URLWithString:urlStr];
    _request = [ASIHTTPRequest requestWithURL:url];
    [_request setRequestMethod:@"GET"];
    [_request setTimeOutSeconds:60];
    _request.delegate = self;
    [_request startAsynchronous];
}

- (void)comparePlistValue
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    NSString *plistPath = [NSString stringWithFormat:@"%@/UserInfoList.plist",documentDir];
    
    self.root = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    self.openid = [[self.root allValues]objectAtIndex:0][@"openid"];
    [self initUser:self.openid];
}

- (void)loadImageQueueInit
{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    NSInvocationOperation *op = [[NSInvocationOperation alloc]initWithTarget:self selector:@selector(downLoadImage) object:nil];
    [queue addOperation:op];
}

#pragma mark -- action
- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)dynamicAction
{
    
}

- (void)recordAction
{
    
}

- (void)careAction
{
    
}

- (void)fansAction
{
    
}

- (void)singAction
{
    StarSongViewController *starSongVC = [[StarSongViewController alloc]init];
    [kNavigationController pushViewController:starSongVC animated:YES];
}

- (void)findSongAction
{
    CategoryListViewController *categoryListVC = [[CategoryListViewController alloc]init];
    [kNavigationController pushViewController:categoryListVC animated:YES];
}

#pragma mark- scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [_pathCover scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_pathCover scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [_pathCover scrollViewWillBeginDragging:scrollView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify =  [NSString stringWithFormat:@"cell%d",indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.row == 0) {
        [self initButtonView:cell];
    }
    return cell;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 400;
    }
    return 65;
}

#pragma mark -- ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    self.dicData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    
    self.nickname = [self.dicData objectForKey:@"nickname"];
    self.gender = [self.dicData objectForKey:@"gender"];
    self.figureurl = [self.dicData objectForKey:@"figureurl"];
    self.city  =  [self.dicData objectForKey:@"city"];
    
    [_pathCover setInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.nickname, XHUserNameKey,self.city, XHBirthdayKey, nil]];
    [self loadImageQueueInit];
    
     //UIImageView *image = [[UIImageView alloc]init];
     //[image setImageWithURL:[NSURL URLWithString:self.figureurl]];
     //[_pathCover setAvatarImage:image.image];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)downLoadImage
{
    NSURL  *imageURL = [NSURL URLWithString:self.figureurl];
    imageData = [NSData dataWithContentsOfURL:imageURL];
}
- (void)startLoadingImage
{
    [_pathCover setAvatarImage:[UIImage imageWithData:imageData]];
}

#pragma mark -- other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [_request cancel];
    [timer invalidate];
    timer = nil;
}

@end
