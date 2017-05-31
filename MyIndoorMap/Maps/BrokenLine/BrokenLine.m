//
//  BrokenLine.m
//  GCMapDemo
//
//  Created by gao on 16/5/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BrokenLine.h"
@class BrokenLine;
@interface BrokenLine ()

@end
@implementation BrokenLine
- (instancetype)initWithIdentify:(NSString *)identify{
    if (self = [super init]) {
        _identify = identify;
    }
    return self;
}

///*center length angle */
//
//+ (CGPoint)centerWithPointA:(CGPoint)a pointB:(CGPoint)b{
//    return CGPointMake((b.x - a.x) * 0.5 + a.x, (b.y - a.y) * 0.5 + a.y);
//}
//
//+ (CGFloat)lengthWithPointA:(CGPoint)a pointB:(CGPoint)b{
//    return sqrt((b.x - a.x) * (b.x - a.x) + (b.y - a.y) * (b.y - a.y));
//}
//+ (CGFloat)angleWithPointA:(CGPoint)a pointB:(CGPoint)b{
//    CGFloat arctan = atan((b.y - a.y) / (b.x - a.x)) + M_PI_2;
//    return arctan;
//}

@end
