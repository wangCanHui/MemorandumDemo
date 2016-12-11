//
//  JBNavigationVController.m
//  e家帮
//
//  Created by ejb on 16/3/9.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBNavigationVController.h"

@interface JBNavigationVController ()<UIGestureRecognizerDelegate>

@end

@implementation JBNavigationVController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.translucent = NO;
    navBar.barTintColor = [UIColor blackColor];
    navBar.tintColor = [UIColor whiteColor];
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.interactivePopGestureRecognizer.delegate = self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (self.viewControllers.count > 1) {
        return YES;
    }else{
        return NO;
    }
}
@end
