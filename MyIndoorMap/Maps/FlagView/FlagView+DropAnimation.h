//
//  FlagView+DropAnimation.h
//  IndoorMapViewVC
//
//  Created by gao on 16/9/6.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "FlagView.h"

@interface FlagView (DropAnimation)
/**
 *  准备掉落动画
 */
- (void)prepareDropAnimation;

/**
 *  掉落动画
 *
 */
- (void)dropAnimationWithRotate:(CGFloat)ratate;

@end
