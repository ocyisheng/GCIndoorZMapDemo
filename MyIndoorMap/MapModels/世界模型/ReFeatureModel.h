//
//  ReFeatureModel.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BaseModel.h"
#import "ReFeatureFrameModel.h"
@interface ReFeatureModel : BaseModel
@property (nonatomic ,assign) NSUInteger ID;//唯一编号
@property (nonatomic ,assign) BOOL unMoved;//是否是永久的，不可移动的

@property (nonatomic ,copy) NSString *name;

@property (nonatomic ,copy) NSString *flagImageName;

@property (nonatomic ,strong) ReFeatureFrameModel *frameModel;

@property (nonatomic ,strong) UIColor *backGroundColor;





@end
