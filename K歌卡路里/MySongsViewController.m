//
//  MySongsViewController.m
//  K歌卡路里
//
//  Created by amber on 14/12/16.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "MySongsViewController.h"
#import "MySongsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "CategoryListViewController.h"

@interface MySongsViewController ()

@end

@implementation MySongsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"录音列表";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate   = self;
    [self.view addSubview:_tableView];
    
    urlStr = @"http://120.27.49.100:8000/res/cover/";
    songStr = @"http://120.27.49.100:8000/res/mp3/";
    
    UIEdgeInsets inset;
    inset.left = 0;
    [_tableView setSeparatorInset:inset];
    [self setExtraCellLineHidden:_tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self initData];
    self.navigationController.navigationBarHidden = NO;
    
    //判断录音的plist文件中是否有录音歌曲，如果没有的话就显示一张图片
    NSString *songName = [[_root allValues]objectAtIndex:0][@"songName"];
    [self backView];
    if (songName.length == 0) {
        [self initSingBtnView];
    }else{
        [view removeFromSuperview];
    }
}

//自定义navigation上的返回按钮
- (void)backView
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  //自定义返回按钮
    button.frame = CGRectMake(0, 0, 30, 40);
    [button setImage:[UIImage imageNamed:@"naviBack_image.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = backItem;
}

#pragma mark -- UI
- (void)initSingBtnView
{
    view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:view];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(ScreenWidth/2 - 70, ScreenHeight / 2 - 25, 140, 40);
    [loginBtn setBackgroundImage:[UIImage imageNamed:@"loginImageBtn.png"] forState:UIControlStateNormal];
    [loginBtn setTitle:@"去唱歌" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(singAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginBtn];
    
    UILabel *singLable = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeight/2 + 20, ScreenWidth, 40)];
    singLable.textColor = [UIColor grayColor];
    singLable.font = [UIFont systemFontOfSize:16];
    singLable.textAlignment = UITextAlignmentCenter;
    singLable.text = @"录音空荡荡的,赶快去唱一首吧";
    [view addSubview:singLable];
}

#pragma mark -- data
- (void)initData
{
    NSString *plistPath = [NSString stringWithFormat:@"%@/RecordList.plist",self.appDelegate.documentDirectory];
    self.root = [[[NSDictionary alloc]initWithContentsOfFile:plistPath]mutableCopy];
    /*
     for (NSString *key in [_root allKeys]) {
     NSDictionary *dic = _root[key];
     NSString *recordName = dic[@"recordName"];
     NSString *songName = dic[@"songName"];
     
     NSLog(@"recordName:%@",recordName);
     NSLog(@"songNmae:%@",songName);
     
     }
     */
}

#pragma mark -- actions
- (void)playAction:(UIButton *)button
{
    
    _singOverVC = [[SingOverViewController alloc]init];
    NSString *songName = [[_root allValues]objectAtIndex:button.tag][@"songName"];
    NSString *recordName = [[_root allValues]objectAtIndex:button.tag][@"recordName"];
    NSString *recordTime = [[_root allValues]objectAtIndex:button.tag][@"recordTime"];
    NSString *songID = [[_root allValues]objectAtIndex:button.tag][@"songID"];
    NSString *singerName = [[_root allValues]objectAtIndex:button.tag][@"singerName"];
    
    
    self.singOverVC.songID = songID;
    self.singOverVC.songsName = songName;
    self.singOverVC.singerName = singerName;
    self.singOverVC.recordID = recordName;
    
    [kNavigationController pushViewController:_singOverVC animated:YES];
    
    //NSLog(@"songName:%@",songName);
    
}

- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)singAction
{
    CategoryListViewController *categryListVC = [[CategoryListViewController alloc]init];
    [kNavigationController pushViewController:categryListVC animated:YES];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.root allValues].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    MySongsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[MySongsTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    _singOverVC = [[SingOverViewController alloc]init];
    NSString *songName = [[_root allValues]objectAtIndex:indexPath.row][@"songName"];
    NSString *recordTime = [[_root allValues]objectAtIndex:indexPath.row][@"recordTime"];
    NSString *songID = [[_root allValues]objectAtIndex:indexPath.row][@"songID"];
    
    NSString *songImageName = [NSString  stringWithFormat:@"%@%@.jpg",urlStr,songID];
    [cell.imageView setImageWithURL:[NSURL URLWithString:songImageName]placeholderImage:[UIImage imageNamed:@"default_CDimage.png"]];
    
    cell.textLabel.text = songName;
    cell.detailTextLabel.text = recordTime;
    
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake(ScreenWidth - 75, 19, 55, 28);
    [playButton setBackgroundImage:[UIImage imageNamed:@"songDownload_Butnon.png"] forState:UIControlStateNormal];
    [playButton setTitle:@"播放" forState:UIControlStateNormal];
    playButton.titleLabel.font = [UIFont systemFontOfSize:13];
    [playButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playAction:) forControlEvents:UIControlEventTouchUpInside];
    //[cell.contentView addSubview:playButton];
    cell. accessoryView = playButton;
    playButton.tag = indexPath.row;
    
    return cell;
}

#pragma mark -- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *songName = [[_root allValues]objectAtIndex:indexPath.row][@"songName"];
    NSLog(@"songName:%@",songName);
}

//是否允许cell编辑，如删除等操作
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//点击编辑或删除时的事件
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //[dataArray removeObjectAtIndex:indexPath.row];
        // Delete the row from the data source.
        //[testTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        NSLog(@"删除");
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
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
    self.navigationController.navigationBarHidden = YES;  //是否隐藏navigationBar
    self.navigationItem.leftBarButtonItem = nil;
}

//清除UITableView底部多余的分割线
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
