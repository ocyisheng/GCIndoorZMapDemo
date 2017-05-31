//
//  TestDataSource.m
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "TestDataSource.h"
#import "FeatureModel.h"
#import "FeatureFrameModel.h"
#import "FeatureView.h"

#define KH  [UIScreen mainScreen].bounds.size.height
#define KW  [UIScreen mainScreen].bounds.size.width
@implementation TestDataSource
- (FloorModel *)floorModel{
    if (!_floorModel) {
        _floorModel = [[FloorModel alloc]init];
        
        _floorModel.ID = 100000;
        _floorModel.number =@"B1";
               NSMutableArray *array = [NSMutableArray array];
        FeatureModel *model1 = [[FeatureModel alloc]init];
        model1.ID = 1;
        model1.name = @"门1";
        model1.unMoved = YES;
        model1.flagImageName = @"";
        model1.backGroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
        
        FeatureFrameModel *frame = [[FeatureFrameModel alloc]init];
        frame.featureID = model1.ID;
        frame.frame = CGRectMake(20, 30, 80, 40);
        frame.center = CGPointMake(40, 30);
        
        model1.frameModel = frame;
        
        [array addObject:model1];
        
        FeatureModel *model2 = [[FeatureModel alloc]init];
        model2.ID = 2;
        model2.name = @"门2";
        model2.unMoved = YES;
        model2.flagImageName = @"";
        model2.backGroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
        
        FeatureFrameModel *frame2 = [[FeatureFrameModel alloc]init];
        frame2.featureID = model2.ID;
        frame2.frame = CGRectMake(KW- 20 - 80, 30, 80 , 40);
        frame2.center = CGPointMake(40, 30);
        
        model2.frameModel = frame2;
        
        [array addObject:model2];
        
        FeatureModel *model3 = [[FeatureModel alloc]init];
        model3.ID = 3;
        model3.name = @"门3";
        model3.unMoved = YES;
        model3.flagImageName = @"";
        model3.backGroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
        
        FeatureFrameModel *frame3 = [[FeatureFrameModel alloc]init];
        frame3.featureID = model3.ID;
        frame3.frame = CGRectMake(20, KH - 30 - 40, 80, 40);
        frame3.center = CGPointMake(40, 30);
        
        model3.frameModel = frame3;
        
        [array addObject:model3];
        
        
        FeatureModel *model4 = [[FeatureModel alloc]init];
        model4.ID = 4;
        model4.name = @"门4";
        model4.unMoved = YES;
        model4.flagImageName = @"";
        model4.backGroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
        
        FeatureFrameModel *frame4 = [[FeatureFrameModel alloc]init];
        frame4.featureID = model4.ID;
        frame4.frame = CGRectMake(KW - 80 - 20, KH - 30 - 40, 80, 40);
        frame4.center = CGPointMake(40, 30);
        
        model4.frameModel = frame4;
        
        [array addObject:model4];
        
        
        FeatureModel *model5 = [[FeatureModel alloc]init];
        model5.ID = 5;
        model5.name = @"讲台";
        model5.unMoved = YES;
        model5.flagImageName = @"";
        model5.backGroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
        
        FeatureFrameModel *frame5 = [[FeatureFrameModel alloc]init];
        frame5.featureID = model5.ID;
        frame5.frame = CGRectMake( KW - 50 - 10, (KH -150) * 0.5, 50, 150);
        frame5.center = CGPointMake(40, 30);
        
        model5.frameModel = frame5;
        
        [array addObject:model5];
        
        for (int i = 0; i < 28; i ++) {
                FeatureModel *model6 = [[FeatureModel alloc]init];
                model6.ID = 6 + i;
                model6.name = [NSString stringWithFormat:@"学生小%d",i];
                model6.unMoved = YES;
                model6.flagImageName = [NSString stringWithFormat:@"学生小%d头像",i];
                model6.backGroundColor = [UIColor colorWithRed:arc4random()%255 / 255.0 green:arc4random()%255 / 255.0 blue:arc4random()%255 / 255.0 alpha:1];
        
                FeatureFrameModel *frame6 = [[FeatureFrameModel alloc]init];
                frame6.featureID = model6.ID;
                frame6.frame = CGRectMake(10 + (i % 4) * 60  , 80 + 50 *(i / 4) + 40, 40, 40);
                frame6.center = CGPointMake(40, 30);
                
                model6.frameModel = frame6;
                
                [array addObject:model6];
        }
        
        _floorModel.features = array;
    }
    return _floorModel;
}

//- (NSMutableArray *)featureLayes{
//    if (!_featureLayes) {
//        _featureLayes = [NSMutableArray array];
//        for (FeatureModel *model  in self.floorModel.features) {
//            FeatureView * layer = [[FeatureView alloc]init];
//            layer.featureModedl = model;
//            [_featureLayes addObject:layer];
//        }
//    }
//    return _featureLayes;
//}
@end
