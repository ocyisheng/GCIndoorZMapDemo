//
//  PolygonUnPassPoint.h
//  ScrollViewScale
//
//  Created by gao on 16/7/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PolygonArea.h"
#import "PolygonUnPassPoint.h"
@interface PolygonUnPassPoint : NSObject
+ (NSArray *)unPassPointsWithArea:(PolygonArea *)area;
@end
