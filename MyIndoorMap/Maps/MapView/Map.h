//
//  Map.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeatureView.h"

@class Map;
@protocol MapHitDelegate <NSObject>

@required
- (void)hitMap:(Map *)map featureView:(FeatureView *)featureView;

@optional
@end

@interface Map : UIView<FeatureViewHitDelegate>

@property (nonatomic ,weak) id<MapHitDelegate> hitDelegate;


@end
