//
//  Recognizer.m
//  ImageManager
//
//  Created by gao on 16/4/29.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "RecognizerView.h"
#import "Helper.h"

@interface RecognizerView ()
<UIGestureRecognizerDelegate>
{
    CGPoint gestureViewCenter;
    BOOL stopScaleZoomDelegateFunc;
}

#warning 注意再次重构使用kvc 重写transform 的平移 缩放 旋转 等方法！！！！！！！！！！https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Key-ValueCodingExtensions/Key-ValueCodingExtensions.html
@property (nonatomic ,strong) UIPanGestureRecognizer *panGesture;//拖动
@property (nonatomic ,strong) UITapGestureRecognizer *tapGesture;//单击
@property (nonatomic ,strong) UITapGestureRecognizer *doubletTapGesture;//双击
@property (nonatomic ,strong) UIPinchGestureRecognizer *pinchGesture;//捏合
@property (nonatomic ,strong) UILongPressGestureRecognizer *longGesture;//长按
@property (nonatomic ,strong) UIRotationGestureRecognizer *rotationGesture;//旋转
@property (nonatomic ,strong) UIView *gestureView;

@end

@implementation RecognizerView
- (instancetype)initWithFrame:(CGRect)frame recognizedView:(UIView *)recognizedView
{
    self = [super initWithFrame:frame];
    if (self) {
      
        self.gestureView = recognizedView;
        [self addGestureRecognizer];
    }
    return self;
}
#pragma mark - public func -
#pragma mark - setter func 缩放,偏移量 -
- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated{
    
    [self limitMaxAndMinZoomScaleWithView:_gestureView
                                   dscale:zoomScale
                                 animated:animated];
}

- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated{
    //计算中心点位置
    
    CGPoint center = self.gestureView.center;
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            _gestureView.center = CGPointMake(center.x + offset.x, center.y + offset.y);
        }];
    }else{
        _gestureView.center = CGPointMake(center.x + offset.x, center.y + offset.y);
    }
}
#pragma mark - getter func -
- (CGFloat)currentScale{
    CGFloat SCALE = [(NSNumber *)[_gestureView valueForKeyPath:@"layer.transform.scale.x"] floatValue];
    return SCALE;
}
- (CGFloat)currentRotation{
#warning 这个是0 - 180  -180 - 0 变化
#warning  rotationGeture.rotation 是以如下方式计算
    //当前的currentRotation - lastRotation 即可
    CGFloat rotate = [(NSNumber *)[_gestureView valueForKeyPath:@"layer.transform.rotation"] floatValue];
    return rotate;
}
- (CGPoint)currentTranslation{
    CGPoint currentCenter = self.gestureView.center;
    CGPoint translation = CGPointMake(currentCenter.x - gestureViewCenter.x, currentCenter.y - gestureViewCenter.y);
    return translation;
}

- (UIView *)recognizedView{
    return _gestureView;
}
- (void)rotateWithDivAngle:(CGFloat)divAngle{
    [UIView  animateWithDuration:0.2 animations:^{
        _gestureView.transform = CGAffineTransformRotate(_gestureView.transform, divAngle);
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
   
    UIImageView *imageView = (UIImageView *) panGesture.view;
    CGPoint point = [panGesture translationInView:self];
    imageView.center = CGPointMake(imageView.center.x + point.x, imageView.center.y + point.y);
   
    if ([self.delegate respondsToSelector:@selector(recognizerView:panGesture:)]) {
        [self.delegate recognizerView:self
                           panGesture:panGesture];
    }
    
    [panGesture setTranslation:CGPointZero inView:self];//image在哪里加的
    
    
}
- (void)doubletTapGesture:(UITapGestureRecognizer *)doubletTapGesture{
    
    //缩放view操作
    BOOL stop = [self limitMaxAndMinZoomScaleWithView:doubletTapGesture.view
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
     rotationGeture.view.transform = CGAffineTransformRotate(rotationGeture.view.transform, rotationGeture.rotation);
      if ([self.delegate respondsToSelector:@selector(recognizerView:rotationGesture:)]) {
        [self.delegate recognizerView:self rotationGesture:rotationGeture];
    }
       //归零
     rotationGeture.rotation = 0.0;
}

- (void)pinGesture:(UIPinchGestureRecognizer *)pinGesture{
    
     //缩放view操作
    BOOL stop = [self limitMaxAndMinZoomScaleWithView:pinGesture.view dscale:pinGesture.scale - 1 animated:NO];
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
    
}

#pragma mark - 添加手势和视图  -
- (void)setGestureView:(UIView *)gestureView{
    _gestureView= gestureView;//(width = 2008, height = 1776)
    #warning frame 应是Map 的自带属性！！！！！！！！！！！！
    _gestureView.center = self.center;
    #warning map 的frame 应是自带属性
    [self addSubview:_gestureView];
    _gestureView.userInteractionEnabled = YES;
    
    //记录当前的缩放比
    self.zoomScale = [self currentScale];
    gestureViewCenter = _gestureView.center;
    
}
- (void)addGestureRecognizer
{
    [_gestureView addGestureRecognizer:self.rotationGesture];//旋转手势
    [_gestureView addGestureRecognizer:self.pinchGesture];//捏合手势
    [_gestureView addGestureRecognizer:self.doubletTapGesture];//双击手势
    [_gestureView addGestureRecognizer:self.tapGesture];//点击手势
    [_gestureView addGestureRecognizer:self.panGesture];//拖动手势
    [_gestureView addGestureRecognizer:self.longGesture];//长按手势
    
}
/**
 *  gestureView 限制最小最大缩放比的
 *
 *  @param view     限制的view
 *  @param animated 动画
 */
- (BOOL)limitMaxAndMinZoomScaleWithView:(UIView *)view dscale:(CGFloat)dscale animated:(BOOL)animated{
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
        [UIView animateWithDuration:0.2f animations:^{
            view.transform = CGAffineTransformScale(view.transform, scale / self.zoomScale ,  scale  / self.zoomScale);
        }];
    }else{
        view.transform = CGAffineTransformScale(view.transform, scale / self.zoomScale ,  scale  / self.zoomScale);
    }
    self.zoomScale = [self currentScale];
    return stop;
}


#pragma mark - getter func -
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

#pragma mark - 放大倍数 -
- (CGFloat)zoomScale{
    if (!_zoomScale) {
#warning 设置默认显示大小有问题！！！！！！
        _zoomScale  = 1.0f;//默认显示的放大
    }
    return _zoomScale;
}
- (CGFloat)maxZoomScale{
    if (!_maxZoomScale) {
        _maxZoomScale = 4.f;//默认最大放大倍数
    }
    return _maxZoomScale;
}
- (CGFloat)minZoomScale{
    if (!_minZoomScale) {
        _minZoomScale = 0.5f;//默认最小放大倍数
    }
    return _minZoomScale;
}
- (CGFloat)tapZoomScale{
    if (!_tapZoomScale) {
        _tapZoomScale = 0.5f;//默认点击放大倍数
    }
    return _tapZoomScale;
}

@end
