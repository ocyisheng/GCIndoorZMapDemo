//
//  MapView.m
//  ImageManager
//
//  Created by gao on 16/5/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "MapView.h"
#import "FlagView.h"
#import "Map.h"
#import "CompassView.h"
#import "DefinitionHeader.h"
#import "Helper.h"

#import "MapFeatureConfig.h"
#import "PinAnnotationView.h"

@class MapView;
@interface MapView ()<RecognizerViewDelegate,CoverViewDataSource,MapHitDelegate,CompassViewDelegate>
{
    UIView       *gestureView;               //记录手势view
    FeatureView  *currenFeatureView;
    BOOL          touchedFeatureMark;            //hitMap是否被触发
    
        
    CGSize mapSize;
    
    NSInteger   zoomScalePriorityCurrentValue;
    NSInteger   zoomScalePriorityLastValue;
    
    void *context;//上下文，标记kvo
    
    CGFloat maxScale;
    CGFloat minScale;
    CGFloat tapScale;
    BOOL    updatePropertyMark[3];//标记Zoom操作是否是默认的或又重新设置
    
}
@property (nonatomic ,strong) RecognizerView *recongnizerView;//手势识别view
@property (nonatomic ,strong) CoverView *coverView;//覆盖层，添加折线标记等
@property (nonatomic ,strong) Map *map;//Feature展示层
@property (nonatomic ,strong) CompassView *compassView;


@end
@implementation MapView

- (void)dealloc{
    //移除kvo
    if ((__bridge NSString *)context) {
        [self.recongnizerView removeObserver:self forKeyPath:H_ZoomScale context:context];
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        updatePropertyMark[0] = NO;
        updatePropertyMark[1] = NO;
        updatePropertyMark[2] = NO;
    }
    return self;
}
#pragma mark - 暴露方法实现-
- (void)addFlagView:(FlagView *)flagView point:(CGPoint)point{
    flagView.coverPoint = point;
    [self addFlagView:flagView];
}
//添加一条折线
- (void)addBrokenLine:(BrokenLine *)brokenLine{
    
    [self.coverView brokenLines:@[brokenLine] wtihGestureView:gestureView];
}
//添加一组折线
- (void)addBrokenLines:(NSArray<BrokenLine *> *)brokenLines
{
     [self.coverView brokenLines:brokenLines wtihGestureView:gestureView];
}
- (void)clearLines{
    [self.coverView clearLines];
}
- (void)clearLineWithIdenfiy:(NSString *)Idenfiy{
    [self.coverView clearLineWithIdentify:Idenfiy];
}

- (void)clearPoints{
    [self.coverView clearPoints];
}

- (void)clearPoint:(FlagView *)flagView{
    [self.coverView clearFlagView:flagView];
}

- (CGPoint)convertCoordinateFrameWithGestureViewPoint:(CGPoint)point{
    return   [gestureView convertPoint:point toView:self.coverView];
}
- (void)updateDataWithData:(NSArray *)mapData{
    if (!mapData.count) {
        return;
    }
    
    mapSize = CGSizeMake((2008 / H_RealToMapScale), (1776 / H_RealToMapScale));
    [MapFeatureConfig configMapFeaturesWithFeatureModelAreas:mapData map:self.map coverView:self.coverView];
#warning 这里可以设置Map的size
#warning 数据中应该带有Map的size
    //(width = 2008, height = 1776)
    [Helper saveMapSize:CGSizeMake((2008 / H_RealToMapScale), (1776 / H_RealToMapScale))];
    //更新放大属性
    [self updateRecognizeViewProperty];
   
    [self addSubview:self.recongnizerView];
    [self addSubview:self.coverView];
     self.coverView.center = self.recongnizerView.center;
    [self addSubview:self.compassView];
    
    //用于监控放大倍数的kvo
    [self addObserverForRecognizeViewZoomScale];
}

