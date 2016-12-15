//
//  JBMemoViewController.m
//  备忘录
//
//  Created by ejb No.2 on 2016/10/19.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "JBMemoViewController.h"
#import "HZQDatePickerView.h"
#import "JBImagePickerTool.h"
#import "Masonry.h"
#import "JBMemo.h"
#import "JBMemoDAL.h"
#import "LKView.h"
#import "JBAddLabelViewController.h"
#import "JBNavigationVController.h"
#import "JBLabel.h"
#import "JBLableDAL.h"
#import <AVFoundation/AVFoundation.h>
#import "JBAnimationView.h"
#import "JBTextAttachment.h"
#import "NSAttributedString+Extension.h"
#import "lame.h"
#import "JBHouseworkPopView.h"
#import "HPTextViewTapGestureRecognizer.h"

@interface JBMemoViewController ()<UITextViewDelegate,HZQDatePickerViewDelegate,JBImagePickerToolDelegate,HPTextViewTapGestureRecognizerDelegate>
/// 保存按钮
@property (nonatomic,strong) UIButton *saveBtn;
/// 设置时间按钮
@property (nonatomic,strong) UIButton *setupTimeBtn;
/// 输入框
@property (nonatomic,strong) UITextView *inputView;
/// 时间选择器
@property (nonatomic,strong) HZQDatePickerView *pickerView;
/// 图片选择工具
@property (nonatomic,strong) JBImagePickerTool *imagePickerTool;

/// 临时存放所有图片的名称
/// 临时存放所有段落文字（以图片对整体文字进行的分割）和图片的集合
@property (nonatomic,strong) NSMutableArray *tempContents;
/// 临时存放设置的日期时间
@property (nonatomic,copy) NSString *tempDate;
@property (nonatomic,assign) BOOL notSaveImage;
@property (nonatomic,copy) NSString *tempFirstContent;

//麦克分按钮
@property (nonatomic,strong) UIButton *buttonitem;
//添加标签按钮
@property (nonatomic,strong) UIButton *Labelbtn;
// 拍照按钮
@property (nonatomic,strong) UIButton *shotbtn;

@property (nonatomic,strong) UIView *bgView;
@property (nonatomic,strong) UILabel *textLabel;

/// 录音文件存放路径
@property (nonatomic,copy) NSString *filePathForRecord;
@property (nonatomic,copy) NSString *tempFilePathForRecord;
/// 录音控制器
@property (nonatomic,strong) AVAudioRecorder *recorder;
/// 播放控制器
@property (nonatomic,strong) AVAudioPlayer *player;
/// 定时器
@property (nonatomic,strong) NSTimer *timer;
/// 录音的时长
@property (nonatomic,assign) NSUInteger recordSeconds;
/// 弹窗
@property (nonatomic,strong) JBHouseworkPopView *popView;

@property (nonatomic,strong) UIView *topToolBarView;
/// 暂存修改前输入框的内容
@property (nonatomic,copy) NSString *lastPlainString;
/// 是否进入后台
@property (nonatomic,assign) BOOL isResignActive;

@end

@implementation JBMemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"备忘录";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveBtn];
    self.tempContents = [NSMutableArray array];
    [self prepareUI];

    ///覆盖语音按钮
    [self buttonitem];
    [self Labelbtn];
    [self shotbtn];
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(KeyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopAnimate) name:@"stopAnimateNotif" object:nil];
    // 让设备开启录音模式
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [JBAnimationView stopAnimate];
    
    self.setupTimeBtn.hidden = YES;
    self.topToolBarView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.setupTimeBtn.hidden = NO;
    self.topToolBarView.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.inputView becomeFirstResponder];
}

#pragma mark - 基本设置

- (void)prepareUI {
    
    //    [self.view addSubview:self.setupTimeBtn];
    [[UIApplication sharedApplication].keyWindow addSubview:self.topToolBarView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.setupTimeBtn];
    [self setData];
}

