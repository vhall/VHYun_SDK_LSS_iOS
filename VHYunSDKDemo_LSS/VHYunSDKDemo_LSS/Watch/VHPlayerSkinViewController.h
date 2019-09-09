//
//  VHPlayerSkinViewController.h
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/8/2.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface VHPlayerSkinViewController : VHBaseViewController

- (instancetype)initWithLiveId:(NSString *)liveId accessToken:(NSString *)token;
- (instancetype)initWithrecordId:(NSString *)recordId accessToken:(NSString *)token;

@end

NS_ASSUME_NONNULL_END
