//
//  NavigateManager.m
//  ScrollViewScale
//
//  Created by gao on 16/7/4.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "NavigateManager.h"
#import "FloorModel.h"
#import "PathFinding+PointConvert.h"
#import "Helper.h"
#import "MapFeatureConfig.h"


#import "MJDijkstra.h"
#define SW   1
#define SH   1


#define NEW 1
@interface NavigateManager()

@property (nonatomic ,strong) FloorModel *floorModel;



@property (nonatomic ,strong) PathFinding *pathFind;
@property (nonatomic ,strong) NSMutableArray *unPassPoints;
@property (nonatomic ,strong) NSArray *resultPoints;

@property (nonatomic ,copy) ResultPointsBlock resultPointsBlock;



@property (nonatomic ,strong) NSMutableDictionary *namePointDic;

@property (nonatomic ,strong) NSDictionary *pathFindDicData;



@end

@implementation NavigateManager
- (instancetype)init
{
    self = [super init];
    if (self) {
#warning 这里加载的是当前显示的Map，获取的是当前不可通过点
//        if (NEW) {
//            [self prepareNavigateData];
//        }else{
//           self.unPassPoints = [[MapFeatureConfig unPassPointForNavigate] mutableCopy];
//        }
        
    }
    return self;
}
- (instancetype)initWithFloorModel:(FloorModel *)floorModel
{
    self = [super init];
    if (self) {
        self.floorModel = floorModel;
}
    return self;
}
#pragma mark - public func -
- (void)startPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint complete:(ResultPointsBlock)completeBlock{
    
     self.unPassPoints = [[MapFeatureConfig unPassPointForNavigate] mutableCopy];
    
    [self startPoint:startPoint endPoint:endPoint];
    if (completeBlock) {
        self.resultPointsBlock = completeBlock;
    }
    [self searchMinShortRode];
}


- (void)startPoint:(CGPoint )startPoint endPoint:(CGPoint )endPoint{
    NSLog(@"%@ , %@",NSStringFromCGPoint(startPoint),NSStringFromCGPoint(endPoint));
    CGPoint start =  [self.pathFind convertPoint:startPoint pointOffset:CGPointZero];
    CGPoint end =  [self.pathFind convertPoint:endPoint pointOffset:CGPointZero];
    NSLog(@"%@ , %@",NSStringFromCGPoint(start),NSStringFromCGPoint(end));

    NSLog(@"startx =%f start.y=%f end.x=%f end.y=%f ",start.x,start.y,end.x,end.y);
    
    CGFloat sx = [Helper getInter:start.x /self.pathFind.tileSize.width];
    CGFloat sy = [Helper getInter:start.y /self.pathFind.tileSize.height];
    start = CGPointMake(sx, sy);
    
    CGFloat ex = [Helper getInter:end.x /self.pathFind.tileSize.width];
    CGFloat ey = [Helper getInter:end.y /self.pathFind.tileSize.height];
    end = CGPointMake(ex, ey);
    
    self.pathFind.endPoint = end;
    self.pathFind.startPoint = start;
}
- (void)searchMinShortRode{
   
    [self.pathFind addBlockTilePositions:[self.pathFind convertWallPoints:[self.unPassPoints copy] pointOffset:CGPointZero]];
    if (self.unPassPoints.count == 0) {
        return ;
    }
    //提取搜索结果
    self.resultPoints  = [self.pathFind convertResultPoints:[self.pathFind findPathing:PathfindingAlgorithm_BreadthFirstSearch IsConvertToOriginCoords:YES] pointOffset:CGPointMake(0, 0)];
    NSLog(@"++++++++++++++++++++ %@",self.resultPoints);
    self.resultPoints =  [self searchCornerPoints:self.resultPoints];
    NSLog(@"----------------- %@",self.resultPoints);
    //搜寻结束，使用block传递搜索结果
    if (self.resultPointsBlock) {
        self.resultPointsBlock(self.resultPoints);
        self.pathFind = nil;

    }
    
}
- (NSArray *)searchCornerPoints:(NSArray *)points{
    __block NSMutableArray *marray = [NSMutableArray array];
    __block BOOL markX = NO;
    __block BOOL markY = NO;
    __block CGPoint beforePoint ;
    [points enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSValue *pointValue = obj;
        if (idx== 0 || idx == points.count - 1) {
            //添加 第一个和最后一个
            [marray addObject:pointValue];
        }else{
            CGPoint lastPoint = [[marray lastObject] CGPointValue];
            CGPoint point = [pointValue CGPointValue];
            
            CGFloat dx = point.x - lastPoint.x;
            CGFloat dy = point.y - lastPoint.y;
            dx = dx >0 ? dx : -dx;
            dy = dy >0 ? dy : -dy;
#warning 在这里实现路线的修正,偏移等操作！！！
            markX = point.x == lastPoint.x ? YES : NO;
            markY = point.y == lastPoint.y ? YES : NO;
            
            if (!markX && !markY ) {//&& dy > 1 && dx > 1
                [marray addObject:[NSValue valueWithCGPoint:beforePoint]];
            }
            beforePoint = point;
        }
    }];
    return [marray copy];
}


