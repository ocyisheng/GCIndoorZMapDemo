//
//  MapFeatureConfig.m
//  ScrollViewScale
//
//  Created by gao on 16/7/15.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "MapFeatureConfig.h"
#import "Map.h"
#import "CoverView.h"
#import "PolygonArea.h"
#import "FeatureView.h"
#import "FeatureLayer.h"
#import "PolygonUnPassPoint.h"
#import "FeatureAreaModel.h"
#import "FeatureModel.h"



#import "ArcModel.h"
#import "LineModel.h"

@interface MapFeatureConfig ()
{
    CoverView           *coverView;
    Map                 *featureMap;
    NSArray             *points;
    FeatureAreaModel    *faModel;
}

@property (nonatomic ,strong) NSMutableArray *unPassPoints;
@property (nonatomic ,strong) NSMutableArray *areaArray;
@property (nonatomic ,strong) NSMutableArray *featureModelArray;


@end
@implementation MapFeatureConfig

+ (instancetype)shareInstance{
    static MapFeatureConfig * s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[MapFeatureConfig alloc]init];
    });
    return s_instance;
}
+ (FeatureModel *)searchFeatureModelWithIdentify:(NSString *)identify{
    
    return [[MapFeatureConfig shareInstance] searchWithIdentify:identify];;
}
+ (FeatureModel *)searchFeatureModelWithID:(NSUInteger )ID{
    
    return [[MapFeatureConfig shareInstance] searchWithID:ID];
}
+ (void)configMapFeaturesWithFeatureModelAreas:(NSArray<FeatureAreaModel *> *)featureAreaModels map:(Map *)map{
    [[MapFeatureConfig shareInstance] configMap:map withFeatureModelAreas:featureAreaModels];
}
+ (void)configMapFeaturesWithFeatureModelAreas:(NSArray<FeatureAreaModel *> *)featureAreaModels map:(Map *)map coverView:(CoverView *)cover{
    [[MapFeatureConfig shareInstance] configMap:map withFeatureModelAreas:featureAreaModels coverView:cover];
}
+ (NSArray *)unPassPointForNavigate{
    [[MapFeatureConfig shareInstance] unPassPointsPrivate];
    return [MapFeatureConfig shareInstance].unPassPoints;
}


#pragma mark - private func - 
/**
 *  获取当前Map所有的不可通过点
 */
- (void)unPassPointsPrivate{
    [self.unPassPoints removeAllObjects];
    self.unPassPoints = nil;
    for (PolygonArea *area in self.areaArray) {
        [self.unPassPoints addObjectsFromArray:[PolygonUnPassPoint unPassPointsWithArea:area]];
    }

}
- (void)configMap:(Map *)map withFeatureModelAreas:(NSArray<FeatureAreaModel *> *)featureAreaModels coverView:(CoverView *)cover{
    featureMap = map;
     coverView = cover;
    [featureAreaModels enumerateObjectsUsingBlock:^(FeatureAreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FeatureModel* fm = obj.featureModel;
        PolygonArea * area = obj.area;
     
        [self.areaArray addObject:area];
        [self.featureModelArray addObject:fm];
        
        FeatureView * fview = [[FeatureView alloc]initWithFrame:area.limitFrame];
        fview.identify = fm.identify;
        fview.ID = fm.ID;
        fview.hitDelegate = map;
        [map addSubview:fview];
#warning 颜色以及Model信息 或需其他类解决。。。。。
        FeatureLayer * flayer = [FeatureLayer layer];
        [fview setFeaturelayer:flayer];
      
        NSLog(@"______________%@",area.pathArray);
        [flayer drawContentLayerWithPath:[self maskPathOfFeatureLayer:flayer pathModelArray:area.pathArray]];
        [flayer drawContentLayerBackgroundColor:fm.backGroundColor];
        
        
#warning 关于此处预加载名称等，待修复！！！！！！ coverPoint
        fview.showName = fm.name;
         fview.priority = arc4random()%4;
        CGPoint cp = [coverView convertPoint:fview.center fromView:map];
        fview.showView.coverPoint = fview.center;
        [coverView addFlagView:fview.showView withPoint:cp];
    
        [fview updateSubViews];
       
        
    }];
    
    //将FeatureModels featureID的升序排列
    
    [self sortFeatureModels];
    

}
/**
 *  渲染地图
 *
 *  @param featureAreaModels 包含渲染的Model 和 信息Model
 */
