//
//  JBModalAnimation.m
//  备忘录
//
//  Created by GMobile No.2 on 2016/10/26.
//  Copyright © 2016年 王灿辉. All rights reserved.
//

#import "JBMemoImageModalAnimation.h"
#import "JBAddLabelViewController.h"
#import "JBNavigationVController.h"

@implementation JBMemoImageModalAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // modal出来的控制器视图
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    toView.alpha = 0;
    // 添加到容器视图
    [[transitionContext containerView] addSubview:toView];
    // 获取Modal出来的控制器
//    JBAddLabelViewController *addLabelVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    JBNavigationVController *navC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    JBAddLabelViewController *addLabelVC = navC.viewControllers.firstObject;
    // 获取过渡的视图
    UIImageView *tempImageView = addLabelVC.tempImageView;
    [toView addSubview:tempImageView];
    // 隐藏目标图片
    addLabelVC.targetImageView.hidden = YES;
    // 动画
    [UIView animateWithDuration:[self transitionDuration:nil] animations:^{
        toView.alpha = 1.0;
        // 设置过渡视图最终动画放大完成的frame
        tempImageView.frame = addLabelVC.targetImageView.frame;
    } completion:^(BOOL finished) {
        // 移除过渡视图
        [tempImageView removeFromSuperview];
        // 显示目标图片
        addLabelVC.targetImageView.hidden = NO;
        addLabelVC.targetImageView.y -= 64;
        // 转场完成
        [transitionContext completeTransition:YES];
    }];
}
@end
