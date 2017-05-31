//
//  ReFeatureFrameModel.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BaseModel.h"
//typedef  NS_ENUM (NSInteger, FrameType){
//    FrameTypeCircle,//圆形
//    FrameTypeRect,//矩形
//    FrameTypeFan,//扇形
////    FrameTypeHall,//大厅
////    FrameTypeColumn,//立柱
////    FrameTypeCorridor,//走廊
////    FrameTypePassageway,//过道
//};

@interface ReFeatureFrameModel : BaseModel
@property (nonatomic ,assign) NSUInteger featureID;

@property (nonatomic ,assign) CGRect frame;

@property (nonatomic ,assign) CGPoint center;



@end
