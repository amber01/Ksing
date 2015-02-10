//
//  SongListViewController.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SongListViewController.h"
#import "SearechSongTableViewController.h"
#import "SongsTableViewCell.h"
#import "SingViewController.h"
#import "SecondViewController.h"
#import "CategoryListViewController.h"
#import "UIImageView+WebCache.h"
#import "SongListTableViewCell.h"
#import "SDWebImageDownloader.h"
#import "SingViewController.h"
#import "MySongsViewController.h"
#import "SearchResultViewController.h"
#import "PopSongListViewController.h"
#import "NewSongListViewController.h"
#import "RockSongListViewController.h"
#import "EuropeAmSongListViewController.h"
#import "HotSongListViewController.h"
#import "TopSongListViewController.h"
#import "LoveSongListViewController.h"
#import "JapanKorSongListViewController.h"
#import "ThemeOneSongViewController.h"
#import "ThemeTwoSongViewController.h"
#import "ThemeThreeSongViewController.h"
#import "ThemeFourSongViewController.h"
#import "ThemeFiveSongViewController.h"


#define kLoadLableNotification @"kLoadLableNotification"
#define FileSavePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define kDeviceHeight [UIScreen mainScreen].bounds.size.height

@interface SongListViewController ()

@end

@implementation SongListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"选歌开唱";
        isLoadData = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.delaysContentTouches = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;  //分割线隐藏
    _tableView.tag = 2001;
    
    _searchTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _searchTableView.dataSource = self;
    _searchTableView.delegate = self;
    _searchTableView.tag = 2002;
    
    urlStr = @"http://120.27.49.100:8000/res/cover/";
    songStr = @"http://120.27.49.100:8000/res/mp3/";
    lrcStr  = @"http://120.27.49.100:8000/res/lrc/";
    
    filesPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DownLoad"];
    NSArray *pathsArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathsArray objectAtIndex:0];
    //NSLog(@"%@",documentsDirectory);
    
    [self downloadPath];
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"HotSongsList" ofType:@"plist"];
    self.dataDic = [NSDictionary dictionaryWithContentsOfFile:path];
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f -_tableView.bounds.size.height, _tableView.bounds.size.width, _tableView.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    self.refreshHeader = YES;  //开启下拉刷新的功能
    [_refreshHeaderView refreshLastUpdatedDate];
    
    //自定义分割线
    for (int i = 0; i < 5; i++) {
        UIView * separator = [[UIView alloc] initWithFrame:CGRectMake(0, (i+4) * 60 +40+560+20 /* i乘以高度*/, ScreenWidth, 0.5)];
        separator.backgroundColor = [UIColor colorWithRed:205/255.0 green:208/255.0 blue:212/255.0 alpha:1];
        [_tableView addSubview:separator];
    }
    [_cell addSubview:_tableView];
    [self.view addSubview:_tableView];
    [self searchView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _tableView.hidden = NO;
    //self.navigationController.navigationBarHidden = NO;  //是否隐藏navigationBar
}

#pragma mark --initURL
//搜索返回数据
- (void)searchResult:(NSString *)songNameStr
{
    NSString * encodingStr = [songNameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; //将中文转换为UTF-8
    self.searchURL = [NSString stringWithFormat:@"http://120.27.49.100:8000/api/song/search/?keyword=%@",encodingStr];
    //NSLog(@"searchResult%@",self.searchURL);
    NSURL *url = [NSURL URLWithString:self.searchURL];
    _request = [ASIHTTPRequest requestWithURL:url];
    _request.tag = 1004;
    _request.delegate = self;
    [_request setRequestMethod:@"GET"];
    [_request setTimeOutSeconds:60];
    [_request startAsynchronous];
}

#pragma mark -- UI
- (void)navigationView
{
    naviView = [[UIView alloc]init];
    naviView.frame = CGRectMake(0, 0, ScreenWidth, 281+560+20 - 44);
    naviView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:naviView];
    [_cell.contentView addSubview:naviView];
    //[self searchButton];
    [self showNews];
    [self hotSongView];
    [self buttonView];
    [self oneButtonView];
    [self twoButtonView];
    [self threeButtonView];
    [self fourButtonView];
}

- (void)searchButton
{
    _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _searchButton.frame = CGRectMake(ScreenWidth - 45, 10, 24, 24);
    [_searchButton setImage:[UIImage imageNamed:@"searchButton.png"] forState:UIControlStateNormal];
    [naviView addSubview:_searchButton];
}

