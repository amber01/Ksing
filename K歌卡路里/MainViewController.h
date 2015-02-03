//
//  MainViewController.h
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCustomButton.h"

@interface MainViewController : UITabBarController<UINavigationControllerDelegate>
{
    BaseCustomButton    *_previousBtn;   //记录前一次选中的按钮
    UIToolbar *toobar;
}

@property (nonatomic,retain)UIImageView  *tabBarView;
@property (nonatomic,copy) NSString      *printString;

- (void)showBadge:(BOOL)show;
//控制tabBar是否显示
- (void)showTable:(BOOL)show;

@end
