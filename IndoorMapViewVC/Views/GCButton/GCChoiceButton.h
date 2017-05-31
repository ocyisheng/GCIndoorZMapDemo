//
//  GCChoiceButton.h
//  DataForDrowMap
//
//  Created by gao on 16/8/2.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCButton.h"
@class GCChoiceButton;
@protocol GCChoiceButtonClickDelegate <NSObject>
@optional

- (void)clickChoiceButton:(UIButton *)button index:(NSUInteger )index;

@end
@interface GCChoiceButton : UIView
- (instancetype)initWithFrame:(CGRect)frame normalTitles:(NSArray *)normalTiles imageNames:(NSArray *)imageNames titleSize:(CGSize)titleSize imageSize:(CGSize)imageSize betweenSpace:(CGFloat)betweenSpace;

@property (nonatomic ,strong) UIColor *buttonBackgroundColor;

@property (nonatomic ,strong) UIFont *buttonFont;

@property (nonatomic ,strong) UIColor *normalTitleColor;

@property (nonatomic ,strong) UIColor *selectedTitleColor;

@property (nonatomic ,weak) id<GCChoiceButtonClickDelegate> clickDelegate;


@end
