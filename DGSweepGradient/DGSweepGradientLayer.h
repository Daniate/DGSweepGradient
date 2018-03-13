//
//  DGSweepGradient.h
//  DGSweepGradient
//
//  Created by Daniate on 2017/9/1.
//  Copyright © 2017年 Daniate. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

/**
 iOS SDK 只支持线性渐变及辐射渐变。
 
 模仿实现Android中的SweepGradient：
 https://developer.android.google.cn/reference/android/graphics/SweepGradient.html
 */
@interface DGSweepGradientLayer : CALayer
/**
 default is [UIColor groupTableViewBackgroundColor]
 */
@property (nonatomic, nonnull, copy) UIColor *lineColor;
/**
 default is 10. limit: [0, MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds)) / 2]
 */
@property (nonatomic, assign) CGFloat lineWidth;
/**
 default is [UIColor blackColor]
 */
@property (nonatomic, nonnull, copy) UIColor *startColor;
/**
 default is [UIColor whiteColor]
 */
@property (nonatomic, nonnull, copy) UIColor *endColor;
/**
 default is 0
 */
@property (nonatomic, assign) CGFloat startAngle;
/**
 default is 2 * M_PI
 */
@property (nonatomic, assign) CGFloat endAngle;
/**
 progress from `startAngle` to `endAngle`. default is 1. limit: [0, 1]
 */
@property (nonatomic, assign) CGFloat progress;
@end
