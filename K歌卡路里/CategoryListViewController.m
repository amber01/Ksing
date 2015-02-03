//
//  CategoryListViewController.m
//  K歌卡路里
//
//  Created by amber on 14/11/25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "CategoryListViewController.h"
#import "PopSongListViewController.h"
#import "ClassicSongsListViewController.h"
#import "SchoolSongListViewController.h"
#import "ClassicSongViewController.h"
#import "RockSongListViewController.h"
#import "LoveSongListViewController.h"
#import "CantoneseSongListViewController.h"
#import "ChildSongListViewController.h"
#import "GodSongListViewController.h"
#import "EuropeAmSongListViewController.h"
#import "JapanKorSongListViewController.h"
#import "AnimeSongListViewController.h"

@interface CategoryListViewController ()

@end

@implementation CategoryListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"分类点歌";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorColor = [UIColor clearColor];  //分割线颜色
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

#pragma mark -- UI
- (void)oneButtonView
{
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.frame = CGRectMake(0, 5, 105, 105);
    [popButton setImage:[UIImage imageNamed:@"pop_image.png"] forState:UIControlStateNormal];
    UILabel *popLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 110, 70, 30)];
    popLable.text = @"流行歌曲";
    popLable.font = [UIFont systemFontOfSize:14];
    popLable.textColor = [UIColor blackColor];
    [popButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *classicButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classicButton.frame = CGRectMake(108, 5, 105, 105);
    [classicButton setImage:[UIImage imageNamed:@"classic_image.png"] forState:UIControlStateNormal];
    UILabel *classicLable = [[UILabel alloc]initWithFrame:CGRectMake(134, 110, 70, 30)];
    classicLable.text = @"经典名曲";
    classicLable.font = [UIFont systemFontOfSize:14];
    classicLable.textColor = [UIColor blackColor];
    [classicButton addTarget:self action:@selector(classicAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *conutryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    conutryButton.frame = CGRectMake(216, 5, 105, 105);
    [conutryButton setImage:[UIImage imageNamed:@"countryMusic_image.png"] forState:UIControlStateNormal];
    UILabel *conutryLable = [[UILabel alloc]initWithFrame:CGRectMake(244, 110, 70, 30)];
    conutryLable.text = @"校园民谣";
    conutryLable.font = [UIFont systemFontOfSize:14];
    conutryLable.textColor = [UIColor blackColor];
    [conutryButton addTarget:self action:@selector(conutryAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.contentView addSubview:classicButton];
    [_cell.contentView addSubview:classicLable];
    [_cell.contentView addSubview:conutryButton];
    [_cell.contentView addSubview:conutryLable];
    [_cell.contentView addSubview:popLable];
    [_cell.contentView addSubview:popButton];
}

- (void)twoButtonView
{
    UIButton *classicSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classicSongButton.frame = CGRectMake(0, 0, 105, 105);
    [classicSongButton setImage:[UIImage imageNamed:@"classicSong_image.png"] forState:UIControlStateNormal];
    UILabel *classicSongLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 110, 70, 30)];
    classicSongLable.text = @"经典歌曲";
    classicSongLable.font = [UIFont systemFontOfSize:14];
    classicSongLable.textColor = [UIColor blackColor];
    [classicSongButton addTarget:self action:@selector(classicSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *rockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rockButton.frame = CGRectMake(108, 0, 105, 105);
    [rockButton setImage:[UIImage imageNamed:@"rock_image.png"] forState:UIControlStateNormal];
    UILabel *rockLable = [[UILabel alloc]initWithFrame:CGRectMake(134, 110, 70, 30)];
    rockLable.text = @"摇滚天堂";
    rockLable.font = [UIFont systemFontOfSize:14];
    rockLable.textColor = [UIColor blackColor];
    [rockButton addTarget:self action:@selector(rockAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *loveSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loveSongButton.frame = CGRectMake(216, 0, 105, 105);
    [loveSongButton setImage:[UIImage imageNamed:@"loveSong_image.png"] forState:UIControlStateNormal];
    UILabel *loveSongLable = [[UILabel alloc]initWithFrame:CGRectMake(244, 110, 70, 30)];
    loveSongLable.text = @"情歌对唱";
    loveSongLable.font = [UIFont systemFontOfSize:14];
    loveSongLable.textColor = [UIColor blackColor];
    [loveSongButton addTarget:self action:@selector(loveSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.contentView addSubview:rockButton];
    [_cell.contentView addSubview:rockLable];
    [_cell.contentView addSubview:loveSongButton];
    [_cell.contentView addSubview:loveSongLable];
    [_cell.contentView addSubview:classicSongButton];
    [_cell.contentView addSubview:classicSongLable];

}

- (void)threeButtonView
{
    UIButton *cantoneseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cantoneseButton.frame = CGRectMake(0, 0, 105, 105);
    [cantoneseButton setImage:[UIImage imageNamed:@"cantonese_image.png"] forState:UIControlStateNormal];
    UILabel *cantoneseLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 110, 70, 30)];
    cantoneseLable.text = @"粤语歌曲";
    cantoneseLable.font = [UIFont systemFontOfSize:14];
    cantoneseLable.textColor = [UIColor blackColor];
    [cantoneseButton addTarget:self action:@selector(cantonesAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *childSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    childSongButton.frame = CGRectMake(108, 0, 105, 105);
    [childSongButton setImage:[UIImage imageNamed:@"childSong_image.png"] forState:UIControlStateNormal];
    UILabel *childSongLable = [[UILabel alloc]initWithFrame:CGRectMake(134, 110, 70, 30)];
    childSongLable.text = @"儿童歌曲";
    childSongLable.font = [UIFont systemFontOfSize:14];
    childSongLable.textColor = [UIColor blackColor];
    [childSongButton addTarget:self action:@selector(childSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *godSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    godSongButton.frame = CGRectMake(216, 0, 105, 105);
    [godSongButton setImage:[UIImage imageNamed:@"godSong_image.png"] forState:UIControlStateNormal];
    UILabel *godSongLable = [[UILabel alloc]initWithFrame:CGRectMake(244, 110, 70, 30)];
    godSongLable.text = @"经典神曲";
    godSongLable.font = [UIFont systemFontOfSize:14];
    godSongLable.textColor = [UIColor blackColor];
    [godSongButton addTarget:self action:@selector(godSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.contentView addSubview:godSongButton];
    [_cell.contentView addSubview:godSongLable];
    [_cell.contentView addSubview:childSongButton];
    [_cell.contentView addSubview:childSongLable];
    [_cell.contentView addSubview:cantoneseLable];
    [_cell.contentView addSubview:cantoneseButton];
    
}

- (void)fourButtonView
{
    UIButton *europeAmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    europeAmButton.frame = CGRectMake(0, 0, 105, 105);
    [europeAmButton setImage:[UIImage imageNamed:@"europeAm_image.png"] forState:UIControlStateNormal];
    UILabel *europeAmLable = [[UILabel alloc]initWithFrame:CGRectMake(25, 110, 70, 30)];
    europeAmLable.text = @"欧美经典";
    europeAmLable.font = [UIFont systemFontOfSize:14];
    europeAmLable.textColor = [UIColor blackColor];
    [europeAmButton addTarget:self action:@selector(europeAmAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *japanKorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    japanKorButton.frame = CGRectMake(108, 0, 105, 105);
    [japanKorButton setImage:[UIImage imageNamed:@"japanKor_image.png"] forState:UIControlStateNormal];
    UILabel *japanLable = [[UILabel alloc]initWithFrame:CGRectMake(134, 110, 70, 30)];
    japanLable.text = @"日韩经典";
    japanLable.font = [UIFont systemFontOfSize:14];
    japanLable.textColor = [UIColor blackColor];
    [japanKorButton addTarget:self action:@selector(japanKorAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *animeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    animeButton.frame = CGRectMake(216, 0, 105, 105);
    [animeButton setImage:[UIImage imageNamed:@"anime_image.png"] forState:UIControlStateNormal];
    UILabel *animeLable = [[UILabel alloc]initWithFrame:CGRectMake(244, 110, 70, 30)];
    animeLable.text = @"动漫歌曲";
    animeLable.font = [UIFont systemFontOfSize:14];
    animeLable.textColor = [UIColor blackColor];
    [animeButton addTarget:self action:@selector(animeAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_cell.contentView addSubview:europeAmButton];
    [_cell.contentView addSubview:europeAmLable];
    [_cell.contentView addSubview:japanKorButton];
    [_cell.contentView addSubview:japanLable];
    [_cell.contentView addSubview:animeLable];
    [_cell.contentView addSubview:animeButton];
    
}

#pragma mark -- actions
- (void)popAction
{
    PopSongListViewController *popSngListVC = [[PopSongListViewController alloc]init];
    [kNavigationController pushViewController:popSngListVC animated:YES];
}

- (void)classicAction
{
    ClassicSongsListViewController *classicSongListVC = [[ClassicSongsListViewController alloc]init];
    [kNavigationController pushViewController:classicSongListVC animated:YES];
}

- (void)conutryAction
{
    SchoolSongListViewController *schoolSongListVC = [[SchoolSongListViewController alloc]init];
    [kNavigationController pushViewController:schoolSongListVC animated:YES];
}

- (void)classicSongAction
{
    ClassicSongViewController *classicSongsListVC = [[ClassicSongViewController alloc]init];
    [kNavigationController pushViewController:classicSongsListVC animated:YES];
}

- (void)rockAction
{
    RockSongListViewController *rockSongListVC = [[RockSongListViewController alloc]init];
    [kNavigationController pushViewController:rockSongListVC animated:YES];
}

- (void)loveSongAction
{
    LoveSongListViewController *loveSongListVC = [[LoveSongListViewController alloc]init];
    [kNavigationController pushViewController:loveSongListVC animated:YES];
}

- (void)cantonesAction
{
    CantoneseSongListViewController *cantoneseSongListVC = [[CantoneseSongListViewController alloc]init];
    [kNavigationController pushViewController:cantoneseSongListVC animated:YES];
}

- (void)childSongAction
{
    ChildSongListViewController *childSongListVC = [[ChildSongListViewController alloc]init];
    [kNavigationController pushViewController:childSongListVC animated:YES];
}

- (void)godSongAction
{
    GodSongListViewController *gadSongListVC = [[GodSongListViewController alloc]init];
    [kNavigationController pushViewController:gadSongListVC animated:YES];
}

- (void)europeAmAction
{
    EuropeAmSongListViewController *europeAmSongListVC = [[EuropeAmSongListViewController alloc]init];
    [kNavigationController pushViewController:europeAmSongListVC animated:YES];
}

- (void)japanKorAction
{
    JapanKorSongListViewController *japanKorSongListVC = [[JapanKorSongListViewController alloc]init];
    [kNavigationController pushViewController:japanKorSongListVC animated:YES];
}

- (void)animeAction
{
    AnimeSongListViewController *animeSongListVC = [[AnimeSongListViewController alloc]init];
    [kNavigationController pushViewController:animeSongListVC animated:YES];
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    _cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (_cell == nil) {
        _cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
        case 0:
            [self oneButtonView];
            break;
        case 1:
            [self twoButtonView];
            break;
        case 2:
            [self threeButtonView];
            break;
        case 3:
            [self fourButtonView];
            break;
        default:
            break;
    }
    return _cell;
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}


@end
