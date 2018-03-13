//
//  DGSweepGradient.m
//  DGSweepGradient
//
//  Created by Daniate on 2017/9/1.
//  Copyright © 2017年 Daniate. All rights reserved.
//

#import "DGSweepGradientLayer.h"

@interface DGSweepGradientLayer ()
/**
 default is 360
 */
@property (nonatomic, assign) NSUInteger segmentCount;
@property (nonatomic, assign) CGFloat fixedLineWidth;
@property (nonatomic, assign) CGFloat fixedProgress;
@end

@implementation DGSweepGradientLayer

@dynamic lineColor;
@dynamic lineWidth;
@dynamic startColor;
@dynamic endColor;
@dynamic startAngle;
@dynamic endAngle;
@dynamic progress;

+ (instancetype)layer {
    return [super layer];
}

- (instancetype)init {
    if (self = [super init])  {
        [self _init];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self _init];
    }
    return self;
}

- (instancetype)initWithLayer:(id)layer {
    if (self = [super initWithLayer:layer]) {
        if ([layer isKindOfClass:[DGSweepGradientLayer class]]) {
            self.needsDisplayOnBoundsChange = YES;
            self.contentsScale = [UIScreen mainScreen].scale;
            self.allowsEdgeAntialiasing = YES;

            DGSweepGradientLayer *sgLayer = (DGSweepGradientLayer *)layer;
            self.segmentCount = sgLayer.segmentCount;
            self.lineColor = sgLayer.lineColor;
            self.lineWidth = sgLayer.lineWidth;
            self.startColor = sgLayer.startColor;
            self.endColor = sgLayer.endColor;
            self.startAngle = sgLayer.startAngle;
            self.endAngle = sgLayer.endAngle;
            self.progress = sgLayer.progress;
        } else {
            [self _init];
        }
    }
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:NSStringFromSelector(@selector(segmentCount))] ||
        [key isEqualToString:NSStringFromSelector(@selector(lineColor))] ||
        [key isEqualToString:NSStringFromSelector(@selector(lineWidth))] ||
        [key isEqualToString:NSStringFromSelector(@selector(startColor))] ||
        [key isEqualToString:NSStringFromSelector(@selector(endColor))] ||
        [key isEqualToString:NSStringFromSelector(@selector(startAngle))] ||
        [key isEqualToString:NSStringFromSelector(@selector(endAngle))] ||
        [key isEqualToString:NSStringFromSelector(@selector(progress))]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (void)_init {
    self.needsDisplayOnBoundsChange = YES;
    self.contentsScale = [UIScreen mainScreen].scale;
    self.allowsEdgeAntialiasing = YES;
    
    self.segmentCount = 72;
    
    [self setValue:[UIColor groupTableViewBackgroundColor] forKey:@"lineColor"];
    [self setValue:@(10) forKey:@"lineWidth"];
    [self setValue:[UIColor redColor] forKey:@"startColor"];
    [self setValue:[UIColor greenColor] forKey:@"endColor"];
    [self setValue:@(0) forKey:@"startAngle"];
    [self setValue:@(2 * M_PI) forKey:@"endAngle"];
    [self setValue:@(1) forKey:@"progress"];
}

- (void)setSegmentCount:(NSUInteger)segmentCount {
    NSUInteger fixedSegmentCount = MAX(1, MIN(360, segmentCount));
    if (_segmentCount != fixedSegmentCount) {
        _segmentCount = fixedSegmentCount;
        [self setNeedsDisplay];
    }
}

