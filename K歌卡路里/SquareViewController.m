//
//  HomeViewController.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SquareViewController.h"
#import "SongListViewController.h"
#import "SecondViewController.h"
#import "BaseNavigationController.h"
#import "SingOverViewController.h"
#import "GirlSingerViewController.h"
#import "UserSongListCellTableViewCell.h"
#import "SingOverViewController.h"
#import "MJRefresh.h"

NSString *const CellIdentifier = @"UserSongListCellTableViewCell";

@interface SquareViewController ()

@end

@implementation SquareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"热门作品";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initTableView];
    [self initData];
    
    [self setupRefresh];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- UI
- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0 , ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //_tableView.backgroundColor = [UIColor orangeColor];
    _tableView.backgroundColor = [UIColor colorWithRed:227/255.0 green:226/255.0 blue:234/255.0 alpha:1];
    //_tableView.allowsSelection = NO;
    //_tableView.delaysContentTouches = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //分割线隐藏
    [self.view addSubview:_tableView];
}

#pragma mark -- data
- (void)initData
{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"SongList" ofType:@"plist"];
    self.data = [NSArray arrayWithContentsOfFile:plistPath];
}

#pragma mark -- MJRefresh
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [_tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    //[self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [_tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    _tableView.headerPullToRefreshText = @"下拉可以刷新";
    _tableView.headerReleaseToRefreshText = @"松开立即刷新";
    _tableView.headerRefreshingText = @"正在加载数据中";
    
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据";
    _tableView.footerReleaseToRefreshText = @"松开立即加载更多数据";
    _tableView.footerRefreshingText = @"正在加载数据中...";
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    // 1.添加假数据
    NSLog(@"开始加载");

    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        NSLog(@"加载完成");
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    // 1.添加假数据
    NSLog(@"开始加载");
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [_tableView footerEndRefreshing];
        NSLog(@"加载完成");
    });
    
}

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UserSongListCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[[NSBundle mainBundle]loadNibNamed:@"UserSongListCellTableViewCell" owner:self options:nil]lastObject];
    }
    
    NSDictionary *dataDic = [self.data objectAtIndex:indexPath.row];
    NSString *score = [NSString stringWithFormat:@"得分: %@",[dataDic  objectForKey:@"score"]];
    NSString *kaclCount = [NSString stringWithFormat:@"卡路里消耗: %@",[dataDic  objectForKey:@"kaclCount"]];
    
    cell.score.text = score;
    cell.kaclCount.text = kaclCount;
    cell.userName.text = [dataDic objectForKey:@"userName"];
    cell.city.text = [dataDic objectForKey:@"city"];
    cell.sign.text = [dataDic objectForKey:@"sign"];
    cell.recordDate.text = [dataDic objectForKey:@"recordDate"];
    cell.songName.text = [dataDic objectForKey:@"songName"];
    cell.avatarView.image = [UIImage imageNamed:[dataDic objectForKey:@"figureurl"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 195;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SingOverViewController *singOverVC = [[SingOverViewController alloc]init];
    [kNavigationController pushViewController:singOverVC animated:YES];
    NSLog(@"row:%d",indexPath.row);
}



#pragma mark -- other
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
