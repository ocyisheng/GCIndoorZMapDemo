//
//  Map.m
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "Map.h"

@interface Map()

@end
@implementation Map

#pragma mark - 重写 func-
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
}


#pragma mark - FeatureViewHitDelegate -
- (void)hitTestFeatureView:(FeatureView *)featureView{

    if ([self.hitDelegate respondsToSelector:@selector(hitMap:featureView:)]) {
        [self.hitDelegate hitMap:self featureView:featureView];
    }
}


- (void)setDataSource:(NSArray *)areaModels{
    
}




@end
