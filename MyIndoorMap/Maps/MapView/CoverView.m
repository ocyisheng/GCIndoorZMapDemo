//
//  CoverView.m
//  ImageManager
//
//  Created by gao on 16/5/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "CoverView.h"
#import "FlagView.h"
#import "FlagView+DropAnimation.h"
#import "BrokenLine.h"
#import "PinAnnotationView.h"
#import "FeatureFlagView.h"
@interface CoverView()
{
    UIView     *recognizedView;
    /**
     *  记录累加的旋转角，FlagView 添加时，设置transform，使其处于保持状态
     */
    CGFloat    currentAddRotate;
}

/**
 *  绘制折线的层
 */
@property (nonatomic ,strong) DrawLineLayer *lineLayer;

/**
 *  储存折线的数组，
 */
@property (nonatomic ,strong) NSMutableArray *brokenLines;

/**
 *      储存固定的flagview，厕所（图片），要显示的名称等
 */
@property (nonatomic ,strong) NSMutableArray<FlagView *> *flagArray;

/**
 *  储存大头针的数组
 */
@property (nonatomic ,strong) NSMutableArray *pinAnnotationArray;

/**
 *  储存自定义CoverFlag 的数组
 */
@property (nonatomic ,strong) NSMutableArray *custumFlagArray;


#warning 这里的数据层可以提取出来！！！！！！！！！！！！！！！！
#warning 待完成！！！！

@end
@implementation CoverView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加折线层
        [self.layer addSublayer:self.lineLayer];
    }
    return self;
}

- (void)brokenLines:(NSArray *)lines wtihGestureView:(UIView *)view
{
    recognizedView = view;
    [self.lineLayer setGestureView:recognizedView];
    [self.lineLayer drawLinesWithLineModels:lines];
    
}
#pragma mark - 坐标转化 -
- (void)convertPointsWithTapOrPinchGestureView:(UIView *)gestureView{
    recognizedView = gestureView;
    [self convertPointsOfFlagViews:self.flagArray toCoverViewByGestureView:recognizedView];
    [self convertPointsOfFlagViews:self.pinAnnotationArray toCoverViewByGestureView:recognizedView];
    [self convertPointsOfFlagViews:self.custumFlagArray toCoverViewByGestureView:recognizedView];
    
    [self.lineLayer updateLines];
}
- (void)coverViewMoveWithPanGestureRecognizer:(UIPanGestureRecognizer *)panGesture{
    CGPoint point = [panGesture translationInView:panGesture.view.superview];
    CGPoint center = self.center;
    self.center = CGPointMake(center.x + point.x, center.y + point.y);
}

- (void)coverViewMoveWithOffset:(CGPoint)offset  animated:(BOOL)animated{
    CGPoint center = self.center;
    
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            self.center = CGPointMake(center.x + offset.x, center.y + offset.y);
        }];
    }else{
        self.center = CGPointMake(center.x + offset.x, center.y + offset.y);
    }
    
}
- (void)coverViewRotaWithDivRotation:(CGFloat)divRotation{
   //记录旋转角
    currentAddRotate += divRotation;
    
    //自身旋转
    self.transform = CGAffineTransformRotate(self.transform, divRotation);
    
    //flag 保持水平
    [self rotationAllFlagViewsWithRotate:divRotation];

}

#pragma mark - 私有方法 -
- (void)rotationAllFlagViewsWithRotate:(CGFloat)rotate{
    [self flagArray:self.flagArray rotate:rotate];
    [self flagArray:self.pinAnnotationArray rotate:rotate];
    [self flagArray:self.custumFlagArray rotate:rotate];
}
- (void)flagArray:(NSMutableArray *)marray rotate:(CGFloat)rotate{
    [marray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FlagView *flag = obj;
        flag.transform = CGAffineTransformRotate(flag.transform, -rotate);
    }];
}

//转换坐标系
- (void)convertPointsOfFlagViews:(NSArray *)array toCoverViewByGestureView:(UIView *)gestureView{
    //标记转换
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FlagView *flag = obj;
        CGPoint point = [recognizedView convertPoint:flag.coverPoint toView:self];
        flag.center = point;
      }];
}

