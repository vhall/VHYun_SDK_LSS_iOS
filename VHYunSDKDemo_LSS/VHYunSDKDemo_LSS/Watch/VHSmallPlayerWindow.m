//
//  VHSmallPlayerWindow.m
//  VHYunSDKDemo_LSS
//
//  Created by vhall on 2019/8/23.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHSmallPlayerWindow.h"

#define FLOAT_VIEW_WIDTH  200
#define FLOAT_VIEW_HEIGHT 112

@interface VHSmallPlayerWindow()


@end

@implementation VHSmallPlayerWindow

+ (instancetype)sharedInstance {
    static VHSmallPlayerWindow *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[VHSmallPlayerWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return instance;
}

- (void)show {
    
}

- (void)hide {
    
}



@end
