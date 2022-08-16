//
//  DemoViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/16.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import "VHBaseViewController.h"
#import <VHLSS/VHPublishConfig.h>

@interface PublishViewController : VHBaseViewController

- (instancetype)initWithRoomID:(NSString *)roomID accessToken:(NSString *)accesstoken publishConfig:(VHPublishConfig *)config;

- (instancetype)init NS_UNAVAILABLE;
@end
