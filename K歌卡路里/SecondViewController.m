//
//  SecondViewController.m
//  K歌卡路里
//
//  Created by amber on 14-10-12.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "SecondViewController.h"
#import "MainViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//从首页push到搜索面板时，隐藏该搜索面板的tabBar
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    MainViewController *tabBarController = (MainViewController *)self.tabBarController;
    [tabBarController showTable:NO];
    
    self.navigationController.toolbarHidden = NO;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