- (void)setData
{
    [self.view addSubview:self.inputView];
    
    // 1. 使用本地数据情况
    if ([self.memo.contents lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 1) {
        // 1.1设置显示时间
        if ([self.memo.memo_time lengthOfBytesUsingEncoding:NSUTF8StringEncoding] > 6) {
            if ([self.memo.memo_time containsString:@","]) {
                [self.setupTimeBtn setTitle:self.memo.memo_time forState:UIControlStateNormal];
                [self.setupTimeBtn sizeToFit];
            }
        }
        // 1.2显示所有内容
        [self.tempContents addObjectsFromArray:[self.memo.contents componentsSeparatedByString:@"ψ"]];
        for (NSString *item in self.tempContents) {
            // item有可能是图片名称，也有可能是一段文字
            if ([item containsString:@".jpg"] && [item componentsSeparatedByString:@"*"].count == 2) { // 说明是加过标签后的图片
                NSString *documentPath = [NSUserDefaults getDocumentPath];
                NSString *filePath = [documentPath stringByAppendingPathComponent:[item componentsSeparatedByString:@"*"].lastObject];
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                UIImage *image= [UIImage imageWithData:data];
                [self addSelectImage:image imageName:item saveImageToSandbox:NO];
            }else{
                if ([item hasSuffix:@".mp3"]) { // 说明是录音
                    self.recordSeconds = [[item componentsSeparatedByString:@"ζ"].firstObject integerValue];
                    NSString *imageName = @"10s";
                    if (self.recordSeconds>10 &&self.recordSeconds<30) {
                        imageName = @"30s";
                    }else if (self.recordSeconds > 30){
                        imageName = @"50s";
                    }
                    UIImage *image= [UIImage imageNamed:imageName];
                    [self addSelectImage:image imageName:item saveImageToSandbox:NO];
                }else{
                    NSString *documentPath = [NSUserDefaults getDocumentPath];
                    NSString *filePath = [documentPath stringByAppendingPathComponent:item];
                    NSData *data = [NSData dataWithContentsOfFile:filePath];
                    if (data) { // 说明是图片
                        UIImage *image= [UIImage imageWithData:data];
                        [self addSelectImage:image imageName:item saveImageToSandbox:NO];
                    }else{ // 说明是一段文字
                        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputView.attributedText];
                        [attri appendAttributedString:[[NSAttributedString alloc] initWithString:item]];
                        self.inputView.attributedText = attri;
                        self.inputView.font = [UIFont systemFontOfSize:15];
                    }
                }
            }
        }
        
    }
    
    self.tempFirstContent = self.memo.textContent;
}

#pragma mark HPTextViewTapGestureRecognizerDelegate
// 点击链接
-(void)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer handleTapOnURL:(NSURL*)URL inRange:(NSRange)characterRange
{
    [[UIApplication sharedApplication] openURL:URL];
}
// 点击图片
-(void)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer handleTapOnTextAttachment:(JBTextAttachment*)textAttachment inRange:(NSRange)characterRange
{
    [self translateAnimationWithTextAttachment:textAttachment inRange:characterRange];
}

#pragma mark - UITextViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.inputView resignFirstResponder];
}

-  (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (!self.lastPlainString) {
        self.lastPlainString = [textView.attributedText getPlainString];
    }
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.isResignActive = NO;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    self.tempFirstContent = textView.text;
}

///ios7~9
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(JBTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    
    [self translateAnimationWithTextAttachment:textAttachment inRange:characterRange];
    return YES;
}
///ios10
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(JBTextAttachment *)textAttachment inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    [self translateAnimationWithTextAttachment:textAttachment inRange:characterRange];
    return YES;
}

