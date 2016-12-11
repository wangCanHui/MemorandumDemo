//
//  BaseViewController.h
//  UltraSpeed
//
//  Created by GMobile No.2 on 16/8/29.
//  Copyright © 2016年 Aang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
/// 返回按钮的显示文字,默认为“返回”
@property (nonatomic,copy) NSString *backBtnTitle;
- (void)backAction;
/// 返回按钮
@property (nonatomic,strong) UIButton *backBtn;
@end
