//
//  ZYFProgressView.m
//  滚动圈
//
//  Created by clouddrink on 2017/1/16.
//  Copyright © 2017年 clouddrink. All rights reserved.
//

#import "ZYFProgressView.h"

NSString * const UAProgressViewProgressAnimationKey = @"UAProgressViewProgressAnimationKey";

@interface ZYFCircularProgressView : UIView

-(void)updateProgress:(CGFloat)progress;

-(CAShapeLayer *)shapeLayer;

@end


@interface ZYFProgressView()

/** 圆形进度条 **/
@property (nonatomic,strong) ZYFCircularProgressView * progressView;

@end

@implementation ZYFProgressView
@synthesize tintColor = _tintColor;

#pragma makr - init -
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initProgressView];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initProgressView];
    }
    return self;
}

-(void)initProgressView{
     _progressView = [[ZYFCircularProgressView alloc]initWithFrame:self.bounds];
    self.progressView.shapeLayer.fillColor = [UIColor clearColor].CGColor;
    [self addSubview:_progressView];
    
    [self resetDefaults];
    
}

-(void)resetDefaults{
    self.smallCicleWidth = 8.5f;//1
    self.bigCicleWidth = 1.0f;//2
    _animationDuration = 0.3f;
    self.progressChangeBlock = nil;
    
    //self.progressView.shapeLayer.shadowOffset = CGSizeMake(0, -5);
    //self.progressView.shapeLayer.shadowColor = self.tintColor.CGColor;
    
    [self tintColorDidChange];
    
}

#pragma mark - Public Accessors

-(void)setBigCicleWidth:(CGFloat)bigCicleWidth{
    _bigCicleWidth = bigCicleWidth;
    self.progressView.shapeLayer.borderWidth = bigCicleWidth;
}

-(void)setSmallCicleWidth:(CGFloat)smallCicleWidth{
    _smallCicleWidth = smallCicleWidth;
    self.progressView.shapeLayer.cornerRadius = 10;
    self.progressView.shapeLayer.lineWidth = smallCicleWidth;
    
}

-(void)setProgress:(CGFloat)progress{
    [self setProgress:progress animated:NO];
    //_progress = progress;
    //[self.progressView updateProgress:progress];
    //[(UILabel *)self.centralView setText:[NSString stringWithFormat:@"%2.0f%%", progress * 100]];
}

-(void)setProgress:(CGFloat)progress animated:(BOOL)animated{
    
    progress = MAX( MIN(progress, 1.0), 0.0); // keep it between 0 and 1
    
    if (_progress == progress) {
        return;
    }
    
    if (animated) {
        
        //[self animateToProgress:progress];
        
    } else {
        
        //[self stopAnimation];
        _progress = progress;
        [self.progressView updateProgress:_progress];
        
    }
    
    if (self.progressChangeBlock) {
        self.progressChangeBlock(self,progress);
    }
    
    
}

//- (void)animateToProgress:(CGFloat)progress {
//    [self stopAnimation];
//    
//    // Add shape animation
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
//    animation.removedOnCompletion = NO;
//    animation.fillMode = kCAFillModeForwards;
//    animation.duration = self.animationDuration;
//    animation.fromValue = @(self.progress);
//    animation.toValue = @(progress);
//    animation.delegate = self;
//    [self.progressView.layer addAnimation:animation forKey:UAProgressViewProgressAnimationKey];
//    
//    // Add timer to update valueLabel
//    _valueLabelProgressPercentDifference = (progress - self.progress) * 100;
//    CFTimeInterval timerInterval =  self.animationDuration / ABS(_valueLabelProgressPercentDifference);
//    self.valueLabelUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval
//                                                                  target:self
//                                                                selector:@selector(onValueLabelUpdateTimer:)
//                                                                userInfo:nil
//                                                                 repeats:YES];
//    
//    
//    _progress = progress;
//}

//- (void)stopAnimation {
//    // Stop running animation
//    [self.progressView.layer removeAnimationForKey:UAProgressViewProgressAnimationKey];
//    
//    // Stop timer
//    [self.valueLabelUpdateTimer invalidate];
//    self.valueLabelUpdateTimer = nil;
//}


- (void)setCentralView:(UIView *)centralView {
    if (_centralView != centralView) {
        [_centralView removeFromSuperview];
        _centralView = centralView;
        [self addSubview:self.centralView];
    }
}

- (void)tintColorDidChange {
    if ([[self superclass] instancesRespondToSelector: @selector(tintColorDidChange)]) {
        [super tintColorDidChange];
    }
    
    UIColor *tintColor = self.tintColor;
    self.progressView.shapeLayer.strokeColor = tintColor.CGColor;
    self.progressView.shapeLayer.borderColor = tintColor.CGColor;
}

- (UIColor*)tintColor
{
    if (_tintColor == nil) {
      _tintColor = [UIColor colorWithRed: 0.0 green: 122.0/255.0 blue: 1.0 alpha: 1.0];
    }
    return _tintColor;
}

- (void) setTintColor:(UIColor *)tintColor
{
    [self willChangeValueForKey: @"tintColor"];
    _tintColor = tintColor;
    [self didChangeValueForKey: @"tintColor"];
    [self tintColorDidChange];
}

#pragma mark - Layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.progressView.frame = self.bounds;
    self.centralView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

@end

#pragma mark - ZYFCircularProgressView -

@implementation ZYFCircularProgressView

+ (Class)layerClass{
    return  CAShapeLayer.class;
}

-(CAShapeLayer *)shapeLayer{
    return (CAShapeLayer *)self.layer;
}

-(instancetype)initWithFrame:(CGRect)frame{
   self = [super initWithFrame:frame];
   if (self) {
       [self updateProgress:0];
   }
    return self;
}

-(void)layoutSubviews{
    self.shapeLayer.cornerRadius = self.frame.size.width / 2.0f;
    self.shapeLayer.path = [self layoutPath].CGPath;
    //设置圆滑曲线头
     self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineJoin = kCALineJoinRound;
}

-(void)updateProgress:(CGFloat)progress{
    [self updatePath:progress];
}

//获取贝塞尔曲线
-(UIBezierPath *)layoutPath{
    const double TWO_M_PI = 2.0 * M_PI;
    const double startAngle = 0.75 * TWO_M_PI;
    const double endAngle = startAngle + TWO_M_PI;
    
    CGFloat width = self.frame.size.width;
    CGFloat borderWidth = self.shapeLayer.borderWidth;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width / 2.0f, width / 2.0f) radius:width/2.0f - borderWidth startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    return path;
}

- (void)updatePath:(CGFloat)progress {
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    self.shapeLayer.strokeEnd = progress;
    [CATransaction commit];
}

@end

