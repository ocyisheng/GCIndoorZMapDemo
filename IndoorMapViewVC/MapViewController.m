//
//  MapViewController.m
//  MyGCIndoorMap
//
//  Created by gao on 16/9/1.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "MapViewController.h"
#import "GCIndoorMap.h"

#import "GCChoiceButton.h"
#import "LocationButtonView.h"
#import "ZoomButton.h"

#import "TouchPopView.h"
#import "XDTestData.h"


#define PATHNAME @"NavigateLinesWeight-08-18-18-13"//featurePoints
#define TestStartPoint CGPointMake(273, 85)

static BOOL  isTestLocation = NO;

@interface MapViewController ()
<MapViewDelegate,GCChoiceButtonClickDelegate,LocationButtonViewClickDelegate,ZoomButtonClickDelegate,TouchPopViewClickDelegate>

{
    PinAnnotationView *lastPin;
    CGPoint startAndEnd[2];
    BOOL haveTouchPinView;
}

@property (nonatomic ,strong) GCChoiceButton *choiceButton;
@property (nonatomic ,strong) LocationButtonView *locationButton;
@property (nonatomic ,strong) ZoomButton *zoomButton;
@property (nonatomic ,strong) TouchPopView *bottomPopView;


@property (nonatomic ,strong) XDTestData *testData;
@property (nonatomic ,strong) MapView  *mapView;
@property (nonatomic ,strong) NavigateManager *navigateManager;


@property (nonatomic ,strong) FlagView *startPin;
@property (nonatomic ,strong) BrokenLine *roadLine;

@property (nonatomic ,strong) PinAnnotationView *touchPinView;

/*
 // 根据地理位置 找 临近feature 的判断方法
 point -> Feature(临近)
 */


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加地图
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.choiceButton];
    [self.view addSubview:self.locationButton];
    [self.view  addSubview:self.zoomButton];
    
    [self.view addSubview:self.bottomPopView];
    
   
    
    NSString *path = [[NSBundle mainBundle] pathForResource:PATHNAME ofType:@"json"];
    [self.mapView updateDataWithData:[self.testData fAreaModelsWithPath:path]];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - MapViewDelegate -
- (void)mapViewWillBeginRotating:(MapView *)mapView{
    NSLog(@"开始旋转");
}
- (void)mapViewDidRotating:(MapView *)mapView currentRotation:(CGFloat)currentRotation{
    NSLog(@"正在旋转,currentRotation:%f",currentRotation);
}
- (void)mapViewDidEndRotating:(MapView *)mapView{
    NSLog(@"停止旋转");
}

- (void)mapViewWillBeginZooming:(MapView *)mapView{
    NSLog(@"开始缩放");
}

- (void)mapViewDidZoom:(MapView *)mapView currentScale:(CGFloat)currentScale{
    NSLog(@"正在缩放,currentScale:%f",currentScale);
}

- (void)mapViewDidEndZooming:(MapView *)mapView{
    NSLog(@"停止缩放");
}

- (void)mapViewWillBeginMoving:(MapView *)mapView{
    NSLog(@"开始移动");
    
    if (!haveTouchPinView) {
        [self.locationButton backFirstImageView];
        [self updateLocationButtonAndZoomButtonWithTouchPopView:NO];
    }
    
}
- (void)mapViewDidMoving:(MapView *)mapView translation:(CGPoint)translation{
    NSLog(@"正在移动，translation:%@",NSStringFromCGPoint(translation));
}

- (void)mapViewDidEndMoving:(MapView *)mapView{
    NSLog(@"停止移动");
}
- (void)mapView:(MapView *)mapview didTapAtPoint:(CGPoint)point featureID:(NSUInteger)featureID{
    //如果有featureID 的话弹出，没有的话缩回
    if (featureID) {
        
        //1.刷新界面布局
        [self updateLocationButtonAndZoomButtonWithTouchPopView:YES];
        
        //2.添加标记
        self.touchPinView.animateDrop = NO;
        [self addPinViewWithID:featureID point:point];
        
        //3.记录结束点
        startAndEnd[1] = point;
        
        //4.给bottomPopView添加简介信息
        [self updateBottomPopViewContentWithFeatureID:featureID];
        
    }else{
        [self updateLocationButtonAndZoomButtonWithTouchPopView:NO];
        [self.locationButton backFirstImageView];
        [self.mapView clearPoint:lastPin];
    }
    
    
    
}

