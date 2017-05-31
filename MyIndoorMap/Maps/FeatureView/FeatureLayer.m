//
//  FeatureLayer.m
//  ScrollViewScale
//
//  Created by gao on 16/7/7.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "FeatureLayer.h"
#import "DefinitionHeader.h"
@interface FeatureLayer()
{
    UIBezierPath *path;
}

@property (nonatomic ,strong) CAShapeLayer *shapeLayer;

@property (nonatomic ,strong) BaseFeatureLayer *contentLayer;

//@property (nonatomic ,strong) UIView *contentView;
@end
@implementation FeatureLayer


#pragma mark - func piblic -
- (BOOL)isAreaSelected:(CGPoint)inPointTouch{

    return CGPathContainsPoint(path.CGPath,NULL,inPointTouch,false);
}

- (void)drawContentLayerWithPath:(UIBezierPath *)bezierPath{
    path = bezierPath;
    [self addSublayer:self.contentLayer];
}

- (void)drawContentLayerBackgroundColor:(UIColor *)backgroundColor{
     self.contentLayer.backgroundColor = backgroundColor.CGColor;
}


#pragma mark - private getter func -
- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.path = path.CGPath;
        _shapeLayer.fillColor = [UIColor blackColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.frame = self.bounds;
        _shapeLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
        _shapeLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _shapeLayer;
}
- (BaseFeatureLayer *)contentLayer{
    if (!_contentLayer) {
        _contentLayer = [BaseFeatureLayer layer];
        _contentLayer.frame = self.bounds;
         _contentLayer.mask = self.shapeLayer;
    }
    return _contentLayer;
}






@end
