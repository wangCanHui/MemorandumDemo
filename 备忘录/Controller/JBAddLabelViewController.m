//
//  JBAddLabelViewController.m
//  备忘录
//
//  Created by GMobile No.2 on 2016/10/25.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBAddLabelViewController.h"
#import "JBMemoImageModalAnimation.h"
#import "JBMemoImageDismissAnimation.h"
#import "LKView.h"
#import "JBLabel.h"

@interface JBAddLabelViewController ()<LKViewDelegate>
//内容
@property(nonatomic,strong)UITextField *content;
//添加标签view
@property(nonatomic,strong)UIView *whiteView;
// 添加标签按钮
@property (nonatomic,strong) UIButton *addLabelBtn;
//标签
@property(nonatomic,strong)LKView *lkView;
//编辑view
@property(nonatomic,strong)UIView *editorView;
//图片
@property(nonatomic,strong)UIImageView *imgView;
//阴影
@property(nonatomic,strong)UIView *shadow;
@property (nonatomic,strong) NSMutableArray *tempPoints;
@property (nonatomic,strong) NSMutableArray *tempTexts;
//是否通过点击编辑
@property(nonatomic,assign)BOOL isEditorClick;
@property (nonatomic,strong) UIButton *saveBtn;
@end

@implementation JBAddLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备忘录";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupImageView];
    [self setupSaveBtn];
    [self setupAddLabelBtn];
    [self setupLabel];
    
}
- (void)setupImageView
{
    NSString *documentPath = [NSUserDefaults getDocumentPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:self.imageName];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UIImage *image =  [UIImage imageWithData:data];
    NSAssert(image!=nil, @"图片不能为nil");
    self.tempImageView = [[UIImageView alloc] initWithImage:image];
    self.tempImageView.center = self.view.center;
    
    self.targetImageView = [[UIImageView alloc] initWithImage:image];
    self.targetImageView.size = CGSizeMake(JBScreenWidth, self.targetImageView.height*JBScreenWidth/self.targetImageView.width);
    self.targetImageView.center = self.view.center;
    if (self.targetImageView.height > JBScreenHeight - 94) {
        self.targetImageView.height -= 60;
    }
    [self.view addSubview:self.targetImageView];
    
}
- (void)setupSaveBtn
{
    self.saveBtn = [UIButton buttonWithTitle:@"完成" titleColor:[UIColor whiteColor] fontSize:18 imageName:nil bkgimageName:nil target:self action:@selector(save)];
    _saveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, -5);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
}

- (void)setupAddLabelBtn
{
    self.addLabelBtn = [UIButton buttonWithTitle:nil titleColor:nil fontSize:0 imageName:@"Label-Button" bkgimageName:nil target:self action:@selector(addLabel)];
    self.addLabelBtn.centerX = self.view.centerX;
    self.addLabelBtn.y = self.view.height - self.addLabelBtn.height - 74;
    [self.view addSubview:self.addLabelBtn];
}

- (void)setupLabel
{
    if ([self.label.points containsString:@"{"]) {
        [self.tempPoints addObjectsFromArray:[self.label.points componentsSeparatedByString:@"*"]];
        [self.tempTexts addObjectsFromArray:[self.label.texts componentsSeparatedByString:@","]];
        NSUInteger count = self.tempPoints.count;
        for (int i = 0 ; i < count ; i ++ ) {
            LKView *view = [[LKView alloc]initWithContent:[self.tempTexts objectAtIndex:i] origin:CGPointFromString([self.tempPoints objectAtIndex:i])];
            view.tag = i;
            view.delegate = self;
            [self.view addSubview:view];
        }
    }
}

