//
//  PlottingScaleView.h
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/28.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 * @brief 比例尺控件
 */
@interface PlottingScaleView : UIView
/*!
 * @brief 比例尺对应的实际长度
 */
@property (nonatomic,assign)CGFloat plottingDistance;
/*!
 * @brief 比例尺是否可变
 */
@property (nonatomic,assign)BOOL changeAbled;
/*!
 * @brief 比例尺的单位长度 单位:米
 */
@property (nonatomic,assign)int minUnit;

@end
