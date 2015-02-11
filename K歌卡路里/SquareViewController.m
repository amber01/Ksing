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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

#pragma mark -- UI
- (void)initTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
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

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserSongListCellTableViewCell";
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
