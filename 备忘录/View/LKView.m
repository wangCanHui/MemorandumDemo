//
//  LKView.m
//  demo4
//
//  Created by ejb on 16/8/24.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "LKView.h"
#define lkColor(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
@interface LKView() <UITextViewDelegate>
@property(nonatomic,assign)BOOL isClick;
@property(nonatomic,strong)UIImageView *originw;
@property(nonatomic,strong)UIView *inputUpView;
@end
@implementation LKView

- (instancetype)initWithContent:(NSString *)content origin:(CGPoint )point;
{
    self = [super init];
    if (self) {
        CGFloat x = arc4random_uniform(200);
        CGFloat y = arc4random_uniform(100) + 200;
        
        if (point.x != 0 || point.y != 0) {
            x = point.x;
            y = point.y;
        }
        
        self.backgroundColor = [UIColor clearColor];
        
        //闪跃图标
        _originw= [[UIImageView alloc]init];
        _originw.frame = CGRectMake(7,3, 25, 25);
        _originw.userInteractionEnabled = YES;
        UITapGestureRecognizer *originClick = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(originClick)];
        [_originw addGestureRecognizer:originClick];
        [self addSubview:_originw];
        _originw.image = [UIImage imageNamed:@"Label-flicker"];
        //跳动
        //        NSMutableArray *volatility = [[NSMutableArray alloc]init];
        //        for (int i = 1 ; i <=3; i ++) {
        //            NSString *fileName = [NSString stringWithFormat:@"%d",i];
        //            UIImage *image = [UIImage imageNamed:fileName];
        //            [volatility addObject:image];
        //        }
        //        _origin.animationImages = volatility;
        //        _origin.animationDuration = volatility.count * 0.1;
        //        _origin.animationRepeatCount =  INT16_MAX;
        //        [_origin startAnimating];
        
        //输入框
        _inputView= [[UITextView alloc]init];
        _inputView.delegate = self;
        _inputView.text = content;
        _inputView.alpha = 1;
        [_inputView sizeToFit];
        _inputView.frame = CGRectMake(CGRectGetMinX(_originw.frame)+30, 0, _inputView.frame.size.width+20, _inputView.frame.size.height);
        _inputView.scrollEnabled = NO;
        //        _inputView.textAlignment = NSTextAlignmentLeft;
        _inputView.textAlignment = NSTextAlignmentCenter;
        _inputView.layoutManager.allowsNonContiguousLayout = NO;
        _inputView.backgroundColor = lkColor(46, 38, 32);
        
        _inputView.textColor = [UIColor whiteColor];
        _inputView.font = [UIFont boldSystemFontOfSize:15];
        _inputView.contentOffset = CGPointMake(0,4);
        _inputView.layer.cornerRadius = 6;
        _inputView.clipsToBounds = YES;
        _inputView.editable = NO;
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(inputViewLongPress:)];
        [_inputView addGestureRecognizer:tap];
        [self addSubview:_inputView];
        
        self.frame =CGRectMake(x,y , CGRectGetWidth(_originw.frame)+ CGRectGetWidth(_inputView.frame)+40, _inputView.frame.size.height);
        
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        longGesture.allowableMovement = 10;
        [self addGestureRecognizer:longGesture];
    }
    return self;
}

//-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if ([UIMenuController sharedMenuController]) {
//        [UIMenuController sharedMenuController].menuVisible = NO;
//    }
//    return YES;
//}

- (void) inputViewLongPress:(UILongPressGestureRecognizer *)longGress{
    if (longGress.state == UIGestureRecognizerStateBegan) {
        if ([self.delegate respondsToSelector:@selector(lkViewLongGestureWith:)]) {
            [self.delegate lkViewLongGestureWith:self];
        }
    }
    
}
- (void)longPress:(UILongPressGestureRecognizer *)longGress {
    if (longGress.state == UIGestureRecognizerStateBegan) {
        
        if ([self.delegate respondsToSelector:@selector(lkViewLongGestureWith:)]) {
            [self.delegate lkViewLongGestureWith:self];
        }
    }
}

-(void)originClick{
    _isClick = !_isClick;
    if (_isClick) {
        [UIView animateWithDuration:0.05 animations:^{
            self.originw.transform = CGAffineTransformTranslate(self.originw.transform, CGRectGetMaxX(self.inputView.frame) + -1, 0);
            //            self.origin.transform = CGAffineTransformTranslate(self.inputView.transform, CGRectGetMaxX(self.origin.frame) - 10, 0);
        }];
    }else{
        [UIView animateWithDuration:0.05 animations:^{
            self.originw.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void) textViewDidChange:(UITextView *)textView{
    CGSize size =
    [textView sizeThatFits:CGSizeMake([UIScreen mainScreen].bounds.size.width, 10)];
    
    CGRect frame = textView.frame;
    frame.size.height = size.height;
    frame.size.width = size.width;
    
    textView.frame = frame;
    _inputUpView.frame = frame;
    
    CGRect selfFrame = self.frame;
    selfFrame.size.width = CGRectGetWidth(_originw.frame)+ CGRectGetWidth(_inputView.frame)+40;
    selfFrame.size.height = _inputView.frame.size.height;
    self.frame = selfFrame;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(lkViewDidEndEditing:)]) {
        [self.delegate lkViewDidEndEditing:textView.text];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([self.delegate respondsToSelector:@selector(textViewDidBeginEditingWith:)]) {
        [self.delegate textViewDidBeginEditingWith:self];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.delegate respondsToSelector:@selector(lkViewClickWith:)]) {
        [self.delegate lkViewClickWith:self];
    }
}



@end
