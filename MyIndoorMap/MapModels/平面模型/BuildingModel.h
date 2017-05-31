//
//  BuildingModel.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BaseModel.h"

@interface BuildingModel : BaseModel
@property (nonatomic ,assign) NSUInteger ID;//唯一编号

@property (nonatomic ,copy) NSString  *name;

@property (nonatomic ,copy) NSString *address;

@property (nonatomic ,strong,readonly) NSArray *floorIDs;//楼层的唯一ID数组

@property (nonatomic ,strong) NSArray *floors;

@property (nonatomic ,assign) int floorCount;//楼层数

@property (nonatomic ,strong) NSArray *floorsNumber;//编号《一层 二层 B1 B2。。。。》

@property (nonatomic ,assign) CGFloat plottingScale;//比例尺

@end
