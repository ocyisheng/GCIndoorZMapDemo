//
//  PathFinding+PointConvert.h
//  GCMapNaviagateDemo
//
//  Created by gao on 16/6/21.
//  Copyright © 2016年 GAO. All rights reserved.
//

#import "PathFinding.h"
@interface PathFinding (PointConvert)

/**
 *  将UIView坐标系转化成数学坐标系
 *
 *  @param point viewPoint
 *
 *  @return 数学坐标系
 */
- (CGPoint)convertPoint:(CGPoint)viewPoint pointOffset:(CGPoint)offset;

/**
 *  将搜寻结果转换成point的数组
 *
 *  @param result PFNode 的数组
 *
 *  @return CGPoint 的数组
 */
- (NSArray *)convertResultPoints:(NSArray *)result pointOffset:(CGPoint)offset;

/**
 *  将UIView坐标系转化成数学坐标系
 *
 *  @param wallPoints 包含UIView坐标坐标系Point的数组
 *  @param offset
 *
 *  @return PathFinding 对象可接受的坐标数组
 */
- (NSArray *)convertWallPoints:(NSArray *)wallPoints pointOffset:(CGPoint)offset;
@end
