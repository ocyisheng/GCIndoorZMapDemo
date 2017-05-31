//
//  TouchPopView.m
//  IndoorMapViewVC
//
//  Created by gao on 16/9/5.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "TouchPopView.h"

#import "GCChoiceButton.h"

#import "DetaiLableView.h"

@interface TouchPopView  ()<DetailViewClickDelegate,GCChoiceButtonClickDelegate>

@property (nonatomic ,strong) GCChoiceButton *bottomChoiceButton;

@property (nonatomic ,strong) DetaiLableView *detailView;




@end
@implementation TouchPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.detailView];
        [self addSubview:self.bottomChoiceButton];
    }
    return self;
}


- (void)updateStoreName:(NSString *)name address:(NSString *)address{
    self.detailView.address.text = address;
    self.detailView.storeName.text = name;
}

#pragma mark - GCChoiceButtonClickDelegate -

- (void)clickChoiceButton:(UIButton *)button index:(NSUInteger)index{
    if ([self.clickDelegate respondsToSelector:@selector(clickTouchPopViewBottomChoiceButton:index:)]) {
        [self.clickDelegate clickTouchPopViewBottomChoiceButton:button index:index];
    }
}
#pragma mark - DetailViewClickDelegate -
- (void)clickDetailViewButton:(UIButton *)button{
    if ([self.clickDelegate respondsToSelector:@selector(clickTouchPopViewDetailButton:)]) {
        [self.clickDelegate clickTouchPopViewDetailButton:self];
    }
}
#pragma mark - settter func -

- (GCChoiceButton *)bottomChoiceButton{
    if (!_bottomChoiceButton) {
        
        CGFloat choice_X = 0.0;
        CGFloat choice_Y = CGRectGetMaxY(self.detailView.frame);
        CGFloat choice_W = CGRectGetWidth(self.detailView.frame);
        CGFloat choice_H = CGRectGetHeight(self.detailView.frame) * 0.5;

        _bottomChoiceButton = [[GCChoiceButton alloc]initWithFrame:CGRectMake(choice_X, choice_Y, choice_W, choice_H) normalTitles:@[@"搜周边",@"去这里",@"开导航"] imageNames:@[@"default_generalsearch_tipsviewbtn_around_normal",@"default_generalsearch_headerviewbtn_routeicon_normal",@"default_generalsearch_tipsviewbtn_shortcut_normal"] titleSize:CGSizeMake(48, 24) imageSize:CGSizeMake(24, 24) betweenSpace:1.0];
        
        _bottomChoiceButton.normalTitleColor = [UIColor grayColor];
        _bottomChoiceButton.buttonFont = [UIFont systemFontOfSize:14.0];
        _bottomChoiceButton.clickDelegate = self;
        
    }
    return _bottomChoiceButton;
}

- (DetaiLableView *)detailView{
    if (!_detailView) {
        NSArray *views = [[NSBundle mainBundle]loadNibNamed:@"DetaiLableView" owner:nil options:nil];
        _detailView = [views lastObject];
        
        CGFloat detail_X = 0.0;
        CGFloat detail_Y = 0.0;
        CGFloat detail_W = CGRectGetWidth(self.bounds);
        CGFloat detail_H = CGRectGetHeight(self.bounds) / 3.0 * 2.0;
        
        _detailView.frame = CGRectMake(detail_X, detail_Y, detail_W, detail_H);
        _detailView.clickDelegate = self;
        
       
    }
    return _detailView;
}

@end
