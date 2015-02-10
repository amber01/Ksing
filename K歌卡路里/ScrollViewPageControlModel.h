//
//  JScrollView+PageControl+AutoScroll.h
//  demoScrollView+PageControl+AutoScroll
//
//  Created by jacob on 29/7/13.
//  Copyright (c) 2013年 jacob QQ:110773265. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JScrollViewViewDelegate;

@interface ScrollViewPageControlModel : UIView<UIScrollViewDelegate>
{
    UIView *firstView;
    UIView *middleView;
    UIView *lastView;
    
    UIGestureRecognizer     *tap;
    NSTimer         *autoScrollTimer;
}
@property (nonatomic,readonly)    UIScrollView *scrollView;
@property (nonatomic,readonly)  UIPageControl *pageControl;
@property (nonatomic,assign)    NSInteger currentPage;
@property (nonatomic,strong)    NSMutableArray *viewsArray;
@property (nonatomic,assign)    NSTimeInterval    autoScrollDelayTime;

@property (nonatomic,assign) id<JScrollViewViewDelegate> delegate;


-(void)shouldAutoShow:(BOOL)shouldStart;//自动滚动，界面不在的时候请调用这个停止timer

@end


@protocol JScrollViewViewDelegate <NSObject>

@optional
- (void)didClickPage:(ScrollViewPageControlModel *)view atIndex:(NSInteger)index;

@end