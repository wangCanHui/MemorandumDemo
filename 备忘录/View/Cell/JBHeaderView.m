//
//  HeaderView.m
//
//
//  Created by ejb on 15/8/18.
//  Copyright (c) 2015年 李海生. All rights reserved.
//

#import "JBHeaderView.h"
#import "JBMemo.h"
#import <UIKit/UIKit.h>

@interface JBHeaderView ()

@property (nonatomic,weak) UIButton *nameView;
@property (nonatomic,weak) UILabel *onlineView;

@end

@implementation JBHeaderView

+ (instancetype)headerViewWithTableView:(UITableView *)tableView
{
    static NSString *ID=@"header";
    JBHeaderView *headerView=[tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (headerView==nil)
    {
        headerView=[[JBHeaderView alloc]initWithReuseIdentifier:ID];
    }
    return headerView;
}

#pragma mark - 重写initWithReuseIdentifier方法

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithReuseIdentifier:reuseIdentifier])
    {
        //1.按钮
        UIButton *nameView=[UIButton buttonWithType:UIButtonTypeCustom];
        //nameView.titleLabel.textAlignment=NSTextAlignmentLeft;
        //设置文本颜色
        [nameView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        //设置对齐方式
        nameView.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        //设置整体内容距离边缘的间距
        nameView.contentEdgeInsets=UIEdgeInsetsMake(0, 20, 0, 0);
        //设置文字距离图标的间距
        nameView.titleEdgeInsets=UIEdgeInsetsMake(0, 10, 0, 0);
        //给按钮增加一个单击事件
        [nameView addTarget:self action:@selector(groupTitleClicked) forControlEvents:UIControlEventTouchUpInside];
        //设置按钮image不变形旋转
        nameView.imageView.contentMode=UIViewContentModeCenter;
        //设置不剪掉因旋转后超出边界的图片
        nameView.imageView.clipsToBounds=NO;
        nameView.backgroundColor = [UIColor whiteColor];
        [self addSubview:nameView];
        self.nameView = nameView;
    }
    return self;
}

- (void)groupTitleClicked
{
    //调用代理方法，实现刷洗tableView
    if ([self.delegate respondsToSelector:@selector(headerViewDidClickIndexPath:)])
    {
        [self.delegate headerViewDidClickIndexPath:[NSIndexPath indexPathForRow:0 inSection:self.tag]];
    }
}

- (void)setMemo:(JBMemo *)memo
{
    _memo = memo;
    //1.设置数据
    //1.1.设置按钮数据
    //设置图标
    [self.nameView setImage:[UIImage imageNamed:memo.headerIcon] forState:UIControlStateNormal];
    // 设置显示文本
    [self.nameView setTitle:memo.memo_time forState:UIControlStateNormal];
}
/**
 *  设置frame
 */
//当前控件的frame改变时，调用这个方法
- (void)layoutSubviews
{
    CGSize headerViewSize=self.bounds.size;
    CGFloat nameW=headerViewSize.width;
    CGFloat namwH=headerViewSize.height;
    self.nameView.frame=CGRectMake(0, 0, nameW, namwH);
    
}

@end


