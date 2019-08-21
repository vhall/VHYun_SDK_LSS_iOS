//
//  VHPlayerSkinTool.h
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/7/31.
//  Copyright © 2019 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VHPlayerSkinTool : NSObject

+ (NSString *)timeFormat:(NSInteger)totalTime;

+ (float)progress:(float)totalTime currentTime:(float)currentTime;

//+ (NSMutableArray *)sortResolutionWithVHDefinitions:(NSArray *)definitions;
//+ (NSInteger)resolutonWithVhallDefinition:(int)definition;

+ (NSString *)defination:(NSInteger)defination;

@end

NS_ASSUME_NONNULL_END
