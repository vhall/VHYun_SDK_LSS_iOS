//
//  OptItem.h
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2022/5/13.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OptItem : NSObject
@property (nonatomic) NSString *title;
@property (nonatomic) BOOL available;
+ (instancetype)itemWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
