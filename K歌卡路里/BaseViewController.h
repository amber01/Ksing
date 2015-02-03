//
//  BaseViewController.h
//  K歌卡路里
//
//  Created by amber on 14-8-25.
//  Copyright (c) 2014年 amber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface BaseViewController : UIViewController
{
     UIView *_loadView;   //加载微博列表时的loading提示
}

@property (nonatomic,retain)MBProgressHUD *hud;
@property (nonatomic,assign)BOOL isBackButton;

- (AppDelegate *)appDelegate;  //拿到AppDelegate中的所有方法。可以让子类来调用
//提示loading
- (void)showLoading:(BOOL)show;
- (void)showHUD:(NSString *)title isDim:(BOOL)isDim;   //通过开源框架MBProgressHUD方式来实现loading提示
- (void)hideHUD;   //隐藏loading方法
- (void)showHUDComplete:(NSString *)title delay:(NSTimeInterval)delay;  //loading完成时的提示


@end
