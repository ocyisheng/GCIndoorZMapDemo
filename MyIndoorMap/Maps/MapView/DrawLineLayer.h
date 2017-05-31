//
//  DrawLineLayer.h
//  GCMapNaviagateDemo
//
//  Created by gao on 16/6/22.
//  Copyright © 2016年 GAO. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BrokenLine.h"
@interface DrawLineLayer : CALayer

/**
 *  接收view ，使用此view进行坐标转化
 *
 *  @param gestureView
 */
- (void)setGestureView:(UIView *)gestureView;

/**
 *  添加一组折线
 *
 *  @param lineModels BrokenLine 数组
 */
- (void)drawLinesWithLineModels:(NSArray <BrokenLine *> *)lineModels;

/**
 *  添加一条折线
 *
 *  @param lineModel 使用BrokenLine model
 */
- (void)drawLineWithLineModel:(BrokenLine *)lineModel;

/**
 *  移除其中一条折线
 *
 *  @param lineModel
 */
- (void)removeBrokenLineWithModel:(BrokenLine *)lineModel;

/**
 *  根据identify 移除折线
 *
 *  @param identify 
 */
- (void)removeBrokenLineWithIdentify:(NSString *)identify;

/**
 *  清除所有折线
 */
- (void)clearLines;

/**
 * 更新折线
 */
- (void)updateLines;
@end
