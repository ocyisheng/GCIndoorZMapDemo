//
//  Helper.h
//  ScrollViewScale
//
//  Created by gao on 16/7/14.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface Helper : NSObject

/**
 *  保存Map的Size
 *
 *  @param mapSize
 */
+ (void)saveMapSize:(CGSize)mapSize;
/**
 *  读取Map的Size
 *
 *  @return
 */
+ (CGSize)readMapSize;

/**
 *  Float 转 int
 *
 *  @param num
 *
 *  @return
 */
+ (NSInteger)getInter:(CGFloat)num;

/**
 *  当前时间
 *
 *  @return 
 */
+(NSString *)currentDateString;
@end
