//
//  ZoomImageView.h
//  NagrandModuleTest
//
//  Created by Choi on 16/4/1.
//  Copyright © 2016年 iOSPractice.xyd. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 * @brief 按钮的类型
 */
typedef NS_ENUM(NSInteger,ZoomType) {
    ZoomTypeAdd = 0,//+
    ZoomTypeSub,    //-
};
/*!
 * @brief 缩放按钮
 */
@interface ZoomImageView : UIView
/*!
 * @brief 按钮的类型
 */
@property (assign,nonatomic)ZoomType zoomtype;
/*!
 * @brief 按钮的背景图片
 */
@property (strong,nonatomic,nullable) UIImage *backgroundImage;
/*!
 * @brief 添加按钮点击事件
 */
-(void)addTarget:(nullable id)target action:(nonnull SEL)selector;
@end