- (void)setMaxZoomScale:(CGFloat )zoomScale{
     updatePropertyMark[0] = YES;
     maxScale = zoomScale;
}
- (void)setMinZoomScale:(CGFloat )zoomScale{
    updatePropertyMark[1] = YES;
    minScale = zoomScale;
}

- (void)setTapZoomScale:(CGFloat )zoomScale{
      updatePropertyMark[2] = YES;
    tapScale = zoomScale;
}

- (void)setCurrenZoomScale:(CGFloat )zoomScale animated:(BOOL)animated{
    [self setCurrentDxZoomScale:zoomScale - self.recongnizerView.zoomScale animated:animated];
}


- (void)setCurrentDxZoomScale:(CGFloat )dxZoomScale animated:(BOOL)animated{
    [self.recongnizerView setZoomScale:dxZoomScale animated:animated];
     //只要有放大操作就需要调用该函数
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self.coverView convertPointsWithTapOrPinchGestureView:self.map];
        }];
    }else{
        [self.coverView convertPointsWithTapOrPinchGestureView:self.map];
    }
}

- (void)setContentOffsetDx:(CGPoint)offsetDx animated:(BOOL)animated{
#warning 注意此处的坐标系转化
    [self.recongnizerView setContentOffset:offsetDx animated:animated];
    [self.coverView coverViewMoveWithOffset:offsetDx animated:animated];
}

- (void)setShowCenter:(CGPoint)showPoint animated:(BOOL)animated{
    CGPoint coCenter = [self.recongnizerView.operatedView convertPoint:showPoint toView:self.recongnizerView];
    CGPoint reCenter = self.recongnizerView.center;//这里应是recongnizerView的中心点
    CGPoint offset = CGPointMake( reCenter.x - coCenter.x , reCenter.y - coCenter.y);
    [self setContentOffsetDx:offset animated:animated];
}

- (void)startUpdateCompassHeading{
    [self.compassView startUpdateHeading];
}

- (void)stopUpdateCompassHeading{
    [self.compassView stopUpdateHeading];
}
- (CGPoint)offsettingPoint:(CGPoint)point withOffset:(CGPoint )offset{
    CGFloat scale = self.recongnizerView.zoomScale;
    
    CGFloat rotation = self.recongnizerView.currentRotation;
    
#warning 此处依旧有问题，需要重新考虑
    return CGPointMake(point.x + offset.x / (scale ), point.y + offset.y / (scale ));
}

#pragma mark - RecognizerViewDelegate -
- (void)recognizerView:(RecognizerView *)recognizedView panGesture:(UIPanGestureRecognizer *)panGesture{
    [self removeGestureAffect];
    
    if (!self.mapOptions.moveEnabled) {
        return;
    }
    NSUInteger state = panGesture.state;
    if (state == UIGestureRecognizerStateBegan) {
        //将要开始移动
        if ([self.delegate respondsToSelector:@selector(mapViewWillBeginMoving:)]) {
            [self.delegate mapViewWillBeginMoving:self];
        }
    }else if(state == UIGestureRecognizerStateEnded){
        //已经结束移动
        if ([self.delegate respondsToSelector:@selector(mapViewDidEndMoving:)]) {
            [self.delegate mapViewDidEndMoving:self];
        }
    }else if (state == UIGestureRecognizerStateChanged){
   
        //正在移动
        if ([self.delegate respondsToSelector:@selector(mapViewDidMoving:translation:)]) {
    #warning 注意这里translation,这里的
            [self.delegate mapViewDidMoving:self translation:self.recongnizerView.currentTranslation];
        }
    }
        //cover跟随手势平移
        [self.coverView coverViewMoveWithPanGestureRecognizer:panGesture];
    
}

