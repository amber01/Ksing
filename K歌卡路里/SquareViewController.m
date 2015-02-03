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
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame = CGRectMake(140, 240, 60, 40);
    button2.tintColor = [UIColor blueColor];
    button2.titleLabel.font = [UIFont systemFontOfSize:14];
    [button2 setTitle:@"click" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(startAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
    UIButton *audioEqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    audioEqButton.frame = CGRectMake(90, ScreenHeight - 100, 140, 44);
    [audioEqButton setImage:[UIImage imageNamed:@"toolBar_audioEQ@2x.png"] forState:UIControlStateNormal];
    [audioEqButton setImage:[UIImage imageNamed:@"toolBar_audioEQ_highlighted@2x.png"] forState:UIControlStateHighlighted];
    [audioEqButton addTarget:self action:@selector(audioEQAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:audioEqButton];
}

- (void)startAction
{
    GirlSingerViewController *girlSingVC = [[GirlSingerViewController alloc]init];
    [kNavigationController pushViewController:girlSingVC animated:YES];
}

- (void)audioEQAction
{
    [self initWithActionSheet];
}

//---------------自定义ActionSheet-------------------

#pragma mark - Public method

- (id)initWithActionSheet
{
    self = [super init];
    if (self) {
        //初始化背景视图，添加手势
        self.view.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self.view addGestureRecognizer:tapGesture];
        
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        
        //self.view.userInteractionEnabled = YES;
        [self creatButtons];
        
    }
    return self;
}

- (void)showInView:(UIView *)view
{
    [[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self.view];
}

#pragma mark - Praviate method

- (void)creatButtons
{
    
    
    //生成LXActionSheetView
    self.backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
    
    UIImage *image = [UIImage imageNamed:@"actionSheet_image@2x.png"];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 320, 355);
    [self.backGroundView addSubview:imageView];
    
    UIButton *finishRcd = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    finishRcd.frame = CGRectMake(6, 7, ScreenWidth, 85);
    [finishRcd setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    finishRcd.titleLabel.font = [UIFont systemFontOfSize:17];
    [finishRcd setTitle:@"完成录制" forState:UIControlStateNormal];
    [finishRcd addTarget:self action:@selector(finishRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:finishRcd];
    
    UIButton *againSingBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    againSingBtn.frame = CGRectMake(6, 94, ScreenWidth, 85);
    [againSingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    againSingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [againSingBtn setTitle:@"重新演唱" forState:UIControlStateNormal];
    [againSingBtn addTarget:self action:@selector(finishRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:againSingBtn];
    
    UIButton *cancelSingBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    cancelSingBtn.frame = CGRectMake(6, 184, ScreenWidth, 85);
    [cancelSingBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelSingBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelSingBtn setTitle:@"放弃演唱" forState:UIControlStateNormal];
    [cancelSingBtn addTarget:self action:@selector(finishRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:cancelSingBtn];
    
    UIButton *cancelBtn = [UIButton  buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.frame = CGRectMake(6, 270, ScreenWidth, 85);
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(finishRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.backGroundView addSubview:cancelBtn];
    
    //给LXActionSheetView添加响应事件
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedBackGroundView)];
    [self.backGroundView addGestureRecognizer:tapGesture];
    [self.view addSubview:self.backGroundView];
    
    self.LXActivityHeight = 355;   //actionSheet的高度
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-self.LXActivityHeight, [UIScreen mainScreen].bounds.size.width, self.LXActivityHeight)];
    } completion:^(BOOL finished) {
    }];
}

- (void)finishRecord
{
    NSLog(@"output");
    [self tappedCancel];
    
}

//点击按钮时移除actionSheet对话框
- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        if (finished) {
            [_backGroundView removeFromSuperview];
        }
    }];
}


- (void)tappedBackGroundView
{
    //
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
