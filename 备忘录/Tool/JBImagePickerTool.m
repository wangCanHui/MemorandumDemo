//
//  JBImagePickerTool.m
//  备忘录
//
//  Created by ejb No.2 on 2016/10/20.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBImagePickerTool.h"
#import "UIImage+Extension.h"

@interface JBImagePickerTool ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic,strong) UIViewController *currentVC;
@property (nonatomic,strong) UIView *view;
@property (nonatomic,strong) UIActionSheet *actionSheet;
@end

@implementation JBImagePickerTool

- (instancetype)initWithCurrentVC:(UIViewController *)currentVC;
{
    self = [super init];
    self.currentVC = currentVC;
    self.view = currentVC.view;
    return self;
}

/// 弹出选择窗
- (void)showActionSheet
{
    self.actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    // 判断相机是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.actionSheet addButtonWithTitle:@"拍照"];
    }
    // 判断相册是否可用
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [self.actionSheet addButtonWithTitle:@"从手机相册选择"];
    }
    [self.actionSheet showInView:self.view];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    BOOL isShowCamera = NO,isShowPhotoLibrary = NO;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        if (buttonIndex == 1 ) {
            isShowCamera = YES;
        }else if (buttonIndex == 2){
            isShowPhotoLibrary = YES;
        }
    }else{
        if (buttonIndex == 1 ) {
            isShowPhotoLibrary = YES;
        }
    }
    
    if (isShowCamera) {
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        pickerVC.allowsEditing = YES;
        [self.currentVC presentViewController:pickerVC animated:YES completion:nil];
        
    }else if (isShowPhotoLibrary){
        UIImagePickerController *pickerVC = [[UIImagePickerController alloc] init];
        pickerVC.delegate = self;
        pickerVC.allowsEditing = YES;
        [self.currentVC presentViewController:pickerVC animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //    NSLog(@"%@",info);
    if ([self.delegate respondsToSelector:@selector(imagePickerTooldidSelectImage:)]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        [self.delegate imagePickerTooldidSelectImage:image.scaleImageForMemoImage];
    }
    [self.currentVC dismissViewControllerAnimated:YES completion:nil];
}


@end
