//
//  NSAttributedString+Extension.m
//  备忘录
//
//  Created by ejb on 2016/11/12.
//  Copyright © 2016年 李海生. All rights reserved.
//

#import "NSAttributedString+Extension.h"
#import "JBTextAttachment.h"

@implementation NSAttributedString (Extension)
- (NSString *)getPlainString {
    
    //最终纯文本
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    
    //替换下标的偏移量
    __block NSUInteger base = 0;
    
    //遍历
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      //检查类型是否是自定义NSTextAttachment类
                      if (value && [value isKindOfClass:[JBTextAttachment class]]) {
                          NSString *string = [NSString stringWithFormat:@"ψ%@ψ",((JBTextAttachment *) value).imageName];
                          //替换
                          [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length)
                                                     withString:string];
                          //增加偏移量
                          base += ((JBTextAttachment *) value).imageName.length+1;
                      }
                  }];
    return [plainString stringByReplacingOccurrencesOfString:@"\n\n" withString:@""];
}

- (NSString *)getImageNames
{
    
    __block NSString *imageNames = nil;
    
    //遍历
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      //检查类型是否是自定义NSTextAttachment类
                      if (value && [value isKindOfClass:[JBTextAttachment class]]) {
                          NSString *imageName = ((JBTextAttachment *) value).imageName;
                          if ([imageName hasSuffix:@".jpg"]) {
                              if (!imageNames) {
                                  imageNames = imageName;
                              }else{
                                  imageNames = [NSString stringWithFormat:@"%@,%@",imageNames,imageName];
                              }
                          }
                      }
                  }];
    
    return imageNames;
}


- (NSDictionary *)getImageNumAndVoiceNum
{
    
    __block NSUInteger imageNum=0,voiceNum=0;
    
    //遍历
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length)
                     options:0
                  usingBlock:^(id value, NSRange range, BOOL *stop) {
                      
                      //检查类型是否是自定义NSTextAttachment类
                      if (value && [value isKindOfClass:[JBTextAttachment class]]) {
                          NSString *imageName = ((JBTextAttachment *) value).imageName;
                          if ([imageName hasSuffix:@".jpg"]) {
                              imageNum++;
                          }else{
                              voiceNum++;
                          }
                      }
                  }];
    
    return @{@"imageNum":@(imageNum),@"voiceNum":@(voiceNum)};
}

@end
