//
//  MyViewController.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "MyViewController.h"
#import "MySongsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CategoryListViewController.h"
#import "MySongsViewController.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"我的";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSBundle从包路径去读取
    NSString *path = [[NSBundle mainBundle]pathForResource:@"MyList" ofType:@"plist"];
    self.dataDic = [NSDictionary dictionaryWithContentsOfFile:path];
    self.data = [NSArray arrayWithArray:[self.dataDic allKeys]];  //拿到字典里面所有的key
    //self.data = @[@"录音列表",@"关注",@"粉丝",@"找歌曲",@"找朋友",@"个人信息"];
    //让数组排序方法，就是让列表中按照ABCD这样方式排序
    self.data = [self.data sortedArrayUsingSelector:@selector(compare:)];
    
    NSString *imagePath = [[NSBundle mainBundle]pathForResource:@"ImageBtnList" ofType:@"plist"];
    self.imageDic = [NSDictionary dictionaryWithContentsOfFile:imagePath];
    self.imagesArr = [NSArray arrayWithArray:[_imageDic allKeys]];  //拿到字典里面所有的key
    
    //_imagesArr = @[@"recordList.png",@"meComm.png",@"meFans.png",@"findSongs.png",@"addFriend.png",@"meInfo.png"];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
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

/*
 //自定义section的背景
 - (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
 {
 NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
 if (sectionTitle == nil) {
 return  nil;
 }
 
 UIView * sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 10)];
 UIColor *color = [UIColor colorWithRed:241/255.0 green:240/255.0 blue:246/255.0 alpha:1];
 [sectionView setBackgroundColor:color];
 return sectionView;
 }
 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    NSArray *data = [_dataDic objectForKey:[self.data objectAtIndex:indexPath.section]];
    NSString *listName = [data objectAtIndex:indexPath.row];
    
    NSArray *array = [_imageDic objectForKey:[self.imagesArr objectAtIndex:indexPath.section]];
    NSString *images = [array objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images];
    
    cell.textLabel.text = listName;
    
    return cell;
}

//显示每个section中的内容，如:A、B、C
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //return self.data[section]; //显示每个section中的内容
    return nil;
}

#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MySongsViewController *mySongsVC = [[MySongsViewController alloc]init];
    NSString *plistPath = [SourcePathModel sourcePath:@"/UserInfoList.plist"];
    self.root = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    NSString *openid = [[_root allValues]objectAtIndex:0][@"openid"];
    if(indexPath.row == 0 && indexPath.section == 0){
        
        if (openid.length >0) {
            self.mySpaceVC = [[MySpaceViewController alloc]init];
            [kNavigationController pushViewController:self.mySpaceVC animated:YES];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录确认" message:@"你需要登录才能看到我的空间哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if (indexPath.row == 1 && indexPath.section == 0) {
        [kNavigationController pushViewController:mySongsVC animated:YES];
    }else if (indexPath.row == 0 && indexPath.section == 1) {
        if (openid.length >0) {
            NSLog(@"关注");
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录确认" message:@"你需要登录才看到我的关注哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if (indexPath.row == 1 && indexPath.section == 1) {
        if (openid.length > 0){
            NSLog(@"粉丝");
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登录确认" message:@"你需要登录才看到我的粉丝哦" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
    }else if (indexPath.row == 0 && indexPath.section == 2)
    {
        CategoryListViewController *categoryListVC = [[CategoryListViewController alloc]init];
        [kNavigationController pushViewController:categoryListVC animated:YES];
    }else if (indexPath.row == 1 && indexPath.section == 2){
        NSLog(@"找朋友");
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
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

#pragma mark -- other
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
