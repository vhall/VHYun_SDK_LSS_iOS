//
//  AppDelegate.m
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/7/19.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "AppDelegate.h"
#import "LSSViewController.h"

@implementation AppDelegate

- (NSArray *)datas {

#error 步骤
/// 1、关闭bitcode
/// 2、设置plist中 App Transport Security Settings -> Allow Arbitrary Loads 设置为YES
/// 3、设置plist中 Privacy - Camera Usage Description      是否允许使用相机
/// 4、设置plist中 Privacy - Microphone Usage Description  是否允许使用麦克风
/// 5、设置以下数据 检查 Bundle ID 即可观看直播

#error 请进行相应参数设置
/// 参数参考 : https://www.vhallyun.com/docs/show/2
    return @[@{
        @"settings":@{
            @"AppID"             : @"", // 必须
            @"AccessToken"       : @"", // 必须
            @"PublishRoomID"     : @"", // 必须
            @"PlayerRoomID"      : @"", // 可选
            @"RecordID"          : @"", // 可选
            @"DocChannelID"      : @"", // 可选
            @"IMChannelID"       : @"", // 可选
            @"InteractiveID"     : @"" // 可选
        }}];
}

/// < 无需修改 > 运行App前的相关设置，用于内部开发环境和外部配置信息
- (void)preLaunchConfigure {
    NSDictionary *configure;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"configure" ofType:@"data"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    BOOL VHDevMode = NO;
    if(data){
        configure = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    }
    NSArray *envdatas = configure ? configure[@"envs"] : [self datas];
    VHDevMode = configure!=nil;
    GLEnvs *envs = [GLEnvs defaultWithEnvironments:envdatas];
    [envs setShowTopLine:VHDevMode];
    [envs enableWithShakeMotion:VHDevMode defaultIndex:0];
    envs.handleListenerWillChange = ^BOOL(NSDictionary *curEnv, NSDictionary *toEnv) {
        return NO;
    };
    [GLEnvs manualChangeEnv:0];
    VHDevMode ? ((void(*)(id,SEL,BOOL))objc_msgSend)(NSClassFromString(configure[@"yundev"][@"class"]),NSSelectorFromString(configure[@"yundev"][@"sel"]),VHDevMode) : nil;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self preLaunchConfigure];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [LSSViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillTerminate:(UIApplication *)application {
    VHSystemArchive();  // 保存设置的变量环境
}
@end
