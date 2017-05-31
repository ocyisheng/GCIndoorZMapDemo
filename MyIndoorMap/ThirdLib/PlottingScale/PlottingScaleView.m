//
//  PlottingScaleView.m
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/28.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import "PlottingScaleView.h"
#import <math.h>
@interface PlottingScaleView ()
@property (nonatomic,assign)CGSize titleSize;
@property (nonatomic,assign)CGFloat plottingWidth;
@property (nonatomic,assign)int realeTitle;
@property (nonatomic,strong)NSMutableArray *titleArr;
@property (nonatomic,assign)BOOL isFirst;
@end

@implementation PlottingScaleView


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        self.changeAbled = true;
        self.minUnit = 5;
        self.realeTitle = self.minUnit;
        self.plottingWidth = frame.size.width;
        self.backgroundColor = [UIColor clearColor];
        self.titleArr = [NSMutableArray arrayWithArray:@[@"1",@"2",@"5"]];
        self.isFirst = true;
    }
    return self;
}



-(void)setMinUnit:(int)minUnit{
    int temp[4] = {1,2,5,10};
    for (int i =0; i < sizeof(temp)/sizeof(temp[0]); i++) {
        if (minUnit < temp[i]) {
            break;
        }
        _minUnit = temp[i];
    }
    if (_minUnit < 1) {
        _minUnit = 1;
    }
    self.realeTitle = self.minUnit;
}
-(void)setPlottingDistance:(CGFloat)plottingDistance{
    if (_plottingDistance == plottingDistance) {
        return;
    }
    _plottingDistance = plottingDistance;
//    NSLog(@"width = %f,plotting = %f",self.bounds.size.width,plottingDistance);
    if (self.isFirst) {
        if (plottingDistance > self.bounds.size.width) {
            NSLog(@"minUnit给的太大,比例尺要显示的长度为:%f大于你所给的比例尺控件的宽度:%f",plottingDistance,self.bounds.size.width);
            assert(0);
        }
        self.isFirst = false;
    }
    if (plottingDistance > self.bounds.size.width) {
        NSLog(@"你应该把比例尺的宽度调宽一点,或者把单位长度设置小一些,因为你的单位长度的比例尺对应的屏幕坐标比比例尺的长度长");
    }
    
    self.plottingWidth = self.plottingDistance;
    self.realeTitle = self.minUnit;
    while (self.plottingWidth<self.bounds.size.width/3) {
        [self extendTitleArr:self.realeTitle];
        CGFloat tempF = self.plottingDistance/self.minUnit;
        NSInteger tempIndex = [self.titleArr indexOfObject:[NSString stringWithFormat:@"%d",self.realeTitle]];
        self.realeTitle = [self.titleArr[tempIndex + 1] intValue];
        self.plottingWidth = self.realeTitle * tempF;
    }
    
    
    [self setNeedsDisplay];
}

-(void)extendTitleArr:(int)title{
    while (1) {
        if (title >= [[self.titleArr lastObject] intValue]) {
            NSMutableArray *tempArr = [NSMutableArray arrayWithArray:self.titleArr];
            NSInteger temp = tempArr.count;
            for (int i = 3 ; i > 0; i --) {
                NSString *str = [NSString stringWithFormat:@"%d",[tempArr[temp - i] intValue] * 10];
                [self.titleArr addObject:str];
            }
        }else{
            break;
        }
    }
}

-(void)drawRect:(CGRect)rect{
        int temp = self.realeTitle/1000;
        CGFloat lineWith = 2.0;
        NSDictionary *titleDic = @{NSForegroundColorAttributeName:[UIColor blackColor],NSFontAttributeName:[UIFont systemFontOfSize:12]};
        NSString *strTitle = temp ? [NSString stringWithFormat:@"%d公里",temp]:[NSString stringWithFormat:@"%d米",self.realeTitle];
        self.titleSize = [strTitle sizeWithAttributes:titleDic];
        [strTitle drawAtPoint:CGPointMake((self.plottingWidth - self.titleSize.width)/2,(rect.size.height - self.titleSize.height)/2) withAttributes:titleDic];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
        CGContextSetLineWidth(context, lineWith);
        CGPoint points[4] = {
            CGPointMake(lineWith/2, rect.size.height * 0.8),
            CGPointMake(lineWith/2, rect.size.height - lineWith/2),
            CGPointMake(self.plottingWidth- lineWith/2, rect.size.height - lineWith/2),
            CGPointMake(self.plottingWidth - lineWith/2,rect.size.height * 0.8),
        };
        CGContextAddLines(context, points, sizeof(points)/sizeof(points[0]));
        CGContextStrokePath(context);
}

@end
