//
//  XDTestData.m
//  ScrollViewScale
//
//  Created by gao on 16/7/7.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "XDTestData.h"
#import "PolygonArea.h"
#import "FeatureAreaModel.h"
#import "DefinitionHeader.h"
#import "FeatureModel.h"
#define SCALE 4.0
@implementation XDTestData
- (NSMutableArray *)areaArray
{
    if (!_areaArray) {//28.833333333333332, 55.666666666666664}, {86, 49.666666666666664}}
        _areaArray =  [NSMutableArray array];//(width = 2008, height = 1776)

        
        PolygonArea *fa1 = [[PolygonArea alloc]initWithCoordinate:@"333,1547,334,1653,682,1651,679,1540,576,1545" scale: H_RealToMapScale];
        
//        FeatureLayer *layer1 = [FeatureLayer layer];
//        layer1.PolygonArea = fa1;
        //H_RealToMap H_RealToMapScale
        PolygonArea *fa2 = [[PolygonArea alloc]initWithCoordinate:@"173,451,173,559,299,563,300,590,316,592,321,628,687,632,689,334,581,335,580,447,536,448,535,465,333,464,330,448"  scale: H_RealToMapScale];
//        FeatureLayer *layer2 = [FeatureLayer layer];
//        layer2.PolygonArea = fa2;//922,445,921,629,1013,628,1051,598,1049,448"
        
        PolygonArea *fa3 = [[PolygonArea alloc]initWithCoordinate:@"922,445,921,629,1013,628,1051,598,1049,448"  scale: H_RealToMapScale];
//        FeatureLayer *layer3 = [FeatureLayer layer];
//        layer3.PolygonArea = fa3;
        
        PolygonArea *fa4 = [[PolygonArea alloc]initWithCoordinate:@"1081,444,1078,598,1177,597,1215,532,1276,485,1275,444"  scale: H_RealToMapScale];
//        FeatureLayer *layer4 = [FeatureLayer layer];
//        layer4.PolygonArea = fa4;

        PolygonArea *fa5 = [[PolygonArea alloc]initWithCoordinate:@"1289,444,1290,484,1371,466,1451,485,1455,444,1369,421"  scale: H_RealToMapScale];
//        FeatureLayer *layer5 = [FeatureLayer layer];
//        layer5.PolygonArea = fa5;

        PolygonArea *fa6 = [[PolygonArea alloc]initWithCoordinate:@"1466,446,1467,485,1513,525,1562,595,1822,593,1818,573,1855,573,1854,443"  scale: H_RealToMapScale];
//        FeatureLayer *layer6 = [FeatureLayer layer];
//        layer6.PolygonArea = fa6;
        
        PolygonArea *fa7 = [[PolygonArea alloc]initWithCoordinate:@"1823,632,1823,751,1866,746,1867,630"   scale: H_RealToMapScale];
//        FeatureLayer *layer7 = [FeatureLayer layer];
//        layer7.PolygonArea = fa7;
        
        PolygonArea *fa8 = [[PolygonArea alloc]initWithCoordinate:@"231,810,229,917,420,915,420,801"  scale: H_RealToMapScale];
//        FeatureLayer *layer8 = [FeatureLayer layer];
//        layer8.PolygonArea = fa8;
        
        
        PolygonArea *fa9 = [[PolygonArea alloc]initWithCoordinate:@"420,915,420,801,580,795,580,917" scale: H_RealToMapScale];
//        FeatureLayer *layer9 = [FeatureLayer layer];
//        layer9.PolygonArea = fa9;
        
        PolygonArea *fa10 = [[PolygonArea alloc]initWithCoordinate:@"64,1051,61,1652,333,1648,331,1421,451,1420,451,1500,577,1500,521,1437,498,1375,489,1292,497,1219,526,1147,580,1078,578,1048"  scale: H_RealToMapScale];
//        FeatureLayer *layer10 = [FeatureLayer layer];
//        layer10.PolygonArea = fa10;

        PolygonArea *fa11 = [[PolygonArea alloc]initWithCoordinate:@"680,792,813,786,813,975,680,973"  scale: H_RealToMapScale];
//        FeatureLayer *layer11 = [FeatureLayer layer];
//        layer11.PolygonArea = fa11;
        
        PolygonArea *fa12 = [[PolygonArea alloc]initWithCoordinate:@"917,981,680,973,679,1076,749,1173,916,1173"  scale: H_RealToMapScale];
//        FeatureLayer *layer12 = [FeatureLayer layer];
//        layer12.PolygonArea = fa12;
        
        PolygonArea *fa13 = [[PolygonArea alloc]initWithCoordinate:@"917,981,916,1173,995,1126,1052,1126,1050,982" scale: H_RealToMapScale];
//        FeatureLayer *layer13 = [FeatureLayer layer];
//        layer13.PolygonArea = fa13;
        
        PolygonArea *fa14 = [[PolygonArea alloc]initWithCoordinate:@"815,786,815,919,919,923,918,783"  scale: H_RealToMapScale];
//        FeatureLayer *layer14 = [FeatureLayer layer];
//        layer14.PolygonArea = fa14;
        
        PolygonArea *fa15 = [[PolygonArea alloc]initWithCoordinate:@"918,783,919,877,1036,776,1037,876"  scale: H_RealToMapScale];
//        FeatureLayer *layer15 = [FeatureLayer layer];
//        layer15.PolygonArea = fa15;
        
        PolygonArea *fa16 = [[PolygonArea alloc]initWithCoordinate:@"1036,776,1179,769,1210,819,1202,1102,1185,1130,1052,1127,1037,876"  scale: H_RealToMapScale];
//        FeatureLayer *layer16 = [FeatureLayer layer];
//        layer16.PolygonArea = fa16;
        
        PolygonArea *fa17 = [[PolygonArea alloc]initWithCoordinate:@"1293,808,1438,808,1437,849,1294,850"  scale: H_RealToMapScale];
//        FeatureLayer *layer17 = [FeatureLayer layer];
//        layer17.PolygonArea = fa17;
        
        PolygonArea *fa18 = [[PolygonArea alloc]initWithCoordinate:@"1554,799,1585,779,1807,780,1806,932,1559,933"  scale: H_RealToMapScale];
//        FeatureLayer *layer18 = [FeatureLayer layer];
//        layer18.PolygonArea = fa18;
        
        PolygonArea *fa19 = [[PolygonArea alloc]initWithCoordinate:@"1559,933,1806,932,1805,1047,1560,1043"  scale: H_RealToMapScale];
//        FeatureLayer *layer19 = [FeatureLayer layer];
//        layer19.PolygonArea = fa19;
        
        PolygonArea *fa20 = [[PolygonArea alloc]initWithCoordinate:@"1560,1043,1805,1047,1804,1163,1559,1160"  scale: H_RealToMapScale];
//        FeatureLayer *layer20 = [FeatureLayer layer];
//        layer20.PolygonArea = fa20;

        PolygonArea *fa21 = [[PolygonArea alloc]initWithCoordinate:@"1574,1199,1572,1406,1454,1412,1458,1582,1540,1590,1544,1701,1964,1705,1955,1287,1950,1197"  scale: H_RealToMapScale];
//        FeatureLayer *layer21 = [FeatureLayer layer];
//        layer21.PolygonArea = fa21;
        
        PolygonArea *fa22 = [[PolygonArea alloc]initWithCoordinate:@"1068,1308,1066,1430,932,1426"  scale: H_RealToMapScale];
//        FeatureLayer *layer22 = [FeatureLayer layer];
//        layer22.PolygonArea = fa22;

        PolygonArea *fa23 = [[PolygonArea alloc]initWithCoordinate:@"764,1285,906,1284,906,1425,922,1429,924,1544,795,1544,795,1479,728,1474,726,1444"  scale: H_RealToMapScale];
        //FeatureLayer *layer23 = [FeatureLayer layer];
        //layer23.PolygonArea = fa23;
        
        PolygonArea *fa24 = [[PolygonArea alloc]initWithCoordinate:@"229,917,580,914,579,1046,232,1047"  scale: H_RealToMapScale];
        //FeatureLayer *layer24 = [FeatureLayer layer];
        //layer24.PolygonArea = fa24;

        
             
        [self.areaArray addObjectsFromArray:@[fa1,fa2,fa3,fa4,fa5,fa6,fa7,fa8,fa9,fa10,fa11,fa12,fa13,fa14,fa15,fa16,fa17,fa18,fa19,fa20,fa21,fa22,fa23,fa24]];
    }
    return _areaArray;
}


