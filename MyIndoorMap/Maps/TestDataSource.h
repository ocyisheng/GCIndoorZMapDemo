//
//  TestDataSource.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FloorModel.h"
#import "FeatureView.h"
@interface TestDataSource : NSObject
@property (nonatomic ,strong) FloorModel *floorModel;
@property (nonatomic ,strong) NSMutableArray *featureLayes;
@end
