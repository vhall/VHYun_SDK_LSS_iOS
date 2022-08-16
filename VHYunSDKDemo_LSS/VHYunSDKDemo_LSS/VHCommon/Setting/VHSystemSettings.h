//
//  VHSystemSettings.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#define VHSystemInstance            [VHSystemSettings sharedSetting]
void VHSystemArchive(void);

@interface VHSystemSettings : NSObject <NSSecureCoding>
@property (nonatomic) NSString *host;
@property (nonatomic) NSString *groupID;
@property(nonatomic, strong)NSString* appID;
@property(nonatomic, strong)NSString* third_party_user_id;  //第三方ID
@property(nonatomic, strong)NSString* accessToken;          //AccessToken 根据开通的服务生成对应的 AccessToken
@property (nonatomic) NSString* nickName;  //昵称
@property (nonatomic) NSString* avatar;    //头像
@property (nonatomic) NSString* playerRoomID;         //看直播房间ID
@property (nonatomic) NSInteger bufferTime;           //RTMP观看缓冲时间
@property (nonatomic) NSString* publishRoomID;        //发直播房间ID
@property (nonatomic) NSString* videoResolution;      //发起直播分辨率 VideoResolution [0,3] 默认1
@property (nonatomic) NSInteger videoBitRate;         //发直播视频码率
@property (nonatomic) NSInteger audioBitRate;         //发直播视频码率
@property (nonatomic) NSInteger videoCaptureFPS;      //发直播视频帧率 ［1～30］ 默认10
@property (nonatomic) BOOL      isOpenNoiseSuppresion;//开启降噪 默认YES
@property (nonatomic) float     volumeAmplificateSize;//开启降噪 默认1.0
@property (nonatomic) BOOL      isOnlyAudio;          //是否纯音频推流
@property (nonatomic) BOOL      isBeautifyFilterEnable;//是否开启美颜
@property (nonatomic) NSString* recordID;             //点播房间ID
@property (nonatomic) BOOL      seekMode;             //seek 播放器是否只支持在播放过的时段seek
@property (nonatomic) NSString* docChannelID;         //文档ChannelID
@property (nonatomic) NSString* docRoomID;            //文档绑定roomID
@property (nonatomic) NSString* imChannelID;          //im ChannelID
@property (nonatomic) NSString*   ilssRoomID;           //互动房间ID
@property (nonatomic) NSString*   ilssLiveRoomID;       //旁路直播间ID
@property (nonatomic) NSInteger   ilssType;              //摄像头及推流参数设置
@property (nonatomic) NSDictionary* ilssOptions;            //摄像头及推流参数设置
@property (nonatomic) BOOL isDouble;            //是否开启双流
@property (nonatomic) NSString*   userData;           //互动房间userData

+ (VHSystemSettings *)sharedSetting;
+ (void)writeToStorage;
@end
