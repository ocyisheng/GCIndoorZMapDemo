//
//  Recognizer.m
//  ImageManager
//
//  Created by gao on 16/4/29.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "RecognizerView.h"

@interface RecognizerView ()
<UIGestureRecognizerDelegate>
{
    CGPoint gestureViewCenter;
    
    BOOL stopScaleZoomDelegateFunc;
    
}

// 注意再次重构使用kvc 重写transform 的平移 缩放 旋转 等方法！！！！！！！！！！https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html
@property (nonatomic ,strong) UIPanGestureRecognizer *panGesture;//拖动
@property (nonatomic ,strong) UITapGestureRecognizer *tapGesture;//单击
@property (nonatomic ,strong) UITapGestureRecognizer *doubletTapGesture;//双击
@property (nonatomic ,strong) UIPinchGestureRecognizer *pinchGesture;//捏合
@property (nonatomic ,strong) UILongPressGestureRecognizer *longGesture;//长按
@property (nonatomic ,strong) UIRotationGestureRecognizer *rotationGesture;//旋转

@property (nonatomic,strong) UIView *operatedView;
@end

@implementation RecognizerView
- (void)initRecognizerView{
    _zoomScale  = 0.25f;//默认显示的放大,不能设置
    _maxZoomScale = 2.f;//默认最大放大倍数
    _minZoomScale = 0.25f;//默认最小放大倍数
    _tapZoomScale = 0.5f;//默认点击放大倍数
}
- (instancetype)initWithFrame:(CGRect)frame operatedView:(UIView *)operatedView{
    self = [super initWithFrame:frame];
    if (self) {
        self.operatedView = operatedView;
    }
    return self;
}
- (void)setOperatedView:(UIView *)operatedView{
    _operatedView = operatedView;
    [self addSubview:operatedView];
    _operatedView.center = self.center;
    //记录当前的缩放比
    self.zoomScale = [self currentScale];
    gestureViewCenter = operatedView.center;
    //添加手势
    [self addGestureRecognizer];
    [self initRecognizerView];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //    if (self.imageView.center.x == 0 && self.imageView.center.y == 0) {
    //        self.imageView.center = [self convertPoint:self.center toView:self.imageView];
    //    }
    
}

#pragma mark - private func
- (CGFloat)currentScale{
    CGFloat scale = [(NSNumber *)[self.operatedView valueForKeyPath:@"layer.transform.scale.x"] floatValue];
    DLog(@"scale:%f",scale)
    return scale;
}
- (CGFloat)currentRotation{
    // 这个是0 - 180  -180 - 0 变化
    //  rotationGeture.rotation 是以如下方式计算
    //当前的currentRotation - lastRotation 即可
    CGFloat rotate = [(NSNumber *)[self.operatedView valueForKeyPath:@"layer.transform.rotation"] floatValue];
    DLog(@"rotate:%f",rotate)
    return rotate;
}
- (CGPoint)currentTranslation{
    CGPoint currentCenter = self.operatedView.center;
    CGPoint translation = CGPointMake(currentCenter.x - gestureViewCenter.x, currentCenter.y - gestureViewCenter.y);
    DLog(@"translation from center :%@",NSStringFromCGPoint(translation));
    return translation;
}
#pragma mark - setter func 缩放,偏移量 -
- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated{
    [self limitZoomScaleWithView:self.operatedView
                          dscale:zoomScale - self.zoomScale
                        animated:animated];
}

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated{
    //计算中心点位置
    CGPoint center = self.operatedView.center;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.operatedView.center = CGPointMake(center.x + offset.x, center.y + offset.y);
        }];
    }else{
        self.operatedView.center = CGPointMake(center.x + offset.x, center.y + offset.y);
    }
}
- (void)rotateWithDivAngle:(CGFloat)divAngle{
    [UIView  animateWithDuration:0.2 animations:^{
        self.operatedView.transform = CGAffineTransformRotate(self.operatedView.transform, divAngle);
        ;
        
    }];
}
#pragma mark - private func -
#pragma mark - 手势触发事件 -
- (void)longGesture:(UILongPressGestureRecognizer *)longGesture
{
    if ([self.delegate respondsToSelector:@selector(recognizerView:longPressGesture:)]) {
        [self.delegate recognizerView:self
                     longPressGesture:longGesture];
    }
}
- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    CGPoint point = [panGesture translationInView:self];
    self.operatedView.center = CGPointMake(self.operatedView.center.x + point.x, self.operatedView.center.y + point.y);
    if ([self.delegate respondsToSelector:@selector(recognizerView:panGesture:)]) {
        [self.delegate recognizerView:self
                           panGesture:panGesture];
    }
    [panGesture setTranslation:CGPointZero inView:self];//i
    
    
}
- (void)doubletTapGesture:(UITapGestureRecognizer *)doubletTapGesture{
    
    //缩放view操作
    BOOL stop = [self limitZoomScaleWithView:self.operatedView
                                      dscale:self.tapZoomScale
                                    animated:NO];
    if (stopScaleZoomDelegateFunc && stop) {
        //当缩放时，方法少调用一次导致，界面在最值时产生跳动
    }else{
        //实现双击的代理
        if ([self.delegate respondsToSelector:@selector(recognizerView:doubleTapGesture:)]) {
            [self.delegate recognizerView:self doubleTapGesture:doubletTapGesture];
            stopScaleZoomDelegateFunc = stop;
        }
    }
}
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture{
    
    if ([self.delegate respondsToSelector:@selector(recognizerView:tapGesture:)]) {
        [self.delegate recognizerView:self tapGesture:tapGesture];
    }
}

