//
//  DefinitionHeader.h
//  ScrollViewScale
//
//  Created by gao on 16/7/14.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#ifndef DefinitionHeader_h
#define DefinitionHeader_h

//储存MapSize键值宏
#define H_SaveMapWidth  @"MapSizeWidthSaveToNSUserDefaults"
#define H_SaveMapHeight @"MapSizeHeightSaveToNSUserDefaults"

//通知名称的宏
/**
 *  FeatureLayer 获取 Map 发送的通知
 *
 *  @return
 */
#define H_GetMapObjectNotification  @"GetMapObjectNotification"

/**
 *  
 *  大头针被点击发送通知的宏
 *
 */
#define H_PinAnnotationTouchedNotification @"PinAnnotationTouchedNSNotification"


#define H_ZoomScaleChangedNotification  @"ZoomScaleChangedNotification"

/**
 *  真值到Map之间的比例
 *
 *  @return
 */
#define H_RealToMapScale 6.0

/**
 *  kvo 检测当前放大倍数变化的宏
 *
 */
#define H_ZoomScale @"zoomScale"



#define ANGLE(rotate) rotate *180.0 / M_PI //弧度转角度
#define RADIAN(angle) angle * M_PI /180.0 //角度转弧度

#define RGBColor(a,b,c) [UIColor colorWithRed:a/255.0 green:b/255.0 blue:c/255.0 alpha:1]

#endif /* DefinitionHeader_h */
