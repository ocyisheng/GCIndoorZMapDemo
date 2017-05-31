//
//  FeatureFrameModel.m
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "FeatureFrameModel.h"

@implementation FeatureFrameModel
- (NSArray *)shapePathPoints
{
    if (!_shapePathPoints) {
        _shapePathPoints = [NSArray array];
    }
    return _shapePathPoints;
}

- (NSString *)description
{
    /*@property (nonatomic ,assign) NSUInteger featureID;
     
     @property (nonatomic ,assign) CGRect frame;
     
     @property (nonatomic ,assign) CGPoint center;*/
    return [NSString stringWithFormat:@"\nfeatureID=%lu,\nframe=%@,\ncenter=%@", (unsigned long)self.featureID,NSStringFromCGRect(self.frame),NSStringFromCGPoint(self.center)];
}
@end
