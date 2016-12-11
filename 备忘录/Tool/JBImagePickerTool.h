//
//  JBImagePickerTool.h
//  备忘录
//
//  Created by ejb No.2 on 2016/10/20.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JBImagePickerToolDelegate  <NSObject>

- (void)imagePickerTooldidSelectImage:(UIImage *)image;

@end

@interface JBImagePickerTool : NSObject
@property (nonatomic,weak) id<JBImagePickerToolDelegate> delegate;
- (instancetype)initWithCurrentVC:(UIViewController *)currentVC;
/// 弹出选择窗
- (void)showActionSheet;
@end