- (void)mapView:(MapView *)mapview didLongPressedAtPoint:(CGPoint)point featureID:(NSUInteger)featureID{
     //1.刷新界面布局
    [self updateLocationButtonAndZoomButtonWithTouchPopView:YES];
    
    //2.添加标记
        //长按时添加动画
    self.touchPinView.animateDrop = YES;
    [self addPinViewWithID:featureID point:point];
    
    //3.记录结束点
    startAndEnd[1] = point;
    
    //4.给bottomPopView添加简介信息
    [self updateBottomPopViewContentWithFeatureID:featureID];

}

- (void)mapView:(MapView *)mapview didTouchedPinView:(PinAnnotationView *)pinView{
    
}
#pragma mark - LocationButtonViewClickDelegate -
- (void)clickLocationButton:(UIButton *)button index:(NSUInteger)index{
    
    switch (index) {
        case 1:
        {
            //激活罗盘；
            [self.mapView startUpdateCompassHeading];
            
            //放大
            [self.mapView setCurrenZoomScale:3.0 animated:YES];
            
             [self.mapView setShowCenter:TestStartPoint animated:YES];
        }
            break;
        case 2:
        {
            //停止罗盘；
            [self.mapView stopUpdateCompassHeading];
            
            //放大
            [self.mapView setCurrenZoomScale:2.0 animated:YES];
            
             [self.mapView setShowCenter:TestStartPoint animated:YES];
        }
            break;
            
        default:
        {
            //调用定位方法，实现定位（手动定位）
            //标记当前，将中心移到当前
            CGFloat duration;
            if (!isTestLocation) {
                [self.locationButton startActivityAnimation];
                duration = 2.0;
            }else{
                duration = 0.03;
            }
            
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //添加开始标记
                [self startPin];
                //居中
                [self.mapView setShowCenter:TestStartPoint animated:YES];
                //停止菊花
                if (!isTestLocation) {
                    [self.locationButton stopActivityAnimation];
                    
                }
                isTestLocation = YES;
                //记录开始点
                startAndEnd[0] = TestStartPoint;
                
                [self updateLocationButtonAndZoomButtonWithTouchPopView:YES];
                //point ----> id (near)
                /*
                 1.当该 point在feature上时
                 2.point 在feature附近
                 
                 
                 */
                
               // [self updateBottomPopViewContentWithFeatureID:<#(NSUInteger)#>]
                
            });

        }
            break;
    }
}
#pragma mark - GCChoiceButtonClickDelegate -
- (void)clickChoiceButton:(UIButton *)button index:(NSUInteger)index{
    
    switch (index) {
        case 0:
        {
            //附近
            
        }
            break;
        case 1:
        {
            //路线
            
        }
            break;
            
        default:
        {
            //我的
            
        }
            break;
    }

}

#pragma mark - ZoomButtonClickDelegate -

- (void)zoomButtonClick:(UIButton *)button index:(NSUInteger)index{
    
    if (index == 0) {
        [self.mapView setCurrentDxZoomScale:1.0 animated:YES];
    }else{
        [self.mapView setCurrentDxZoomScale:-1.0 animated:YES];
    }
}


#pragma mark - TouchPopViewClickDelegate -