// 用获取到的图片做转场动画
- (void)translateAnimationWithTextAttachment:(JBTextAttachment *)textAttachment inRange:(NSRange)characterRange
{
    // 阻止点击图片时，输入框键盘响应弹起
    if (!self.inputView.isFirstResponder) {
        self.inputView.editable = NO;
    }
    // 获取文件名
    NSString *fileName = [self fileNameWithImageRange:characterRange];
    // 1. 说明是语音
    if ([fileName hasSuffix:@".amr"] || [fileName hasSuffix:@".mp3"]) {
        [self playRecordWithFileName:[fileName componentsSeparatedByString:@"ζ"].lastObject];
        return;
    }
    // 2. 说明是图片
    BOOL isSave = YES;
    NSArray *names = [fileName componentsSeparatedByString:@"*"];
    // 说明是合成过得图片，需要截取出原图
    if (names.count == 2) {
        fileName = names[0];
        isSave = NO;
    }
    JBAddLabelViewController *addLableVC  = [[JBAddLabelViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    addLableVC.saveBlock = ^(UIImage *targetImage,NSArray *tempPoints,NSArray *tempTexts){
        weakSelf.setupTimeBtn.hidden = NO;
        weakSelf.topToolBarView.hidden = NO;
        weakSelf.inputView.editable = YES;
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:weakSelf.inputView.attributedText];
        textAttachment.image = targetImage;
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:textAttachment];
        [attri replaceCharactersInRange:characterRange withAttributedString:string];
        weakSelf.inputView.attributedText = attri;
        
        if (tempPoints.count == 0) { // 删除数据库中的标签
            [[JBLableDAL sharedInstance] deleteWithImageName:fileName];
        }else{ // 1. 保存或修改标签到数据库
            [weakSelf saveOrUpdateLabelToDBWithImageName:fileName tempPoints:tempPoints tempTexts:tempTexts isSave:isSave];
        }
        // 2. 保存图片到沙盒
        [weakSelf saveImageToSandbox:targetImage imageRange:characterRange attachment:textAttachment];
    };
    addLableVC.backBlock = ^{
        weakSelf.setupTimeBtn.hidden = NO;
        weakSelf.topToolBarView.hidden = NO;
        weakSelf.inputView.editable = YES;
    };
    JBLabel *label = [[JBLableDAL sharedInstance] selectWithImageName:fileName];
    addLableVC.label = label;
    addLableVC.imageName = fileName;
    JBNavigationVController *navC = [[JBNavigationVController alloc] initWithRootViewController:addLableVC];
    // 设置控制器的modal展现
    navC.modalPresentationStyle = UIModalPresentationCustom;
    // 设置转场代理
    navC.transitioningDelegate = addLableVC;
    [self presentViewController:navC animated:YES completion:nil];
    self.setupTimeBtn.hidden = YES;
    self.topToolBarView.hidden = YES;
}

// 保存图片到沙盒并更换数组中的图片名
- (void)saveImageToSandbox:(UIImage *)image imageRange:(NSRange)imageRange attachment:(JBTextAttachment *)attachment
{
    // 图片原名
    NSString *imageNameOriginal = [self fileNameWithImageRange:imageRange];
    // 保存图片到沙盒
    NSString *imageNameTarget = [self saveImageToSandbox:image];
    NSString *imageName = [NSString stringWithFormat:@"%@*%@",[imageNameOriginal componentsSeparatedByString:@"*"].firstObject,imageNameTarget];
    // 标记至关重要
    attachment.imageName = imageName;
}

// 获取目标图片名在数组中的索引
- (NSString *)fileNameWithImageRange:(NSRange)imageRange
{
    __block NSString *fileName = nil;
    NSAttributedString *attributeString = self.inputView.attributedText;
    
    //遍历
    [attributeString enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, attributeString.length)
                                options:0
                             usingBlock:^(id value, NSRange range, BOOL *stop) {
                                 //检查类型是否是自定义NSTextAttachment类
                                 //检查类型是否是自定义NSTextAttachment类
                                 if (value && [value isKindOfClass:[JBTextAttachment class]]) {
                                     if (range.location == imageRange.location && range.length == imageRange.length) {
                                         fileName = ((JBTextAttachment *) value).imageName;
                                         *stop = YES;
                                     }
                                 }
                             }];
    return fileName;
}

