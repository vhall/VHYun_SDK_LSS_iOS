//
//  WatchVodViewController.h
//  VHYunSDKDemo
//
//  Created by vhall on 2017/11/24.
//  Copyright © 2017年 www.vhall.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VHBaseViewController.h"
#import <VHLSS/VHVodPlayer.h>

@interface WatchVodViewController : VHBaseViewController
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithRecordID:(NSString *)recordID accessToken:(NSString *)accessToken seekMode:(VHVodPlayerSeeekModel)seekMode;
@end
