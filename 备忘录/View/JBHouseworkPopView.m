//
//  JBHouseworkPopView.m
//  e家帮
//
//  Created by 王灿辉 on 2016/11/26.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBHouseworkPopView.h"

@interface JBHouseworkPopView ()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic,strong) UIView *view;
@property (nonatomic,copy) NSString *title;
@end

@implementation JBHouseworkPopView

- (instancetype)initWithTitle:(NSString *)title bgViewImage:(UIImage *)image showInView:(UIView *)view
{
    if (self = [super init]) {
        self = [[NSBundle mainBundle]loadNibNamed:@"JBHouseworkPopView" owner:self options:nil].lastObject;
        self.titleLabel.text = title;
        self.bgView.image = image;
        self.view = view;
        self.frame = view.bounds;
        self.height = view.height + 64;
    }
    return self;
}

- (IBAction)cancelAction:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)OKAction:(id)sender {
    [self removeFromSuperview];
    if (self.OKBlock) {
        self.OKBlock();
    }
}

- (void)show
{
//    [self.view addSubview:self];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
@end