- (void)saveOrUpdateLabelToDBWithImageName:(NSString *)imageName tempPoints:(NSArray *)tempPoints tempTexts:(NSArray *)tempTexts isSave:(BOOL)isSave
{
    NSString *points = nil;
    for (NSString *item in tempPoints) {
        NSUInteger index = [tempPoints indexOfObject:item];
        if (index == 0) {
            points = item;
            
        }else{
            points = [NSString stringWithFormat:@"%@*%@",points,item];
        }
    }
    
    NSString *texts = nil;
    for (NSString *item in tempTexts) {
        NSUInteger index = [tempTexts indexOfObject:item];
        if (index == 0) {
            texts = item;
        }else{
            texts = [NSString stringWithFormat:@"%@,%@",texts,item];
        }
    }
    JBLabel *label = [[JBLabel alloc] init];
    label.imageName = imageName;
    label.points = points;
    label.texts = texts;
    if (isSave) {
        [[JBLableDAL sharedInstance] insertWithLabel:label];
    }else{
        [[JBLableDAL sharedInstance] updateWithLabel:label];
    }
}

#pragma mark - HZQDatePickerViewDelegate
///显示时间内容
- (void)getSelectDate:(NSString *)date type:(DateType)type {
    
    [self.setupTimeBtn setTitle:[date componentsSeparatedByString:@","].firstObject forState:UIControlStateNormal];
    [self.setupTimeBtn sizeToFit];
    self.tempDate = date;
    
}

#pragma mark - JBImagePickerToolDelegate
- (void)imagePickerTooldidSelectImage:(UIImage *)image
{
    [self addSelectImage:image imageName:nil saveImageToSandbox:YES];
}

#pragma mark - 点击事件

//- (void)backAction
//{
//    if (self.memo) {
//        if (![self.lastPlainString isEqualToString:[self.inputView.attributedText getPlainString]] && self.lastPlainString) {
//            [self showPopView];
//        }else{
//            [super backAction];
//        }
//    }else{
//        if (self.inputView.attributedText.getPlainString.length != 0) {
//            [self showPopView];
//        }else{
//            [super backAction];
//        }
//    }
//}


- (void)showPopView
{
    self.popView = [[JBHouseworkPopView alloc] initWithTitle:@"确定退出此次编辑？" bgViewImage:[UIImage imageNamed:@"Exit-edit"] showInView:self.view];
    [self.popView show];
    __weak typeof(self) weakSelf = self;
    self.popView.OKBlock = ^{
        [weakSelf.setupTimeBtn removeFromSuperview];
        [weakSelf.topToolBarView removeFromSuperview];
        [super backAction];
    };
}
- (void)save
{
    [self.view endEditing:YES];
    // 如果为空直接返回
    if (self.inputView.attributedText.getPlainString.length == 0) {
        [self backAction];
        return;
    }
    
    JBMemo *memo = nil;
    // 新增备忘录保存
    if (!self.memo) {
        memo = [self createMemo];
        if ([[JBMemoDAL sharedInstance] insertOneMemoWithMemo:memo]) {
            if (self.saveBlock) {
                self.saveBlock();
            }
            [self backAction];
        }
    // 修改备忘录再次保存
    }else{
        memo = [self createMemo];
        memo.memo_id = self.memo.memo_id;
        if ( [[JBMemoDAL sharedInstance] updateOneMemoWithMemo:memo]) {
            if (self.saveBlock) {
                self.saveBlock();
            }
            [self backAction];
        }
    }
    
}

- (JBMemo *)createMemo
{
    JBMemo *memo = [[JBMemo alloc] init];
    if (!self.tempDate) { // 用户未设置时间的情况
        memo.memo_time = [NSDate stringFromDate:[NSDate dateWithTimeIntervalSinceNow:0] dateFormat:@"MM月dd日 HH:mm"];
    }else{
        memo.memo_time = self.tempDate;
    }
    memo.contents = [self.inputView.attributedText getPlainString];
    memo.imageNames = [self.inputView.attributedText getImageNames];
    self.tempFirstContent = self.tempFirstContent == nil ? @"" : self.tempFirstContent;
    memo.textContent = [self.tempFirstContent stringByReplacingOccurrencesOfString:@"\n\r" withString:@""];
    NSDictionary *dict = [self.inputView.attributedText getImageNumAndVoiceNum];
    memo.picNum = [dict[@"imageNum"] intValue];
    memo.voiceNum = [dict[@"voiceNum"] intValue];
    return memo;
}