- (void)searchView
{
    _searechBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width
                                                                , 44)];
    _searechBar.delegate = self;
    _searechBar.backgroundColor = [UIColor redColor];
    _searechBar.backgroundColor = [UIColor clearColor];
    _searechBar.barStyle = UIBarStyleDefault;
    _searechBar.showsBookmarkButton = YES;  //右侧是否显示一个搜索按钮
    //自定义搜索框内的button
    
    [_searechBar setImage:[UIImage imageNamed:@"SearchIcon.png"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateNormal];
    [_searechBar setImage:[UIImage imageNamed:@"SearchIcon_highli.png"] forSearchBarIcon:UISearchBarIconBookmark state:UIControlStateHighlighted];
    
    UIImage *img = [[UIImage imageNamed:@"navigation_view.png"] stretchableImageWithLeftCapWidth:1 topCapHeight:0];
    [_searechBar setBackgroundImage:img];  //设置searchBar背景颜色
    
    //[_searechBar setBarTintColor:[UIColor clearColor]];
    //[self searchHeight:_searechBar];
    _searechBar.placeholder = @"请输入想唱的歌曲";
    //UISearchDisplayController会自带一个UISearchBar的
    searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searechBar contentsController:self];
    searchDisplayController.active = NO;
    searchDisplayController.delegate = self;
    searchDisplayController.searchResultsDataSource = self;
    searchDisplayController.searchResultsDelegate = self;
    
    _tableView.tableHeaderView = _searechBar;
    [self lineView];
}

- (void)lineView
{
    _imageLineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"userinfo_header_separator.png"]];
    _imageLineView.frame = CGRectMake(-10, 0, 350, 1);
    
    _imageNewsLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"userinfo_header_separator.png"]];
    _imageNewsLine.frame = CGRectMake(-10, 85-44, 350, 1);
    
    [naviView addSubview:_imageLineView];
}

- (void)hotSongView
{
    UIView *hotSongView = [[UIView alloc]initWithFrame:CGRectMake(0, 218+40+560+10-44, ScreenWidth, 20)];
    hotSongView.backgroundColor = [UIColor whiteColor];
    [naviView addSubview:hotSongView];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(17, 5, 100, 20)];
    label.text = @"热门推荐";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:12];
    [hotSongView addSubview:label];
    
    UIView *iconView = [[UIView alloc]initWithFrame:CGRectMake(9, 8.5, 3, 12)];
    iconView.backgroundColor = [UIColor redColor];
    [hotSongView addSubview:iconView];
}

//展示ScrollView的一些视图
- (void)showNews
{
    ScrollViewPageControlModel *scrollViewPageview=[[ScrollViewPageControlModel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
    UIImageView *imageView1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"001.png"]];
    UIImageView *imageView2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"002.png"]];
    UIImageView *imageView3=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"003.png"]];
    UIImageView *imageView4=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"004.png"]];
    UIImageView *imageView5=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"005.png"]];
    
    scrollViewPageview.autoScrollDelayTime=3.0;
    scrollViewPageview.delegate=self;
    NSMutableArray *viewsArray=[[NSMutableArray alloc]initWithObjects:imageView1,imageView2,imageView3,imageView4,imageView5, nil];
    [scrollViewPageview setViewsArray:viewsArray];
    [naviView addSubview:scrollViewPageview];
    [scrollViewPageview shouldAutoShow:YES];
    
    /*
     UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
     scrollView.backgroundColor = [UIColor clearColor];
     //设置scroll视图显示的内容大小
     scrollView.contentSize = CGSizeMake(ScreenWidth*5, 130);
     scrollView.showsHorizontalScrollIndicator = NO; //指示器的状态
     scrollView.scrollsToTop = YES;  //当滑到最底部的时候，点击状态栏时自动返回到最顶部位置
     scrollView.pagingEnabled = YES; //出现一个翻页的效果
     scrollView.delegate = self;
     [naviView addSubview:scrollView];
     
     //将5张图片放到表视图中
     float _x = 0;
     for (int index = 0; index < 5; index ++) {
     UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+_x, 0, ScreenWidth, 130)];
     NSString *imageName = [NSString stringWithFormat:@"00%d.png",index+1];
     imageView.image = [UIImage imageNamed:imageName];
     
     [scrollView addSubview:imageView];
     _x += ScreenWidth; //表示翻页后，x坐标自动变化320的像素
     }
     
     //UIPageControl实现翻页页码标记
     UIPageControl *pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 140-44, ScreenWidth, 30)];
     [_cell.contentView addSubview:pageControl];
     pageControl.numberOfPages = 5;
     pageControl.tag = 101;
     */
}

