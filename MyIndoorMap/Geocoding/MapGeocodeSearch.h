//
//  MapGeocodeSearch.h
//  GCMapDemo
//
//  Created by gao on 16/6/6.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MapGeocodeSearch : NSObject
/*
 
 1.正向地理编码服务实现了将中文地址或地名描述转换为地球表面上相应位置的功能。 
 
 2.反向地理编码实现将经纬度坐标转化为中文地址(省市街道名字等)
 
 
 3.此类可暂时使用 sqlite 储存编码信息，使用数据库 搜素需要的信息，
    >1.实现 搜索名称时获取位置（正向编码）
    >2.实现 从位置信息获取中文地址等其他信息(反向编码)
 
 机场 号 层 Feature
 他们的基本信息，包括编号，名称 ，实际坐标 屏幕坐标 其他信息
 列表结构:
 
 (1)
 (2)
 (3)
 (4)
 (5)
 (6)
 
 Feature 使用分类 实现 poi 的搜索。。。。。。。。。
 
 */
- (CGPoint)realPositionByName:(NSString *)name;//模糊查询所有的 name 对应的位置


@end
