//
//  SettingViewController.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"设置";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    self.tencentOAuth = [[TencentOAuth alloc]initWithAppId:appKey andDelegate:self];
    //_tencentOAuth.redirectURI = @"www.qq.com";  //这里需要填写注册APP时填写的域名。默认可以不用填写。建议不用填写。
    self.loginUser = [[LoginUserModel alloc]init];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"SettingList" ofType:@"plist"];
    self.dataDic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.data = [NSArray arrayWithArray:[self.dataDic allKeys]];
    
    //self.data = @[@"注册登录",@"分享设置",@"意见反馈",@"关于K歌卡路里"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initSourchPath];
}

#pragma mark -- UI
- (void)initCellView:(UITableViewCell *)cell
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 42)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    [cell.contentView addSubview:view];
}

#pragma mark -- Data
- (void)initSourchPath
{
    NSString *plistPath = [SourcePathModel sourcePath:@"/UserInfoList.plist"];
    self.root = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    NSString *openid = [[_root allValues]objectAtIndex:0][@"openid"];
    if (openid.length > 0) {
        UIButton *button = (UIButton *)[self.view viewWithTag:102];
        [button setTitle:@"退出" forState:UIControlStateNormal];
    } else if (openid.length == 0){
        UIButton *button = (UIButton *)[self.view viewWithTag:101];
        [button addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
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

#pragma mark -- UITableViewDataSource
//section表中包含row行的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *data =  [_dataDic objectForKey:[_data objectAtIndex:section]];
    return [data count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSArray *data = [_dataDic objectForKey:[self.data objectAtIndex:indexPath.section]];
    NSString *listName = [data objectAtIndex:indexPath.row];
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        cell.imageView.image = [UIImage imageNamed:@"loginInfo_Image"];
    }else if (indexPath.row == 1 && indexPath.section == 0){
        cell.imageView.image = [UIImage imageNamed:@"versionCheck_Image.png"];
    }else if (indexPath.row == 0 && indexPath.section == 1){
        cell.imageView.image = [UIImage imageNamed:@"idea_Image.png"];
    }else if (indexPath.row == 1 && indexPath.section == 1){
        cell.imageView.image = [UIImage imageNamed:@"about_Image.png"];
    }
    cell.textLabel.text = listName;
    return cell;
}

//显示每个section中的内容，如:A、B、C
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return self.data[section]; //显示每个section中的内容
    return nil;
}


//自定义section的view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [self viewShow:section];
}

- (UIView *)viewShow:(NSInteger)section
{
    NSString *plistPath = [SourcePathModel sourcePath:@"/UserInfoList.plist"];
    self.root = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    NSString *openid = [[_root allValues]objectAtIndex:0][@"openid"];
    if (section == 1) {
        if (openid.length == 0) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 92)];
            view.backgroundColor = [UIColor clearColor];
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.frame = CGRectMake(20, 30, ScreenWidth - 40, 40);
            [loginBtn setBackgroundImage:[UIImage imageNamed:@"singBtn_image"] forState:UIControlStateNormal];
            [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
            loginBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
            loginBtn.tag = 101;
            [view addSubview:loginBtn];
            return view;
        }else if (openid.length > 0){
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 92)];
            view.backgroundColor = [UIColor clearColor];
            UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            logoutBtn.frame = CGRectMake(20, 30, ScreenWidth - 40, 40);
            [logoutBtn setBackgroundImage:[UIImage imageNamed:@"singBtn_image"] forState:UIControlStateNormal];
            [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
            logoutBtn.titleLabel.font = [UIFont systemFontOfSize:17];
            [logoutBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
            logoutBtn.tag = 102;
            [view addSubview:logoutBtn];
            return view;
        }
    }
    return nil;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"平台信息" message:@"你现在是用QQ平台登录的哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"版本检测" message:@"你现在的版本为0.1.0,目前为最新版本哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

//表示section Header的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {  //让第1个section高度为50，其他为25；
        return 20;
    }
    return 10;
}

//表色section Footer的高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return 92;
    }else{
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark -- action
- (void)loginAction:(UIButton *)button
{
    NSString *plistPath = [SourcePathModel sourcePath:@"/UserInfoList.plist"];
    self.root = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    NSString *openid = [[_root allValues]objectAtIndex:0][@"openid"];

    UIButton *loginBtn = (UIButton *)[self.view viewWithTag:101];
    UIButton *logoutBtn = (UIButton *)[self.view viewWithTag:102];
    if (loginBtn.tag == 101) {
        if (openid.length > 0) {
            [logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录确认" message:@"你已经成功登陆了" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }else if (openid.length ==  0){
        _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
        [_tencentOAuth authorize:_permissions inSafari:NO];
        }
    }else if (logoutBtn.tag == 102 && openid.length > 0)
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"退出确认" message:@"你已成功登录了,确定退出当前账户吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else if (logoutBtn.tag == 102 && openid.length == 0){
        _permissions = [NSArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo", @"add_t", nil];
        [_tencentOAuth authorize:_permissions inSafari:NO];
    }
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

#pragma mark --UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString *plistPath = [SourcePathModel sourcePath:@"/UserInfoList.plist"];
        [SourcePathModel deleteSingleFile:plistPath];
        UIButton *button = (UIButton *)[self.view viewWithTag:102];
        [button setTitle:@"登录" forState:UIControlStateNormal];
    }
}

#pragma mark -- TencentSessionDelegate
//登录成功后调用
- (void)tencentDidLogin
{
    if ([_tencentOAuth getUserInfo]) {
        
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
