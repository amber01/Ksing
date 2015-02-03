//
//  DynamicViewController.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "DynamicViewController.h"

@interface DynamicViewController ()

@end

@implementation DynamicViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"好友动态";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:appKey andDelegate:self];
    //_tencentOAuth.redirectURI = @"www.qq.com";  //这里需要填写注册APP时填写的域名。默认可以不用填写。建议不用填写。
    self.loginUser = [[LoginUserModel alloc]init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [view removeFromSuperview];
    [tipsView removeFromSuperview];
    [self comparePlistValue];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- UI
- (void)initLoginView
{
    if (ScreenHeight >= 568) {
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 49)];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginImageI5BG.png"]];
        imageView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight - 49);
        [self.view addSubview:view];
        [view addSubview:imageView];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(ScreenWidth/2 - 70, ScreenHeight - 180, 140, 40);
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginImageBtn.png"] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:loginBtn];
    }else if (ScreenHeight == 480){
        view = [[UIView alloc]initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 49)];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loginImageBG.png"]];
        imageView.frame = CGRectMake(0, 20, ScreenWidth, ScreenHeight - 49);
        [self.view addSubview:view];
        [view addSubview:imageView];
        
        UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        loginBtn.frame = CGRectMake(ScreenWidth/2 - 70, ScreenHeight - 190, 140, 40);
        [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginImageBtn.png"] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        [loginBtn addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:loginBtn];
    }
    
    UILabel *loginLable = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 115, ScreenHeight - 145, 240, 40)];
    loginLable.textColor = [UIColor grayColor];
    loginLable.font = [UIFont systemFontOfSize:16];
    loginLable.text = @"登录之后才能看到你的小伙伴哦";
    [view addSubview:loginLable];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 49 - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)initTipsView
{
    tipsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:tipsView];
    
    UIButton *imageFansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageFansBtn.frame =  CGRectMake(108, 105, 105, 105);
    [imageFansBtn setImage:[UIImage imageNamed:@"addFans_image"] forState:UIControlStateNormal];
    [imageFansBtn addTarget:self action:@selector(addFansAction) forControlEvents:UIControlEventTouchUpInside];
    [tipsView addSubview:imageFansBtn];
    
    UIImageView *imageTextView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"addFansText_image"]];
    imageTextView.frame = CGRectMake(50, 240, 457/2,205/2);
    [tipsView addSubview:imageTextView];
    
    UIButton *addFansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addFansBtn.frame = CGRectMake(ScreenWidth/2 - 70, ScreenHeight - 125, 140, 40);
    [addFansBtn setBackgroundImage:[UIImage imageNamed:@"loginImageBtn.png"] forState:UIControlStateNormal];
    [addFansBtn setTitle:@"找朋友" forState:UIControlStateNormal];
    [addFansBtn addTarget:self action:@selector(addFansAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addFansBtn];
    
    view.hidden = YES;
}

#pragma mark -- HTTP
- (void)loadRequest
{
    NSString *urlStr = @"http://120.27.49.100:8000/api/user/add_user/";
    NSURL *url = [NSURL URLWithString:urlStr];
    _loadRequest = [ASIFormDataRequest requestWithURL:url];
    [_loadRequest setRequestMethod:@"POST"];
    [_loadRequest setPostValue:self.loginUser.openid forKey:@"openid"];
    [_loadRequest setPostValue:self.loginUser.nickname forKey:@"nickname"];
    [_loadRequest setPostValue:self.loginUser.gender forKey:@"gender"];
    [_loadRequest setPostValue:self.loginUser.figureurl forKey:@"figureurl"];
    [_loadRequest setPostValue:self.loginUser.city forKey:@"city"];
    [_loadRequest setDelegate:self];
    [_loadRequest startAsynchronous];
}

#pragma mark -- data
- (void)setPostValue
{
    self.loginUser.openid = [_tencentOAuth openId];
}

- (void)onClickLogout
{
    
}

/**
 *  登录成功后将openID通过存储到本地plist文件中
 *
 *  @return
 */

