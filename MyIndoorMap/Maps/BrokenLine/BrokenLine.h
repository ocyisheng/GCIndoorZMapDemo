//
//  BrokenLine.h
//  GCMapDemo
//
//  Created by gao on 16/5/13.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrokenLine : NSObject
@property (nonatomic ,strong) NSArray *pointArray;
@property (nonatomic ,copy) NSString *identify;
@property (nonatomic ,strong) UIColor *lineColor;//颜色
@property (nonatomic ,assign) CGFloat lineWidth;//线宽

/**
 *  使用identify创建line
 *
 *  @param identify 唯一标示
 *
 *  @return self
 */
- (instancetype)initWithIdentify:(NSString *)identify;

@end
