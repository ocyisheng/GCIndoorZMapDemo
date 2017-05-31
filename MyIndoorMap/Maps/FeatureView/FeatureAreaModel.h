//
//  FeatureAreaModel.h
//  ScrollViewScale
//
//  Created by gao on 16/7/18.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PolygonArea,FeatureModel;
@interface FeatureAreaModel : NSObject

/**
 *  储存形状和位置信息
 */
@property (nonatomic ,strong) PolygonArea *area;

/**
 *  储存该Feature的其他信息
 */
@property (nonatomic ,strong) FeatureModel *featureModel;





@end
