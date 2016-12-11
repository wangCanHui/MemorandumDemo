//
//  JBDismissAnimation.m
//  备忘录
//
//  Created by GMobile No.2 on 2016/10/26.
//  Copyright © 2016年 王灿辉. All rights reserved.
//

#import "JBMemoImageDismissAnimation.h"
#import "JBAddLabelViewController.h"
#import "JBNavigationVController.h"
@implementation JBMemoImageDismissAnimation
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    // 获取dismiss的控制器
//    JBAddLabelViewController *addLabelVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    JBNavigationVController *navC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    JBAddLabelViewController *addLabelVC = navC.viewControllers.firstObject;
   
    addLabelVC.targetImageView.hidden = true;
    // 获取过渡的视图
//    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:addLabelVC.targetImageView.image];
//    // 添加到容器视图
//    [[transitionContext containerView] addSubview:tempImageView];
//
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
//    tempImageView.center = fromView.center;
    
    [UIView animateWithDuration:[self transitionDuration:nil] animations:^{
        fromView.alpha = 0;
        // 动画到缩小的位置
//        tempImageView.frame = addLabelVC.tempImageView.frame;
//        tempImageView.transform = CGAffineTransformMakeScale(0.1 , 0.1);
    } completion:^(BOOL finished) {
        // 告诉系统,转场完成
        [transitionContext completeTransition:YES];
    }];
}
@end