- (void)buttonView
{
    UIButton *hotSongBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    hotSongBtn.frame = CGRectMake(22, 190-44, 35, 35);
    [hotSongBtn setImage:[UIImage imageNamed:@"findSongs.png"] forState:UIControlStateNormal];
    UILabel *hotLable = [[UILabel alloc]initWithFrame:CGRectMake(13, 230-44, 70, 30)];
    hotLable.text = @"热门歌曲";
    hotLable.textColor = [UIColor grayColor];
    hotLable.font = [UIFont systemFontOfSize:14];
    [hotSongBtn addTarget:self action:@selector(hotAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:hotSongBtn];
    [naviView addSubview:hotLable];
    
    UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    starBtn.frame = CGRectMake(67+35, 190-44, 35, 35);
    [starBtn setImage:[UIImage imageNamed:@"singer_image.png"] forState:UIControlStateNormal];
    UILabel *starLable = [[UILabel alloc]initWithFrame:CGRectMake(58+35, 230-44, 70, 30)];
    starLable.text = @"歌星点歌";
    starLable.textColor = [UIColor grayColor];
    starLable.font = [UIFont systemFontOfSize:14];
    starLable.textColor = [UIColor grayColor];
    [starBtn addTarget:self action:@selector(starSongAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:starBtn];
    [naviView addSubview:starLable];
    
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    categoryBtn.frame = CGRectMake(67+35+80, 190-44, 35, 35);
    [categoryBtn setImage:[UIImage imageNamed:@"category_image.png"] forState:UIControlStateNormal];
    UILabel *categoryLable = [[UILabel alloc]initWithFrame:CGRectMake(58+35+80, 230-44, 70, 30)];
    categoryLable.text = @"分类点歌";
    categoryLable.textColor = [UIColor grayColor];
    categoryLable.font = [UIFont systemFontOfSize:14];
    [categoryBtn addTarget:self action:@selector(categorySongAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:categoryBtn];
    [naviView addSubview:categoryLable];
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake(67+35+160, 190-44, 35, 35);
    [recordBtn setImage:[UIImage imageNamed:@"recordList.png"] forState:UIControlStateNormal];
    UILabel *recordLable = [[UILabel alloc]initWithFrame:CGRectMake(58+35+160, 230-44, 70, 30)];
    recordLable.text = @"我的录音";
    recordLable.textColor = [UIColor grayColor];
    recordLable.font = [UIFont systemFontOfSize:14];
    [recordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    [naviView addSubview:recordBtn];
    [naviView addSubview:recordLable];
}

//解决UISearchBar背景颜色是黑色
- (void)searchHeight:(UISearchBar *)mySearchBar
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if ([mySearchBar respondsToSelector:@selector(barTintColor)]) {
        float iosversion7_1 = 7.1;
        if (version >= iosversion7_1)
        {
            //iOS7.1
            [[[[mySearchBar.subviews objectAtIndex:0] subviews] objectAtIndex:0] removeFromSuperview];
            [mySearchBar setBackgroundColor:[UIColor clearColor]];
        }
        else
        {
            //iOS7.0
            [mySearchBar setBarTintColor:[UIColor clearColor]];
            [mySearchBar setBackgroundColor:[UIColor clearColor]];
        }
    }
    else
    {
        //iOS7.0以下
        [[mySearchBar.subviews objectAtIndex:0] removeFromSuperview];
        [mySearchBar setBackgroundColor:[UIColor clearColor]];
    }
    
}

- (void)oneButtonView
{
    UIButton *popButton = [UIButton buttonWithType:UIButtonTypeCustom];
    popButton.frame = CGRectMake(1.5, 280-10-44, 158, 105);
    [popButton setImage:[UIImage imageNamed:@"sing_image1.png"] forState:UIControlStateNormal];
    UILabel *popLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 387-10-44, 70, 30)];
    popLable.text = @"流行金曲";
    popLable.font = [UIFont systemFontOfSize:14];
    popLable.textColor = [UIColor blackColor];
    [popButton addTarget:self action:@selector(popAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *newSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    newSongButton.frame = CGRectMake(161, 280-10-44, 157.5, 105);
    [newSongButton setImage:[UIImage imageNamed:@"sing_image2.png"] forState:UIControlStateNormal];
    UILabel *newSongLable = [[UILabel alloc]initWithFrame:CGRectMake(175, 387-10-44, 70, 30)];
    newSongLable.text = @"新歌枪鲜";
    newSongLable.font = [UIFont systemFontOfSize:14];
    newSongLable.textColor = [UIColor blackColor];
    [newSongButton addTarget:self action:@selector(newSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    [naviView addSubview:newSongButton];
    [naviView addSubview:newSongLable];
    [naviView addSubview:popLable];
    [naviView addSubview:popButton];
}

- (void)twoButtonView
{
    UIButton *rockButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rockButton.frame = CGRectMake(1.5, 270+140-44, 158, 105);
    [rockButton setImage:[UIImage imageNamed:@"sing_image3.png"] forState:UIControlStateNormal];
    UILabel *rockLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 377+140-44, 70, 30)];
    rockLable.text = @"摇滚天堂";
    rockLable.font = [UIFont systemFontOfSize:14];
    rockLable.textColor = [UIColor blackColor];
    [rockButton addTarget:self action:@selector(rockAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *europeAmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    europeAmButton.frame = CGRectMake(161, 270+140-44, 157.5, 105);
    [europeAmButton setImage:[UIImage imageNamed:@"sing_image4.png"] forState:UIControlStateNormal];
    UILabel *europeAmLable = [[UILabel alloc]initWithFrame:CGRectMake(175, 377+140-44, 70, 30)];
    europeAmLable.text = @"欧美经典";
    europeAmLable.font = [UIFont systemFontOfSize:14];
    europeAmLable.textColor = [UIColor blackColor];
    [europeAmButton addTarget:self action:@selector(europeAmSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    [naviView addSubview:rockButton];
    [naviView addSubview:rockLable];
    [naviView addSubview:europeAmLable];
    [naviView addSubview:europeAmButton];
}

- (void)threeButtonView
{
    UIButton *hotSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    hotSongButton.frame = CGRectMake(1.5, 270+280-44, 158, 105);
    [hotSongButton setImage:[UIImage imageNamed:@"sing_image5.png"] forState:UIControlStateNormal];
    UILabel *hotSongLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 377+280-44, 70, 30)];
    hotSongLable.text = @"推荐热歌";
    hotSongLable.font = [UIFont systemFontOfSize:14];
    hotSongLable.textColor = [UIColor blackColor];
    [hotSongButton addTarget:self action:@selector(hotSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *kButton = [UIButton buttonWithType:UIButtonTypeCustom];
    kButton.frame = CGRectMake(161, 270+280-44, 157.5, 105);
    [kButton setImage:[UIImage imageNamed:@"sing_image6.png"] forState:UIControlStateNormal];
    UILabel *kLable = [[UILabel alloc]initWithFrame:CGRectMake(175, 377+280-44, 70, 30)];
    kLable.text = @"K歌金榜";
    kLable.font = [UIFont systemFontOfSize:14];
    kLable.textColor = [UIColor blackColor];
    [kButton addTarget:self action:@selector(kSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    [naviView addSubview:hotSongButton];
    [naviView addSubview:hotSongLable];
    [naviView addSubview:kButton];
    [naviView addSubview:kLable];
}

- (void)fourButtonView
{
    UIButton *loveSongButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loveSongButton.frame = CGRectMake(1.5, 270+280+140-44, 158, 105);
    [loveSongButton setImage:[UIImage imageNamed:@"sing_image7.png"] forState:UIControlStateNormal];
    UILabel *loveSongLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 377+280+140-44, 70, 30)];
    loveSongLable.text = @"情歌对唱";
    loveSongLable.font = [UIFont systemFontOfSize:14];
    loveSongLable.textColor = [UIColor blackColor];
    [loveSongButton addTarget:self action:@selector(loveSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *japanKorButton = [UIButton buttonWithType:UIButtonTypeCustom];
    japanKorButton.frame = CGRectMake(161, 270+280+140-44, 157.5, 105);
    [japanKorButton setImage:[UIImage imageNamed:@"sing_image8.png"] forState:UIControlStateNormal];
    UILabel *japanKorLable = [[UILabel alloc]initWithFrame:CGRectMake(175, 377+280+140-44, 70, 30)];
    japanKorLable.text = @"日韩经典";
    japanKorLable.font = [UIFont systemFontOfSize:14];
    japanKorLable.textColor = [UIColor blackColor];
    [japanKorButton addTarget:self action:@selector(japanKorSongAction) forControlEvents:UIControlEventTouchUpInside];
    
    [naviView addSubview:loveSongButton];
    [naviView addSubview:loveSongLable];
    [naviView addSubview:japanKorButton];
    [naviView addSubview:japanKorLable];
}


#pragma mark -- actions
- (void)songLoadAction:(UIButton *)button
{
    _songID = [[_dataDic allValues]objectAtIndex:button.tag][@"id"];
    _songName = [[_dataDic allValues]objectAtIndex:button.tag][@"name"];
    _singger = [[_dataDic allValues]objectAtIndex:button.tag][@"singer"];
    
    NSString *mp3Names = [NSString stringWithFormat:@"%@_01.mp3",self.songID];
    
    NSLog(@"%@",mp3Names);
    
    BOOL isFile = [SongListViewController isFileExist:mp3Names];
    
    
    if (button.selected == NO && isFile == NO) {
        
        button.selected = YES;
        [button setTitle:nil forState:UIControlStateNormal];
        [self startDownloadMP3:button];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifShow) name:kLoadLableNotification object:nil];
        
        loadingLabel = [[UILabel alloc]initWithFrame:CGRectMake(12, -1, 40, 30)];
        loadingLabel.textColor = [UIColor orangeColor];
        loadingLabel.text = @"0%";
        loadingLabel.textAlignment = UITextAlignmentCenter;
        loadingLabel.font = [UIFont systemFontOfSize:13];
        [button addSubview:loadingLabel];
        
    }else if (isFile == YES){
        [self currentTimeShow];
        singVC = [[SingViewController alloc]init];
        singVC.urlString = _songID;
        singVC.songsName = _songName;
        singVC.singerName = _singger;
        singVC.recordName = self.recordName;
        singVC.recordTime = self.recordTime;
        singVC.recordTimeValue = self.recordTimeValue;
        
        [button setTitle:@"演唱" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"songDownloadSelectBtn.png"] forState:UIControlStateNormal];
        [kNavigationController pushViewController:singVC animated:YES];
        //[[NSNotificationCenter defaultCenter]postNotificationName:kSendSongIDNotification object:nil];
        
    }else if (button.selected == YES)
    {
        alertView = [[UIAlertView alloc]initWithTitle:nil message:@"歌曲正在下载中,是否取消点歌?" delegate:self cancelButtonTitle:@"是" otherButtonTitles:@"否", nil];
        [alertView show];
    }
}

- (void)notifShow
{
    loadingLabel.text = _loadProgress;
    if ([loadingLabel.text isEqualToString:@"100%"]) {
        loadingLabel.text = @"演唱";
        //NSLog(@"下载完成");
        return;
    }
}

-(void)recordAction
{
    MySongsViewController *mySongsVC = [[MySongsViewController alloc]init];
    [kNavigationController pushViewController:mySongsVC animated:YES];
}

- (void)starSongAction
{
    self.starSongVC = [[StarSongViewController alloc]init];
    [kNavigationController pushViewController:self.starSongVC animated:YES];
}

- (void)categorySongAction
{
    categoryListVC = [[CategoryListViewController alloc]init];
    [kNavigationController pushViewController:categoryListVC animated:YES];
}

- (void)popAction
{
    PopSongListViewController *popSngListVC = [[PopSongListViewController alloc]init];
    [kNavigationController pushViewController:popSngListVC animated:YES];
}

-(void)newSongAction
{
    NewSongListViewController *newSongListVC= [[NewSongListViewController alloc]init];
    [kNavigationController pushViewController:newSongListVC animated:YES];
}

-(void)rockAction
{
    RockSongListViewController *rockSongListVC = [[RockSongListViewController alloc]init];
    [kNavigationController pushViewController:rockSongListVC animated:YES];
}

-(void)europeAmSongAction
{
    EuropeAmSongListViewController *europeAmSongListVC = [[EuropeAmSongListViewController alloc]init];
    [kNavigationController pushViewController:europeAmSongListVC animated:YES];
}

- (void)hotSongAction
{
    HotSongListViewController *hotSongListVC= [[HotSongListViewController alloc]init];
    [kNavigationController pushViewController:hotSongListVC animated:YES];
}

- (void)kSongAction
{
    TopSongListViewController *topSongListVC= [[TopSongListViewController alloc]init];
    [kNavigationController pushViewController:topSongListVC animated:YES];
}

- (void)loveSongAction
{
    LoveSongListViewController *loveSongListVC = [[LoveSongListViewController alloc]init];
    [kNavigationController pushViewController:loveSongListVC animated:YES];
}

-(void)japanKorSongAction
{
    JapanKorSongListViewController *japanKorSongListVC = [[JapanKorSongListViewController alloc]init];
    [kNavigationController pushViewController:japanKorSongListVC animated:YES];
}

- (void)hotAction
{
    HotSongListViewController *hotSongListVC= [[HotSongListViewController alloc]init];
    [kNavigationController pushViewController:hotSongListVC animated:YES];
}

#pragma mark -- data


- (void)startDownloadMP3:(UIButton *)button
{
    urlFileStr = [[_dataDic allValues]objectAtIndex:button.tag][@"id"];
    NSString *songFile = [NSString stringWithFormat:@"%@%@_01.mp3",songStr,urlFileStr];
    NSString *lrcFile = [NSString stringWithFormat:@"%@%@.lrc",lrcStr,urlFileStr];
    
    
    NSURL *songURL = [NSURL URLWithString:songFile];
    NSURL *lrcURL = [NSURL URLWithString:lrcFile];
    
    if (!networkQueue) {
        networkQueue = [[ASINetworkQueue alloc] init];
    }
    [networkQueue setShowAccurateProgress:YES]; // 进度精确显示
    [networkQueue setDelegate:self]; // 设置队列的代理对象
    [networkQueue setMaxConcurrentOperationCount:4];   //设置最大并发连接数，也就是同时几个任务在下载
    
    //初始化保存路径
    NSString *saveMP3Path = [FileSavePath  stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@_01.mp3",urlFileStr]];
    NSString *saveLRCPath = [FileSavePath  stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@.lrc",urlFileStr]];
    
    _loadRequest = [ASIHTTPRequest requestWithURL:songURL];
    _loadRequest.delegate = self;
    _loadRequest.tag = 1002;
    
    _loadLRCRequest = [ASIHTTPRequest requestWithURL:lrcURL];
    _loadLRCRequest.delegate = self;
    _loadLRCRequest.tag = 1003;
    
    //	//初始化临时文件路径，就是将mp3先放到DownLoad/temp/这个目录，等下载完后再放到DownLoad目录
    NSString *tempMP3Path = [FileSavePath stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/temp/%@_01.mp3.temp",urlFileStr]];
    NSString *tempLRCPath = [FileSavePath stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/temp/%@.lrc.temp",urlFileStr]];
    
    if (_loadRequest) {
        //设置文件保存路径，就是将mp3先放到DownLoad/temp/这个目录，等下载完后再放到DownLoad目录
        [_loadRequest setDownloadDestinationPath:saveMP3Path];
        //设置临时文件路径
        [_loadRequest setTemporaryFileDownloadPath:tempMP3Path];
        //设置进度条的代理,
        [_loadRequest setDownloadProgressDelegate:self];
        //设置是是否支持断点下载
        [_loadRequest setAllowResumeForFileDownloads:YES];
        
        [networkQueue addOperation:_loadRequest];  //添加队列对象
        [networkQueue go];     //开始队列
    }
    
    if (_loadLRCRequest) {
        [_loadLRCRequest setDownloadDestinationPath:saveLRCPath];
        [_loadLRCRequest setTemporaryFileDownloadPath:tempLRCPath];
        [networkQueue addOperation:_loadLRCRequest];
        [networkQueue go];
    }
    
    
    //NSLog(@"%@",songFile);
    //NSLog(@"%@",lrcFile);
}

#pragma mark -- JScrollViewViewDelegate
- (void)didClickPage:(ScrollViewPageControlModel *)view atIndex:(NSInteger)index
{
    ThemeOneSongViewController *themeOneSongVC = [[ThemeOneSongViewController alloc]init];
    ThemeTwoSongViewController *themeTwoSongVC = [[ThemeTwoSongViewController alloc]init];
    ThemeThreeSongViewController *themeThreeVC = [[ThemeThreeSongViewController alloc]init];
    ThemeFourSongViewController  *themeFourVC  = [[ThemeFourSongViewController alloc]init];
    ThemeFiveSongViewController  *themeFiveVC  = [[ThemeFiveSongViewController alloc]init];
    
    switch (index) {
        case 0:
            [kNavigationController pushViewController:themeOneSongVC animated:YES];
            break;
        case 1:
            [kNavigationController pushViewController:themeTwoSongVC animated:YES];
            break;
        case 2:
            [kNavigationController pushViewController:themeThreeVC animated:YES];
            break;
        case 3:
            [kNavigationController pushViewController:themeFourVC animated:YES];
            break;
        case 4:
            [kNavigationController pushViewController:themeFiveVC animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark -- ASIHTTPRequestDelegate
//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小，可以显示下载进度多少字节
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    if (request.tag == 1002){
        //下载新任务前清空上一个任务下载的数据量
        self.downLoadLenth = 0;
        
        double fileLenth = [[responseHeaders valueForKey:@"Content-Length"] doubleValue];
        self.fileSiz = fileLenth;
    }
}
//下载中,显示下载的进度条
- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    if (request.tag == 1002){
        self.downLoadLenth += bytes;
        double progress = self.downLoadLenth / self.fileSiz;
        _loadProgress = [NSString stringWithFormat:@"%.0f%%",progress * 100];
        //NSLog(@"%@",loadProgress);
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoadLableNotification object:nil];
    }
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    
    if (request.tag == 1004){
        NSData *responseData = [request responseData];
        self.searchData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        _songData = [self.searchData objectForKey:@"detail"];
        [self.searchDisplayController.searchResultsTableView reloadData];
        //        [_searchTableView reloadData];
        //NSLog(@"three:%@",_songData);
        /*
         for (int i = 0; i<_songData.count; i++) {
         NSDictionary *dic = [_songData objectAtIndex:i];
         _searchName  = [dic objectForKey:@"name"];
         _searchSinger   = [dic objectForKey:@"singer"];
         _searchSongID = [dic objectForKey:@"id"];
         //NSLog(@"%@",_searchName);
         }
         */
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchDisplayController.searchBar.text];
        //filterData =  [[NSArray alloc] initWithArray:[self.songData filteredArrayUsingPredicate:predicate]];
        
        //NSLog(@"==%@",filterData);
        //NSLog(@"--%@",self.songData);
    }
}

//请求失败
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSError *error = request.error;
    NSLog(@"请求网络出错：%@",error);
    if (request.tag == 1002){
        UIAlertView *alertView1 = [[UIAlertView alloc]initWithTitle:@"温馨提醒" message:@"请求超时，请点击取消重新下载" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView1 show];
    }
}

#pragma mark - UITableViewController delagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView && _songData.count >=1 && _request) {
        return _songData.count;
    }else{
        return [self.dataDic count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    _cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (_cell == nil) {
        _cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //cell.userInteractionEnabled = NO; //是否允许点击cell
    }
    /*
     //解决在tableViewCell上点击按钮延时的问题
     for (id obj in _cell.subviews)
     {
     if ([NSStringFromClass([obj class])isEqualToString:@"UITableViewCellScrollView"])
     {
     UIScrollView *scroll = (UIScrollView *) obj;
     scroll.delaysContentTouches = NO;
     break;
     }
     }
     */
    _songData = [self.searchData objectForKey:@"detail"];
    
    if (tableView.tag == 2001) {
        _cell.selectionStyle = UITableViewCellSelectionStyleNone; //cell选中颜色为无色
        //cell中显示的图片大小
        [_cell.imageView setFrame:CGRectMake(10, 5, 50, 50)];
        _cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        UIColor *color = [UIColor colorWithRed:54.0/255 green:53.0/255 blue:52.0/255 alpha:1];
        _cell.textLabel.textColor = color;
        _cell.detailTextLabel.textColor = [UIColor grayColor];
        
        //cell中显示的文字距离
        int cellHeight = _cell.frame.size.height;
        int cellWidth = _cell.frame.size.width;
        _cell.textLabel.frame = CGRectMake(70, -5 , cellWidth, cellHeight-10);
        _cell.detailTextLabel.frame = CGRectMake(70, 20, cellWidth, cellHeight-10);
        _cell.textLabel.font = [UIFont systemFontOfSize:16];
        UIColor *textColor = [UIColor colorWithRed:42.0/255.0 green:42.0/255.0 blue:42.0/255.0 alpha:1.0];
        _cell.textLabel.textColor = textColor;
        
        _songID = [[_dataDic allValues]objectAtIndex:indexPath.row][@"id"];
        _songName = [[_dataDic allValues]objectAtIndex:indexPath.row][@"name"];
        _singger = [[_dataDic allValues]objectAtIndex:indexPath.row][@"singer"];
        
        NSString *songImageName = [NSString  stringWithFormat:@"%@%@.jpg",urlStr,_songID];
        
        [_cell.imageView setImageWithURL:[NSURL URLWithString:songImageName]placeholderImage:[UIImage imageNamed:@"default_CDimage.png"]];
        _cell.textLabel.text = _songName;
        _cell.detailTextLabel.text = _singger;
        
        UIButton *songLoadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        songLoadBtn.frame = CGRectMake(ScreenWidth - 75, 16, 64, 29);
        [songLoadBtn setBackgroundImage:[UIImage imageNamed:@"songDownload_Butnon.png"] forState:UIControlStateNormal];
        [songLoadBtn setBackgroundImage:[UIImage imageNamed:@"songDownloadSelectBtn.png"] forState:UIControlStateSelected];
        [songLoadBtn setTitle:@"点歌" forState:UIControlStateNormal];
        songLoadBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        //songLoadBtn.tag = 201;
        songLoadBtn.selected = NO;
        [songLoadBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [songLoadBtn addTarget:self action:@selector(songLoadAction:) forControlEvents:UIControlEventTouchUpInside];
        //[cell.contentView addSubview:songLoadBtn];
        [_cell. contentView addSubview: songLoadBtn ];
        songLoadBtn.tag = indexPath.row;
        
        switch (indexPath.row) {
            case 0:
                [self navigationView];
                break;
            default:
                break;
        }
        
    }else if (tableView.tag == 2002 && _songData.count > 1)
        [self.view addSubview:_searchTableView];
    if (tableView == self.searchDisplayController.searchResultsTableView && _songData.count >=1) {
        //[searchDisplayController.searchResultsTableView removeFromSuperview];
        self.searchDisplayController.searchResultsTableView.allowsSelection = YES;
        self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        NSDictionary *dic = [self.songData objectAtIndex:indexPath.row];
        _searchName  = [dic objectForKey:@"name"];
        _searchSinger   = [dic objectForKey:@"singer"];
        _searchSongID = [dic objectForKey:@"id"];
        //NSLog(@"two%@",_searchName);
        
        int cellHeight = _cell.frame.size.height;
        int cellWidth = _cell.frame.size.width;
        _cell.textLabel.frame = CGRectMake(10, 0 , cellWidth, cellHeight-10);
        
        _cell.textLabel.font = [UIFont systemFontOfSize:14.5];
        UIColor *color = [UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:1.0];
        _cell.textLabel.textColor = color;
        _cell.textLabel.text = _searchName;
    }else if (_songData.count == 0 && tableView == self.searchDisplayController.searchResultsTableView)
    {
        _cell.textLabel.text = nil;
        self.searchDisplayController.searchResultsTableView.allowsSelection = NO;
        self.searchDisplayController.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        if (indexPath.row == 1) {
            _cell.textLabel.textColor = [UIColor grayColor];
            _cell.textLabel.font = [UIFont systemFontOfSize:16];
            _cell.textLabel.text = @"                 对不起,没有你要歌曲";
        }
    }
    return _cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 2001) {
        if (indexPath.row == 0) {
            return 281 + 560+20-44;
        }else if(indexPath.row == 1||indexPath.row == 2||indexPath.row == 3||indexPath.row == 4||indexPath.row == 5){
            return 60;
        }else if(indexPath.row == 6){
            return 20;
        }else{
            return 135;
        }
    }else{
        return 50;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView){
        NSDictionary *dic = [self.songData objectAtIndex:indexPath.row];
        _searchName  = [dic objectForKey:@"name"];
        _searchSinger   = [dic objectForKey:@"singer"];
        _searchSongID = [dic objectForKey:@"id"];
        
        searchResultVC = [[SearchResultViewController alloc]init];
        searchResultVC.songName = _searchName;
        searchResultVC.singer = _searchSinger;
        searchResultVC.songID = _searchSongID;
        [kNavigationController pushViewController:searchResultVC animated:YES];
    }
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView{
    tableView.rowHeight = 60.0f;
}


#pragma mark -- UISearchBarDelegate
//点击搜索框的回调,将要开始编辑，如果返回NO，则无法输入文字
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //準備搜尋前，把上面調整的TableView調整回全屏幕的狀態，如果要產生動畫效果，要另外執行animation代碼
    //_tableView.frame = CGRectMake(0, 0, 320, _tableView.frame.size.height);
    //_searchButton.hidden = NO;
    return YES;
}

//当文本开始编辑,cancel按钮自定义,
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;       //显示“取消”按钮
    
    for(id cc in [searchBar subviews])
    {
        for (UIView *views in [cc subviews]) {
            if ([NSStringFromClass(views.class)isEqualToString:@"UINavigationButton"])
            {
                UIButton *btn = (UIButton *)views;
                //btn.userInteractionEnabled = YES;  //是否禁用按钮点击
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [btn setTitle:@"           " forState:UIControlStateNormal];
                btn.enabled = YES;
                //自定义cancel按钮的图片
                [btn setBackgroundImage:[UIImage imageNamed:@"cancelButtonImage.png"] forState:UIControlStateNormal];
            }
        }
    }
}

// 注册为第一响应者
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    //NSLog(@"%s", __FUNCTION__);
    return YES;
}

// 输入结束的时候执行。
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //NSLog(@"%s", __FUNCTION__);
}

//点击Cancel按钮时触发
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    
    //NSLog(@"搜索按钮");
    //SearchResultViewController *searchResultVC = [[SearchResultViewController alloc]init];
    //[kNavigationController pushViewController:searchResultVC animated:YES];
    [searchBar resignFirstResponder];
}

//是否隐藏cancel按钮
- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    //controller.searchBar.showsCancelButton = YES;
}

// 点击键盘Search按钮时，执行。
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    // 取消第一响应者
    [searchBar resignFirstResponder];
    //NSLog(@"%s", __FUNCTION__);
}

//按钮按下时调用搜索结果
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2)
{
    //NSLog(@"%s", __FUNCTION__);
}

// 内容将要改变的时候
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text NS_AVAILABLE_IOS(3_0)
{
    // 只能输入6个字符
    /*
     if ( range.location > 5 )
     {
     return NO;
     }
     */
    //NSLog(@"%@, range= %@", text, NSStringFromRange(range));
    //NSLog(@"%s", __FUNCTION__);
    return YES;
}


// 文字内容已经改变(将input的内容返还给服务器)
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self searchResult:searchText];
    //NSLog(@"input: %@", searchText);
    //NSLog(@"%s", __FUNCTION__);
}

