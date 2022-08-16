//
//  FeatCell.h
//  VHYunSDKDemo_LSS
//
//  Created by LiGuoliang on 2022/3/9.
//  Copyright © 2022 vhall. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FeatCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) UIColor *highlightedColor;
@property (nonatomic) UIColor *normalColor;
@end

NS_ASSUME_NONNULL_END
