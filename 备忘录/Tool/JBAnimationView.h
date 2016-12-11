//
//  JBAnimationView.h
//  备忘录
//
//  Created by GMobile No.2 on 2016/11/3.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBAnimationView : UIView
+ (void)animateWithImages:(NSArray *)images duration:(int)duration inViewController:(UIViewController *)viewController showTime:(BOOL)isShowTime;
+ (void)stopAnimate;
@end
