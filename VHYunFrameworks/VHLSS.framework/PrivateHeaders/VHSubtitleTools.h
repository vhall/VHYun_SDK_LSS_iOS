//
//  VHSubtitleTools.h
//  VHLssVod
//
//  Created by xiongchao on 2020/11/3.
//  Copyright © 2020 vhall. All rights reserved.
//
//字幕下载及解析工具类
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class VHVidoeSubtitleModel;
@interface VHSubtitleTools : NSObject

//获取字幕详情（即获取该字幕每一句话的信息列表）
+ (void)getSubtitleDetailWithModel:(VHVidoeSubtitleModel *)subtitleModel success:(void(^)(NSArray <VHVidoeSubtitleItemModel *> *subtitleItems))success fail:(void(^)(NSError *error))fail;

@end

NS_ASSUME_NONNULL_END
