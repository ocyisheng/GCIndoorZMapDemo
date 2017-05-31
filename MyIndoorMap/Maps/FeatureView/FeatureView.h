//
//  FeatureView.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeatureLayer.h"
#import "FeatureFlagView.h"

#pragma mark - 协议声明 -
@class FeatureView,FeatureFlagView;
@protocol FeatureViewHitDelegate <NSObject>
@optional

- (void)hitTestFeatureView:(FeatureView *)featureView;

@end

#pragma mark - 枚举声明 showView的显示优先级 -
typedef NS_ENUM(NSInteger ,FeatureShowViewPriority){
    FeatureShowViewPriorityLow = 0,
    FeatureShowViewPriorityMiddle = 1,
    FeatureShowViewPriorityHight = 2,
    FeatureShowViewPriorityDefault = 3,//默认优先级最高，一直显示
};

#pragma mark - FeatureView 实现 -
@interface FeatureView : UIView

@property (nonatomic ,weak) id<FeatureViewHitDelegate> hitDelegate;
@property (nonatomic ,copy) NSString *identify;//

/**
 *  唯一标识的ID
 */
@property (nonatomic ,assign) NSUInteger ID;

/**
 *  记录上次的点击位置，与当前进行比较，用来判断是否点击了大头针(PinAnnotationView)
 */
@property (nonatomic ,assign) CGPoint pinAnnotationMarkPoint;


#warning 优先级，使用枚举。根据放大倍数，依照优先级进行显示或隐藏名称
/**
 *  优先级，枚举类型。
 *  根据放大倍数，依照优先级进行显示或隐藏名称
 */
@property (nonatomic ,assign) FeatureShowViewPriority priority;

/**
 *  渲染的多边形区域
 */
@property (nonatomic ,strong) FeatureLayer *featurelayer;
#warning 待操作
/**
 *  设置是否能被点击
 */
@property (nonatomic ,assign) BOOL canBeTouched;

/**
 *  预显示的view
 */
@property (nonatomic ,strong) FeatureFlagView *showView;


/**
 *  预显示Feature的名称的标记
 */
@property (nonatomic ,copy) NSString *showName;

/**
 *  显示预先标记的图片名称
 */
@property (nonatomic ,copy) NSString *showImageName;


/**
 *  更新界面，使showView初始化
 */
- (void)updateSubViews;

@end
