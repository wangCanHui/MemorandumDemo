//
//  LKView.h
//  demo4
//
//  Created by ejb on 16/8/24.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LKView;
@protocol LKViewDelegate<NSObject>
- (void)lkViewClickWith:(LKView *)sender;
- (void)lkViewLongGestureWith:(LKView *)sneder;
- (void)lkViewDidEndEditing:(NSString *)text;
- (void)textViewDidBeginEditingWith:(LKView *)sender;
@end

@interface LKView : UIView
@property(nonatomic,strong)UITextView *inputView;
@property(nonatomic,weak)id<LKViewDelegate> delegate;

- (instancetype)initWithContent:(NSString *)content origin:(CGPoint )point;
- (void) textViewDidChange:(UITextView *)textView;
@end

