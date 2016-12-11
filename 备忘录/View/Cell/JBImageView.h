//
//  JBImageView.h
//  备忘录
//
//  Created by ejb on 2016/10/22.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JBImageView;
@protocol JBImageViewDelegate<NSObject>
@optional
// 监听选中某个cell
- (void)imageView:(JBImageView *)collectionView didSelectItemAtIndex:(NSInteger)index;
@end

@interface JBImageView : UICollectionView
@property (nonatomic,strong) NSArray *imageNames;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,assign) NSUInteger imageCount;
/// 是否显示录音图片
@property (nonatomic,assign,getter=isShowRecord) BOOL showRecord;

/// 代理
@property (nonatomic,weak) id<JBImageViewDelegate> imageViewDelegate;
@end

@interface JBImageViewCell : UICollectionViewCell
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,assign) NSUInteger imageCount;
@end

