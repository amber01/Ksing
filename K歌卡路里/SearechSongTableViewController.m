//
//  SearechSongTableViewController.m
//  K歌卡路里
//
//  Created by amber on 14-9-26.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SearechSongTableViewController.h"
#import "MainViewController.h"
#import "SingViewController.h"


@interface SearechSongTableViewController ()

@end

@implementation SearechSongTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(backAction:) name:kPopViewControllerNotification object:nil];
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.toolbarHidden = NO;
    
    [self toolbarShow];

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self barImage];
    //[self showText];

    NSLog(@"%f",self.view.height);
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.navigationController.toolbarHidden = YES;
}

#pragma mark -- UI

- (void)toolbarShow
{
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"toolbar_back.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(backAction)];
    
    NSArray *items = @[backItem];
    
    self.navigationController.toolbar.frame = CGRectMake(0, self.view.height - 49, self.view.width, 49);
    self.toolbarItems = items;
}

- (void)barImage
{
    _barImageVeiw = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barView_image.png"]];
    _barImageVeiw.frame = CGRectMake(0, 0, 100, 100);
    self.data = @[_barImageVeiw,@"hello"];
    [cell.contentView addSubview:_barImageVeiw];
    
    UIImageView * _barImageVeiw1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barView_image.png"]];
    _barImageVeiw1.frame = CGRectMake(110, 0, 100, 100);
    self.data = @[_barImageVeiw1,@"hello"];
    [cell.contentView addSubview:_barImageVeiw1];

    UIImageView * _barImageVeiw2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barView_image.png"]];
    _barImageVeiw2.frame = CGRectMake(220, 0, 100, 100);
    self.data = @[_barImageVeiw,@"hello"];
    [cell.contentView addSubview:_barImageVeiw2];
}

- (void)showText
{
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 58)];
    textView.text = @"每个人心中都有一个自己的小曲库，即使K歌的次数早已多的数不清，而那些曾经给予你感动、带给你力量、让你热泪盈眶的歌曲，仍然时常会在你的耳边响起.....";
    textView.editable = NO;
    textView.textColor = [UIColor grayColor];
    [cell.contentView addSubview:textView];
}

- (void)backAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}



//加载到该页面时,给ManViewController发一条通知，让界面显示自定义toolbar
/*
- (void)toobarShow
{
    [[NSNotificationCenter defaultCenter]postNotificationName:kTabBarShowNotification object:nil];
}
 */

#pragma mark -- actions
//接受一条通知，toolbar中的cancel时返回到上一次
- (void)backAction:(NSNotification *)notification
{
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter]postNotificationName:kHiddenToobbarShowl object:nil];

}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.data count] + 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SearechSongTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone; //选择cell取消选中
        
        switch (indexPath.row) {
            case 0:
                [self barImage];
                break;
            case 1:
                [self showText];
                break;
            case 2:
                cell.textLabel.text = @"千年等一回";
                break;
            case 3:
                cell.textLabel.text = @"最重要的小事";
                break;
            case 4:
                cell.textLabel.text = @"隐形的翅膀";
                break;
            case 5:
                cell.textLabel.text = @"燕尾蝶";
                break;
            case 6:
                cell.textLabel.text = @"广岛之恋";
                break;
            case 7:
                cell.textLabel.text = @"明天会更好";
                break;
            case 8:
                cell.textLabel.text = @"伤心的人别听慢歌";
                break;
            case 9:
                _barImageVeiw = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barView_image.png"]];
                _barImageVeiw.frame = CGRectMake(0, 0, self.view.width, 130);
                [cell.contentView addSubview:_barImageVeiw];
                break;
            case 10:
                cell.imageView.image = [UIImage imageNamed:@"002.png"];
                break;
            default:
                break;
        }
        
    }
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    }else if(indexPath.row == 1){
        return 70;
    }else{
        return 40;
    }
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIToolbar *toobar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 340, self.view.width, 44)];
    
    [self.view addSubview:toobar];
    return toobar;
}
*/

//移除通知
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
