//
//  JBHouseworkPopView.h
//  e家帮
//
//  Created by 王灿辉 on 2016/11/26.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JBHouseworkPopView : UIView
@property (nonatomic,copy) void(^OKBlock)();
- (instancetype)initWithTitle:(NSString *)title bgViewImage:(UIImage *)image showInView:(UIView *)view;
- (void)show;
@end
