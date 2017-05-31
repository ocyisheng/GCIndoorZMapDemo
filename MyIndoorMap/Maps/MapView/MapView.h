//
//  MapView.h
//  ImageManager
//
//  Created by gao on 16/5/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecognizerView.h"
#import "CoverView.h"
#import "BrokenLine.h"
#import "Map.h"
#import "MapOptions.h"
@class FlagView,MapView,PinAnnotationView,Map,MapOptions,MapView;
@protocol MapViewDelegate <NSObject>
#warning    此处还需添加其他回调，参看高德地图。。。。。。。。。
@optional
/*
 1.手势enble.分离
 2.添加颜色操作,地图制作
 
 3.手势开始，结束的代理，应有gesture
 
 4.dataSorce的代理
 
 5.添加移动操作，实现Map跟随移动
 
 */

/**
 *  长按手势响应
 *
 *  @param point     当前长按的点
 *  @param featureID 如果有Feature，就返回FeatureID,没有就返回0
 */
- (void)mapView:(MapView *)mapview didLongPressedAtPoint:(CGPoint)point featureID:(NSUInteger)featureID;
#warning 注意添加委托对象 MapView

/**
 *  点击手势响应
 *
 *  @param point     当前点击的点
 *  @param featureID 如果有Feature，就返回FeatureID,没有就返回0
 */
- (void)mapView:(MapView *)mapview didTapAtPoint:(CGPoint)point featureID:(NSUInteger)featureID;

/**
 *  点击PinAnnotationView 的回调
 *
 *  @param pinView 点击的PinAnnotationView
 */
- (void)mapView:(MapView *)mapview didTouchedPinView:(PinAnnotationView *)pinView;


/*
 *  mapView将要缩放时的回调
 *  mapView - 将要缩放的mapView实例
 */
- (void)mapViewWillBeginZooming:(MapView *)mapView;

/*
 *  mapView正在缩放的回调
 *  mapView - 正在缩放的mapView实例
 *  scale - 缩放比例
 */
- (void)mapViewDidZoom:(MapView *)mapView currentScale:(CGFloat)currentScale;

/*
 *  mapView结束缩放的回调
 *  mapView - 结束缩放的mapView实例
 */
- (void)mapViewDidEndZooming:(MapView *)mapView;


/*
 *  mapView将要旋转时的回调
 *  mapView - 将要旋转的mapView实例
 */
- (void)mapViewWillBeginRotating:(MapView *)mapView;

/*
 *  mapView正在旋转的回调
 *  mapView - 正在旋转的mapView实例
 *  rotation - 旋转角度
 */
- (void)mapViewDidRotating:(MapView *)mapView currentRotation:(CGFloat)currentRotation;

/*
 *  mapView结束旋转的回调
 *  mapView - 结束旋转的mapView实例
 */
- (void)mapViewDidEndRotating:(MapView *)mapView;


/*
 *  mapView将要移动时的回调
 *  mapView - 将要移动的mapView实例
 */
- (void)mapViewWillBeginMoving:(MapView *)mapView;

/*
 *  mapView正在移动的回调
 *  mapView - 正在移动的mapView实例
 *  translation - 移动的距离,这个Point 应是累加量
 */
- (void)mapViewDidMoving:(MapView *)mapView translation:(CGPoint)translation;

/*
 *  mapView结束移动的回调
 *  mapView - 结束移动的mapView实例
 */
- (void)mapViewDidEndMoving:(MapView *)mapView;

@required

@end


@protocol MapViewDataSource <NSObject>
@required


@optional
#warning 下面的是dataSource 的协议。。。。待完成
- (NSInteger)numberOfFlagInCoverView:(MapView *)mapView;
- (FlagView *)coverView:(MapView *)mapView flagAtIndex:(NSInteger )index;

@end

@interface MapView : UIView
@property (nonatomic ,weak) id <MapViewDelegate> delegate;

/*
 DataSource的代理
 */
@property (nonatomic ,weak) id <MapViewDataSource> dataSource;

/**
 *  地图的手势操作，默认都是允许（缩放，旋转，点击，双击，长按，移动等手势操作）
 */
@property (nonatomic ,strong) MapOptions *mapOptions;

@property (nonatomic ,assign) BOOL showCompass;

/**
 *
 *  使用一个center向map上添加flag
 *  @param flagView 标记视图
 *  @param point    flag中心点（gestureView 坐标系，实际添加view使用时，需要转化坐标系）
 */
- (void)addFlagView:(FlagView *)flagView point:(CGPoint)point;

/**
 * 添加折线
 *
 *  @param line BrokenLine
 */
- (void)addBrokenLines:(NSArray<BrokenLine *> *)brokenLines;//

- (void)addBrokenLine:(BrokenLine *)brokenLine;

/**
 *  更新地图资源,加载Map数据
 *
 *  @param mapData
 */
- (void)updateDataWithData:(NSArray *)mapData;

/**
 *  清除折线
 */
- (void)clearLines;

- (void)clearPoints;
- (void)clearPoint:(FlagView *)flagView;
- (void)clearLineWithIdenfiy:(NSString *)Idenfiy;

/**
 *  将坐标系进行转换
 *
 *  @param point gestureView 上的的点
 *
 *  @return self.coverView 上的点
 */
- (CGPoint)convertCoordinateFrameWithGestureViewPoint:(CGPoint)point;


/**
 *  设置最大.最小.点击放大倍数 ,用于Map数据还未加载
 */
- (void)setMaxZoomScale:(CGFloat )zoomScale;

/**
 *  设置最小放大倍数 ,用于Map数据还未加载
 */
- (void)setMinZoomScale:(CGFloat )zoomScale;

/**
 *  设置双击击放大倍数 ,用于Map数据还未加载
 */
- (void)setTapZoomScale:(CGFloat )zoomScale;

/**
 *  设置当前的放大到的倍数,用于Map数据已加载成功
 *
 *  @param zoomScale 放大到的倍数
 *  @param animated  动画
 */
- (void)setCurrenZoomScale:(CGFloat )zoomScale animated:(BOOL)animated;

/**
 *  设置每次放大或缩小的倍数,用于Map数据已加载成功
 *
 *  @param dxZoomScale 变化的倍数
 *  @param animated    动画
 */
- (void)setCurrentDxZoomScale:(CGFloat )dxZoomScale animated:(BOOL)animated;

/**
 *  内容视图移动操作,offset是微分量，相对于中心
 *
 */
- (void)setContentOffsetDx:(CGPoint)offsetDx animated:(BOOL)animated;

/**
 *  使showPoint居中，用于Pin添加后居中
 */
- (void)setShowCenter:(CGPoint)showPoint animated:(BOOL)animated;


/**
 *  将point偏移一个offset，用于标记的偏移
 *
 */
#warning 这个偏移量有问题
//- (CGPoint)offsettingPoint:(CGPoint)point withOffset:(CGPoint )offset;


/**
 *  电子罗盘开始更新方向
 */
- (void)startUpdateCompassHeading;

/**
 *  电子罗盘结束更新方向
 */
- (void)stopUpdateCompassHeading;
@end

