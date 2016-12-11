//
//  JBImageView.m
//  备忘录
//
//  Created by ejb on 2016/10/22.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBImageView.h"

@interface JBImageView() <UICollectionViewDataSource,UICollectionViewDelegate>

@end

static NSString * const cellReuseIdentifier = @"imageCell";

@implementation JBImageView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self.backgroundColor = [UIColor whiteColor];
    if (self = [super initWithCoder:aDecoder]) {
        
        // 设置数据源
        self.dataSource = self;
        // 设置代理
        self.delegate = self;
        // 注册cell
        [self registerClass:[JBImageViewCell class] forCellWithReuseIdentifier:cellReuseIdentifier];
        self.userInteractionEnabled = NO;
//        self.layer.borderColor = [UIColor greenColor].CGColor;
//        self.layer.borderWidth = 2;
    }
    return self;
}


#pragma mark - UICollectionViewDataSource & UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.isShowRecord && self.imageName.length > 10 ? 2 : 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JBImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseIdentifier forIndexPath:indexPath];

    if (indexPath.item == 0) {
        if (self.imageName.length > 10) {
            cell.imageCount = self.imageCount;
            cell.imageName = self.imageName;
        }else{
            cell.imageName = @"yuyinqian";
        }
    }else if (indexPath.item == 1){
        cell.imageName = @"yuyinqian";
    }
    return cell;
}

// 监听选中某个cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 调用代理方法
    if ([self.imageViewDelegate respondsToSelector:@selector(imageView:didSelectItemAtIndex:)]) {
        [self.imageViewDelegate imageView:self didSelectItemAtIndex:indexPath.item];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"imageViewDidSelectItemNotif" object:self userInfo:@{@"indexPath":indexPath}];
}

- (void)setImageNames:(NSArray *)imageNames
{
    _imageNames = imageNames;
    [self reloadData];
}
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    [self reloadData];
}
@end

@interface JBImageViewCell ()
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *countLabel;
@end

@implementation JBImageViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
    }
    return self;
}
#pragma mark - setter
- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    if ([imageName isEqualToString:@"yuyinqian"]) {
        self.imageView.image =  [UIImage imageNamed:imageName];
//        [self.countLabel removeFromSuperview];
    }else{
        NSArray *names = [imageName componentsSeparatedByString:@"*"];
        if (names.count == 2) {
            imageName = names.lastObject;
        }
        
        NSString *documentPath = [NSUserDefaults getDocumentPath];
        NSString *filePath = [documentPath stringByAppendingPathComponent:imageName];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        self.imageView.image =  [UIImage imageWithData:data];
        // 添加图片张数
        [self addSubview:self.countLabel];
        self.countLabel.text = [NSString stringWithFormat:@"%ld图",self.imageCount];
    }
}
#pragma mark - 懒加载
- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [UILabel labelWithText:nil TextColor:[UIColor whiteColor] backgroundColor:[UIColor blackColor] fontSize:12];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        _countLabel.frame = CGRectMake(27, 37, 30, 20);
        _countLabel.alpha = 0.7;
        _countLabel.layer.cornerRadius = 10;
        _countLabel.clipsToBounds = YES;
    }
    return _countLabel;
}
@end
