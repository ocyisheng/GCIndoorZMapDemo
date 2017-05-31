//
//  ZoomButton.h
//  IndoorMapViewVC
//
//  Created by gao on 16/9/5.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZoomButton;


@protocol ZoomButtonClickDelegate <NSObject>

- (void)zoomButtonClick:(UIButton *)button index:(NSUInteger)index;

@end
@interface ZoomButton : UIView
@property (nonatomic ,weak) id<ZoomButtonClickDelegate> clickDelegate;
@end
