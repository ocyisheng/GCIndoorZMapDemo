//
//  GCChoiceButton.m
//  DataForDrowMap
//
//  Created by gao on 16/8/2.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import "GCChoiceButton.h"

#define SPACE 2.0
@interface GCChoiceButton(){
    CGSize _imageSize;
    CGSize _titleSize;
    CGFloat _betweenSpace;
}

@property (nonatomic ,strong) NSMutableArray *buttonArray;

@property (nonatomic ,strong) NSArray *normalTiles;

@property (nonatomic ,strong) NSArray *imageNames;

@property (nonatomic ,strong) NSArray *selectedTitles;


@end
@implementation GCChoiceButton
- (instancetype)initWithFrame:(CGRect)frame normalTitles:(NSArray *)normalTiles imageNames:(NSArray *)imageNames titleSize:(CGSize)titleSize imageSize:(CGSize)imageSize betweenSpace:(CGFloat)betweenSpace{
    if (self = [super initWithFrame:frame]) {
        _imageSize = imageSize;
        _titleSize = titleSize;
        _betweenSpace =betweenSpace;
        self.normalTiles = normalTiles;
        self.imageNames = imageNames;
    }
    return self;
}
- (void)buttonClick:(UIButton *)button{
    CGFloat x = CGRectGetMinX(button.frame);
   
    NSUInteger index = x / (CGRectGetWidth(button.frame) + SPACE);
    NSLog(@"GCChoiceButton index:%ld",index);
    if ([self.clickDelegate respondsToSelector:@selector(clickChoiceButton:index:)]) {
        [self.clickDelegate clickChoiceButton:button index:index];
    }
}
#pragma mark - setter func -
- (void)layoutSubviews{
    NSUInteger count = self.buttonArray.count;
   CGFloat butWidth = (self.bounds.size.width - (count +1) * SPACE ) / count;
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GCButton *button = obj;
        
        button.frame = CGRectMake(SPACE + (butWidth +SPACE) * idx, 0, butWidth, self.bounds.size.height);
        [self addSubview:button];
    }];
}
- (void)setNormalTiles:(NSArray *)normalTiles{
    _normalTiles = normalTiles;
    
    for (NSString *title in _normalTiles) {
        
        GCButton *button = [GCButton buttonWithType: GCButtonTypeRight frame:CGRectZero];
        button.titleSize = _titleSize;
        button.imageSize = _imageSize;
        button.betweenSpace = _betweenSpace;
        [button setTitle:title forState:UIControlStateNormal];
       
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.buttonArray addObject:button];
        
    }
    
    [self setNeedsLayout];
    
}

- (void)setSelectedTitles:(NSArray *)selectedTitles{
    _selectedTitles = selectedTitles;
   [_selectedTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GCButton *button = self.buttonArray[idx];
       [button setTitle:obj forState:UIControlStateSelected];
   }];
    
}
- (void)setImageNames:(NSArray *)imageNames{
    _imageNames = imageNames;
    [_imageNames enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
         GCButton *button = self.buttonArray[idx];
        [button setImage:[UIImage imageNamed:obj] forState:UIControlStateNormal];
    }];
    
}
- (void)setButtonFont:(UIFont *)buttonFont{
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GCButton *button = self.buttonArray[idx];
        button.titleLabel.font = buttonFont;
    }];
}
- (void)setButtonBackgroundColor:(UIColor *)buttonBackgroundColor{
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GCButton *button = self.buttonArray[idx];
        button.backgroundColor = buttonBackgroundColor;
    }];
}
- (void)setNormalTitleColor:(UIColor *)normalTitleColor{
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GCButton *button = self.buttonArray[idx];
        [button setTitleColor:normalTitleColor forState:UIControlStateNormal];
    }];
}
- (void)setSelectedTitleColor:(UIColor *)selectedTitleColor{
    [self.buttonArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GCButton *button = self.buttonArray[idx];
       [button setTitleColor:selectedTitleColor forState:UIControlStateHighlighted];
    }];
}
#pragma mark - getter func -

- (NSMutableArray *)buttonArray{
    if (!_buttonArray) {
        _buttonArray = [NSMutableArray array];
    }
    return _buttonArray;
}
@end
