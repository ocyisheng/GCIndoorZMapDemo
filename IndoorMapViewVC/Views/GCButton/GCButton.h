//
//  GCButton.h
//  DTMachine7
//
//  Created by gao on 16/6/15.
//  Copyright © 2016年 上海你我信息有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, GCButtonType) {
     GCButtonTypeTop = 0,        //title位置居中在上在上
     GCButtonTypeBottom,     //title位置居中在下
     GCButtonTypeLeft,       //title位置居中在左
     GCButtonTypeRight,      //title位置居中在右
};
@interface GCButton : UIButton
@property (nonatomic ,assign) CGSize titleSize;
@property (nonatomic ,assign) CGSize imageSize;
@property (nonatomic ,assign) CGFloat betweenSpace;//title，image之间的间隔
+ (instancetype)buttonWithType:(GCButtonType)buttonType frame:(CGRect)frame;
+ (instancetype)buttonWithFrame:(CGRect)frame;//默认title在下
@end