- (void)clickTouchPopViewDetailButton:(TouchPopView *)popView{
    
}
- (void)clickTouchPopViewBottomChoiceButton:(UIButton *)button index:(NSUInteger)index{
    switch (index) {
        case 0:
        {
            //搜周边
            
        }
            break;
        case 1:
        {
            //去这里
            [SVProgressHUD showWithStatus:@"正在计算导航路径"];
            __block NSString * warn;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
#ifdef FUNC1
#warning 这是第一种路径规划方式
                [self.navigateManager startPoint:startAndEnd[0] endPoint:startAndEnd[1] complete:^(NSArray *resultPoints) {
                    warn = @"导航路径加载成功";
                    if (resultPoints.count == 0) {
                        warn = @"未查寻到路径";
                    }
                    self.roadLine.pointArray = resultPoints;
                    self.navigateManager = nil;
                }];
#else
#warning 这是第二种路径规划方式
                [self.navigateManager start:startAndEnd[0] end:startAndEnd[1] completeDijkstra:^(NSArray *resultPoints) {
                    warn = @"导航路径加载成功";
                    if (resultPoints.count == 0) {
                        warn = @"未查寻到路径";
                    }
                    self.roadLine.pointArray = resultPoints;
                    self.navigateManager = nil;
                    
                }];
#endif
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mapView addBrokenLine:self.roadLine];
                    [SVProgressHUD showSuccessWithStatus:warn];
                });
                
                
            });

            
        }
            break;
            
        default:
        {
            //开导航
            
            
        }
            break;
    }
    
}
#pragma mark - private func -

- (void)updateBottomPopViewContentWithFeatureID:(NSUInteger)featureID{
    
    FeatureModel * model =  [MapFeatureConfig searchFeatureModelWithID:featureID];
    [self.bottomPopView updateStoreName:model.name address:[NSString stringWithFormat:@"%@ | %@ | %ld",model.name,model.identify,model.ID]];
    
}
- (void)addPinViewWithID:(NSUInteger)ID point:(CGPoint)point{
    haveTouchPinView = YES;
    
    [self.locationButton backFirstImageView];
    [self.mapView clearPoint:lastPin];
    
    self.touchPinView.currentFeatureID = ID;
    [self.mapView addFlagView:self.touchPinView point:point];
    
    lastPin = self.touchPinView;
    
}
- (void)updateLocationButtonAndZoomButtonWithTouchPopView:(BOOL)isTouchPopView{
    
    if (!isTouchPopView) {
      [self.mapView clearLines];
    }
    
    
    self.bottomPopView.hidden = !isTouchPopView;
    self.choiceButton.hidden = isTouchPopView;
    
    CGFloat location_W = 44.0;
    CGFloat location_H = 44.0;
    CGFloat location_X = 8.0;
    CGFloat location_Y;
    if (isTouchPopView) {
        location_Y = CGRectGetMinY(self.bottomPopView.frame) - location_H - 8.0;
    }else{
        location_Y = CGRectGetMinY(self.choiceButton.frame) - location_H - 8.0;
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        self.locationButton.frame = CGRectMake(location_X, location_Y, location_W, location_H);
    }];
    
    CGFloat zoom_W = CGRectGetWidth(self.locationButton.frame);
    CGFloat zoom_H = CGRectGetHeight(self.locationButton.frame)*2 + 2.0;
    CGFloat zoom_X = CGRectGetWidth(self.view.frame) - CGRectGetMinX(self.locationButton.frame) - zoom_W;
    CGFloat zoom_Y = CGRectGetMaxY(self.locationButton.frame)- zoom_H;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.zoomButton.frame = CGRectMake(zoom_X, zoom_Y, zoom_W, zoom_H);
    }];
    
    
}

#pragma mark - getter func -

- (TouchPopView *)bottomPopView{
    if (!_bottomPopView) {
        _bottomPopView = [[TouchPopView alloc]initWithFrame:CGRectMake(0,[self sheight] - 99, [self swidth], 99)];
        _bottomPopView.backgroundColor = [UIColor whiteColor];
        _bottomPopView.clickDelegate = self;
        _bottomPopView.hidden = YES;
    }
    return _bottomPopView;
}