#pragma mark -- other
//设置下载MP3的路径
- (void)downloadPath
{
    // 创建存放路径
    //初始化Documents路径
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //初始化临时文件路径
    NSString *folderPath = [path stringByAppendingPathComponent:@"/DownLoad/temp"];
    //创建文件管理器
    fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    
    if (!fileExists) {//如果不存在说创建,因为下载时,不会自动创建文件夹
        [fileManager createDirectoryAtPath:folderPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }
}


//判断沙盒中是否有该文件存在
+ (BOOL)isFileExist:(NSString *)fileNames
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [docPaths objectAtIndex:0];
    NSString *sourcePath = [NSString stringWithFormat:@"%@/DownLoad/",documentDir];
    NSString *filesPaths = [sourcePath stringByAppendingFormat:fileNames,nil];
    BOOL result = [fileManager fileExistsAtPath:filesPaths];
    return result;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_loadRequest cancel];
    [_request cancel];
    [_loadLRCRequest cancel];
}

- (void)currentTimeShow
{
    NSDateFormatter *nsdf2=[[NSDateFormatter alloc] init];
    [nsdf2 setDateStyle:NSDateFormatterShortStyle];
    [nsdf2 setDateFormat:@"YYYYMMDDHHmmss"];
    NSString *date=[nsdf2 stringFromDate:[NSDate date]];
    self.recordName = [NSString stringWithFormat:@"%@ID%@.aac",date,_songID];
    self.recordTime = date;
    
    NSDateFormatter *nsdf3=[[NSDateFormatter alloc] init];
    [nsdf3 setDateStyle:NSDateFormatterShortStyle];
    [nsdf3 setDateFormat:@"MM-dd HH:mm"];
    NSString *date2=[nsdf3 stringFromDate:[NSDate date]];
    self.recordTimeValue = date2;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
