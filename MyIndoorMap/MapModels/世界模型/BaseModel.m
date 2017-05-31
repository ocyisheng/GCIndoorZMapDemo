//
//  BaseModel.m
//  UIDynamicDemo
//
//  Created by gao on 16/4/20.
//  Copyright © 2016年 gao. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    NSLog(@"未识别的key:%@",key);
}
- (id)valueForUndefinedKey:(NSString *)key{
    return nil;
}
+ (NSArray *)prepareData:(id)object{
    NSLog(@"I am baseModel");
    return nil;
}


- (instancetype)initWithDictionaty:(NSDictionary *)dic{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
+ (instancetype)modelWithDictianary:(NSDictionary *)dic{
    return [[[self class]alloc]initWithDictionary:dic];
}
@end
