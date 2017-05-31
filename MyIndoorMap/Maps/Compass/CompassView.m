//
//  CompassView.m
//  CompassCoreLocationDemo
//
//  Created by gao on 16/5/24.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "CompassView.h"
#import <CoreLocation/CoreLocation.h>
@class CompassView;
@interface CompassView ()<CLLocationManagerDelegate>
{
    BOOL updating;//是否激发回调的标记（电子罗盘变化的回调）
    
    CGFloat lastRotation;
    CGFloat divRotation;
}

@property (nonatomic ,strong) UIImageView *directionImageView;//箭头image
@property (nonatomic ,strong) UIImageView *dividingImageView;//刻度image
@property (nonatomic ,strong) CLLocationManager *locationManager;

@end
@implementation CompassView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.hidden = YES;
    }
    return self;
}
- (void)startUpdateHeading{
    updating = YES;
}
- (void)stopUpdateHeading{
    updating = NO;
}
- (void)drawRect:(CGRect)rect{
    
    self.layer.allowsEdgeAntialiasing = YES;
    [self bringSubviewToFront:self.directionImageView];
    [self.locationManager startUpdatingHeading];
}
- (CLLocationManager *)locationManager
{
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        // 每隔多少度更新一次
        _locationManager.headingFilter = 1.0;
    }
    return _locationManager;
}
#pragma mark - setter getter -
- (void)setDivingImageName:(NSString *)divingImageName{
    _divingImageName = divingImageName;
    
    [self addSubview:self.dividingImageView];
}
- (void)setDirectionImageName:(NSString *)directionImageName{
    _directionImageName = directionImageName;
    [self addSubview:self.directionImageView];

}
- (UIImageView *)directionImageView{
    if (!_directionImageView) {
        _directionImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.directionImageName]];
        _directionImageView.frame = self.bounds;
        _directionImageView.layer.allowsEdgeAntialiasing = YES;
        
    }
    return _directionImageView;
}
- (UIImageView *)dividingImageView{
    if (!_dividingImageView) {
        _dividingImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:self.divingImageName]];
        CGRect bounds = self.bounds;
        _dividingImageView.frame = CGRectMake(bounds.origin.x, bounds.origin.y, bounds.size.width ,  bounds.size.height );
    }
    return _dividingImageView;
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
//    NSLog(@"磁北角度:%f", newHeading.magneticHeading);
//    NSLog(@"真北角度:%f", newHeading.trueHeading);
    CGFloat angle = newHeading.trueHeading;
    
    // 把角度转弧度
    CGFloat angleR = angle / 180.0 * M_PI;
    divRotation = angleR - lastRotation;
    lastRotation = angleR;
    
       // 旋转方向指示图片
    [UIView animateWithDuration:0.2 animations:^{
        self.directionImageView.transform = CGAffineTransformRotate(self.directionImageView.transform, divRotation);
    }];
    
    //    //旋转方向图片
    //    [UIView animateWithDuration:0.25 animations:^{
    //        self.dividingImageView.transform = CGAffineTransformMakeRotation(angleR);
    //    }];
    
    
    if (updating) {
        //使用 transform =  CGAffineTransformRotate(self.transform, divRotation);
        if ([self.delegate respondsToSelector:@selector(compassView:updateAngleDiv:)]) {
            [self.delegate compassView:self updateAngleDiv:divRotation];
        }
    }

}

- (void)updateHeadingWithDivAngle:(CGFloat )divAngle{
    [UIView animateWithDuration:0.2 animations:^{
        self.directionImageView.transform = CGAffineTransformRotate(self.directionImageView.transform, divAngle);
    }];
}

@end
