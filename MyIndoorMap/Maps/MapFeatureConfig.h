//
//  MapFeatureConfig.h
//  ScrollViewScale
//
//  Created by gao on 16/7/15.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Map,CoverView,FeatureAreaModel,FeatureModel;
@interface MapFeatureConfig : NSObject



/**
 *  获取导航所需的所有不可通过点
 */
+ (NSArray *)unPassPointForNavigate;


+ (void)configMapFeaturesWithFeatureModelAreas:(NSArray<FeatureAreaModel *> *)featureAreaModels map:(Map *)map coverView:(CoverView *)cover;


/**
 *  绘制Map地图
 *
 *  @param featureAreaModels 包含形状信息 和 其他必要信息
 */
+ (void)configMapFeaturesWithFeatureModelAreas:(NSArray<FeatureAreaModel *> *)featureAreaModels map:(Map *)map;

/**
 *  使用identify 查找该Feature 的信息
 *
 *  @param identify 唯一标识
 */
+ (FeatureModel *)searchFeatureModelWithIdentify:(NSString *)identify;

/**
 *  使用ID查找feature的信息
 *
 *  @param ID 唯一的ID
 */
+ (FeatureModel *)searchFeatureModelWithID:(NSUInteger )ID;
@end