- (NSMutableArray *)fAreaModels{
    if (!_fAreaModels) {
        _fAreaModels = [NSMutableArray array];
        
        for (PolygonArea *area in self.areaArray) {
            FeatureAreaModel *areaModel = [[FeatureAreaModel alloc]init];
            areaModel.area = area;
            
            [_fAreaModels addObject:areaModel];
        }
        
    }
    return _fAreaModels;
}

- (NSArray *)fAreaModelsWithPath:(NSString *)path{
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *array =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"++++++++ %@",array);
    NSLog(@"%@",error);
    NSMutableArray *marry = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        NSString *codders = dic[@"coordinates"];
        NSString *ID = dic[@"ID"];
        NSString *name  =dic[@"displayName"];
        
         PolygonArea *area = [[PolygonArea alloc]initWithCoordinate:codders  scale: 1.0];
        
        FeatureAreaModel *areaModel = [[FeatureAreaModel alloc]init];
        areaModel.area = area;
       
        
     FeatureModel* featureModel = [[FeatureModel alloc]init];
        featureModel.ID = [ID integerValue];
        featureModel.name = name;
        featureModel.identify = [NSString stringWithFormat:@"XD%ld",featureModel.ID];
        featureModel.flagImageName = featureModel.name;
        featureModel.backGroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
        FeatureFrameModel *frameModel = [[FeatureFrameModel alloc]init];
        frameModel.frame = area.limitFrame;
        frameModel.featureID = featureModel.ID;
        featureModel.frameModel = frameModel;

        areaModel.featureModel = featureModel;
        [marry addObject:areaModel];
        
    }
    return [marry copy];
}/*
  
  
  {
  "ID" : 0,
  "coordinates" : "260.483,99.200,303.683,99.100,303.683,95.700,309.183,95.550,309.283,74.150,244.433,74.050,244.333,81.100,<228.598857,111.385533,-1.090287,-0.366097,34.040272<"
  }
  
  
  */
@end