- (ZoomButton *)zoomButton{
    if (!_zoomButton) {
        CGFloat zoom_W = CGRectGetWidth(self.locationButton.frame);
        CGFloat zoom_H = CGRectGetHeight(self.locationButton.frame)*2 + 2.0;
        CGFloat zoom_X = CGRectGetWidth(self.view.frame) - CGRectGetMinX(self.locationButton.frame) - zoom_W;
        CGFloat zoom_Y = CGRectGetMaxY(self.locationButton.frame)- zoom_H;
        _zoomButton = [[ZoomButton alloc]initWithFrame:CGRectMake(zoom_X, zoom_Y, zoom_W, zoom_H)];
         _zoomButton.backgroundColor = RGBColor(221, 221, 221);
        _zoomButton.clickDelegate = self;
    }
    return _zoomButton;
}
- (LocationButtonView *)locationButton{
    if (!_locationButton) {
        CGFloat location_W = 44.0;
        CGFloat location_H = 44.0;
        CGFloat location_X = 8.0;
        CGFloat location_Y = CGRectGetMinY(self.choiceButton.frame) - location_H - 8.0;
       
        _locationButton = [[LocationButtonView alloc]initWithFrame:CGRectMake(location_X, location_Y, location_W, location_H) imageNames:@[@"postiton_button",@"default_main_gpssearchbutton_image_normal",@"default_main_gpsrotatingbutton_image_normal"]];
        _locationButton.backgroundColor = RGBColor(221, 221, 221);
        _locationButton.clickDelegate = self;
    }
    return _locationButton;
}

- (GCChoiceButton *)choiceButton{
    if (!_choiceButton) {
        _choiceButton = [[GCChoiceButton alloc]initWithFrame:CGRectMake(0,[self sheight] - 44, [self swidth], 44) normalTitles:@[@"附近",@"路线",@"我的"]  imageNames:@[@"default_main_bottom_around_normal",@"default_main_bottom_route_normal",@"default_main_bottom_mine_normal"] titleSize:CGSizeMake(40, 30) imageSize:CGSizeMake(30, 30) betweenSpace:2];
        _choiceButton.normalTitleColor = [UIColor blackColor];
        _choiceButton.selectedTitleColor = RGBColor(29, 77, 136);//29 77 136
        _choiceButton.backgroundColor = RGBColor(221, 221, 221);
        _choiceButton.buttonFont = [UIFont systemFontOfSize:15.0];
        _choiceButton.clickDelegate = self;
    }
    return _choiceButton;
}
- (MapView *)mapView{
    if (!_mapView) {
        _mapView = [[MapView alloc]initWithFrame:CGRectMake(0, 0, [self swidth], [self sheight] - 44)];
        _mapView.delegate = self;
        _mapView.showCompass = YES;
    }
    return _mapView;
}


- (FlagView *)startPin{
    if (!_startPin) {
        _startPin = [[FlagView alloc]initWithFrame:CGRectMake(0, 0, 30.0, 30.0)];
        [self.mapView addFlagView:_startPin point:TestStartPoint];
        CGRect bounds = _startPin.bounds;
        UIImageView * pinImageView = [[UIImageView alloc]initWithFrame:CGRectMake(bounds.origin.x, bounds.origin.y - 15.0, bounds.size.width, bounds.size.height)];
        pinImageView.image = [UIImage imageNamed:@"定位起点.png"];
        [_startPin addSubview:pinImageView];

    }
    return _startPin;
}
- (PinAnnotationView *)touchPinView{
    if (!_touchPinView) {
        _touchPinView = [[PinAnnotationView alloc]init];
        _touchPinView.pinColor = PinAnnotationColorBlue;
        _touchPinView.canShowCallout = NO ;
        _touchPinView.animateDrop = NO;

    }
        return _touchPinView;
}
- (BrokenLine *)roadLine{
    if (!_roadLine) {
        _roadLine = [[BrokenLine alloc]initWithIdentify:@"FirstBrokenLineRode"];
        _roadLine.lineWidth = 2.5f;
        _roadLine.lineColor = [UIColor redColor];
    }
    return _roadLine;
}

- (NavigateManager *)navigateManager{
    if (!_navigateManager) {
        _navigateManager= [[NavigateManager alloc]init];
    }
    return _navigateManager;
}
- (XDTestData *)testData
{
    if (!_testData) {
        _testData = [[XDTestData alloc]init];
    }
    return _testData;
}

-(CGFloat)sheight{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    return height;
}
- (CGFloat)swidth{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    return width;
}
@end
