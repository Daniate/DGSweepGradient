//
//  DGSweepGradientView.m
//  DGSweepGradient
//
//  Created by Daniate on 2017/9/1.
//  Copyright © 2017年 Daniate. All rights reserved.
//

#import "DGSweepGradientView.h"

@interface DGSweepGradientView ()
@property (nonatomic, readonly, strong) DGSweepGradientLayer *gradientLayer;
@end

@implementation DGSweepGradientView

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.gradientLayer.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.gradientLayer.delegate = self;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

+ (Class)layerClass {
    return [DGSweepGradientLayer class];
}

- (void)setLineColor:(UIColor *)lineColor {
    self.gradientLayer.lineColor = lineColor;
}

- (UIColor *)lineColor {
    return self.gradientLayer.lineColor;
}

- (void)setLineWidth:(CGFloat)lineWidth {
    self.gradientLayer.lineWidth = lineWidth;
}

- (CGFloat)lineWidth {
    return self.gradientLayer.lineWidth;
}

- (void)setStartColor:(UIColor *)startColor {
    self.gradientLayer.startColor = startColor;
}

- (UIColor *)startColor {
    return self.gradientLayer.startColor;
}

- (void)setEndColor:(UIColor *)endColor {
    self.gradientLayer.endColor = endColor;
}

- (UIColor *)endColor {
    return self.gradientLayer.endColor;
}

- (void)setStartAngle:(CGFloat)startAngle {
    self.gradientLayer.startAngle = startAngle;
}

- (CGFloat)startAngle {
    return self.gradientLayer.startAngle;
}

- (void)setEndAngle:(CGFloat)endAngle {
    self.gradientLayer.endAngle = endAngle;
}

- (CGFloat)endAngle {
    return self.gradientLayer.endAngle;
}

- (void)setProgress:(CGFloat)progress {
    self.gradientLayer.progress = progress;
}

- (CGFloat)progress {
    return self.gradientLayer.progress;
}

- (DGSweepGradientLayer *)gradientLayer {
    return (DGSweepGradientLayer *)self.layer;
}

#pragma mark - CALayerDelegate
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    if ([event isEqualToString:NSStringFromSelector(@selector(lineColor))] ||
        [event isEqualToString:NSStringFromSelector(@selector(lineWidth))] ||
        [event isEqualToString:NSStringFromSelector(@selector(startColor))] ||
        [event isEqualToString:NSStringFromSelector(@selector(endColor))] ||
        [event isEqualToString:NSStringFromSelector(@selector(startAngle))] ||
        [event isEqualToString:NSStringFromSelector(@selector(endAngle))] ||
        [event isEqualToString:NSStringFromSelector(@selector(progress))]) {
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:event];
        anim.fromValue = self.gradientLayer.presentationLayer ? [self.gradientLayer.presentationLayer valueForKey:event] : [self valueForKey:event];
        anim.duration = .3;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
        return anim;
    }
    return [super actionForLayer:layer forKey:event];
}

@end
