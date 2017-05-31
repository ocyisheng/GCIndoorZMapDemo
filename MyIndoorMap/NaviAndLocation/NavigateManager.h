//
//  NavigateManager.h
//  ScrollViewScale
//
//  Created by gao on 16/7/4.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class FloorModel,FeatureModel,NavigateManager;
typedef void(^ResultPointsBlock)(NSArray *resultPoints);
@interface NavigateManager : NSObject

/**
 *  使用楼层的Model初始化
 *
 *  @param floorModel
 *
 *  @return self
 */
//- (instancetype)initWithFloorModel:(FloorModel *)floorModel;

/**
 *  使用开始 结束点 搜寻路径,A* 算法查找
 *
 *  @param startPoint   开始点
 *  @param endPoint     结束点
 *  @param completeBlock 搜索完成时的block，返回值是点的数组
 */
- (void)startPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint complete:(ResultPointsBlock)completeBlock;

/**
 *  使用开始结束点搜寻路径，最短路径算法，需要导航点支持
 *
 *  @param start         开始点
 *  @param end            结束点
 *  @param completeBlock 搜索完成时的回调，返回值是点的数组
 */
- (void)start:(CGPoint )start end:(CGPoint)end  completeDijkstra:(ResultPointsBlock)completeBlock;
@end
