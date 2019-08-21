//
//  VHCstomResolutionView.h
//  VHPlayerSkinDemo
//
//  Created by vhall on 2019/8/1.
//  Copyright © 2019 vhall. All rights reserved.
//

#import "VHSkinCoverView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VHCstomResolutionViewDelegate <NSObject>

- (void)resolutionBtnAction:(UIButton *)sender resolution:(NSInteger)definition title:(NSString *)title;

@end


@interface VHCstomResolutionView : VHSkinCoverView

- (void)resolutionArray:(NSArray *)definitions curDefinition:(NSInteger)definition;

@property (nonatomic, weak) id <VHCstomResolutionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