#pragma mark - 点击事件
// 完成保存
- (void)save
{
    self.addLabelBtn.hidden = YES;
    [self.view endEditing:YES];
    NSMutableArray *points = [NSMutableArray array];
    for (NSString *item in self.tempPoints) {
        if (item.length > 0) {
            [points addObject:item];
        }
    }
    NSMutableArray *texts = [NSMutableArray array];
    for (NSString *item in self.tempTexts) {
        if (item.length > 0) {
            [texts addObject:item];
        }
    }
    if (points.count == 0 && !self.label.imageName) {
        [self backAction];
        return;
    }
    UIGraphicsBeginImageContext(self.view.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 从上下文获取绘制好的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图片上下文
    UIGraphicsEndImageContext();
    CGImageRef imageRef = newImage.CGImage;
    // 设置想要截图的区域
    CGRect rect = self.targetImageView.frame;
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *targetImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    self.targetImageView.image = targetImage;
    if (self.saveBlock) {
        self.saveBlock(targetImage,points,texts);
    }
    [self backAction];
}

- (void)backAction
{
    if (self.backBlock) {
        self.backBlock();
    }
    [super backAction];
}

// 添加标签
- (void)addLabel
{
    // 捏合手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    self.shadow = [[UIView alloc]init];
    self.shadow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height);
    self.shadow.backgroundColor = [UIColor blackColor];
    self.shadow.alpha  =0.5;
    [self.shadow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowClick)]];
    [self.view addSubview:self.shadow];
    
    _whiteView = [[UIView alloc]init];
    //    _whiteView.backgroundColor = [UIColor whiteColor];
    _whiteView.frame  = CGRectMake(10,120, 295, 189);
    _whiteView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Label-box"]];
    //适配plus
    if (JBScreenWidth == 414) {
        _whiteView.origin = CGPointMake(55, JBScreenHeight - 580);
    }else {
        _whiteView.origin = CGPointMake(35, JBScreenHeight - 550);
    }
    //    _whiteView.center = self.imgView.center;
    _whiteView.layer.cornerRadius = 5;
    [self.view addSubview:_whiteView];
    
    UIButton *fixedButton = [[UIButton alloc]init];
    fixedButton.backgroundColor = kUIColorFromRGB(0x0d990d);
    [fixedButton setTitle:@"添加" forState:UIControlStateNormal];
    fixedButton.frame = CGRectMake(48, CGRectGetHeight(_whiteView.frame)- 45, 226, 30);
    fixedButton.layer.cornerRadius = 6;
    [fixedButton addTarget:self action:@selector(fixedClick) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:fixedButton];
    
    
    _content = [[UITextField alloc]init];
    _content.borderStyle = UITextBorderStyleRoundedRect;
    _content.frame = CGRectMake(48, 48, 226, CGRectGetHeight(_whiteView.frame) - CGRectGetHeight(fixedButton.frame) - 76);
    _content.placeholder = @"输入标签";
    _content.layer.cornerRadius = 5;
    [_whiteView addSubview:_content];
    
    [self hideViews];
    
}

// 修改标签
- (void)updateLabel
{
    // 捏合手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    self.shadow = [[UIView alloc]init];
    self.shadow.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,  [UIScreen mainScreen].bounds.size.height);
    self.shadow.backgroundColor = [UIColor blackColor];
    self.shadow.alpha  =0.5;
    [self.shadow addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(shadowClick)]];
    [self.view addSubview:self.shadow];
    
    _whiteView = [[UIView alloc]init];
    
    _whiteView.frame  = CGRectMake(10,120, 294.5, 189);
    _whiteView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Label-box"]];
    //适配plus
    if (JBScreenWidth == 414) {
        _whiteView.origin = CGPointMake(55, JBScreenHeight - 580);
    }else {
        _whiteView.origin = CGPointMake(35, JBScreenHeight - 550);
    }
    
    [self.view addSubview:_whiteView];
    
    UIButton *fixedButton = [[UIButton alloc]init];
    fixedButton.backgroundColor = kUIColorFromRGB(0x0d990d);
    [fixedButton setTitle:@"保存" forState:UIControlStateNormal];
    fixedButton.frame = CGRectMake(48, CGRectGetHeight(_whiteView.frame)- 45, 226, 30);
    fixedButton.layer.cornerRadius = 6;
    [fixedButton addTarget:self action:@selector(fixedClick) forControlEvents:UIControlEventTouchUpInside];
    [_whiteView addSubview:fixedButton];
    
    
    _content = [[UITextField alloc]init];
    _content.borderStyle = UITextBorderStyleRoundedRect;
    _content.frame = CGRectMake(48, 48, 226, CGRectGetHeight(_whiteView.frame) - CGRectGetHeight(fixedButton.frame) - 76);
    _content.placeholder = @"输入标签";
    _content.layer.cornerRadius = 5;
    [_whiteView addSubview:_content];
    
    [self hideViews];
}


//阴影点击
- (void) shadowClick{
    
    [self.shadow removeFromSuperview];
    [self.whiteView removeFromSuperview];
    [self.editorView removeFromSuperview];
    [self showViews];
}

//确定
- (void) fixedClick{
    if ([_content.text isEqualToString:@""]) {
        NSLog(@"请输入内容");
        return;
    }
    [self showViews];
    [self.view endEditing:YES];
    [self shadowClick];
    
    if (self.isEditorClick) {
        self.lkView.inputView.text =_content.text;
        [self.lkView textViewDidChange:self.lkView.inputView];
    }else{
        LKView *view = [[LKView alloc]initWithContent:self.content.text origin:CGPointZero];
        view.delegate = self;
        view.tag = self.tempPoints.count;
        [self.view addSubview:view];
        
        self.lkView = view;
        [self.tempPoints addObject:NSStringFromCGPoint(view.frame.origin)];
        [self.tempTexts addObject:self.content.text];
    }
    self.isEditorClick = NO;
}