#pragma mark - 删除操作 -
- (void)clearLines{
   //清空资源
    [self.brokenLines  removeAllObjects];
    self.brokenLines = nil;
    //删除layer上的所有折线
    [self.lineLayer clearLines];
}
- (void)clearLineWithIdentify:(NSString *)identify{
    //删除资源
    BrokenLine *reLine;
    for (BrokenLine *line in self.brokenLines) {
        if ([line.identify isEqualToString:identify]) {
            reLine = line;
        }
    }
    [self.brokenLines removeObject:reLine];
    //layer删除某一条折线
    [self.lineLayer removeBrokenLineWithIdentify:identify];
}
- (void)clearFlagView:(FlagView *)flagView{
#warning 此处类的判断似乎有隐患 isMemberOfClass 是否是某类的实例； isKindOfClass 是否是某类或其子类的实例
    if ([flagView isKindOfClass:[PinAnnotationView class]]) {
        
        [self.pinAnnotationArray removeObject:flagView];
        
    }else if ([flagView isKindOfClass:[FeatureFlagView class]]){
        
        [self.custumFlagArray addObject:flagView];
    }else{
        
        [self.flagArray removeObject:flagView];
    }
    [flagView removeFromSuperview];
}

- (void)clearCustumFlags{
   
    for (FlagView *flag in self.custumFlagArray) {
        [flag removeFromSuperview];
    }
      [self.custumFlagArray removeAllObjects];
}

- (void)clearPinAnnotations{
   
    for (FlagView *flag in self.pinAnnotationArray) {
        [flag removeFromSuperview];
    }
     [self.pinAnnotationArray removeAllObjects];
}

- (void)clearFlags{
   
    for (FlagView *flag in self.flagArray) {
        [flag removeFromSuperview];
    }
     [self.flagArray removeAllObjects];
}

- (void)clearPoints{
    [self clearFlags];
    [self clearPinAnnotations];
}
- (void)clearLastPoint{
    PinAnnotationView *pin  = [self.pinAnnotationArray lastObject];
    [pin removeFromSuperview];
    [self.pinAnnotationArray removeLastObject];
}

- (void)addFlagView:(FlagView *)flag withPoint:(CGPoint)point{

    flag.center = point;
    flag.transform = CGAffineTransformMakeRotation(-currentAddRotate);
   
    
    if ([flag isKindOfClass:[FeatureFlagView class]]){
        
        [self.custumFlagArray addObject:flag];
        
    }else if ([flag isKindOfClass:[PinAnnotationView class]]){
        
         [self.pinAnnotationArray addObject:flag];
         PinAnnotationView *pin = (PinAnnotationView *)flag;
        if (pin.animateDrop) {
            [pin prepareDropAnimation];
            [self addSubview:pin];
            [pin dropAnimationWithRotate:currentAddRotate];
            return;
        }
        
    }else{
        
        [self.flagArray addObject:flag];
    }
     [self addSubview:flag];
}


- (BOOL)isInsideWithTouchPoint:(CGPoint )touchPoint pinView:(PinAnnotationView **)pinView
{
#warning 该方法已经计算出被点击的PinAnnotationView。关于PinAnnotationView被点击的通知可以省略！！！！！
    
    __block BOOL finded = NO;
    [self.pinAnnotationArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PinAnnotationView *pin = obj;
        CGPoint convertPoint = [self convertPoint:touchPoint toView:pin];
        if ([pin isAreaTouchPoint:convertPoint]&& pin.canShowCallout) {
            *pinView = pin;
            *stop = YES;
            finded = YES;
    NSLog(@"该PinAnnotationView被点击，convertPoint在自身的:%@,呼出状态是:%d",NSStringFromCGPoint(convertPoint),pin.canShowCallout);
        }
    }];
    
    if (finded) {
        return YES;
    }
    return NO;
}


#pragma mark - setter getter func -
- (DrawLineLayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [[DrawLineLayer alloc]init];
        _lineLayer.frame = self.bounds;

    }
    return _lineLayer;
}

- (NSMutableArray *)flagArray{
    if (!_flagArray) {
        _flagArray = [NSMutableArray array];
    }
    return _flagArray;
}

- (NSMutableArray *)brokenLines{
    if (!_brokenLines) {
        _brokenLines = [NSMutableArray array];
    }
    return _brokenLines;
}
- (NSMutableArray *)pinAnnotationArray{

    if (!_pinAnnotationArray) {
        _pinAnnotationArray = [NSMutableArray array];
    }
    return _pinAnnotationArray;

}
- (NSMutableArray *)custumFlagArray{
    if (!_custumFlagArray) {
        _custumFlagArray = [NSMutableArray array];
    }
    return _custumFlagArray;
}
@end
