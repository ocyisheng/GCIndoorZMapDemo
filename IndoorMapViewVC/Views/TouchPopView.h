//
//  TouchPopView.h
//  IndoorMapViewVC
//
//  Created by gao on 16/9/5.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TouchPopView;
@protocol TouchPopViewClickDelegate <NSObject>

@optional
- (void)clickTouchPopViewDetailButton:(TouchPopView *)popView;
- (void)clickTouchPopViewBottomChoiceButton:(UIButton *)button index:(NSUInteger)index;

@end
@interface TouchPopView : UIView

@property (nonatomic ,weak) id<TouchPopViewClickDelegate> clickDelegate;

- (void)updateStoreName:(NSString *)name address:(NSString *)address;
@end