- (void)recognizerView:(RecognizerView *)recognizedView pinchGesture:(UIPinchGestureRecognizer *)pinchGesture{
    [self removeGestureAffect];
    
    if (!self.mapOptions.zoomEnabled) {
        return;
    }
    NSUInteger state = pinchGesture.state;
    if (state == UIGestureRecognizerStateBegan) {
        //将要开始放大
        if ([self.delegate respondsToSelector:@selector(mapViewWillBeginZooming:)]) {
            [self.delegate mapViewWillBeginZooming:self];
        }
    }else if(state == UIGestureRecognizerStateEnded){
        //已经停止放大
        if ([self.delegate respondsToSelector:@selector(mapViewDidEndZooming:)]) {
            [self.delegate mapViewDidEndZooming:self];
        }
    }else if (state == UIGestureRecognizerStateChanged){
        //正在放大
        if ([self.delegate respondsToSelector:@selector(mapViewDidZoom:currentScale:)]) {
            [self.delegate mapViewDidZoom:self currentScale:self.recongnizerView.zoomScale];
        }
    }
    //CoverView 跟随放大
    [self.coverView convertPointsWithTapOrPinchGestureView:recognizedView.operatedView];
    
    
}

- (void)recognizerView:(RecognizerView *)recognizedView rotationGesture:(UIRotationGestureRecognizer *)rotationGesture{
#warning 在长按手势里添加Pin的点击回调
    [self removeGestureAffect];
    
    if (!self.mapOptions.rotateEnabled) {
        return;
    }
    NSUInteger state = rotationGesture.state;
    if (state == UIGestureRecognizerStateBegan) {
        //将要开始旋转
        if ([self.delegate respondsToSelector:@selector(mapViewWillBeginRotating:)]) {
            [self.delegate mapViewWillBeginRotating:self];
        }
    }else if(state == UIGestureRecognizerStateEnded){
        //停止旋转
        if ([self.delegate respondsToSelector:@selector(mapViewDidEndRotating:)]) {
            [self.delegate mapViewDidEndRotating:self];
        }
    }else if (state == UIGestureRecognizerStateChanged){
        //正在旋转
        if ([self.delegate respondsToSelector:@selector(mapViewDidRotating:currentRotation:)]) {
            [self.delegate mapViewDidRotating:self currentRotation:self.recongnizerView.currentRotation];
        }
    }
    DLog(@"%f",rotationGesture.rotation);
    //cover跟随手势旋转
    [self.coverView coverViewRotaWithDivRotation:rotationGesture.rotation];
    //如果显示罗盘
    if (self.showCompass) {
        [self.compassView stopUpdateHeading];
        [self.compassView updateHeadingWithDivAngle:rotationGesture.rotation];
        [self.compassView startUpdateHeading];
    }
    
    
    
}
- (void)recognizerView:(RecognizerView *)recognizedView tapGesture:(UITapGestureRecognizer *)tapGesture{
    //消除长按手势影响 FeatureModel的传递
    [self removeGestureAffect];
    
    gestureView = recognizedView.operatedView;//保存手势，使用坐标转换
    CGPoint currentP = [tapGesture locationInView:recognizedView.operatedView];
#warning PinView 专一作为标记只有各种颜色的区分
#warning 他应有一个属性标记他已经被添加，不管是长按添加或者点击添加，然后再点击回调中判断是否该Pin被点击
    
    PinAnnotationView *pinView;
    if ([self.coverView isInsideWithTouchPoint:[self convertCoordinateFrameWithGestureViewPoint:currentP] pinView:&pinView]) {
#warning 这里是大头针点击回调
        if ([self.delegate respondsToSelector:@selector(mapView:didTouchedPinView:)]) {
            [self.delegate mapView:self didTouchedPinView:pinView];
        }
        return;
    }
    
    if (!self.mapOptions.sigleTapEnabled) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mapView:didTapAtPoint:featureID:)]) {
        [self.delegate mapView:self didTapAtPoint:currentP featureID:currenFeatureView.ID];
        
    }
    
#warning 仿大头针的中心点是FeatureView的center加偏移量。。。。。。。。。。。。。。。
    //已有MapView实现
}


