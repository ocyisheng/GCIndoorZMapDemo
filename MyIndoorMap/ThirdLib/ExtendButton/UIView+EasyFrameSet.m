//
//  UIView+EasyFrameSet.m
//  sdk2.0zhengquandasha
//
//  Created by Choi on 15/12/29.
//  Copyright © 2015年 palmaplus. All rights reserved.
//

#import "UIView+EasyFrameSet.h"

@implementation UIView (EasyFrameSet)

#pragma mark- GET
-(CGFloat)x{
    return self.frame.origin.x;

}

-(CGFloat)y{
    return self.frame.origin.y;
}

-(CGFloat)width{
    return self.bounds.size.width;
}

-(CGFloat)height{
    return self.bounds.size.height;
}

-(CGPoint)origin{
    return CGPointMake(self.x, self.y);
}

-(CGSize)size{
    return CGSizeMake(self.width, self.height);
}

#pragma mark- SET
-(void)setX:(CGFloat)x{
    self.frame = CGRectMake(x,self.y, self.width, self.height);
}

-(void)setY:(CGFloat)y{
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}


-(void)setWidth:(CGFloat)width{
    self.frame = CGRectMake(self.x, self.y,width, self.height);
}

-(void)setHeight:(CGFloat)height{
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

-(void)setOrigin:(CGPoint)origin{
    self.frame = CGRectMake(origin.x, origin.y, self.width, self.height);
}

-(void)setSize:(CGSize)size{
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}


@end
