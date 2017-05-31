//
//  BaseFeatureLayer.m
//  ScrollViewScale
//
//  Created by gao on 16/7/18.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BaseFeatureLayer.h"

@implementation BaseFeatureLayer
- (instancetype)init
{
    self = [super init];
    if (self) {
        //消除锯齿
        self.allowsEdgeAntialiasing = YES;//允许各边格栅化
        self.edgeAntialiasingMask = kCALayerTopEdge | kCALayerLeftEdge | kCALayerBottomEdge | kCALayerRightEdge;//默认是每边都格栅化。
    }
    return self;
}

+ (instancetype)layer{
    return [[[self class] alloc]init];
}
@end