- (void)recognizerView:(RecognizerView *)recognizedView doubleTapGesture:(UITapGestureRecognizer *)doubleTapGesture{
    [self removeGestureAffect];
    
    if (!self.mapOptions.doubleTapEnabled) {
        return;
    }
    
    //将要开始放大
    if ([self.delegate respondsToSelector:@selector(mapViewWillBeginZooming:)]) {
        [self.delegate mapViewWillBeginZooming:self];
    }
    [self.coverView convertPointsWithTapOrPinchGestureView:recognizedView.operatedView];
    //停止放大
    if ([self.delegate respondsToSelector:@selector(mapViewDidEndZooming:)]) {
        [self.delegate mapViewDidEndZooming:self];
    }
    
}
- (void)recognizerView:(RecognizerView *)recognizedView longPressGesture:(UILongPressGestureRecognizer *)longGesture{
    //传递长按手势,长按手势会多次调用该方法
    if (longGesture.state == UIGestureRecognizerStateRecognized) {
        
        [self removeGestureAffect];
        
        if (!self.mapOptions.longTapEnabled) {
            return;
        }
        
        CGPoint currentP = [longGesture locationInView:recognizedView.operatedView];
        gestureView = recognizedView.operatedView;//保存手势，使用坐标转换
        
        if ([self.delegate respondsToSelector:@selector(mapView:didLongPressedAtPoint:featureID:)]) {
            [self.delegate mapView:self didLongPressedAtPoint:currentP featureID:currenFeatureView.ID];
            
        }
    }
    
}

#pragma mark - MapHitDelegate -
- (void)hitMap:(Map *)map featureView:(FeatureView *)featureView{
#warning  点击featureView响应的方法 以及 点击Map响应的方法
    //记录当前被点击的FeatureView
    currenFeatureView = featureView;
    touchedFeatureMark = YES;
    
    NSLog(@"currenFeatureView：%@",currenFeatureView);
}

#pragma mark - CompassViewDelegate -

- (void)compassView:(CompassView *)compassView updateAngleDiv:(CGFloat)angleDiv{
    [UIView animateWithDuration:0.2 animations:^{
        [self.recongnizerView rotateWithDivAngle:angleDiv];
        [self.coverView coverViewRotaWithDivRotation:angleDiv];
    }];
}

#pragma mark - observe -
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    if ([keyPath isEqualToString:H_ZoomScale]) {
        //发送ZoomScale变化后的通知，用于不同优先级的showView(FeatureFlagView)的隐藏
        [self postZoomScaleNotification];
    }
        
}

#pragma mark - 私有方法实现-
/**
 *  添加标记的方法
 *
 *  @param flag 标记对象
 */
- (void)addFlagView:(FlagView *)flag{
    CGPoint center = [self convertCoordinateFrameWithGestureViewPoint:flag.coverPoint];
    [self.coverView addFlagView:flag withPoint:center];
}

/**
 *  监控 recongnizerView ZoomScale 的kvo
 */
- (void)addObserverForRecognizeViewZoomScale{
    context = (__bridge void *)([Helper currentDateString]);
    [self.recongnizerView addObserver:self forKeyPath:H_ZoomScale options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:context];
    
}
- (void)updateRecognizeViewProperty{
    
    if (updatePropertyMark[0]) {
        self.recongnizerView.maxZoomScale = maxScale;
    }
    if (updatePropertyMark[1]) {
        self.recongnizerView.minZoomScale = minScale;
    }
    if (updatePropertyMark[2]) {
        self.recongnizerView.tapZoomScale = tapScale;
    }
    
}
- (void)removeGestureAffect{
#warning 这里的
    //消除其他手势影响FeatureModel的传递（tap传递）（- (void)hitMap:(Map *)map featureModel:(FeatureModel *)featureModel）
    if (!touchedFeatureMark) {
        currenFeatureView = nil;
    }else{
        touchedFeatureMark = NO;
    }
    
}
/**
 *  发送优先级别的通知，
 */
