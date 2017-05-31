//
//  GCCompassView.m
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/15.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import "GCCompassView.h"
#import <CoreLocation/CoreLocation.h>

@interface GCCompassView()<CLLocationManagerDelegate>
@property (nonatomic,assign)BOOL isFirst;
@property (nonatomic,strong)UIImageView *backgroundImageView;
@property (nonatomic,assign)CGFloat rotation;
@property (nonatomic ,assign) BOOL updating;//是否激发回调的标记（电子罗盘变化的回调）
@property (nonatomic ,strong) CLLocationManager *locationManager;
@end


@implementation GCCompassView
- (void)startUpdateHeading{
    _updating = YES;
}
- (void)stopUpdateHeading{
    _updating = NO;
}
-(UIImageView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc]init];
    }
    return _backgroundImageView;
}
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        // 每隔多少度更新一次
        _locationManager.headingFilter = 2;
    }
    return _locationManager;
}
#pragma mark - CLLocationManagerDelegate
/*
 获取到手机朝向时调用
 @param manager    位置管理者
 @param newHeading 朝向对象
 */
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    /*
     CLHeading
     magneticHeading : 磁北角度
     trueHeading : 真北角度
     */
    //显示当前角度
    NSLog(@"磁北角度:%f", newHeading.magneticHeading);
    NSLog(@"真北角度:%f", newHeading.trueHeading);
    CGFloat angle = newHeading.trueHeading;
    // 把角度转弧度
    CGFloat angleR = angle / 180.0 * M_PI;
    
    if ([self.delegate respondsToSelector:@selector(compassView:updateAngle:)] && _updating) {
        [self.delegate compassView:self updateAngle:angleR];
    }
    // 旋转方向指示图片
    [UIView animateWithDuration:0.25 animations:^{
        self.transform = CGAffineTransformIdentity;
        CGAffineTransform transform = CGAffineTransformMakeRotation(- angle);
        self.transform = transform;
    }];
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.isFirst = true;
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = frame.size.width/2;
        [self.locationManager startUpdatingHeading];

    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        self.backgroundColor = [UIColor whiteColor];
      //  self.layer.cornerRadius = aDecoder.width/2;
    }
    return self;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    self.backgroundImageView.image = backgroundImage;
    self.backgroundImageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    [self addSubview:self.backgroundImageView];
    _backgroundImage = backgroundImage;
}

-(void)GCCompassViewRotateWithAngleFromNorth:(CGFloat )angleFromNorth{
    self.transform = CGAffineTransformIdentity;
    CGAffineTransform transform = CGAffineTransformMakeRotation(-1 * M_PI / 180 * angleFromNorth);
    self.transform = transform;
}

-(void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
}

-(void)drawRect:(CGRect)rect{
    //黑色圆形背景
    if(!self.backgroundImage){
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height));
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextFillPath(context);
        
        //刻度
        CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
        NSArray *tempArr = [self getPoint];
        for (int i = 0; i < tempArr.count; i+=2) {
            CGContextMoveToPoint(context, [tempArr[i] CGPointValue].x, [tempArr[i] CGPointValue].y);
            CGContextAddLineToPoint(context, [tempArr[i + 1] CGPointValue].x, [tempArr[i + 1] CGPointValue].y);
        }
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 1.0);
        CGContextStrokePath(context);
        
        //三角形
        CGContextMoveToPoint(context, self.bounds.size.width/2,self.bounds.size.height/2 * 0.4);
        CGContextAddLineToPoint(context, self.bounds.size.width/2 - 4, self.bounds.size.height/2 - 1);
        CGContextAddLineToPoint(context, self.bounds.size.width/2 + 4, self.bounds.size.height/2 - 1);
        CGContextClosePath(context);
        CGContextSetFillColorWithColor(context, [UIColor redColor].CGColor);
        CGContextFillPath(context);
        
        //字
        NSString *str = @"北";
        [str drawInRect:CGRectMake(self.bounds.size.width/2 - 5,self.bounds.size.height/2, 12, 12) withAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],NSFontAttributeName:[UIFont systemFontOfSize:10]}];
    }
}

-(NSArray *)getPoint{
        CGFloat temp0 = 0.75 * self.bounds.size.width/2;
        CGFloat temp1 = self.bounds.size.width/2;
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i = 0; i < 16; i++) {
            CGFloat core = M_PI * 2 / 16 * i;
            CGFloat y0 = temp1 - sin(core) * temp0;
            CGFloat x0 = temp1 - cos(core) * temp0;
            CGFloat y1 = temp1 - sin(core) * 0.9 * temp1;
            CGFloat x1 = temp1 - cos(core) * 0.9 * temp1;
            [arr addObject:[NSValue valueWithCGPoint:CGPointMake(x0, y0)]];
            [arr addObject:[NSValue valueWithCGPoint:CGPointMake(x1, y1)]];
        }
    return [NSArray arrayWithArray:arr];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"点击指南针");
//    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
//    animation.toValue = [NSNumber numberWithFloat:0.f];
//    animation.springBounciness = 10.f;
//    animation.springSpeed = 5;
//    [self.layer pop_addAnimation:animation forKey:@"rotationAnimation"];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:10.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
    } completion:^(BOOL finished) {
        
    }];
    
    if (self.compassBlock) {
        self.compassBlock();
    }
}

@end