- (void)addUserOpenID:(NSString *)openidKey opeinIDValue:(NSString *)opeinIDValue
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    NSString *dicplistpath = [NSString stringWithFormat:@"%@/UserInfoList.plist",documentDir];
    
    NSMutableDictionary *dic = [[NSMutableDictionary dictionaryWithContentsOfFile:dicplistpath]mutableCopy];
    
    if (dic == nil) {
        NSMutableDictionary *rootdicplist=[[NSMutableDictionary alloc]init];
        //定义第一个Dictionary集合
        NSMutableDictionary *childPlist=[[NSMutableDictionary alloc]init];
        [childPlist setObject:opeinIDValue forKey:openidKey];
        
        //添加到根集合中
        [rootdicplist setObject:childPlist forKey:@"openid"];
        //写入文件
        [rootdicplist writeToFile:dicplistpath atomically:YES];
    }else{
        NSMutableDictionary *childPlist=[[NSMutableDictionary alloc]init];
        [childPlist setObject:opeinIDValue forKey:openidKey];
        //添加到根集合中
        [dic setObject:childPlist forKey:@"openid"];
        //写入文件
        [dic writeToFile:dicplistpath atomically:YES];
    }
}

/**
 *  判断本地的UserOpenid.plist文件中是否存在openid
 */
- (void)comparePlistValue
{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    NSString *plistPath = [NSString stringWithFormat:@"%@/UserInfoList.plist",documentDir];
    
    self.root = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    NSString *openid = [[_root allValues]objectAtIndex:0][@"openid"];
    if (openid.length == 0) {
        [self initLoginView];
    }else{
        [self initTipsView];
    }
}

#pragma mark -- actions
- (void)loginAction
{
    _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
    [_tencentOAuth authorize:_permissions inSafari:NO];
}

- (void)addFansAction
{
    
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 33;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifyCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifyCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifyCell];
    }
    cell.textLabel.text = @"one";
    return cell;
}

#pragma mark -- ASIHTTPRequestDelegate
- (void) requestFinished:(ASIHTTPRequest *)request {
    
    //返回信息
    NSLog(@"Response %d : %@", request.responseStatusCode, [request responseString]);
    
    //NSData *responseData = [request responseData];
}

- (void) requestStarted:(ASIHTTPRequest *) request {
    NSLog(@"request started...");
}

- (void) requestFailed:(ASIHTTPRequest *) request {
    NSError *error = [request error];
    NSLog(@"%@", error);
}


#pragma mark -- TencentSessionDelegate
//登录成功后调用
- (void)tencentDidLogin
{
    if ([_tencentOAuth getUserInfo]) {
        //[self initTableView];
        [self initTipsView];
        
        NSLog(@"登录完成");
        NSLog(@"accessToken:%@",[_tencentOAuth accessToken]);
        NSLog(@"openID:%@",[_tencentOAuth openId]);
        NSString *openid = [_tencentOAuth openId];
        [self addUserOpenID:@"openid" opeinIDValue:openid];
    }
    //[self setPostValue];
   /*
    if (_tencentOAuth.accessToken && 0 != [_tencentOAuth.accessToken length])
    {
        // 记录登录用户的OpenID、Token以及过期时间
        _labelAccessToken.text = _tencentOAuth.accessToken;
    }
    else
    {
        _labelAccessToken.text = @"登录不成功 没有获取accesstoken";
    }
    */
}

//非网络错误导致登录失败
-(void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled)
    {
        //_labelTitle.text = @"用户取消登录";
        NSLog(@"用户取消登录");
    }
    else
    {
        //_labelTitle.text = @"登录失败";
        NSLog(@"登录失败");
    }
}

//网络情况下登录失败
-(void)tencentDidNotNetWork
{
    //_labelTitle.text=@"无网络连接，请设置网络";
    NSLog(@"无网络连接，请设置网络");
}

- (void)getUserInfoResponse:(APIResponse*) response
{
    if (response.retCode == URLREQUEST_SUCCEED)
    {
        self.loginUser.nickname = [response.jsonResponse objectForKey:@"nickname"];
        self.loginUser.gender = [response.jsonResponse objectForKey:@"gender"];
        self.loginUser.figureurl = [response.jsonResponse objectForKey:@"figureurl_qq_2"];
        self.loginUser.city = [response.jsonResponse objectForKey:@"city"];
        self.loginUser.age  = [response.jsonResponse objectForKey:@"year"];
        self.loginUser.openid = [_tencentOAuth openId];
        
        NSLog(@"openid:%@",self.loginUser.openid);
        NSLog(@"nickname:%@",self.loginUser.nickname);
        NSLog(@"gender:%@",self.loginUser.gender);
        NSLog(@"figureurl:%@",self.loginUser.figureurl);
        NSLog(@"city:%@",self.loginUser.city);
        NSLog(@"city:%@",self.loginUser.age);
        [self loadRequest];
    }
    //NSLog(@"%@",response.jsonResponse);
}


#pragma mark -- other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