- (void)setupTime
{
    [self.view endEditing:YES];
    [self setupDateView:DateTypeOfStart];
}
// 开始录音
- (void)startRecord
{
    if ([self.inputView isFirstResponder]) {
        [self.view endEditing:YES];
        return;
    }
    self.inputView.userInteractionEnabled = NO;
    if ([self createRecorder]) {
        if ([self.recorder prepareToRecord]) {
            NSLog(@"开始录音准备成功");
            // 开始录音
            if ([self.recorder record]) {
                NSLog(@"开始录音成功");
                [self recordAnimation];
                // 初始值
                self.recordSeconds = 1;
                self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(recordSecondsAdd) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
                
            };
        }
    }
}

- (void)recordSecondsAdd
{
    self.recordSeconds++;
}
// 结束录音
- (void)stopRecord
{
    self.inputView.userInteractionEnabled = YES;
    [JBAnimationView stopAnimate];
    [self.timer invalidate];
    self.timer = nil;
    // 延时1秒钟再停止录音，防止最后声音没录上
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.recorder stop];
        if (self.recordSeconds < 2) {
            // 在这里添加显示录音时间过短的提示
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"luyin-duan"]];
            imageView.center = CGPointMake(self.view.centerX, self.view.centerY-64);
            [self.view addSubview:imageView];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [imageView removeFromSuperview];
            });
            // 初始值
            self.recordSeconds = 1;
        }else{
            NSString *imageName = @"10s";
            if (self.recordSeconds>10 &&self.recordSeconds<30) {
                imageName = @"30s";
            }else if (self.recordSeconds > 30){
                imageName = @"50s";
            }
            // pcm转mp3
            NSString *mp3FilePath = [self.tempFilePathForRecord stringByReplacingOccurrencesOfString:@"pcm" withString:@"mp3"];
            @try {
                NSUInteger read, write;
                
                FILE *pcm = fopen([self.tempFilePathForRecord cStringUsingEncoding:1], "rb"); //source 被转换的音频文件位置
                fseek(pcm, 4*1024, SEEK_CUR); //skip file header
                FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb"); //output 输出生成的Mp3文件位置
                
                const int PCM_SIZE = 8192;
                const int MP3_SIZE = 8192;
                short int pcm_buffer[PCM_SIZE*2];
                unsigned char mp3_buffer[MP3_SIZE];
                
                lame_t lame = lame_init();
                lame_set_in_samplerate(lame, 44100.0);
                lame_set_VBR(lame, vbr_default);
                lame_init_params(lame);
                
                do {
                    read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                    if (read == 0)
                        write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                    else
                        write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                    
                    fwrite(mp3_buffer, write, 1, mp3);
                    
                } while (read != 0);
                
                lame_close(lame);
                fclose(mp3);
                fclose(pcm);
            }
            @catch (NSException *exception) {
                NSLog(@"%@",[exception description]);
            }
            @finally {
                NSLog(@"MP3生成成功: %@",mp3FilePath);
                // 显示录音
                NSString *fileName = mp3FilePath.lastPathComponent;
                fileName = [NSString stringWithFormat:@"%ldζ%@",self.recordSeconds,fileName];
                [self addSelectImage:[UIImage imageNamed:imageName] imageName:fileName saveImageToSandbox:NO];
                // 初始值
                self.recordSeconds = 1;
                AVAudioSession *session = [AVAudioSession sharedInstance];
                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
            }
        }
    });
}

// 上传照片
-(void)ShootingClick{
    
    [self.view endEditing:YES];
    
    self.imagePickerTool = [[JBImagePickerTool alloc] initWithCurrentVC:self];
    
    self.imagePickerTool.delegate = self;
    
    [self.imagePickerTool showActionSheet];
    
}
// 提示添加标签
-(void)labelPromptClick{
    
    //点击弹出提示语 （这个是要的）
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.textLabel];
    self.bgView.center = self.view.center;
    self.textLabel.center = self.view.center;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bgView removeFromSuperview];
        [self.textLabel removeFromSuperview];
    });
}


