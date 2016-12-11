//
//  HZQDatePickerView.m
//  HZQDatePickerView
//
//  Created by 1 on 15/10/26.
//  Copyright © 2015年 HZQ. All rights reserved.
//

#import "HZQDatePickerView.h"

@interface HZQDatePickerView ()

@property (nonatomic, strong) NSString *selectDate;

@property (weak, nonatomic) IBOutlet UIButton *cannelBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIView *backgVIew;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightPadding;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftPadding;

@end

@implementation HZQDatePickerView

+ (HZQDatePickerView *)instanceDatePickerView
{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"HZQDatePickerView" owner:nil options:nil];
    HZQDatePickerView *pickerView =  [nibView objectAtIndex:0];
    return pickerView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgVIew.layer.cornerRadius = 5;
    self.backgVIew.layer.borderWidth = 1;
    self.backgVIew.layer.borderColor = [[UIColor clearColor] CGColor];
    self.backgVIew.layer.masksToBounds = YES;
    
    /** 确定 */
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.layer.borderWidth = 1;
    self.sureBtn.layer.masksToBounds = YES;
    
    /** 取消按钮 */
    self.cannelBtn.layer.cornerRadius = 4;
    self.cannelBtn.layer.borderWidth = 1;
    self.cannelBtn.layer.masksToBounds = YES;
    
    self.leftPadding.constant = 0;
    self.rightPadding.constant = 0;
    
}

- (NSString *)timeFormat
{
    NSDate *selected = [self.datePickerView date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    formatter.dateFormat=@"MM月dd日 HH:mm";
    NSString *currentOlderOneDateStr = [formatter stringFromDate:selected];
    return currentOlderOneDateStr;
}

- (void)animationbegin:(UIView *)view {
    /* 放大缩小 */
    
    // 设定为缩放
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    // 动画选项设定
    animation.duration = 0.1; // 动画持续时间
    animation.repeatCount = -1; // 重复次数
    animation.autoreverses = YES; // 动画结束时执行逆动画
    
    // 缩放倍数
    animation.fromValue = [NSNumber numberWithFloat:1.0]; // 开始时的倍率
    animation.toValue = [NSNumber numberWithFloat:0.9]; // 结束时的倍率
    
    // 添加动画
    [view.layer addAnimation:animation forKey:@"scale-layer"];
    
}

// 遮罩点击
- (IBAction)blackBtnClick:(id)sender {
    [self.superview endEditing:YES];
    [self removeBtnClick:nil];
}

// 取消
- (IBAction)removeBtnClick:(id)sender {
    // 开始动画
    [self animationbegin:sender];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

// 确定
- (IBAction)sureBtnClick:(id)sender {
    // 开始动画
    [self animationbegin:sender];
    
    self.selectDate = [self timeFormat];
    
    //delegate
    [self.delegate getSelectDate:self.selectDate type:self.type];
    
    
    [self removeBtnClick:nil];
}

@end


