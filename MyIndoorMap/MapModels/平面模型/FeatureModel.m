//
//  FeatureModel.m
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "FeatureModel.h"

@implementation FeatureModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"\nid=%ld,\nunMoved=%hhd,\nname=%@,\nflagImageName=%@,\nbackgroundcolor=%@,\nframeModel={%@\n}", (unsigned long)self.ID,self.unMoved,self.name,self.flagImageName,self.backGroundColor,self.frameModel
            ];
}

- (FeatureFrameModel *)frameModel{
    if (!_frameModel) {
        _frameModel = [[FeatureFrameModel alloc]init];
    }
    return _frameModel;
}
@end