- (void)drawInContext:(CGContextRef)ctx {
    [super drawInContext:ctx];
    
    CGRect bounds = self.bounds;
    CGFloat minWH = MIN(CGRectGetWidth(bounds), CGRectGetHeight(bounds));
    
    CGFloat minLineWidth = 0;
    CGFloat maxLineWidth = minWH / 2;
    
    CGFloat minProgress = 0;
    CGFloat maxProgress = 1;
    
    self.fixedLineWidth = MIN(MAX(minLineWidth, self.lineWidth), maxLineWidth);
    self.fixedProgress = MIN(MAX(minProgress, self.progress), maxProgress);
    
    CGFloat outerRadius = maxLineWidth;
    CGFloat innerRadius = outerRadius - self.fixedLineWidth;
    
    CGPoint center = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path addArcWithCenter:center radius:outerRadius startAngle:0 endAngle:2*M_PI clockwise:YES];
    [path addArcWithCenter:center radius:innerRadius startAngle:2*M_PI endAngle:0 clockwise:NO];
    [path closePath];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, 0);
    CGContextSetFillColorWithColor(ctx, self.lineColor.CGColor);
    CGContextFillPath(ctx);
    
    [self drawSegmentsWithCount:self.segmentCount - 1 context:ctx];
    [self drawSegmentsWithCount:self.segmentCount context:ctx];
    [self drawSegmentsWithCount:self.segmentCount + 1 context:ctx];
}

- (void)drawSegmentsWithCount:(NSUInteger)segmentCount context:(CGContextRef)ctx
{
    CGRect bounds = self.bounds;
    CGPoint centerPoint = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds));
    
    CGFloat minWH = MIN(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGFloat radius = (minWH - self.fixedLineWidth) / 2;
    
    CGFloat r1, g1, b1, a1;
    CGFloat r2, g2, b2, a2;
    [self.startColor getRed:&r1 green:&g1 blue:&b1 alpha:&a1];
    [self.endColor getRed:&r2 green:&g2 blue:&b2 alpha:&a2];
    
    UIColor *fromColor = self.startColor;
    float endAngle = self.startAngle + (self.endAngle - self.startAngle) * self.fixedProgress;
    for(int i = 0; i < segmentCount; ++i)
    {
        CGFloat p1 = (CGFloat)(i) / segmentCount;
        CGFloat p2 = (CGFloat)(i + 1) / segmentCount;
        
        UIColor *toColor = [UIColor colorWithRed:p2 * r2 + (1 - p2) * r1
                                           green:p2 * g2 + (1 - p2) * g1
                                            blue:p2 * b2 + (1 - p2) * b1
                                           alpha:p2 * a2 + (1 - p2) * a1];
        
        float fromAngle = self.startAngle + p1 * (endAngle - self.startAngle);
        float toAngle = self.startAngle + p2 * (endAngle - self.startAngle);
        [self drawSegmentWithCenter:centerPoint
                               from:fromAngle
                                 to:toAngle
                             radius:radius
                         startColor:fromColor
                           endColor:toColor
                            context:ctx];
        
        fromColor = toColor;
    }
}

- (void)drawSegmentWithCenter:(CGPoint)center
                         from:(CGFloat)startAngle
                           to:(CGFloat)endAngle
                       radius:(CGFloat)radius
                   startColor:(UIColor *)startColor
                     endColor:(UIColor *)endColor
                      context:(CGContextRef)ctx {
    CGContextSaveGState(ctx);
    CGContextSetLineWidth(ctx, self.fixedLineWidth);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center
                                                        radius:radius
                                                    startAngle:startAngle
                                                      endAngle:endAngle
                                                     clockwise:YES];
    CGContextAddPath(ctx, path.CGPath);
    CGContextReplacePathWithStrokedPath(ctx);
    CGContextClip(ctx);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSArray *colors = @[
                        (__bridge id)startColor.CGColor,
                        (__bridge id)endColor.CGColor,
                        ];
    CGFloat locations[] = {
        0.0,
        1.0,
    };
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)colors, locations);
    
    CGFloat angle1 = startAngle - M_PI_2;
    CGFloat angle2 = endAngle - M_PI_2;
    CGFloat r = radius + self.fixedLineWidth / 2;
    
    CGPoint startPoint = CGPointMake(center.x - sin(angle1) * r, center.y + cos(angle1) * r);
    CGPoint endPoint = CGPointMake(center.x - sin(angle2) * r, center.y + cos(angle2) * r);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextRestoreGState(ctx);
}
@end
