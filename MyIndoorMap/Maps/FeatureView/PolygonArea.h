//
//  PolygonArea.h
//  ScrollViewScale
//
//  Created by gao on 16/7/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface PolygonArea : NSObject

@property (nonatomic ,strong) NSArray *pathArray;//使用它

@property (nonatomic ,assign) CGRect limitFrame;//极限坐标

-(id)initWithCoordinate:(NSString*)inStrCoordinate scale:(CGFloat )scale;


#warning 这个属性可弃用
@property (nonatomic ,strong) NSArray *pathPoints;// 解析Path所需的点阵
@end
