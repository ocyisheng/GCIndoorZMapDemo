//
//  FeatureAreaModel.m
//  ScrollViewScale
//
//  Created by gao on 16/7/18.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "FeatureAreaModel.h"
#import "PolygonArea.h"
#import "FeatureModel.h"

@implementation FeatureAreaModel


#warning 测试数据。。。。。。。。。。。。
- (FeatureModel *)featureModel{
    if (!_featureModel) {
        _featureModel = [[FeatureModel alloc]init];
        _featureModel.ID = arc4random()%100;
        _featureModel.name = [NSString stringWithFormat:@"xi dan %ld",_featureModel.ID];
        _featureModel.identify = [NSString stringWithFormat:@"XD%ld",_featureModel.ID];
        _featureModel.flagImageName = _featureModel.name;
        _featureModel.backGroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
        FeatureFrameModel *frameModel = [[FeatureFrameModel alloc]init];
        frameModel.frame = self.area.limitFrame;
        frameModel.featureID = _featureModel.ID;
        _featureModel.frameModel = frameModel;

    }
    return _featureModel;
}
@end
