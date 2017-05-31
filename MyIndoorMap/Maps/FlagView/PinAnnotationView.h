//
//  PinAnnotationView.h
//  GCMapDemo
//
//  Created by gao on 16/5/25.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "FlagView.h"
#import "CalloutView.h"
@class FeatureLayer,PinAnnotationView;
/*
 定制一个大头针
 1.固定形状
 2.颜色
 3.能被点击
 4.能被拖动（延后）
 
 */

@protocol PinAnnotationViewDelegate <NSObject>

@optional



@end

typedef NS_ENUM(NSInteger, PinAnnotationColor) {
    PinAnnotationColorRed = 0,
    PinAnnotationColorGreen,
    PinAnnotationColorBlue,
    PinAnnotationColorPurple,
    PinAnnotationColorYellow,
    PinAnnotationColorBlack
};

@interface PinAnnotationView : FlagView
/**
 *  是否可以展示CalloutView,默认是no
 */
@property (nonatomic ,assign) BOOL canShowCallout;
/**
 *  是否掉落动画，默认是 no
 */
@property (nonatomic ,assign) BOOL animateDrop;

/**
 *  被选中，
 */
@property (nonatomic ,assign) BOOL selected;

/**
 *  显示颜色
 */
@property (nonatomic ,assign) PinAnnotationColor pinColor;


@property (nonatomic ,weak) id<PinAnnotationViewDelegate> delegate;

//@property (nonatomic ,strong)UIImage *contentImage;



#warning  使用事件初始化！！！！


- (BOOL)isAreaTouchPoint:(CGPoint)inTouchPoint;

/**
 *  保存当前标记的FeatureID
 */
@property (nonatomic ,assign) NSUInteger currentFeatureID;



@end
