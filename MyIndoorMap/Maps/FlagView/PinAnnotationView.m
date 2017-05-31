//
//  PinAnnotationView.m
//  GCMapDemo
//
//  Created by gao on 16/5/25.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "PinAnnotationView.h"
#import "FeatureView.h"
#import "FeatureModel.h"

#import "FeatureFrameModel.h"
#import "CoverView.h"
#import "DefinitionHeader.h"


@interface PinAnnotationView()
{
    UIColor *_pinAnnotationColor;
    BOOL haveCallout;
    
}

///**
// *  使用图片自定义pin
// */
//
//@property (nonatomic ,strong) UIImage *image;
//
//@property (nonatomic ,strong) CALayer *pinLayer;
//
//@property (nonatomic ,strong) CAShapeLayer *maskLayer;
//
//
@property (nonatomic ,strong) UIBezierPath *maskPath;





/**
 *  自定义绘制pin
 */
@property (nonatomic ,strong) CAShapeLayer *shapeLayer;

@property (nonatomic ,strong) UIBezierPath *path;

@property (nonatomic ,strong) CALayer *contentLayer;



@end


@implementation PinAnnotationView

 - (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, 25, 75)];
#warning 这里需要生成新的初始化方法
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
          }
    return self;
}
- (void)drawRect:(CGRect)rect {
    [self.layer addSublayer:self.contentLayer];
    
    //[self.layer addSublayer:self.pinLayer];
 
}

#pragma mark - getter setter -

- (CALayer *)contentLayer{
    if (!_contentLayer) {
        _contentLayer = [CALayer layer];
        _contentLayer.backgroundColor = self.pinAnnotationColor.CGColor;;
        _contentLayer.frame = self.bounds;
        _contentLayer.mask = self.shapeLayer;
        
    }
    return _contentLayer;
}
- (CAShapeLayer *)shapeLayer{
    if (!_shapeLayer) {
        _shapeLayer = [CAShapeLayer layer];
        _shapeLayer.path = self.path.CGPath;
        _shapeLayer.fillColor = [UIColor blackColor].CGColor;
        _shapeLayer.strokeColor = [UIColor redColor].CGColor;
        _shapeLayer.frame = self.bounds;
        _shapeLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
        _shapeLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _shapeLayer;
}

- (UIBezierPath *)path{
    if (!_path) {
        _path = [UIBezierPath bezierPath];
        
        CGFloat r = (self.bounds.size.width - 4 ) * 0.5;
        CGFloat h = 3.0 * r;
        CGPoint center = CGPointMake(r + 2.0, r + 2.0);//- 120  30;
        CGPoint pa = CGPointMake(0.1334 * r + 2.0, 1.5 * r +2.0);
        CGPoint pb = CGPointMake(1.8666 * r + 2.0, 1.5 * r + 2.0);
        CGPoint pc = CGPointMake(r + 2.0, h +2.0);
        
        [_path moveToPoint:pa];
        [_path addLineToPoint:pc];
        [_path addLineToPoint:pb];
        [_path addArcWithCenter:center radius:r startAngle:RADIAN(-210) endAngle:RADIAN(30) clockwise:YES];
        [_path closePath];
    
    }
    return _path;
}

- (UIColor *)pinAnnotationColor{
    switch (_pinColor) {
        case PinAnnotationColorRed:
        {
            _pinAnnotationColor = [UIColor colorWithRed:192 / 255.0 green:25 / 255.0 blue:17 / 255.0 alpha:1.0];
        }
            break;
        case PinAnnotationColorGreen:
        {
            _pinAnnotationColor = [UIColor greenColor];
        }
            break;//  PinAnnotationColorBlue,
        case PinAnnotationColorBlue:
        {
            _pinAnnotationColor = [UIColor colorWithRed:36 / 255.0 green:143 / 255.0 blue:249 / 255.0 alpha:1.0];
        }
            break;
        case PinAnnotationColorPurple:
        {
            _pinAnnotationColor = [UIColor purpleColor];
        }
            break;
        case PinAnnotationColorYellow:
        {
            _pinAnnotationColor = [UIColor yellowColor];
        }
            break;
        case PinAnnotationColorBlack:
        {
            _pinAnnotationColor = [UIColor blackColor];
        }
            break;
            
    }
    return _pinAnnotationColor;
}
- (void)setSelected:(BOOL)selected{
    //选中时红色
    self.contentLayer.backgroundColor = [UIColor colorWithRed:192 / 255.0 green:25 / 255.0 blue:17 / 255.0 alpha:1.0].CGColor;
}
- (void)setContentImage:(UIImage *)contentImage{
   // _contentImage = contentImage;
    self.contentLayer.contents = (id)contentImage.CGImage;
    
}
- (BOOL)isAreaTouchPoint:(CGPoint)inTouchPoint{

    return CGPathContainsPoint(self.path.CGPath,NULL,inTouchPoint,false);
}


//- (UIBezierPath *)maskPath{
//    if (!_maskPath) {
//       // CGBitmapContextCreateImage
//        CGContextRef context = UIGraphicsGetCurrentContext();
//      
//        CGContextTranslateCTM(context, 0.0, 0.0);
//        CGContextScaleCTM(context, 1.0, -1.0);
//        
//        CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
//        
//        CGContextSaveGState(context);
//      //  CGContextClipToMask(context, self.bounds, CGImageRetain(self.image.CGImage));
//        CGContextFillRect(context, self.bounds);
//        CGContextRestoreGState(context);
//       
//        CGPathRef pathRef = CGContextCopyPath(context);
//        _maskPath = [UIBezierPath bezierPathWithCGPath:pathRef];
//        
//    }
//    
//    return _maskPath;
//}
//
//- (CAShapeLayer *)maskLayer{
//    if (!_maskLayer) {
//        _maskLayer = [CAShapeLayer layer];
//        _maskLayer.path = self.maskPath.CGPath;
//        _maskLayer.fillColor = [UIColor blackColor].CGColor;
//        _maskLayer.strokeColor = [UIColor redColor].CGColor;
//        _maskLayer.frame = self.bounds;
//        _maskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
//        _maskLayer.contentsScale = [UIScreen mainScreen].scale;
//
//    }
//    return _maskLayer;
//}
//
//- (CALayer *)pinLayer{
//    if (!_pinLayer) {
//        _pinLayer = [CALayer layer];
//        _pinLayer.frame = self.bounds;
//        _pinLayer.mask = self.maskLayer;
//        _pinLayer.contents = (id)self.image.CGImage;
//    }
//    return _pinLayer;
//}
//#warning 在这里再添加一个能使用图片的方法，并且可以根据图片获取点击范围
//- (UIImage *)image{
//    if (!_image) {
//        _image = [UIImage imageNamed:@"定位"];
//    }
//    return _image;
//}
@end
