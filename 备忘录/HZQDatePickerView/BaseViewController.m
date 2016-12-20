//
//  BaseViewController.m
//  UltraSpeed
//
//  Created by GMobile No.2 on 16/8/29.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLeftBarItem];
}

- (void)setupLeftBarItem{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.backBtn];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [self.view endEditing:YES];
//}

#pragma mark - 点击事件

- (void)backAction{
    if (self.presentingViewController && self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        self.tabBarController.tabBar.hidden = NO;
    }
}

#pragma mark - setter
- (void)setBackBtnTitle:(NSString *)backBtnTitle
{
    [self.backBtn setTitle:backBtnTitle forState:UIControlStateNormal];
    [self.backBtn sizeToFit];
}

#pragma mark - 懒加载
- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithTitle:nil titleColor:nil fontSize:17 imageName:@"back" bkgimageName:nil target:self action:@selector(backAction)];
        _backBtn.imageEdgeInsets = UIEdgeInsetsMake(2, -5, 0, 0);
    }
    return _backBtn;
}

@end
