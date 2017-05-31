//
//  FeatureLayer.h
//  ScrollViewScale
//
//  Created by gao on 16/7/7.
//  Copyright © 2016年 高春阳. All rights reserved.
//
#import "BaseFeatureLayer.h"

@interface FeatureLayer : BaseFeatureLayer

/**
 *  使用Path 绘制contentLayer
 */
- (void)drawContentLayerWithPath:(UIBezierPath *)bezierPath;

/**
 *  设置contentLayer 的背景色
 */
- (void)drawContentLayerBackgroundColor:(UIColor *)backgroundColor;


/**
 *  判断点是否在path内部
 */
- (BOOL)isAreaSelected:(CGPoint)touchPoint;

@end
