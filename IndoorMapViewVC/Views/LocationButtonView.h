//
//  LocationButtonView.h
//  IndoorMapViewVC
//
//  Created by gao on 16/9/2.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocationButtonView;
@protocol LocationButtonViewClickDelegate <NSObject>

@optional
- (void)clickLocationButton:(UIButton *)button index:(NSUInteger )index;

@end
@interface LocationButtonView : UIView
-(instancetype)initWithFrame:(CGRect)frame imageNames:(NSArray *)imageNames;

@property (nonatomic ,weak) id<LocationButtonViewClickDelegate> clickDelegate;
- (void)backFirstImageView;
- (void)startActivityAnimation;
- (void)stopActivityAnimation;
@end
