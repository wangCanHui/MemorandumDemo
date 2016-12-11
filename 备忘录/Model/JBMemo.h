//
//  JBMemo.h
//  备忘录
//
//  Created by ejb No.2 on 2016/10/20.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JBMemo : NSObject
@property (nonatomic,assign) int memo_id;
@property (nonatomic,assign) int jws_id;
/// 所有被图片分隔的段落文本 详情内容里面的内容  图片文本存储的地方
@property (nonatomic,copy) NSString *contents;
/// 所有图片名称
@property (nonatomic,copy) NSString *imageNames;
@property (nonatomic,copy) NSString *textContent;
/// 权限成员
//@property (nonatomic,copy) NSString *members;
@property (nonatomic,assign,getter=isVisible) BOOL visible;
@property (nonatomic,copy) NSString *headerIcon;
///用户id
@property (nonatomic,assign) NSInteger creatorId;
///创建时间
@property (nonatomic,copy) NSString *createTime;
///计划时间
@property (nonatomic,copy) NSString *planTime;
@property (nonatomic,copy) NSString *memo_time;
///列表显示的时间
@property (nonatomic,copy) NSString *updateTime;
///列表显示的家务事标题
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *firstContent;
///详情列表
@property (nonatomic,copy) NSString *content;
///语音数量
@property (nonatomic,assign) int voiceNum;
///视频数量
@property (nonatomic,assign) int videoNum;
//标记是否@谁 谁可以点击完成 @到的显示1？
@property (nonatomic,assign) NSInteger ispointTo;
/// 状态：0默认，1完成 这个是列表显示的完成任务
@property (nonatomic,assign) NSInteger taskStatus;
///任务完成时间
@property (nonatomic,assign) NSString *completeTime;
@property (nonatomic,assign) BOOL isShowRecord;
//存储@谁 帮姐ID数组
@property (nonatomic,copy) NSString *sIds;
//存储@谁 用户ID数组
@property (nonatomic,copy) NSString *userIds;
///groupType 分组键值id
@property (nonatomic,assign) NSInteger *groupType;
///group的小分组里面的那个组读
@property (nonatomic,copy) NSString *whoRead;
///显示@谁的名字存储进这个字段
@property (nonatomic,copy) NSString *pointTo;
///完成者ID
@property (nonatomic,assign) NSInteger completorId;
///完成者类  0是用户 1是帮姐
@property (nonatomic,assign) NSInteger completorType;
///类型
@property (nonatomic,copy)NSString *itemType;
///图片
@property (nonatomic,copy) NSString *url;
///图片名字
@property (nonatomic,copy) NSString *sisurl;
///合成图片
@property (nonatomic,copy) NSString *imgtags;
///标签X
@property (nonatomic,copy) NSString *pointX;
//标签Y
@property (nonatomic,copy) NSString *pointY;
///图片数量
@property (nonatomic,assign) int picNum;
///语音时长
@property (nonatomic,copy) NSString *duration;
///是否修改1 还是增加0
@property (nonatomic,assign) NSInteger *updated;
///是否是网络图片0是本地或者1是网络区分
@property (nonatomic,assign) NSInteger *isOutImg;
/// 列表页图片
@property (nonatomic,copy) NSString *img;
@property (nonatomic,strong) NSArray *users;
/// 是否显示展开收起按钮
@property (nonatomic,assign) BOOL isShowExpandedView;
@end
