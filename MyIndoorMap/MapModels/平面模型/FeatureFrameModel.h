//
//  FeatureFrameModel.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BaseModel.h"
@interface FeatureFrameModel : BaseModel

@property (nonatomic ,assign) NSUInteger featureID;

@property (nonatomic ,assign) CGRect frame;

@property (nonatomic ,assign) CGPoint center;


@property (nonatomic ,strong) NSArray *shapePathPoints;//数组




@property (nonatomic ,assign) CGFloat orignX;

@property (nonatomic ,assign) CGFloat orignY;

@property (nonatomic ,assign) CGFloat sizeWidth;

@property (nonatomic ,assign) CGFloat sizeHeight;


@property (nonatomic ,assign) CGFloat centerX;

@property (nonatomic ,assign) CGFloat centerY;

@property (nonatomic ,assign) CGFloat startAngle;

@property (nonatomic ,assign) CGFloat endAngle;

@property (nonatomic ,assign) CGFloat radius;

@end
