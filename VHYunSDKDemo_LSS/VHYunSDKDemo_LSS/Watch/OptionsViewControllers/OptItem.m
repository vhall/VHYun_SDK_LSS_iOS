//
//  OptItem.m
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2022/5/13.
//  Copyright © 2022 vhall. All rights reserved.
//

#import "OptItem.h"

@implementation OptItem
+ (instancetype)itemWithTitle:(NSString *)title {
    OptItem *item = [OptItem new];
    item.title = title;
    item.available = YES;
    return item;
}
@end
