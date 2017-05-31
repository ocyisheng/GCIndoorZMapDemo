//
//  PathFinding+PointConvert.m
//  GCMapNaviagateDemo
//
//  Created by gao on 16/6/21.
//  Copyright © 2016年 GAO. All rights reserved.
//

#import "PathFinding+PointConvert.h"
#import "PFNode.h"

@implementation PathFinding (PointConvert)
- (CGPoint)convertPoint:(CGPoint)viewPoint pointOffset:(CGPoint)offset{
    CGPoint point = CGPointMake(viewPoint.x + offset.x, self.mapSize.height - viewPoint.y - 1 * self.tileSize.height + offset.y);
    return point;
}
- (NSArray *)convertWallPoints:(NSArray *)wallPoints pointOffset:(CGPoint)offset{
    

    NSMutableArray *marray = [NSMutableArray array];
    
    for (NSValue *pointValue in wallPoints) {
        CGPoint point = [pointValue CGPointValue];
        NSValue *convertValue = [NSValue valueWithCGPoint: [self convertPoint:point pointOffset:offset]];
        [marray addObject:convertValue];
    }
    return [marray copy];
}
- (NSArray *)convertResultPoints:(NSArray *)results pointOffset:(CGPoint)offset {
    NSMutableArray *marray = [NSMutableArray array];
    for (PFNode *node in results) {
        CGPoint center = CGPointMake(node.x , node.y);
        NSValue *centerValue = [NSValue valueWithCGPoint:CGPointMake(center.x *self.tileSize.width  + offset.x, (self.mapSize.height / self.tileSize.height - 1 - center.y) * self.tileSize.height + offset.y)];
        [marray addObject:centerValue];
    }
    return [marray copy];
}


@end
