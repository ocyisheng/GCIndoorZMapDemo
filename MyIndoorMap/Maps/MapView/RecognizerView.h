//
//  GestureRecognizer.h
//  ImageManager
//
//  Created by gao on 16/4/29.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <UIKit/UIKit.h>

// DEBUG 模式下打印日志 当前行数 所在文件
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define DLog(...)

#endif

//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ULog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ULog(...)
#endif

@class RecognizerView;//,GCPitchGestureRecongnizer;
@protocol RecognizerViewDelegate <NSObject>

@optional
- (void)recognizerView:(RecognizerView *)recognizedView tapGesture:(UITapGestureRecognizer *)tapGesture;
- (void)recognizerView:(RecognizerView *)recognizedView doubleTapGesture:(UITapGestureRecognizer *)doubleTapGesture;
- (void)recognizerView:(RecognizerView *)recognizedView panGesture:(UIPanGestureRecognizer *)panGesture;
- (void)recognizerView:(RecognizerView *)recognizedView pinchGesture:(UIPinchGestureRecognizer *)pinchGesture;
- (void)recognizerView:(RecognizerView *)recognizedView longPressGesture:(UILongPressGestureRecognizer *)longGesture;
- (void)recognizerView:(RecognizerView *)recognizedView rotationGesture:(UIRotationGestureRecognizer *)rotationGesture;

//- (void)recognizerView:(RecognizerView *)recognizedView rotation:(CGFloat)rotation;
//- (void)recognizerView:(RecognizerView *)recognizedView pitchRecongnizer:(GCPitchGestureRecongnizer *)pitchGesture;


/**
 *  手势状态代理
 *  拖动 放大 旋转
 *
 *
 */
@required

@end

@interface RecognizerView : UIView
/**
 *  最小放大倍数
 */
@property (nonatomic ,assign) CGFloat minZoomScale;
/**
 *  最大放大倍数
 */
@property (nonatomic ,assign) CGFloat maxZoomScale;
/**
 *  放大倍数
 */
@property (nonatomic ,assign) CGFloat zoomScale;
/**
 *  点击放大倍数
 */
@property (nonatomic ,assign) CGFloat tapZoomScale;

/**
 *  当前旋转角度
 */
@property (nonatomic ,readonly) CGFloat currentRotation;

/**
 *  当前偏移量，相对于中心点
 */
@property (nonatomic ,readonly) CGPoint currentTranslation;

/**
 *  代理对象
 */
@property (nonatomic ,weak)  id<RecognizerViewDelegate> delegate;

/**
 *   旋转被识别的view
 *
 *  @param gestureView
 */

- (UIView *)operatedView;


/**
 *  使用一个要被手势操作的view初始化RecognzerView
 *  @param operatedView 被手势操作的view
 */
- (instancetype)initWithFrame:(CGRect)frame operatedView:(UIView *)operatedView;
/**
 *  旋转当前View
 *
 *  @param divAngle 累加量
 */
- (void)rotateWithDivAngle:(CGFloat)divAngle;


/**
 *  放大缩小方法
 *
 *  @param zoomScale 当是负数时，缩小操作
 *  @param animated  动画
 */
- (void)setZoomScale:(CGFloat)zoomScale animated:(BOOL)animated;

/**
 *  内容视图移动操作
 *
 */
- (void)setContentOffset:(CGPoint)offset animated:(BOOL)animated;



@end
