//
//  MapOption.h
//  MyGCIndoorMap
//
//  Created by gao on 16/8/24.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MapOptions : NSObject
/*!
 *  是否允许缩放
 */
@property (nonatomic, assign)BOOL zoomEnabled;//default is true

/*!
 *  是否允许移动
 */
@property (nonatomic, assign)BOOL moveEnabled;//default is true

/*!
 *  是否允许旋转
 */
@property (nonatomic, assign)BOOL rotateEnabled;//default is true

/*!
 *  是否允许俯仰
 */
//@property (nonatomic, assign)BOOL skewEnabled;//default is true

/*!
 *  是否允许单击
 */
@property (nonatomic, assign)BOOL sigleTapEnabled;//default is true

/*!
 *  是否允许双击
 */
@property (nonatomic, assign)BOOL doubleTapEnabled;//default is ture

/**
 *  是否被长按
 */
@property (nonatomic ,assign)BOOL longTapEnabled;


@end
