//
//  CoverView.h
//  ImageManager
//
//  Created by gao on 16/5/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DrawLineLayer.h"

@class CoverView,FlagView,PinAnnotationView;

@protocol CoverViewDataSource <NSObject>
@optional
//#warning 此处回调方法，应是POI搜索时的方法，仿照UITableViewDataSource,待完成
//- (NSInteger)numberOfFlagInCoverView:(CoverView *)coverView;
//- (FlagView *)coverView:(CoverView *)coverView flagAtIndex:(NSInteger )index;



@required

@end


@interface CoverView : UIView


@property (nonatomic ,assign) id <CoverViewDataSource> dataSource;

- (void)addFlagView:(FlagView *)flag withPoint:(CGPoint)point;

/**
 *  添加多条折线
 *
 *  @param points
 *  @param view   
 */
- (void)brokenLines:(NSArray *)lines wtihGestureView:(UIView *)view;

/**
 *  清除所有折线
 */
- (void)clearLines;

/**
 *  清除某一条折线
 *
 *  @param identify 折线的唯一标示
 */
- (void)clearLineWithIdentify:(NSString *)identify;

/**
 *  清除最后一个Pin
 */
- (void)clearLastPoint;

/**
 *  清除点
 */
- (void)clearPoints;

- (void)clearFlags;

/**
 *  清除一个标记点
 */
- (void)clearFlagView:(FlagView *)flagView;


/**
 *  转换坐标系，注意适用于放大手势操作 只要有放大操作就需要调用该函数
 *
 *  @param gestureView pinch 或 tap 手势
 */
- (void)convertPointsWithTapOrPinchGestureView:(UIView *)gestureView;

/**
 *  跟随手势拖动而动,上下左右平移
 *
 *  @param panGesture 拖动手势
 */
- (void)coverViewMoveWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture;
- (void)coverViewMoveWithOffset:(CGPoint)offset  animated:(BOOL)animated;
///**
// *  跟随手势旋转
// *
// *  @param rotationGesture 旋转手势
// */
//- (void)coverViewRotaWithRotationGesture:(UIRotationGestureRecognizer *)rotationGesture;

/**
 *  coverView  旋转
 *
 *  @param angle
 */
- (void)coverViewRotaWithDivRotation:(CGFloat)divRotation;

/**
 *  查找Point对应的CoverPoint,返回值是bool
 *
 *  @param point      被测试的点
 *  @param coverPoint
 *
 *  @return
 */
- (BOOL)isInsideWithTouchPoint:(CGPoint )touchPoint pinView:(PinAnnotationView **)pinView;

@end