- (void)configMap:(Map *)map withFeatureModelAreas:(NSArray<FeatureAreaModel *> *)featureAreaModels{
    featureMap = map;
    [featureAreaModels enumerateObjectsUsingBlock:^(FeatureAreaModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FeatureModel* fm = obj.featureModel;
        PolygonArea * area = obj.area;
        points = area.pathPoints;
        [self.areaArray addObject:area];
        [self.featureModelArray addObject:fm];
        FeatureView * fview = [[FeatureView alloc]initWithFrame:area.limitFrame];
        fview.identify = fm.identify;
        fview.ID = fm.ID;
        fview.hitDelegate = map;
        [map addSubview:fview];
#warning 颜色以及Model信息 或需其他类解决。。。。。
        FeatureLayer * flayer = [FeatureLayer layer];
        [fview setFeaturelayer:flayer];
        [flayer drawContentLayerWithPath:[self maskPathOfFeatureLayer:flayer]];
        
        
        [flayer drawContentLayerBackgroundColor:fm.backGroundColor];
    }];
    
    //将FeatureModels featureID的升序排列
    [self sortFeatureModels];

}

- (UIBezierPath *)maskPathOfFeatureLayer:(CALayer *)layer {
    UIBezierPath * path = [UIBezierPath bezierPath];
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [featureMap.layer convertPoint:[obj CGPointValue] toLayer:layer];
        if (idx == 0) {
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
        }
    }];
    [path closePath];
    return path;
}


- (UIBezierPath *)maskPathOfFeatureLayer:(CALayer *)layer pathModelArray:(NSArray *)pathModelArr{
    
   __block UIBezierPath * path = [UIBezierPath bezierPath];
   __block BOOL startDraw = YES;//起始点标记，标记开始点
    
        [pathModelArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
        if ([obj isKindOfClass:[ArcModel class]]) {
            ArcModel *am = obj;
            CGPoint center = [featureMap.layer convertPoint:am.center toLayer:layer];
            if (am.circle) {
                path = [UIBezierPath bezierPathWithArcCenter:center radius:am.radius startAngle:0 endAngle:2 * M_PI clockwise:YES];
            }else{
                [path addArcWithCenter:center radius:am.radius startAngle:am.startAngle endAngle:am.endAngle clockwise:YES];
            }
            
        }else if ([obj isKindOfClass:[LineModel class]]){
             LineModel *lm = obj;
            [lm.points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                CGPoint point = [featureMap.layer convertPoint:[obj CGPointValue] toLayer:layer];
                if (idx == 0 && startDraw ) {
                    [path moveToPoint:point];
                     startDraw = NO;
                }else{
                    [path addLineToPoint:point];
                }
           }];
            
        }
        
    }];
    [path closePath];
   
    return path;
}



- (FeatureModel *)searchWithIdentify:(NSString *)identify{
#warning 这里的数组可以使用 排序算法先排序再查找！！！
    __block FeatureModel *fm ;
  [self.featureModelArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
      fm = obj;
      if ([fm.identify isEqualToString:identify]) {
          *stop = YES;
      }
  }];
    return fm;
}

- (FeatureModel *)searchWithID:(NSUInteger)ID{
    //二分法查找
    NSUInteger high,low,len;
    len = self.featureModelArray.count;//已排序
    high = len - 1;//假设数组是从小到大排列的
    low = 0;
    NSUInteger midle = len/2;
    FeatureModel *fm;
    while (high >= low) {
       midle = (high + low)/2;
        fm = self.featureModelArray[midle];
        if (fm.ID == ID) {
            return fm;
        }
        if (fm.ID > ID) {
            high = midle -1;
        }else if (fm.ID < ID){
            low = midle + 1;
        }
    }
    
    return fm;
}
- (void)sortFeatureModels{
    //升序排序
    [self.featureModelArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        FeatureModel *m1 = obj1;
        FeatureModel *m2 = obj2;
        return m1.ID > m2.ID;
    }];
}
int binarysearch(int arr[],int len,int key)
{
    int high,low;
    high = len - 1;//假设数组是从小到大排列的
    low = 0;
    int midle = len/2;
    
    while(high >= low)
    {
        midle = (high + low)/2;
        
        if(arr[midle] == key)
            return midle;
        if(arr[midle] > key)
            high = midle - 1;         //前提是假设数组是从小到大排序，否则不确定是该加1还是减1
        else if(arr[midle] < key )
            low = midle + 1;
    }
    return (-1);
    
}
#pragma mark - getter func -
- (NSMutableArray *)unPassPoints{
    if (!_unPassPoints) {
        _unPassPoints = [NSMutableArray array];
    }
    return _unPassPoints;
    
}

- (NSMutableArray *)areaArray{
    if (!_areaArray) {
        _areaArray = [NSMutableArray array];
    }
    return _areaArray;
    
}
- (NSMutableArray *)featureModelArray{
    if (!_featureModelArray) {
        _featureModelArray = [NSMutableArray array];
    }
    return _featureModelArray;
    
}
@end
