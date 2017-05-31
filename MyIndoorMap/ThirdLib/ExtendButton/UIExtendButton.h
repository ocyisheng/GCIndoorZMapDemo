//
//  UIExtendButton.h
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/25.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 * @brief 楼层切换按钮的展开方向
 */
typedef NS_ENUM(NSInteger,ExtendDirection) {
    ExtendTop =  0,
    ExtendLeft = 1,
    ExtendBottom = 2,
    ExtendRight = 3,
};
/*!
 * @brief 楼层切换按钮
 */
@interface UIExtendButton : UIButton
/*!
 * @brief 子楼层的名称数组
 */
@property(nonatomic,strong)NSArray *subTitleArray;
/*!
 * @brief 展开方向
 */
@property(nonatomic,assign)ExtendDirection extendStyle;
/*!
 * @brief item的回调block
 */
@property(nonatomic,copy)void (^clickBlock)(int index);
/*!
 * @brief 当前选中的item的索引
 */
@property (assign,nonatomic)int currentIndex;
/*!
 * @brief 楼层按钮展开的长度（default:200）
 */
@property (assign,nonatomic)CGFloat extendDistance;
/*!
 * @brief item默认的颜色
 */
@property (strong,nonatomic)UIColor *defaultColor;
/*!
 * @brief item选中时的颜色
 */
@property (strong,nonatomic)UIColor *selectedColor;

@end
