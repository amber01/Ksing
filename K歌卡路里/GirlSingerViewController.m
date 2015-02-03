//
//  GirlSingerViewController.m
//  K歌卡路里
//
//  Created by amber on 15/1/22.
//  Copyright (c) 2015年 amber. All rights reserved.
//

#import "GirlSingerViewController.h"

@interface GirlSingerViewController ()

@end

@implementation GirlSingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 140)];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"barView_image"]];
    imageView.frame = CGRectMake(0,0,320,140);
    [view addSubview:imageView];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _tableView.tableHeaderView = view;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)initButtonView:(UITableViewCell *)cell
{
    UIView *btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
    UIColor *backColor = [UIColor colorWithRed:225/255.0 green:225/255.0 blue:225/255.0 alpha:1];
    btnView.backgroundColor = backColor;
    [cell.contentView addSubview:btnView];
    UIColor *textColor = [UIColor colorWithRed:68/255.0 green:68/255.0 blue:68/255.0 alpha:1];
    
    UILabel *dynamicLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 40, 30)];
    dynamicLabel.textColor = textColor;
    dynamicLabel.font = [UIFont systemFontOfSize:14];
    dynamicLabel.textAlignment = NSTextAlignmentCenter;
    dynamicLabel.text = @"90";
    
    UILabel *recordLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 40, 30)];
    recordLabel.textColor = textColor;
    recordLabel.font = [UIFont systemFontOfSize:14];
    recordLabel.textAlignment = NSTextAlignmentCenter;
    recordLabel.text = @"23";
    
    UILabel *careLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 40, 30)];
    careLabel.textColor = textColor;
    careLabel.font = [UIFont systemFontOfSize:14];
    careLabel.textAlignment = NSTextAlignmentCenter;
    careLabel.text = @"23";
    
    UILabel *fansLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 2, 40, 30)];
    fansLabel.textColor = textColor;
    fansLabel.font = [UIFont systemFontOfSize:14];
    fansLabel.textAlignment = NSTextAlignmentCenter;
    fansLabel.text = @"23";
    
    UIColor *color = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
    
    UIView *linkView1 = [[UIView alloc]init];
    linkView1.frame = CGRectMake(0, 15, 0.5, 30);
    linkView1.backgroundColor = color;
    
    UIView *linkView2 = [[UIView alloc]init];
    linkView2.frame = CGRectMake(0, 15, 0.5, 30);
    linkView2.backgroundColor = color;
    
    UIView *linkView = [[UIView alloc]init];
    linkView.frame = CGRectMake(0, 15, 0.5, 30);
    linkView.backgroundColor = color;
    
    
    UIButton *dynamicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dynamicBtn.frame = CGRectMake(0, 0, 80, 115/2);
    [dynamicBtn setImage:[UIImage imageNamed:@"dynamicBtn_image"] forState:UIControlStateNormal];
    [dynamicBtn addTarget:self action:@selector(dynamicAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    recordBtn.frame = CGRectMake(80, 0, 80, 115/2);
    [recordBtn setImage:[UIImage imageNamed:@"recordBtn_image"] forState:UIControlStateNormal];
    [recordBtn addTarget:self action:@selector(recordAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *careBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    careBtn.frame = CGRectMake(80*2, 0, 80, 115/2);
    [careBtn setImage:[UIImage imageNamed:@"careBtn_image"] forState:UIControlStateNormal];
    [careBtn addTarget:self action:@selector(careAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *fansBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    fansBtn.frame = CGRectMake(80*3, 0, 80, 115/2);
    [fansBtn setImage:[UIImage imageNamed:@"fansBtn_image"] forState:UIControlStateNormal];
    [fansBtn addTarget:self action:@selector(fansAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *singBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    singBtn.frame = CGRectMake(30, 72, ScreenWidth - 60, 42);
    [singBtn setBackgroundImage:[UIImage imageNamed:@"singBtn_image"] forState:UIControlStateNormal];
    [singBtn setTitle:@"去唱歌" forState:UIControlStateNormal];
    singBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [singBtn addTarget:self action:@selector(singAction) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:dynamicBtn];
    [btnView addSubview:recordBtn];
    [btnView addSubview:careBtn];
    [btnView addSubview:fansBtn];
    [btnView addSubview:singBtn];
    [recordBtn addSubview:linkView];
    [careBtn addSubview:linkView1];
    [fansBtn addSubview:linkView2];
    [dynamicBtn addSubview:dynamicLabel];
    [recordBtn addSubview:recordLabel];
    [careBtn addSubview:careLabel];
    [fansBtn addSubview:fansLabel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identify =  [NSString stringWithFormat:@"cell%d",indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    if (indexPath.row == 0) {
        [self initButtonView:cell];
    }else if (indexPath.row == 1){
        cell.textLabel.text =@"text";
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 130;
    }
    return 65;
}


@end
