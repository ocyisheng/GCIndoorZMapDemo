//
//  FlagView+DropAnimation.m
//  IndoorMapViewVC
//
//  Created by gao on 16/9/6.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "FlagView+DropAnimation.h"

@implementation FlagView (DropAnimation)
- (void)prepareDropAnimation{
    
    CGRect screen = [UIScreen mainScreen].bounds;
    CATransform3D move = CATransform3DIdentity;
    CGFloat iniViewYPosition = (CGRectGetHeight(screen) + CGRectGetHeight(self.frame)) / 2;
    
    move = CATransform3DMakeTranslation(0, -iniViewYPosition, 0);
    
    //move = CATransform3DRotate(move, 40 * M_PI/180, 0, 0, 1.0f);
    
    self.layer.transform = move;
}
- (void)dropAnimationWithRotate:(CGFloat)ratate{
    
    self.transform = CGAffineTransformRotate(self.transform, -ratate);
    
    [UIView animateWithDuration:1.0f
                          delay:0.0f
         usingSpringWithDamping:0.4f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         CATransform3D init = CATransform3DIdentity;
                         self.layer.transform = init;
#warning 此处由于界面旋转造成pin 偏转，此处需要复位；
                         self.transform = CGAffineTransformRotate(self.transform, -ratate);
                         
                     }
                     completion:nil];
}

@end
