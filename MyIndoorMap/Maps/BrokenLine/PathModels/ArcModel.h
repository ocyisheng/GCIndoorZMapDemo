//
//  ArcModel.h
//  ScrollViewScale
//
//  Created by gao on 16/7/27.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BaseModel.h"

@interface ArcModel : BaseModel

@property (nonatomic ,assign) CGPoint center;//圆心

@property (nonatomic ,assign) CGFloat radius;//半径

@property (nonatomic ,assign) CGFloat startAngle;//开始

@property (nonatomic ,assign) CGFloat endAngle;//结束

@property (nonatomic ,assign) CGPoint maxHightPoint;

@property (nonatomic ,assign)  BOOL  circle;





@end
