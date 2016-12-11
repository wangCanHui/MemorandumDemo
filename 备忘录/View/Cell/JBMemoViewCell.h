//
//  JBMemoTableViewCell.h
//  备忘录
//
//  Created by ejb on 2016/10/22.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBMemoViewCell;
@protocol JBMemoViewCellDelegate <NSObject>
- (void)memoViewCellShowOrHide:(JBMemoViewCell *)cell;
@end
@class JBMemo;
@interface JBMemoViewCell : UITableViewCell
@property (nonatomic,strong) JBMemo *memo;
@property (nonatomic,weak) id<JBMemoViewCellDelegate> delegate;
@end
