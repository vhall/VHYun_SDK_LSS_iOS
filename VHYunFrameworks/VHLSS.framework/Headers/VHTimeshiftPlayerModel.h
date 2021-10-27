//
//  VHTimeshiftPlayerModel.h
//  VHLive
//
//  Created by 郭超 on 2021/8/16.
//  Copyright © 2021 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHTimeshiftPlayerModel : NSObject

- (instancetype)initWithLogParam:(NSDictionary*)logParam;

- (void)loadWithParam:(NSDictionary*)param
              success:(void(^)(VHTimeshiftPlayerModel* playerModel))success
               failed:(void(^)(NSError *error))failedBlock;

@property (nonatomic,copy,readonly)NSString  * roomID;
@property (nonatomic,copy,readonly)NSString  * accessToken;

// 对外提供
@property (nonatomic,copy,readonly)NSString  * default_playUrls;  //默认调度数据 包含线路 清晰度 token
@property (nonatomic,copy,readonly)NSString  * dispatchUrl;     //点播调度url
@property (nonatomic,copy,readonly)NSString  * protocol;        //播放协议 hls_domainname mp4_domainname
@property (nonatomic,copy,readonly)NSString  * logStr;
@property (nonatomic,copy,readonly)NSString  * watermark_img;//水印图片
@property (nonatomic,assign,readonly)NSInteger watermark_type;//水印图片位置 水印位置 [0,1,2,3,4] 对应 [无水印,左上角,右上角,右下角,左下角]
@property (nonatomic,assign)BOOL   isQAndAStream;//是否是在线答题流
@property (nonatomic,assign,readonly)NSInteger  stream_status; // 1推流中 2 未推流
@property (nonatomic,assign)BOOL   cast_screen;//是否开启投屏 默认Yes
@property(nonatomic, assign) BOOL live_subtitle;//是否开通实时字幕 1 开通 0 未开通

@property (nonatomic,copy,readonly)NSDictionary *logParam;

@property(nonatomic, assign) NSInteger live_duration;//使用直播时移时 当前直播间直播了多久

/** 下载水印图片*/
- (void)downloadWatermark:(void(^)(UIImage *image))block;

@end

NS_ASSUME_NONNULL_END
