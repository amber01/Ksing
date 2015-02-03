//
//  StarSongViewController.m
//  K歌卡路里
//
//  Created by amber on 15/1/22.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "StarSongViewController.h"
#import "MaleSingerViewController.h"
#import "GirlSingerViewController.h"
#import "GroupSingerViewController.h"
#import "AllSingerViewController.h"

@interface StarSongViewController ()

@end

@implementation StarSongViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.title = @"歌星点歌";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableView];
    [self setExtraCellLineHidden:_tableView];
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

#pragma mark -- UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString  *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;  //cell的右侧箭头样式
    UIColor *color = [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
    cell.textLabel.textColor = color;
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"男歌手";
            break;
        case 1:
            cell.textLabel.text = @"女歌手";
            break;
        case 2:
            cell.textLabel.text = @"组合";
            break;
        case 3:
            cell.textLabel.text = @"全部";
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        MaleSingerViewController *maleSingerVC = [[MaleSingerViewController alloc]init];
        [kNavigationController pushViewController:maleSingerVC animated:YES];
    }else if (indexPath.row == 1){
        GirlSingerViewController *girlSingerVC = [[GirlSingerViewController alloc]init];
        [kNavigationController pushViewController:girlSingerVC animated:YES];
    }else if (indexPath.row == 2){
        GroupSingerViewController *groupSingerVC = [[GroupSingerViewController alloc]init];
        [kNavigationController pushViewController:groupSingerVC animated:YES];
    }else{
        AllSingerViewController *allSingerVC = [[AllSingerViewController alloc]init];
        [kNavigationController pushViewController:allSingerVC animated:YES];
    }
}

#pragma mark -- other
//清除UITableView底部多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
