//
//  MaleSingerViewController.m
//  K歌卡路里
//
//  Created by amber on 15/1/22.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "MaleSingerViewController.h"

@interface MaleSingerViewController ()

@end

@implementation MaleSingerViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"男歌手";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initURL];
    [self initTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- UI
- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark -- data
- (void)initURL
{
    NSString *urlStr = @"http://120.27.49.100:8000/api/get_songs_by_gender/?gender=0";
    NSURL    *url = [[NSURL alloc]initWithString:urlStr];
    _request = [[ASIHTTPRequest alloc]initWithURL:url];
    _request.delegate = self;
    [_request setRequestMethod:@"GET"];
    [_request setTimeOutSeconds:60];
    [_request startAsynchronous];
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    NSLog(@"count:%d",self.data.count);
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    NSDictionary *dic = [self.data objectAtIndex:indexPath.row];
    _singger   = [dic objectForKey:@"singer"];
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  //cell的右侧箭头样式
    UIColor *color = [UIColor colorWithRed:39.0/255.0 green:39.0/255.0 blue:39.0/255.0 alpha:1.0];
    cell.textLabel.textColor = color;
    cell.textLabel.text = _singger;
    
    return cell;
}

#pragma mark -- ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSData *responseData = [request responseData];
    self.data = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
    [_tableView reloadData];
        
    for (int i = 0;i < self.data.count; i++) {
        NSDictionary *dic = [self.data objectAtIndex:i];
        _songName  = [dic objectForKey:@"name"];
        _singger   = [dic objectForKey:@"singer"];
        _songID = [dic objectForKey:@"id"];
        
        //NSLog(@"%@",_singger);
    }
}

//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    NSLog(@"请求网络出错：%@",error);
    UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"请求超时，请确定网络是否正常" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView1 show];
}

#pragma mark -- other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
