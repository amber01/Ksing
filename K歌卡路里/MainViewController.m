//
//  MainViewController.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "MainViewController.h"
#import "BaseNavigationController.h"
#import "SquareViewController.h"
#import "DynamicViewController.h"
#import "SongListViewController.h"
#import "MyViewController.h"
#import "SettingViewController.h"
#import "BaseNavigationController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.printString = @"print out!";
       // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toobarShow:) name:kTabBarShowNotification object:nil];
       // [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hiddenToobarShow:) name:kHiddenToobbarShowl object:nil];
    }
    self.tabBar.hidden = YES; //隐藏原先的tabBar
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self.tabBarController.tabBar setSelectedImageTintColor:[UIColor orangeColor]];
    [self initViewController];
    [self initTabBarView];
}

//初始化控制器
- (void)initViewController
{
    SquareViewController *squareViewController = [[SquareViewController alloc]init];
    DynamicViewController *dynamicViewController = [[DynamicViewController alloc]init];
    SongListViewController *songListViewController = [[SongListViewController alloc]init];
    MyViewController *myViewController = [[MyViewController alloc]init];
    SettingViewController *settViewController = [[SettingViewController alloc]init];
    
    
    
    NSArray *views = @[squareViewController,dynamicViewController,songListViewController,myViewController,settViewController];
    
    NSMutableArray *viewControllers = [NSMutableArray arrayWithCapacity:5];
    
    for (UIViewController *viewController in views) {
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:viewController];
        [viewControllers addObject:nav];
        nav.delegate = self;
    }
    self.viewControllers = viewControllers;  //将这5个导航控制器给tab
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

- (void)initTabBarView
{
    self.tabBar.hidden = YES; //隐藏原先的tabBar
    CGFloat tabBarViewY = self.view.frame.size.height - 49;
    
    
    _tabBarView = [[UIImageView alloc] initWithFrame:CGRectMake(0, tabBarViewY, 320, 49)];
    _tabBarView.userInteractionEnabled = YES; //这一步一定要设置为YES，否则不能和用户交互
    _tabBarView.image = [UIImage imageNamed:@"tabbar_background.png"];
    
    [self.view addSubview:_tabBarView];
    
    [self creatButtonWithNormalName:@"guangchang.png"andSelectName:@"guangchang_highlighted.png"andTitle:@"广场"andIndex:0];
    [self creatButtonWithNormalName:@"dongtai.png"andSelectName:@"dongtai_highlighted.png"andTitle:@"动态"andIndex:1];
    [self creatButtonWithNormalName:@"huatong.png"andSelectName:@"huatong_highlighted.png"andTitle:@"选歌开唱"andIndex:2];
    [self creatButtonWithNormalName:@"wo.png"andSelectName:@"wo_highlighted.png"andTitle:@"我的"andIndex:3];
    [self creatButtonWithNormalName:@"shezhi.png"andSelectName:@"shezhi_highlighted.png"andTitle:@"设置"andIndex:4];
    
    
    BaseCustomButton *btn = _tabBarView.subviews[0];

    
    [self changeViewController:btn]; //自定义的控件中的按钮被点击了调用的方法，默认进入界面就选中第一个按钮
}

#pragma mark 创建一个按钮
- (void)creatButtonWithNormalName:(NSString *)normal andSelectName:(NSString *)selected andTitle:(NSString *)title andIndex:(int)index
{
    BaseCustomButton *button = [BaseCustomButton buttonWithType:UIButtonTypeCustom];
    button.tag = index;
    
    
    CGFloat buttonW = _tabBarView.frame.size.width / 5;
    CGFloat buttonH = _tabBarView.frame.size.height;
    button.frame = CGRectMake(64 *index, 0, buttonW, buttonH);
    
    [button setImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:selected] forState:UIControlStateDisabled];
    [button setTitle:title forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(changeViewController:) forControlEvents:UIControlEventTouchDown];
    
    button.imageView.contentMode = UIViewContentModeCenter; // 让图片在按钮内居中
    button.titleLabel.textAlignment = NSTextAlignmentCenter; // 让标题在按钮内居中
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];//设置title在一般情况下为白色字体
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateDisabled];//设置title在button被选中情况下为灰色字体
    
    //   button.font = [UIFont systemFontOfSize:12]; // 设置标题的字体大小
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    
    [_tabBarView addSubview:button];
}

#pragma mark 按钮被点击时调用
- (void)changeViewController:(BaseCustomButton *)button
{
    self.selectedIndex = button.tag; //切换不同控制器的界面
    button.enabled = NO;
    
    if (_previousBtn != button ) {
        
        _previousBtn.enabled = YES;
        
    }
    
    /*
    //通过模态方式打开控制器
     if (button.tag == 2) {
         SongListViewController *songListViewController = [[SongListViewController alloc]init];
         BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:songListViewController];
         [self presentViewController:baseNav animated:YES completion:nil];
     }
    */
    _previousBtn = button;
    
}

#pragma mark -- push到其他界面隐藏tabBar方法
//-------------push到其他界面是，隐藏tabBar-----------------
- (void)showBadge:(BOOL)show
{
    _tabBarView.hidden = !show;
}

//控制tabBar是否显示
- (void)showTable:(BOOL)show
{
    //调整tabBar的frame即可
    [UIView animateWithDuration:0.35 animations:^{
        if (show == YES) {  //yes就显示
            _tabBarView.left = 0;
        }else{
            _tabBarView.left = - ScreenWidth;
            
            //_tabBarView.hidden = YES;
        }
    }];
    [self _resizeView:show];
}

#pragma mark -- UI
//调整tabBar的高度
-(void) _resizeView:(BOOL)showTabbar
{
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:NSClassFromString(@"UITransitonView")]) {
            if (showTabbar) {
                subView.height = ScreenHeight - 49 - 20;
            }else{
                subView.height = ScreenHeight - 20;
            }
        }
    }
}

#pragma mark -- NavigationController delegate
//将要push的时候就隐藏tabBar，这里可以监听5个tabBar导航控制的事件
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //取出navigationController的子控制器个数
    NSUInteger count = navigationController.viewControllers.count;
    
    if (count == 2) {
        [self showTable:NO]; //子控制器个数为2的时候隐藏
        
    }else if (count == 1)
        [self showTable:YES];  //为1的时候显示
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
//切换的时候给该类发一个通知
- (void)toobarShow:(NSNotification *)notification
{
    toobar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.height - 49, self.view.width, 49)];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(backAction)];
    
    NSArray *items = @[backItem];
    toobar.items = items;
    [self.view addSubview:toobar];
}
*/
 
- (void)hiddenToobarShow:(NSNotification *)notification
{
    toobar.hidden = YES;
}

#pragma mark -- actions
- (void)backAction
{
    
}

//移除通知
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

/*
 - (void)dealloc
 {
 [[NSNotificationCenter defaultCenter]removeObserver:self];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