#pragma mark - setter func -

- (PathFinding *)pathFind{
    if (!_pathFind) {
        //应该是 map 的自带 sizi
#warning size 传值！！！！！！！！！！
        _pathFind = [[PathFinding alloc] initWithMapSize:[Helper readMapSize]
                                                tileSize:CGSizeMake(SW,SH)
                                             coordsOrgin:CGPointZero];
        _pathFind.heuristicType = HeuristicTypeEuclidean;
        _pathFind.movementType = DiagonalMovement_Never;
    }
    return _pathFind;
}

#pragma mark - getter func -
- (NSArray *)resultPoints{
    if (!_resultPoints) {
        _resultPoints = [NSArray array];
    }
    return _resultPoints;
}



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)prepareNavigateData{
    
    //caches dictionary
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesDir = [paths objectAtIndex:0];
    //将导航文件，写入caches中
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pointsScale" ofType:@"json"];
    //使用json数据加载界面
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    NSLog(@"解析前的资源:: %@",array);
    NSLog(@"%@",error);
    NSMutableDictionary *mdic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in array) {
        NSString *coordinates = dic[@"coordinates"];
        //NSString *ID = dic[@"ID"];//coordinatesScale
        NSString *coordinatesScale = dic[@"coordinatesScale"];
        NSString *displayeName = dic[@"displayName"];
#warning 坐标除以10
        NSArray *parray = [coordinates componentsSeparatedByString:@","];
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake([parray[0] floatValue] , [parray[1] floatValue])];
        [self.namePointDic setValue:pointValue forKey:displayeName];//"AN+50.335,Ac+16.414,G+32.142,D+34.069"
        
        NSArray *scaleArray =[coordinatesScale componentsSeparatedByString:@","];
        
        
           NSMutableDictionary *msdic = [NSMutableDictionary dictionary];
        for (NSString *scalstring in scaleArray) {
            NSArray *sn = [scalstring componentsSeparatedByString:@"+"];
            
            NSString *n = sn[0];
            NSString *scale = sn[1];
            
            [msdic setValue:@([scale floatValue]) forKey:n ];
        }
        
        
        [mdic setValue:[msdic copy] forKey:displayeName];
    }
    
    _pathFindDicData = [mdic copy];
    NSLog(@"解析后的资源:%@",_pathFindDicData);

}

- (void)start:(CGPoint )start end:(CGPoint)end  completeDijkstra:(ResultPointsBlock)completeBlock{
    
      [self prepareNavigateData];
    
    if (completeBlock) {
        self.resultPointsBlock = completeBlock;
    }
    
    NSString *startString = [self searchNearNameWith:start];
    NSString *endString = [self searchNearNameWith:end];
    
    NSArray *path = MJShortestPath(_pathFindDicData, startString, endString);
    
    
    NSMutableArray *pointArray = [NSMutableArray array];
    [pointArray addObject:[NSValue valueWithCGPoint:start]];
    for (NSString *name in path) {
        NSValue *pointValue = self.namePointDic[name];
        
        [pointArray addObject:pointValue];
    }
      [pointArray addObject:[NSValue valueWithCGPoint:end]];
    NSLog(@"搜寻结果:%@",pointArray);
    if (self.resultPointsBlock) {
        self.resultPointsBlock([pointArray copy]);
    }
    
    
}
- (NSString *)searchNearNameWith:(CGPoint)point{
    //找出最临近的作为起点或终点
    NSString *minName = @"";
    CGFloat lastxy = 1000000.0;
    for (NSString *name in self.namePointDic) {
        NSValue *pointValue = self.namePointDic[name];
        CGPoint cPoint = [pointValue CGPointValue];
       
        CGFloat dx = cPoint.x - point.x;
        CGFloat dy = cPoint.y - point.y;
        
        CGFloat xy2 = dx * dx + dy * dy;
        
        if (xy2 < lastxy) {
            lastxy = xy2;
            
            minName = name;
        }
        

    }
    return minName;
   
}

- (NSMutableDictionary *)namePointDic{
    if (!_namePointDic) {
        _namePointDic = [NSMutableDictionary dictionary];
    }
    return _namePointDic;
}
@end
