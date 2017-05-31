//
//  DrawLineLayer.m
//  GCMapNaviagateDemo
//
//  Created by gao on 16/6/22.
//  Copyright © 2016年 GAO. All rights reserved.
//

#import "DrawLineLayer.h"
#import <UIKit/UIKit.h>
@interface DrawLineLayer ()
{
    NSArray *linePoints;
    UIView *fromView;
}
@property (nonatomic ,strong) NSMutableArray *brokenLines;

@end
@implementation DrawLineLayer

- (void)drawInContext:(CGContextRef)ctx{
        for (BrokenLine *line in self.brokenLines) {
        NSInteger count = line.pointArray.count;
        if (count >=2) {
            CGPoint points[count];
            for (NSInteger index = 0; index < count; index ++) {
                CGPoint point = [line.pointArray[index] CGPointValue];
                CGPoint coverpoint = [fromView.layer convertPoint:point toLayer:self];
                points[index] = coverpoint;
            }
#warning 这里可以自定义折线，如虚线等
           
            CGContextSetLineWidth(ctx, line.lineWidth);
            CGContextSetLineJoin(ctx, kCGLineJoinRound);
            CGContextSetStrokeColorWithColor(ctx, line.lineColor.CGColor);
            CGContextAddLines(ctx, points, count);//添加线
            CGContextSetShouldAntialias(ctx, YES );
            CGContextDrawPath(ctx, kCGPathStroke); //根据坐标绘制路径
        }
    }
}
- (void)setGestureView:(UIView *)gestureView{
    fromView = gestureView;
}

- (void)updateLines{
   
    [self setNeedsDisplay];
   
}
- (void)drawLineWithLineModel:(BrokenLine *)lineModel{
    [self.brokenLines addObject:lineModel];
    [self setNeedsDisplay];
}

- (void)drawLinesWithLineModels:(NSArray <BrokenLine *> *)lineModels{
    [self.brokenLines addObjectsFromArray:lineModels];
    [self setNeedsDisplay];
}
- (void)removeBrokenLineWithModel:(BrokenLine *)lineModel{
    [self.brokenLines removeObject:lineModel];
    [self setNeedsDisplay];
}

- (void)clearLines{
    [self.brokenLines removeAllObjects];
    [self setNeedsDisplay];
}
/**
 *  根据identify 移除折线
 *
 *  @param identify NSString 类型
 */
- (void)removeBrokenLineWithIdentify:(NSString *)identify{
    BrokenLine *reLine;
    for (BrokenLine *line in self.brokenLines) {
        if ([line.identify isEqualToString:identify]) {
            reLine = line;
        }
    }
    [self.brokenLines removeObject:reLine];
    [self setNeedsDisplay];
}
#pragma mark - setter -
- (NSMutableArray *)brokenLines{
    if (!_brokenLines) {
        _brokenLines = [NSMutableArray array];
    }
    return _brokenLines;
}
@end