- (void)rotationGesture:(UIRotationGestureRecognizer *)rotationGeture
{
    //旋转手势
    //旋转弧度
    //旋转，从当前位置旋转
    self.operatedView.transform = CGAffineTransformRotate(_operatedView.transform, rotationGeture.rotation);
    //归零
    if ([self.delegate respondsToSelector:@selector(recognizerView:rotationGesture:)]) {
        [self.delegate recognizerView:self rotationGesture:rotationGeture];
    }
    rotationGeture.rotation = 0.0;
}

- (void)pinGesture:(UIPinchGestureRecognizer *)pinGesture{
    //缩放view操作
    BOOL stop = [self limitZoomScaleWithView:self.operatedView dscale:pinGesture.scale - 1.0 animated:NO];
    
    if (stopScaleZoomDelegateFunc && stop) {
        //当缩放时，方法少调用一次导致，界面在最值时产生跳动
    }else{
        if ([self.delegate respondsToSelector:@selector(recognizerView:pinchGesture:)]) {
            [self.delegate recognizerView:self pinchGesture:pinGesture];
            stopScaleZoomDelegateFunc = stop;
        }
    }
    //归零
    pinGesture.scale = 1.0;
}

#pragma mark - 手势代理方法 -
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //允许多手势
    return YES;
}

#pragma mark - 键值观察的回调方法-
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"center"]) {
        //
        //        BOOL visible =  [self.imageView isVisibleInScreen];
        //        if (!visible) {
        //            //[self alwaysSetGestureViewToSuperViewCenter];
        //        }
    }
}

#pragma mark - 添加手势和视图
- (void)addGestureRecognizer
{
    [self addGestureRecognizer:self.rotationGesture];//旋转手势
    [self addGestureRecognizer:self.pinchGesture];//捏合手势
    [self addGestureRecognizer:self.doubletTapGesture];//双击手势
    [self addGestureRecognizer:self.tapGesture];//点击手势
    [self addGestureRecognizer:self.panGesture];//拖动手势
    [self addGestureRecognizer:self.longGesture];//长按手势
    
}
/**
 *  gestureView 限制最小最大缩放比的
 *
 *  @param view     限制的view
 *  @param animated 动画
 */
- (BOOL)limitZoomScaleWithView:(UIView *)view dscale:(CGFloat)dscale animated:(BOOL)animated{
    BOOL stop = NO;
    CGFloat scale = self.zoomScale + dscale;
    if (scale <=self.minZoomScale) {
        scale = self.minZoomScale;
        stop = YES;
    }else if (scale >= self.maxZoomScale) {
        scale = self.maxZoomScale;
        stop = YES;
    }
    if (animated) {
        [UIView animateWithDuration:0.3f animations:^{
            view.transform = CGAffineTransformScale(view.transform, scale / self.zoomScale ,  scale  / self.zoomScale);
        }];
    }else{
        view.transform = CGAffineTransformScale(view.transform, scale / self.zoomScale ,  scale  / self.zoomScale);
    }
    self.zoomScale = [self currentScale];
    
    return stop;
}
- (void)alwaysSetGestureViewToSuperViewCenter{
    
    CGPoint convGesCenter = [self.operatedView convertPoint:self.operatedView.center toView:self.operatedView];
    CGPoint divCenter = CGPointMake(self.center.x - convGesCenter.x,self.center.y  - convGesCenter.y);
    
    [self setContentOffset:divCenter animated:YES];
    
}
//- (CGPoint)topLiftPoint:(UIView *)view{
//   return  CGPointZero;
//}
//- (CGPoint)topRightPoint:(UIView *)view{
//    return CGPointMake(CGRectGetWidth(view.frame), 0);
//}
//- (CGPoint)bottomLiftPoint:(UIView *)view{
//    return CGPointMake(0, CGRectGetHeight(view.frame));
//}
//- (CGPoint)bottomRightPoint:(UIView *)view{
// return CGPointMake(CGRectGetWidth(view.frame), CGRectGetHeight(view.frame));
//}
#pragma mark - getter func -

- (UIView *)recognizedView
{
    return self.operatedView;
}
#pragma mark - 手势创建 -
- (UIPanGestureRecognizer *)panGesture{
    if (!_panGesture) {
        _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        _panGesture.delegate = self;
    }
    return _panGesture;
}
- (UIPinchGestureRecognizer *)pinchGesture{
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinGesture:)];
        _pinchGesture.delegate = self;
    }
    return _pinchGesture;
}
- (UIRotationGestureRecognizer *)rotationGesture{
    if (!_rotationGesture) {
        _rotationGesture = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(rotationGesture:)];
        _rotationGesture.delegate = self;
    }
    return _rotationGesture;
}
- (UITapGestureRecognizer *)doubletTapGesture{
    if (!_doubletTapGesture) {
        _doubletTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubletTapGesture:)];
        _doubletTapGesture.numberOfTouchesRequired = 1;
        _doubletTapGesture.numberOfTapsRequired = 2;
    }
    return _doubletTapGesture;
}
- (UITapGestureRecognizer *)tapGesture{
    if (!_tapGesture) {
        _tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGesture:)];
        _tapGesture.numberOfTouchesRequired = 1;
        _tapGesture.numberOfTapsRequired = 1;
        [_tapGesture requireGestureRecognizerToFail:self.doubletTapGesture];
    }
    return _tapGesture;
}
- (UILongPressGestureRecognizer *)longGesture{
    if (!_longGesture) {
        _longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longGesture:)];
        _longGesture.minimumPressDuration = 0.3;
    }
    return _longGesture;
}
@end
