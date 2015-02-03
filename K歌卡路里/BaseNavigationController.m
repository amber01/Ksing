//
//  BaseNavigationController.m
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc]init];
    barButtonItem.title= @" ";
    self.navigationItem.backBarButtonItem= barButtonItem;
    //[self navigationView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [self customNavTitle];
    //CGRect rect = self.navigationController.navigationBar.frame;
    //self.navigationController.navigationBar.frame = CGRectMake(rect.origin.x,rect.origin.y,rect.size.width,44);
}

-(void)customNavTitle
{
    UIColor *color = [UIColor orangeColor];
    NSDictionary *dictColor = [NSDictionary dictionaryWithObject:color forKey:UITextAttributeTextColor];
    self.navigationBar.titleTextAttributes = dictColor;
}

- (void)navigationView
{
    float version = WXHLOSVersion();
    UIImage *image = [UIImage imageNamed:@"navigation_background.png"];
    
    if (version >= 5.0) {
        [self.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    } else {
        //调用setNeedsDisplay方法会让绚烂引擎异步调用drawRect方法
        [self.navigationBar setNeedsDisplay];
    }
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
