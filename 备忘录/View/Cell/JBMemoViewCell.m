//
//  JBMemoTableViewCell.m
//  备忘录
//
//  Created by ejb on 2016/10/22.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBMemoViewCell.h"
#import "JBImageView.h"
#import "JBMemo.h"

@interface JBMemoViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *firstContentLabel;
@property (weak, nonatomic) IBOutlet JBImageView *jb_imageView;
@property (weak, nonatomic) IBOutlet UILabel *membersLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *jb_imageViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *membersLabelTop;
@property (weak, nonatomic) IBOutlet UIButton *expandedBtn;

@end

@implementation JBMemoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (IBAction)showOrHide:(UIButton *)sender {
    
    if (self.firstContentLabel.numberOfLines == 0) { // 展开变为收起
        self.firstContentLabel.numberOfLines = 1;
        //        self.jb_imageViewHeight.constant = 0;
        //        self.membersLabelTop.constant = 0;
        [sender setTitle:@"全文" forState:UIControlStateNormal];
        sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else{ // 收起变为展开
        self.firstContentLabel.numberOfLines = 0;
        //        self.jb_imageViewHeight.constant = 60;
        //        self.membersLabelTop.constant = 10;
        [sender setTitle:@"收起" forState:UIControlStateNormal];
        sender.imageView.transform = CGAffineTransformIdentity;
    }
    if ([self.delegate respondsToSelector:@selector(memoViewCellShowOrHide:)]) {
        [self.delegate memoViewCellShowOrHide:self];
    }
}
#pragma mark - setter
- (void)setMemo:(JBMemo *)memo
{
    _memo = memo;
    if (memo.imageNames.length > 10 || memo.voiceNum) {
        self.jb_imageViewHeight.constant = 60;
        self.membersLabelTop.constant = 10;
    }else{
        self.jb_imageViewHeight.constant = 0;
        self.membersLabelTop.constant = 0;
    }
    self.firstContentLabel.numberOfLines = !memo.isVisible;
    self.firstContentLabel.text = memo.textContent;
    self.jb_imageView.showRecord = memo.voiceNum;
    self.jb_imageView.imageCount = memo.picNum;
    self.jb_imageView.imageName = [memo.imageNames componentsSeparatedByString:@","].firstObject;
    self.expandedBtn.hidden = !memo.isShowExpandedView;
    self.membersLabel.text = @"指定到：@美眉";
}

@end
