//
//  GCCompassView.h
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/15.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GCCompassView;
@protocol GCCompassViewDelegate <NSObject>

- (void)compassView:(GCCompassView *)compassView  updateAngle:(CGFloat)angle;

@end

/*!
 * @brief 指南针控件
 */
@interface GCCompassView : UIView

@property (nonatomic ,assign) id<GCCompassViewDelegate> delegate;

/*!
 * @brief 指南针的背景图片
 */
@property (nonatomic,strong)UIImage *backgroundImage;
/*!
 * @brief 指南针点击事件的回调
 */
@property (nonatomic,copy)void(^compassBlock)();
/*!
 * @brief 指南针的旋转方法
 * @param 地图与正北的夹角
 */
-(void)GCCompassViewRotateWithAngleFromNorth:(CGFloat )angleFromNorth;


/**
 *  电子罗盘开始更新方向
 */
- (void)startUpdateHeading;
/**
 *  电子罗盘结束更新方向
 */
- (void)stopUpdateHeading;
@end
