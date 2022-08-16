//
//  VHSystemSetting.m
//  VHYunSDKDemo
//
//  Created by vhall on 2017/12/19.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//


#import "VHSystemSettings.h"
#import <objc/message.h>
#import <sys/utsname.h>

void VHSystemArchive(void) {
    [VHSystemSettings writeToStorage];
}

@implementation VHSystemSettings
# pragma mark- init

+ (VHSystemSettings *)sharedSetting {
    static dispatch_once_t onceToken;
    static VHSystemSettings *instance;
    dispatch_once(&onceToken, ^{
        if(instance == nil){
            instance = [VHSystemSettings loadFromStorage];
        }
    });
    return instance;
}

+ (BOOL)supportsSecureCoding {
    return YES;
}
- (instancetype)initWithCoder:(NSCoder *)coder {
    uint count = 0;
    objc_property_t *ps = class_copyPropertyList([self class], &count);
    for(int i=0; i<count; i++){
        objc_property_t p = ps[i];
        NSString *prop_name = [NSString stringWithCString:property_getName(p) encoding:NSUTF8StringEncoding];
        NSString *prop_attr = @(property_getAttributes(p));
        if([prop_attr hasPrefix:@"T@"]) {
            [self setValue:[coder decodeObjectForKey:prop_name] forKey:prop_name];
        }
    }
    free(ps);
    return self;
}
- (void)encodeWithCoder:(NSCoder *)coder {
    uint count = 0;
    objc_property_t *ps = class_copyPropertyList([self class], &count);
    for(int i=0; i<count; i++){
        objc_property_t p = ps[i];
        NSString *prop_name = [NSString stringWithCString:property_getName(p) encoding:NSUTF8StringEncoding];
        NSString *prop_attr = @(property_getAttributes(p));
        if([prop_attr hasPrefix:@"T@"]) {
            [coder encodeObject:[self valueForKey:prop_name] forKey:prop_name];
        }
    }
    free(ps);
}
+ (VHSystemSettings *)loadFromStorage {
    VHSystemSettings *instance = nil;
    if([[NSFileManager defaultManager] fileExistsAtPath:[VHSystemSettings path]]) {
        instance = [NSKeyedUnarchiver unarchiveObjectWithFile:[VHSystemSettings path]];
    }
    if (instance == nil) {
        instance = [VHSystemSettings new];
    }else{
        NSLog(@">>> 读档成功...");
    }
    return instance;
}
+ (void)writeToStorage {
    BOOL suc = [NSKeyedArchiver archiveRootObject:[VHSystemSettings sharedSetting] toFile:[VHSystemSettings path]];
    NSLog(@">>> 归档%@...", suc ? @"成功": @"失败");
}
+ (NSString *)path {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"vd_archive_t"];
}
#pragma mark - 基础设置
GETTER(NSString *, groupID, @"group.com.vhall.BroadcastNew.group");
GETTER(NSString *, appID, [GLEnvs current][@"AppID"]);
GETTER(NSString *, accessToken, [GLEnvs current][@"AccessToken"]);
GETTER(NSString *, playerRoomID, [GLEnvs current][@"PlayerRoomID"]);
GETTER(NSString *, recordID, [GLEnvs current][@"RecordID"]);
GETTER(NSString *, docChannelID, [GLEnvs current][@"DocChannelID"]);
GETTER(NSString *, imChannelID, [GLEnvs current][@"IMChannelID"]);
GETTER(NSString *, ilssRoomID, [GLEnvs current][@"InteractiveID"]);
GETTER(NSString *, ilssLiveRoomID, [GLEnvs current][@"PublishRoomID"]);
GETTER(NSString *, nickName, @"VHnickName");
GETTER(NSString *, avatar, @"https://cnstatic01.e.vhall.com/upload/user/avatar/7b/75/7b75555e8c4e53b04cfa74da8c23011b.jpg");
GETTER(NSInteger, bufferTime, 2);
GETTER(NSString *, publishRoomID, nil);
GETTER(NSString *, videoResolution, nil);
GETTER(NSInteger, videoBitRate, 0);
GETTER(NSInteger, audioBitRate, 0);
GETTER(NSInteger, videoCaptureFPS, 15);
GETTER(BOOL, isOpenNoiseSuppresion, NO);
GETTER(float, volumeAmplificateSize, 0);
GETTER(NSString *, docRoomID, @"");
GETTER(NSInteger, ilssType, 0);

- (NSString *)third_party_user_id {
    if(!_third_party_user_id) {
        struct utsname systemInfo;
        uname(&systemInfo);
        NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
        platform= [platform stringByReplacingOccurrencesOfString:@"," withString:@"_"];
        _third_party_user_id = [NSString stringWithFormat:@"%@_%d",platform,(arc4random()%1000000)];
    }
    return _third_party_user_id;
}
- (NSDictionary *)ilssOptions {
    if(!_ilssOptions) {
        _ilssOptions = @{
            @"frameResolutionType":@(0),
            @"streamType":@(2),
            @"numSpatialLayers":@(1)
        };
    }
    return _ilssOptions;
}
@end