#pragma mark - helpAction
// imageName不需要就传nil
- (void)addSelectImage:(UIImage *)image imageName:(NSString *)imageName saveImageToSandbox:(BOOL)saveToSandbox
{
    self.saveBtn.hidden = NO;
    // 1. 添加图片显示操作
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithAttributedString:self.inputView.attributedText];
    if (self.inputView.text.length > 1 && saveToSandbox) {
        [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\r"]];
    }
    JBTextAttachment *attch = [[JBTextAttachment alloc] init];
    attch.image = image;
    if (imageName) {
        // 标记识别，至关重要
        attch.imageName = imageName;
    }
    NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
    [attri appendAttributedString:string];
    [attri appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\r"]];
    self.inputView.attributedText = attri;
    self.inputView.font = [UIFont systemFontOfSize:15];
    if (saveToSandbox) {
        // 保存图片到沙盒
        NSString *imageName = [self saveImageToSandbox:image];
        attch.imageName = imageName;
    }
}

///设置时间选择器
- (void)setupDateView:(DateType)type {
    
    self.pickerView = [HZQDatePickerView instanceDatePickerView];
    self.pickerView.xssj.text = [self.setupTimeBtn.titleLabel.text componentsSeparatedByString:@","].firstObject;
    //适配plus
    if (JBScreenWidth == 414) {
        self.pickerView.xssj.origin = CGPointMake(23, 30);
        
    }else {
        self.pickerView.xssj.origin = CGPointMake(15, 30);
    }
    self.pickerView.frame = CGRectMake(0, 0, JBScreenWidth, JBScreenHeight);
    [self.pickerView setBackgroundColor:[UIColor clearColor]];
    self.pickerView.delegate = self;
    self.pickerView.type = type;
    // 今天开始往后的日期
    [self.pickerView.datePickerView setMinimumDate:[NSDate date]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
}

/// 保存originalImage到沙盒，返回图片名称
- (NSString *)saveImageToSandbox:(UIImage *)image {
    
    NSString *timeStamp = [NSDate getTimeStamp];
    NSString *imageName = [NSString stringWithFormat:@"%@.jpg",timeStamp];
    NSString *documentPath = [NSUserDefaults getDocumentPath];
    NSString *filePath =  [documentPath stringByAppendingPathComponent:imageName];
    NSData *data = UIImageJPEGRepresentation(image, 1);
    bool isSuccessed = [data writeToFile:filePath atomically:YES];
    if (isSuccessed) {
        NSLog(@"保存originalImage到沙盒成功！");
    }else{
        NSLog(@"保存originalImage到沙盒失败！");
    }
    
    return imageName;
}

- (NSString *)filePathForRecord
{
    // 根据当前时间来生成文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *name = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.pcm",name];
    
    // 获取文件名对应URL
    // 获取沙盒Document文件夹目录,用于保存到沙河
    NSString *documentPath = [NSUserDefaults getDocumentPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    return filePath;
}
// 创建recorder录音器
- (BOOL)createRecorder
{
    self.tempFilePathForRecord = self.filePathForRecord;
    NSURL *url = [NSURL fileURLWithPath:self.tempFilePathForRecord];
    //    JBLog(@"%@",url);
    //    NSMutableDictionary *settings = [NSMutableDictionary dictionary];
    //    settings[AVFormatIDKey] = @(kAudioFormatLinearPCM);
    //录音设置
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [recordSettings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [recordSettings setValue :[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];//44100.0 , 11025.0
    //通道数
    [recordSettings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];
    //创建录音机
    NSError *error=nil;
    BOOL success = YES;
    self.recorder = [[AVAudioRecorder alloc]initWithURL:url settings:recordSettings error:&error];   //给一个空的字典，是按照默认格式
    if (error) {
        success = NO;
        NSLog(@"创建录音机对象时发生错误，错误信息：%@",error.localizedDescription);
    }
    return success;
}

// 创建player播放器
- (void)createPlayerWithFileName:(NSString *)fileName
{
    NSString *filePath = [[NSUserDefaults getDocumentPath]stringByAppendingPathComponent:fileName];
    if ( [[NSFileManager defaultManager]fileExistsAtPath:filePath]) {
        NSLog(@"%@存在！！",fileName);
    }
    // 播放
    // 1. 获取音乐文件的URL
    if (filePath.length == 0 || filePath == NULL || filePath == nil) {
        return;
    }
    NSURL *url = [NSURL fileURLWithPath:filePath];
    //创建一个AVAudioPlayer播放器
    NSError *error=nil;
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
    // 设置音量
    self.player.volume = 1.0;
    if (error) {
        NSLog(@"创建播放器对象时发生错误，错误信息：%@",error.localizedDescription);
    }
}

- (void)playRecordWithFileName:(NSString *)fileName
{
    [self createPlayerWithFileName:fileName];
    //准备播放，做数据的缓存, 做音频相关硬件准备
    if ([self.player prepareToPlay]) {
        NSLog(@"准备播放条件成功!");
        // 如果player没有做好准备, paly方法会隐式的去调用prepareToPlay
        if ( [self.player play]) {
            NSLog(@"播放成功！");
            [self playAnimation];
        }
    }else{
        NSLog(@"准备播放条件失败!");
    }
}

// 语音播放动画
- (void)playAnimation
{
    self.inputView.userInteractionEnabled = NO;
    NSMutableArray *arrayImages=[NSMutableArray array];
    for (int i=1; i<=3; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"bofang%d",i]];
        [arrayImages addObject:image];
    }
    [JBAnimationView animateWithImages:arrayImages duration:self.player.duration inViewController:self showTime:YES];
}

// 录音动画
- (void)recordAnimation
{
    NSMutableArray *arrayImages=[NSMutableArray array];
    for (int i=0; i<=19; i++) {
        UIImage *image=[UIImage imageNamed:[NSString stringWithFormat:@"voice_%d",i]];
        [arrayImages addObject:image];
    }
    [JBAnimationView animateWithImages:arrayImages duration:MAXFLOAT inViewController:self showTime:NO];
}

- (void)stopAnimate
{
    self.inputView.userInteractionEnabled = YES;
    self.inputView.editable = YES;
    [self.player stop];
}

#pragma mark - 处理通知

- (void)appWillResignActive
{
    self.isResignActive = YES;
    self.view.transform = CGAffineTransformMakeTranslation(0, 0);
}

- (void)appWillEnterForeground
{
    self.isResignActive = NO;
}

- (void)KeyboardWillChangeFrame:(NSNotification *)notify
{
    if (self.isResignActive) {
        return;
    }
    NSDictionary *userInfo = notify.userInfo;
    CGRect keyboFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat ty = keyboFrame.origin.y - JBScreenHeight;
    [UIView animateWithDuration:0.25 animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        if (ty >= 0) {
            self.inputView.contentInset = UIEdgeInsetsZero;
        }else{
            self.inputView.contentInset = UIEdgeInsetsMake(-ty-self.inputView.y+35, 0, 0, 0);
        }
    }];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 懒加载

- (UIView *)topToolBarView
{
    if (!_topToolBarView) {
        _topToolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, JBScreenWidth, 35)];
        _topToolBarView.backgroundColor = [UIColor whiteColor];
    }
    return _topToolBarView;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton buttonWithTitle:@"" titleColor:[UIColor whiteColor] fontSize:18 imageName:@"savegood" bkgimageName:nil target:self action:@selector(save)];
        _saveBtn.y = 10;
        _saveBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        _saveBtn.origin = CGPointMake(20, 10);
        
    }
    return _saveBtn;
}

