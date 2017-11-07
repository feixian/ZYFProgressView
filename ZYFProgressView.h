//
//  ZYFProgressView.h
//  滚动圈
//
//  Created by clouddrink on 2017/1/16.
//  Copyright © 2017年 clouddrink. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZYFProgressView : UIView

@property (nonatomic,copy) void (^progressChangeBlock)(ZYFProgressView *progressView,CGFloat progress);

@property (nonatomic, strong) UIColor *tintColor;

/** 进度值 **/
@property (nonatomic,assign) CGFloat progress;

/** 设置进度小圈宽度 **/
@property (nonatomic,assign) CGFloat smallCicleWidth;

/** 设置进度大圈的宽度 **/
@property (nonatomic,assign) CGFloat bigCicleWidth;

@property (nonatomic, strong) UIView *centralView;

@property (nonatomic, assign) CFTimeInterval animationDuration UI_APPEARANCE_SELECTOR;


@end
