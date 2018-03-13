//
//  ViewController.m
//  DGSweepGradient
//
//  Created by Daniate on 2017/9/1.
//  Copyright © 2017年 Daniate. All rights reserved.
//

#import "ViewController.h"
#import "DGSweepGradientView.h"
#import "CAKeyframeAnimation+AHEasing.h"

@interface ViewController ()
@property (nonatomic, weak) DGSweepGradientView *sweepGradientView;
@property (nonatomic, weak) DGSweepGradientLayer *sweepGradientLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    DGSweepGradientView *sweepGradientView = [DGSweepGradientView new];
    [self.view addSubview:sweepGradientView];
    self.sweepGradientView = sweepGradientView;
    
    DGSweepGradientLayer *sweepGradientLayer = [DGSweepGradientLayer layer];
    [self.view.layer addSublayer:sweepGradientLayer];
    self.sweepGradientLayer = sweepGradientLayer;
    
    sweepGradientView.lineWidth = sweepGradientLayer.lineWidth = 80;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGFloat statusBarHeight = MIN(statusBarFrame.size.height, statusBarFrame.size.width);
    
    CGFloat maxH = (CGRectGetHeight(self.view.bounds) - 4 * statusBarHeight) / 2;
    CGFloat maxW = CGRectGetWidth(self.view.bounds) - 2 * statusBarHeight;
    
    CGFloat wh = MIN(maxH, maxW);
    
    self.sweepGradientView.bounds = self.sweepGradientLayer.bounds = CGRectMake(0, 0, wh, wh);
    
    CGFloat centerX = CGRectGetMidX(self.view.bounds);
    
    self.sweepGradientView.center = CGPointMake(centerX, 2 * statusBarHeight + wh / 2);
    self.sweepGradientLayer.position = CGPointMake(centerX, 2 * statusBarHeight + wh + statusBarHeight + wh / 2);
}

- (void)_handleTap:(id)sender {
    CGFloat p = arc4random_uniform(101) / 100.0;
    
    self.sweepGradientView.progress = p;
    
    [self.sweepGradientLayer removeAnimationForKey:@"progress"];
    
    NSNumber *fromNum;
    if (self.sweepGradientLayer.presentationLayer) {
        fromNum = [self.sweepGradientLayer.presentationLayer valueForKey:@"progress"];
    } else {
        fromNum = [self valueForKey:@"progress"];
    }
    CGFloat from =  fromNum.doubleValue;
    CGFloat to = p;
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"progress"
                                                                 function:BounceEaseOut
                                                                fromValue:from
                                                                  toValue:to
                                                            keyframeCount:30];
    anim.duration = 1;
    
    [self.sweepGradientLayer addAnimation:anim forKey:@"progress"];
    
    self.sweepGradientLayer.progress = p;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
