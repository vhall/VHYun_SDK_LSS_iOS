//
//  WatchViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/22.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHBaseViewController.h"

@interface WatchViewController : VHBaseViewController

- (instancetype)initWithRoomID:(NSString *)lssID accessToken:(NSString *)accessToken BufferTime:(NSInteger)bufferTime;

- (instancetype)initWithRoomID:(NSString *)lssID interactID:(NSString *)inavID accessToken:(NSString *)accessToken BufferTime:(NSInteger)bufferTime;

- (instancetype)init NS_UNAVAILABLE;
@end
