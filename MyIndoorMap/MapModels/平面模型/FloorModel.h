//
//  FloorModel.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BaseModel.h"

@interface FloorModel : BaseModel
@property (nonatomic ,assign) NSUInteger ID;//唯一编号

@property (nonatomic ,copy) NSString *number;

@property (nonatomic ,strong) NSArray *features;//featureModel数组

@end
