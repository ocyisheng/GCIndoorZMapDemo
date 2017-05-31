//
//  CompassView.h
//  CompassCoreLocationDemo
//
//  Created by gao on 16/5/24.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CompassView;
@protocol CompassViewDelegate <NSObject>

- (void)compassView:(CompassView *)compassView  updateAngleDiv:(CGFloat)angleDiv;

@end
@interface CompassView : UIView

@property (nonatomic ,copy) NSString *directionImageName;//方向指示视图

@property (nonatomic ,copy) NSString *divingImageName;//方向视图《底部》

@property (nonatomic ,weak) id<CompassViewDelegate> delegate;

/**
 *  电子罗盘开始更新方向
 */
- (void)startUpdateHeading;

/**
 *  电子罗盘结束更新方向
 */
- (void)stopUpdateHeading;

/**
 *  方向指示图标跟随旋转
 *
 */
- (void)updateHeadingWithDivAngle:(CGFloat )divAngle;

@end