- (UIButton *)setupTimeBtn
{
    if (!_setupTimeBtn) {
        
        _setupTimeBtn = [UIButton buttonWithTitle:@"选择计划时间" titleColor:[UIColor lightGrayColor] fontSize:15 imageName:@"clock" bkgimageName:@"time-box2" target:self action:@selector(setupTime)];
        _setupTimeBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        _setupTimeBtn.frame = CGRectMake(5, 5+64, 143, 30);
        
    }
    return _setupTimeBtn;
}

- (UITextView *)inputView
{
    if (!_inputView) {
        _inputView = [[UITextView alloc] initWithFrame:CGRectMake(20, 30, JBScreenWidth-40, JBScreenHeight - 49-CGRectGetMaxY(self.setupTimeBtn.frame)-30)];
        if (JBScreenWidth == 375) {
            _inputView.height = _inputView.height + 30;
        }
        _inputView.font = [UIFont systemFontOfSize:15];
//        _inputView.editable = NO;
        // 破解UITextView编辑和点击图片无解之题
        HPTextViewTapGestureRecognizer *textViewTapGestureRecognizer = [[HPTextViewTapGestureRecognizer alloc] init];
        textViewTapGestureRecognizer.delegate = self;
        [_inputView addGestureRecognizer:textViewTapGestureRecognizer];
        _inputView.delegate = self;
    }
    return _inputView;
}


