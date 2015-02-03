//
//  BaseViewController.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.isBackButton = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [self customNaviBack];
    // Do any additional setup after loading the view.
}

//拿到AppDelegate中的所有方法。可以让子类来调用
- (AppDelegate *)appDelegate
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return appDelegate;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- custom navigation back button
- (void)customNaviBack
{
    //自定义返回按钮
    //判断当前的控制器是否是根控制器，如果是根控制器就不需要显示返回按钮.这个数组里面放的都是控制器
    NSArray *viewController = self.navigationController.viewControllers;
    if (viewController.count > 1 && self.isBackButton) {  //大于1，不处于根控制器的情况下
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];  //自定义返回按钮
        button.frame = CGRectMake(0, 0, 30, 40);
        [button setImage:[UIImage imageNamed:@"naviBack_image.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -- loading
//首页的微博列表默认显示一个loading加载中状态方法
- (void)showLoading:(BOOL)show
{
    if (_loadView == nil) {
        _loadView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight/2-80, ScreenWidth, 20)];
    }
    
    //loading视图
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:    UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    
    //正在加载的label
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:16.0f];
    label.textColor = [UIColor blackColor];
    label.text = @"正在加载中...";
    [label sizeToFit];
    
    label.left = (320-label.width)/2;
    activityView.right = label.left-5;
    
    [_loadView addSubview:label];
    [_loadView addSubview:activityView];
    
    if (show == YES) {
        if (![_loadView superview]) {
            [self.view addSubview:_loadView];
        }else{
            [_loadView removeFromSuperview];
        }
    }
}

//通过开源框架MBProgressHUD方式来实现loading提示
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim
{
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.dimBackground = isDim;  //是否需要一个灰色的背景框
    self.hud.labelText = title;   //加载文字
}

- (void)hideHUD
{
    //self.hud.hidden = YES;
    [self.hud hide:YES];
}

- (void)showHUDComplete:(NSString *)title delay:(NSTimeInterval)delay
{
    //自定义view图片
    self.hud.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;   //自定义视图
    
    if (title.length > 0) {
        self.hud.labelText = title;
    }
    [self.hud hide:YES afterDelay:delay];  //这个完成打钩的提示延时1s隐藏
}


@end
