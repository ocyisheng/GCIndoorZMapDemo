//
//  MapOption.m
//  MyGCIndoorMap
//
//  Created by gao on 16/8/24.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "MapOptions.h"

@implementation MapOptions
- (instancetype)init
{
    self = [super init];
    if (self) {
        _moveEnabled = YES;
        _rotateEnabled = YES;
        _zoomEnabled = YES;
        //_skewEnabled = YES;
        _sigleTapEnabled = YES;
        _doubleTapEnabled = YES;
        _longTapEnabled = YES;
        
    }
    return self;
}
@end
