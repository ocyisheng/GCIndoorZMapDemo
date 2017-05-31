//
//  BaseModel.h
//  UIDynamicDemo
//
//  Created by gao on 16/4/20.
//  Copyright © 2016年 gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface BaseModel : NSObject

/**
 *  使用数组或字典，生成self的数组
 *
 *  @param object
 *
 *  @return 
 */
+ (NSArray *)prepareData:(id)object;

/**
 *  使用字典生成一个Model
 *
 *  @param object 字典
 *
 *  @return self
 */
- (instancetype)initWithDictionaty:(NSDictionary *)dic;

+ (instancetype)modelWithDictianary:(NSDictionary *)dic;

@end