-(UIButton *)buttonitem {
    
    if (!_buttonitem) {
        _buttonitem = [[UIButton alloc]init];
        _buttonitem.frame = CGRectMake(160, 540, 100, 100);
        [_buttonitem setImage:[UIImage imageNamed:@"voice-unactivated"] forState:UIControlStateNormal];
        [_buttonitem setImage:[UIImage imageNamed:@"voice-activation"] forState:UIControlStateHighlighted];
        [_buttonitem addTarget:self action:@selector(startRecord) forControlEvents:UIControlEventTouchDown];
        [_buttonitem addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
        
        //适配plus
        if (JBScreenWidth == 414) {
            _buttonitem.origin = CGPointMake(155, JBScreenHeight - 150);
        }else if(JBScreenWidth == 320 ) {
            _buttonitem.origin = CGPointMake(135, JBScreenHeight - 125);
        }else {
            _buttonitem.origin = CGPointMake(135, JBScreenHeight - 150);
        }
        [self.view addSubview:_buttonitem];
    }
    return _buttonitem;
    
}

-(UIButton *)Labelbtn {
    
    if (!_Labelbtn) {
        _Labelbtn = [[UIButton alloc]init];
        _Labelbtn.frame = CGRectMake(280, 540, 50, 50);
        [_Labelbtn setImage:[UIImage imageNamed:@"Label"] forState:UIControlStateNormal];
        [_Labelbtn setImage:[UIImage imageNamed:@"Label"] forState:UIControlStateSelected];
        [_Labelbtn addTarget:self action:@selector(labelPromptClick) forControlEvents:UIControlEventTouchUpInside];
        
        //适配plus
        if (JBScreenWidth == 414) {
            _Labelbtn.origin = CGPointMake(320, JBScreenHeight - 115);
        }else if(JBScreenWidth == 320 ) {
            _Labelbtn.origin = CGPointMake(250, JBScreenHeight - 115);
        }else {
            _Labelbtn.origin = CGPointMake(290, JBScreenHeight - 115);
        }
        [self.view addSubview:_Labelbtn];
    }
    return _Labelbtn;
}

-(UIButton *)shotbtn {
    
    if (!_shotbtn) {
        _shotbtn = [[UIButton alloc]init];
        _shotbtn.frame = CGRectMake(280, 540, 50, 50);
        [_shotbtn setImage:[UIImage imageNamed:@"camera1"] forState:UIControlStateNormal];
        [_shotbtn setImage:[UIImage imageNamed:@"camera1"] forState:UIControlStateSelected];
        [_shotbtn addTarget:self action:@selector(ShootingClick) forControlEvents:UIControlEventTouchUpInside];
        //适配plus
        if (JBScreenWidth == 414) {
            _shotbtn.origin = CGPointMake(38, JBScreenHeight - 115);
        }else if(JBScreenWidth == 320 ) {
            _shotbtn.origin = CGPointMake(28, JBScreenHeight - 115);
        }else {
            _shotbtn.origin = CGPointMake(38, JBScreenHeight - 115);
        }
        [self.view addSubview:_shotbtn];
    }
    return _shotbtn;
    
}

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 40)];
        _bgView.layer.cornerRadius = 5;
        _bgView.clipsToBounds = YES;
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.8;
    }
    return _bgView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.text = @"请选择需要添加标签的图片";
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

@end
