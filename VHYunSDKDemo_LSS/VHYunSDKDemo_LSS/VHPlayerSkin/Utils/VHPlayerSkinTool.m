//
//  VHPlayerSkinTool.m
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/7/31.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHPlayerSkinTool.h"

@implementation VHPlayerSkinTool

+ (NSString *)timeFormat:(NSInteger)totalTime {
    if (totalTime < 0) {
        return @"00:00";
    }
    NSInteger durHour = totalTime / 3600;
    NSInteger durMin = (totalTime / 60) % 60;
    NSInteger durSec = totalTime % 60;
    
    if (durHour > 0) {
        return [NSString stringWithFormat:@"%zd:%02zd:%02zd", durHour, durMin, durSec];
    } else {
        return [NSString stringWithFormat:@"%02zd:%02zd", durMin, durSec];
    }
}

+ (float)progress:(float)totalTime currentTime:(float)currentTime {

    return ceilf(currentTime) / ceilf(totalTime);
}

//+ (NSMutableArray *)sortResolutionWithVHDefinitions:(NSArray *)definitions {
//    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:5];//1080p 720p 480p 360p 原画 音频 5 ~ 0
//    //VHPlayerDefinitionOrigin             = 0,    //原画
//    //VHPlayerDefinitionUHD                = 1,    //超高清 1080p
//    //VHPlayerDefinitionHD                 = 2,    //高清   720p
//    //VHPlayerDefinitionSD                 = 3,    //标清   480p
//    //VHPlayerDefinitionAudio              = 4,    //纯音频
//    for (NSNumber *num in definitions) {
//        if ([num  isEqual: @0]) {
//            [arr insertObject:num atIndex:1];
//        }
//        if ([num  isEqual: @1]) {
//            [arr insertObject:num atIndex:5];
//        }
//        if ([num  isEqual: @2]) {
//            [arr insertObject:num atIndex:4];
//        }
//        if ([num  isEqual: @3]) {
//            [arr insertObject:num atIndex:3];
//        }
//        if ([num  isEqual: @4]) {
//            [arr insertObject:num atIndex:0];
//        }
//    }
//    return arr;
//}
//+ (NSInteger)resolutonWithVhallDefinition:(int)definition {
//    //vhall分辨率 0原画 1超高清 2高清 3标清 4音频
//    //1080p 720p 480p 360p 原画 音频 5 ~ 0
//
//    return 0;
//}

+ (NSString *)defination:(NSInteger)defination
{
    NSArray *titles = @[@"原画",@"720p",@"480p",@"360p",@"音频"];
    if (defination >= 0 && defination <= 4) {
        return titles[defination];
    }
    //    VHDefinitionOrigin             = 0,    //原画
    //    VHDefinitionUHD                = 1,    //超高清    720p
    //    VHDefinitionHD                 = 2,    //高清      480p
    //    VHDefinitionSD                 = 3,    //标清      360p
    //    VHDefinitionAudio              = 4,    //音频
    return @"";
}


@end
