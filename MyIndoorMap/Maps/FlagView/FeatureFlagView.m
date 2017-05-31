//
//  FeatureFlagView.m
//  ScrollViewScale
//
//  Created by gao on 16/7/22.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "FeatureFlagView.h"
@interface FeatureFlagView()

@property (nonatomic ,strong) UIImageView *flagImageView;

@property (nonatomic ,strong) UILabel *flagLable;

@end
@implementation FeatureFlagView



#pragma mark - setter func -
- (void)setName:(NSString *)name{
    _name = name;
    
    self.flagLable.text = name;
    
    
    [self.flagLable sizeToFit];
    
    [self addSubview:self.flagLable];
    
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;

    self.flagImageView.image = [UIImage imageNamed:imageName];
    
    [self addSubview:self.flagImageView];
    
}
#pragma mark -  getter func  -
- (UIImageView *)flagImageView{
    if (!_flagImageView) {
        _flagImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        _flagImageView.center = self.center;
    }
    return _flagImageView;
}

- (UILabel *)flagLable{
    if (!_flagLable) {
        _flagLable = [[UILabel alloc]initWithFrame:self.bounds];
        _flagLable.textAlignment = NSTextAlignmentCenter;
    }
    return _flagLable;
}
- (instancetype)init
{
#warning FeatureFlagView 默认大小 20，20
    return [[FeatureFlagView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
}
@end