#pragma mark - help Action
- (void)hideViews
{
    self.addLabelBtn.hidden = YES;
    self.backBtn.hidden = YES;
    self.saveBtn.hidden = YES;
}

- (void)showViews
{
    self.addLabelBtn.hidden = NO;
    self.backBtn.hidden = NO;
    self.saveBtn.hidden = NO;
}


#pragma mark  - LKViewDelegate

- (void)lkViewDidEndEditing:(NSString *)text
{
    [self.tempTexts replaceObjectAtIndex:self.lkView.tag withObject:text];
}

- (void)textViewDidBeginEditingWith:(LKView *)sender
{
    self.lkView = sender;
}

- (void)lkViewClickWith:(LKView *)sender{
    if (self.lkView) {
        [self.lkView endEditing:YES];
    }
    self.lkView  = sender;
}

- (void)lkViewLongGestureWith:(LKView *)sneder{
    
    self.lkView = sneder;
    _editorView = [[UIView alloc]initWithFrame:CGRectMake(sneder.frame.origin.x+10, CGRectGetMinY(sneder.frame) - 54, 150, 52)];
    //    _editorView.layer.cornerRadius = 12;
    _editorView.clipsToBounds = YES;
    _editorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"polygon"]];
    [self.view addSubview:_editorView];
    
    UIButton *editorButton = [[UIButton alloc]init];
    editorButton.frame = CGRectMake(0, -5, CGRectGetWidth(_editorView.frame)/2, CGRectGetHeight(_editorView.frame));
    [editorButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editorButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [editorButton setTitle:@"编辑" forState:UIControlStateNormal];
    
    [editorButton addTarget:self action:@selector(editorClick) forControlEvents:UIControlEventTouchUpInside];
    [_editorView addSubview:editorButton];
    
    UIButton *deleteButton = [[UIButton alloc]init];
    deleteButton.frame = CGRectMake(CGRectGetMaxX(editorButton.frame),-5 , CGRectGetWidth(_editorView.frame)/2, CGRectGetHeight(_editorView.frame));
    [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [deleteButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [deleteButton addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [_editorView addSubview:deleteButton];
    
}

//编辑
- (void)editorClick{
    //    [self.lkView.inputView becomeFirstResponder];
    self.isEditorClick = YES;
    [self updateLabel];
    _content.text = self.lkView.inputView.text;
    [self.editorView removeFromSuperview];
}

//删除
- (void)deleteClick{
    
    [self.lkView removeFromSuperview];
    [self.editorView removeFromSuperview];
    [self.tempPoints replaceObjectAtIndex:self.lkView.tag withObject:@""];
    [self.tempTexts replaceObjectAtIndex:self.lkView.tag withObject:@""];
}

- (void)pinch:(UIPinchGestureRecognizer *)pinch{
    
    CGFloat scale = pinch.scale;
    self.imgView.transform = CGAffineTransformScale(self.imgView.transform, scale, scale);
    pinch.scale = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:1.0 animations:^{
            self.imgView.transform = CGAffineTransformIdentity;
        }];
    });
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    
    [self.editorView removeFromSuperview];
    UITouch *aTouch = [touches anyObject];
    //获取当前触摸操作的位置坐标
    CGPoint loc = [aTouch locationInView:self.imgView];
    //获取上一个触摸点的位置坐标
    CGPoint prevloc = [aTouch previousLocationInView:self.imgView];
    CGRect myFrame = self.lkView.frame;
    //改变View的x、y坐标值
    float deltaX = loc.x - prevloc.x;
    float deltaY = loc.y - prevloc.y;
    myFrame.origin.x += deltaX;
    myFrame.origin.y += deltaY;
    //重新设置View的显示位置
    [self.lkView setFrame:myFrame];
}

-  (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.lkView && self.tempPoints.count > 0) {
        [self.tempPoints replaceObjectAtIndex:self.lkView.tag withObject:NSStringFromCGPoint(self.lkView.frame.origin)];
        [self.tempTexts replaceObjectAtIndex:self.lkView.tag withObject:self.lkView.inputView.text];
        NSLog(@"%@,%@",NSStringFromCGRect(self.lkView.frame),self.content.text);
    }
}


#pragma mark - getter
- (NSMutableArray *)tempPoints
{
    if (!_tempPoints) {
        _tempPoints = [NSMutableArray array];
    }
    return _tempPoints;
}
- (NSMutableArray *)tempTexts
{
    if (!_tempTexts) {
        _tempTexts = [NSMutableArray array];
    }
    return _tempTexts;
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return [[JBMemoImageModalAnimation alloc] init];
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    return [[JBMemoImageDismissAnimation alloc] init];
}

@end
