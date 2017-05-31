//
//  GCButton.m
//  DTMachine7
//
//  Created by gao on 16/6/15.
//  Copyright © 2016年 上海你我信息有限公司. All rights reserved.
//

#import "GCButton.h"
@interface GCButton()
@property (nonatomic ,assign) GCButtonType buttonTypeGC;
@end
@implementation GCButton
+ (instancetype)buttonWithFrame:(CGRect)frame{
    return [[self alloc]initWithButtonType:GCButtonTypeBottom frame:frame];
}
+ (instancetype)buttonWithType:(GCButtonType)buttonType frame:(CGRect)frame{
    
    return [[self alloc]initWithButtonType:buttonType frame:frame];
}
- (instancetype)initWithButtonType:(GCButtonType)buttonType frame:(CGRect)frame{
    if (self = [super init]) {
        self.buttonTypeGC = buttonType;
        self.frame = frame;
        //self.adjustsImageWhenHighlighted = NO;
        if (buttonType == GCButtonTypeTop || buttonType == GCButtonTypeBottom) {
            self.titleLabel.textAlignment= NSTextAlignmentCenter;
        }
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
   return [self titleRect];
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return [self imageRect];
}

- (CGRect)titleRect{
    CGRect titleRect = CGRectZero;
    
    CGFloat image_H = self.imageSize.height;
    CGFloat image_W = self.imageSize.width;
    
    CGFloat title_W = self.titleSize.width;
    CGFloat title_H = self.titleSize.height;
    CGFloat title_X = 0.0;
    CGFloat title_Y = 0.0;
    CGFloat contentWidth = self.frame.size.width;
    CGFloat contentHeight = self.frame.size.height;

    switch (self.buttonTypeGC) {
        case GCButtonTypeTop:
        {
            title_X = (contentWidth - title_W) *0.5;
            title_Y = (contentHeight - image_H - title_H - self.betweenSpace) * 0.5;
            
        }
            break;
        case GCButtonTypeBottom:
        {
            title_X = (contentWidth - title_W) *0.5;
            title_Y = contentHeight - (contentHeight - image_H - title_H - self.betweenSpace) * 0.5 - title_H;

        }
            break;

        case GCButtonTypeLeft:
        {
            title_Y = (contentHeight - title_H) *0.5;
            title_X = (contentWidth - image_W - title_W - self.betweenSpace) * 0.5;
            
        }
            break;

        case GCButtonTypeRight:
        {
            title_Y = (contentHeight - title_H) *0.5;
            title_X = contentWidth - (contentWidth - image_W - title_W - self.betweenSpace) * 0.5 - title_W;
        }
            break;
            
        default:
        {
            title_X = (contentWidth - title_W) *0.5;
            title_Y = contentHeight - (contentHeight - image_H - title_H - self.betweenSpace) * 0.5 - title_H;
            
        }
            break;
        
    }
    
    titleRect = CGRectMake(title_X, title_Y, title_W, title_H);
    return titleRect;
}
- (CGRect)imageRect{
    CGRect imageRect = CGRectZero;
    CGFloat title_H = self.titleSize.height;
    CGFloat title_W = self.titleSize.width;
    
    CGFloat image_W = self.imageSize.width;
    CGFloat image_H = self.imageSize.height;
    CGFloat image_X = 0.0;
    CGFloat image_Y = 0.0;
    CGFloat contentWidth = self.frame.size.width;
    CGFloat contentHeight = self.frame.size.height;

    switch (self.buttonTypeGC) {
        case GCButtonTypeTop:
        {
            image_X = (contentWidth - image_W) *0.5;
            image_Y = contentHeight - (contentHeight - image_H - title_H - self.betweenSpace) * 0.5 - image_H;
        }
            break;
        case GCButtonTypeBottom:
        {
            image_X = (contentWidth - image_W) *0.5;
            image_Y = (contentHeight - image_H - title_H - self.betweenSpace) * 0.5;
        }
            break;
            
        case GCButtonTypeLeft:
        {
            image_Y = (contentHeight - image_H) *0.5;
            image_X = contentWidth - (contentWidth - image_W - title_W - self.betweenSpace) * 0.5 - image_W;

        }
            break;
            
        case GCButtonTypeRight:
        {
            image_Y = (contentHeight - image_H) *0.5;
            image_X = (contentWidth - image_W - title_W - self.betweenSpace) * 0.5 ;
        }
            break;
            
        default:
        {//默认lable在下
            image_X = (contentWidth - image_W) *0.5;
            image_Y = (contentHeight - image_H - title_H - self.betweenSpace) * 0.5;
        }
            break;
    }
    
    imageRect = CGRectMake(image_X, image_Y, image_W, image_H);
    return imageRect;
}
@end
