//
//  XDTestData.h
//  ScrollViewScale
//
//  Created by gao on 16/7/7.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FeatureAreaModel;
@interface XDTestData : NSObject

@property (nonatomic ,strong) NSMutableArray *areaArray;

@property (nonatomic ,strong) NSMutableArray *fAreaModels;

- (NSArray *)fAreaModelsWithPath:(NSString *)path;


@end
