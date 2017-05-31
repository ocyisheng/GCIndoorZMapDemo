//
//  DetaiLableView.h
//  IndoorMapViewVC
//
//  Created by gao on 16/9/5.
//  Copyright © 2016年 上海你我信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCButton/GCButton.h"

@protocol DetailViewClickDelegate <NSObject>

- (void)clickDetailViewButton:(UIButton *)button;

@end
@interface DetaiLableView : UIView
@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UIView *button;


@property (nonatomic ,strong) GCButton *rightButton;


@property (nonatomic ,weak) id<DetailViewClickDelegate> clickDelegate;
@end
