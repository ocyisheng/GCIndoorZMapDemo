//
//  PolygonUnPassPoint.m
//  ScrollViewScale
//
//  Created by gao on 16/7/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "PolygonUnPassPoint.h"
#import "Helper.h"

#import "ArcModel.h"
#import "LineModel.h"

@interface PolygonUnPassPoint()
{
    CGPoint limitFrameCenter;
}
@property (nonatomic ,strong) NSMutableArray *unPassPoints;
@property (nonatomic ,strong) UIBezierPath *path;

@property (nonatomic ,strong) PolygonArea *polygonArea;

@property (nonatomic ,assign) CGRect moreLimitFrame;



@end
@implementation PolygonUnPassPoint

+ (NSArray *)unPassPointsWithArea:(PolygonArea *)area{
    return [[[PolygonUnPassPoint alloc]initWithArea:area].unPassPoints copy];
}
- (id)initWithArea:(PolygonArea *)area{
    if (self = [super init]) {

        self.polygonArea = area;
        self.path = [self pathWithPathModelArray:area.pathArray];
    }
    return self;
}

- (UIBezierPath *)pathWithPathModelArray:(NSArray *)pathModelArr{
    __block UIBezierPath * path = [UIBezierPath bezierPath];
    __block BOOL startDraw = YES;//起始点标记，标记开始点
    [pathModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ArcModel class]]) {
            ArcModel *am = obj;
            
            if (am.circle) {
                path = [UIBezierPath bezierPathWithArcCenter:am.center radius:am.radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
            }else{
                [path addArcWithCenter:am.center radius:am.radius startAngle:am.startAngle endAngle:am.endAngle clockwise:YES];
            }
            
        }else if ([obj isKindOfClass:[LineModel class]]){
            LineModel *lm = obj;
            [lm.points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
                  CGPoint point = [obj CGPointValue];
                if (idx == 0 && startDraw ) {
                    [path moveToPoint:point];
                    startDraw = NO;
                }else{
                    [path addLineToPoint:point];
                }
            }];
            
        }
        
    }];
    [path closePath];
    
    return path;
}

- (BOOL)isAreaSelected:(CGPoint)inPointTouch{
    
    return CGPathContainsPoint(self.path.CGPath,NULL,inPointTouch,false);
}
- (NSMutableArray *)unPassPoints
{
    if (!_unPassPoints) {
        _unPassPoints = [NSMutableArray array];
        
        CGRect limitframe = self.polygonArea.limitFrame;
        CGFloat f_X = [Helper getInter:limitframe.origin.x];
        CGFloat f_Y = [Helper getInter:limitframe.origin.y];
        CGFloat f_W = [Helper getInter:limitframe.size.width];
        CGFloat f_H = [Helper getInter:limitframe.size.height];

        for (int i = f_X ; i <= f_X + f_W ; i ++ ) {
            for (int j = f_Y ; j <= f_Y + f_H ; j ++) {
                CGPoint point = CGPointMake(i, j);
                if ([self isAreaSelected:point]) {
                    [_unPassPoints addObject:[NSValue valueWithCGPoint:point]];
                }
            }
        }
    }
    return _unPassPoints;
}


@end