- (void)postZoomScaleNotification{
    
    CGFloat zoomScale = self.recongnizerView.zoomScale;
    CGFloat maxScales = self.recongnizerView.maxZoomScale;
    CGFloat minScales = self.recongnizerView.minZoomScale;
    CGFloat dScale = (maxScales - minScales) /4.0 ;
    
    //连续数值转离散数值
    if (zoomScale < dScale) {
        zoomScalePriorityCurrentValue = 3;
    }
    if (zoomScale >= dScale && zoomScale < 2 * dScale) {
        zoomScalePriorityCurrentValue = 2;
    }
    if (zoomScale >= 2 * dScale && zoomScale < 3 * dScale ){
        zoomScalePriorityCurrentValue = 1;
    }
    if (zoomScale >= 3 * dScale ) {
        zoomScalePriorityCurrentValue = 0;
    }
    /*
     实现原理
     ________/__________/_____________/____________
     1000    0 + 8  0   3
     1100    4 + 8  1   2
     1110    6 + 8  2   1
     1111    7 + 8  3   0
     
     */
    if (!(zoomScalePriorityLastValue == zoomScalePriorityCurrentValue)) {
        [[NSNotificationCenter defaultCenter] postNotificationName:H_ZoomScaleChangedNotification object:self userInfo:@{H_ZoomScale:@(zoomScalePriorityCurrentValue)}];
        zoomScalePriorityLastValue = zoomScalePriorityCurrentValue;
        NSLog(@"%ld",zoomScalePriorityCurrentValue);
        //4 6  7   100 110 111
    }
    
}


#pragma mark - setter func -
- (Map *)map{
    if (!_map) {
        _map = [[Map alloc]initWithFrame:CGRectMake(0, 0, mapSize.width, mapSize.height)];
        _map.hitDelegate = self;
        _map.layer.allowsEdgeAntialiasing = YES;//消除旋转后的锯齿效果
        _map.backgroundColor = [UIColor whiteColor];
    }
    return _map;
}
- (RecognizerView *)recongnizerView{
    if (!_recongnizerView) {
        _recongnizerView = [[RecognizerView alloc]initWithFrame:self.bounds operatedView:self.map];
        _recongnizerView.delegate = self;
        gestureView = _recongnizerView.operatedView;
        
    }
    return _recongnizerView;
}

- (CoverView *)coverView{
    if (!_coverView) {
#warning recongnizerView 设置最大frame,消除折线截断现象，过度放大不能识别。。。。。。
#warning coverView的size 应是map的size的MaxZoomScale倍!!!!!!!!!
#warning 搞个NSUserDefault 储存
        //当设置了maxZoomScale时
        CGFloat scale = maxScale >0 ? maxScale :self.recongnizerView.maxZoomScale;
        _coverView = [[CoverView alloc]initWithFrame:CGRectMake(0, 0, mapSize.width * scale, mapSize.height* scale)];
        _coverView.center = self.recongnizerView.center;
        _coverView.backgroundColor = [UIColor clearColor];
        _coverView.userInteractionEnabled = NO;
    }
    return _coverView;
}

- (CompassView *)compassView{
    if (!_compassView) {
        _compassView = [[CompassView alloc]initWithFrame:CGRectMake(20, 120, 40, 40)];
        _compassView.backgroundColor = [UIColor clearColor];
        _compassView.directionImageName = @"north_arrow";
        _compassView.delegate = self;
        [_compassView startUpdateHeading];
    }
    return _compassView;
}

- (MapOptions *)mapOptions{
    if(!_mapOptions){
        _mapOptions = [[MapOptions alloc]init];
    }
    return _mapOptions;
}
- (void)setShowCompass:(BOOL)showCompass{
    _showCompass = showCompass;
    self.compassView.hidden = !showCompass;
}
@end
