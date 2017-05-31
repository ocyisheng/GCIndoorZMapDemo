//
//  PolygonArea.m
//  ScrollViewScale
//
//  Created by gao on 16/7/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "PolygonArea.h"
#import "ArcModel.h"
#import "LineModel.h"

@interface PolygonArea ()


@end
@implementation PolygonArea
-(id)initWithCoordinate:(NSString*)inStrCoordinate scale:(CGFloat )scale{
    self = [super init];
    /*
     "260.483,99.200,303.683,99.100,303.683,95.700,309.183,95.550,309.283,74.150,244.433,74.050,244.333,81.100,<*228.598857,111.385533,-1.090287,-0.366097,34.040272<*/
    
#warning 这里的字段可
    if(self != nil)
    {
        NSMutableArray *array = [[inStrCoordinate componentsSeparatedByString:@"<"] mutableCopy];
        if (array.count == 1) {
            array = [[inStrCoordinate componentsSeparatedByString:@","] mutableCopy];
            
            [array removeAllObjects];
            [array addObject:[NSString stringWithFormat:@"%@,",inStrCoordinate]];
        }
        [array removeObject:@""];
        NSMutableArray *pathArrayM = [NSMutableArray array];
        for (NSString *coordstring in array) {
            if ([coordstring hasSuffix:@","]) {
                //是折线 LineModel
                NSMutableArray*    arrAreaCoordinates =
                [[coordstring componentsSeparatedByString:@","] mutableCopy];
                [arrAreaCoordinates removeObject:@""];
                
                NSUInteger  countTotal      = [arrAreaCoordinates count];
                NSUInteger  countCoord      = countTotal/2;
                
                NSMutableArray *marray = [NSMutableArray array];
                for(NSUInteger i = 0; i < countCoord; i++)
                {
                    NSUInteger index = i<<1; //相当于 x2 两位的是 4
                    CGPoint aPoint = CGPointMake([[arrAreaCoordinates objectAtIndex:index] floatValue] / scale, [[arrAreaCoordinates objectAtIndex:index+1] floatValue] / scale);
                    [marray addObject:[NSValue valueWithCGPoint:aPoint]];
                    
                }
                self.pathPoints = [self.pathPoints arrayByAddingObjectsFromArray:[marray copy]];
                LineModel *lm = [[LineModel alloc]init];
                lm.points = [marray copy];
                
                [pathArrayM addObject:lm];

            }else if ([coordstring hasPrefix:@"*"]){
                NSString *str = [coordstring substringFromIndex:1];
                NSArray *circelStringArr = [str componentsSeparatedByString:@","];
                
                //是圆弧 ArcModel
                ArcModel * am = [[ArcModel alloc]init];
                am.center = CGPointMake([circelStringArr[0] floatValue] /scale, [circelStringArr[1] floatValue]/ scale);
                am.startAngle = [circelStringArr[2] floatValue];
                am.endAngle = [circelStringArr[3] floatValue];
                am.radius = [circelStringArr[4] floatValue]/scale;
         
                if ([circelStringArr[2] isEqualToString:@"0.000000"] &&[circelStringArr[3] isEqualToString:@"6.283185"] ) {
                    //当是整圆时
                    am.circle = YES;
                    CGPoint maxPoint = CGPointMake(am.center.x + (am.radius + 1), am.center.y + (am.radius + 1));
                    CGPoint minPoint = CGPointMake(am.center.x - (am.radius + 1), am.center.y - (am.radius + 1));
                    CGPoint minxX = CGPointMake(minPoint.x, maxPoint.y);
                    CGPoint maxX = CGPointMake(maxPoint.x, minPoint.y);
                    self.pathPoints = [self.pathPoints arrayByAddingObjectsFromArray:@[[NSValue valueWithCGPoint:maxPoint],[NSValue valueWithCGPoint:minPoint],[NSValue valueWithCGPoint:minxX],[NSValue valueWithCGPoint:maxX]]];
                        
                    }

                if ( circelStringArr.count == 7) {
                    //当是外凸形状时
                    am.maxHightPoint = CGPointMake([circelStringArr[5] floatValue] /scale, [circelStringArr[6] floatValue]/ scale);
                    self.pathPoints = [self.pathPoints arrayByAddingObjectsFromArray:@[[NSValue valueWithCGPoint:am.maxHightPoint]]];
                }
          
                [pathArrayM addObject:am];
            }
        }
        self.pathArray = [pathArrayM copy];
        
        CGFloat p_X = [self isX:YES isMin:YES];
        CGFloat p_Y = [self isX:NO isMin:YES];
        CGFloat p_W = [self isX:YES isMin:NO] - p_X ;
        CGFloat p_H = [self isX:NO isMin:NO] - p_Y  ;
        
        _limitFrame = CGRectMake(p_X, p_Y, p_W, p_H);
        
        NSLog(@"%@ %@",self.pathPoints,NSStringFromCGRect(_limitFrame));


    
            }
    return self;

}

#pragma mark - private func -
/**
 *  获取 x 或 y 的最大值或最小值
 *
 *  @param isX   是否是 x
 *  @param isMin 是否最小
 *
 *  @return 
 */
- (CGFloat)isX:(BOOL)isX isMin:(BOOL)isMin{
    NSArray *array =  [self.pathPoints sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSValue *pv1 = obj1;
        NSValue *pv2 =obj2;
        CGPoint p1 = [pv1 CGPointValue];
        CGPoint p2 = [pv2 CGPointValue];
    
        CGFloat a,b = 0.0;
        
        if (isX) {
            a = p1.x;
            b = p2.x;
        }else{
            a = p1.y;
            b = p2.y;
        }
        if (isMin) {
            return a > b;
        }else{
            return a < b;
        }
        
    }];
    NSValue *pv = array[0];
    CGPoint p = [pv CGPointValue];
    
    CGFloat xy = 0.0;
    
    xy = isX == YES ? p.x :p.y ;
#warning 这里可以优化。。。。。。
    return  xy;
}


#pragma mark - getter func -
- (NSArray *)pathPoints{
    if (!_pathPoints) {
        _pathPoints = [NSArray array];
    }
    return _pathPoints;
}

- (NSArray *)pathArray{
    if (!_pathArray) {
        _pathArray = [NSArray array];
    }
    return _pathArray;

}

@end
