//
//  Helper.m
//  ScrollViewScale
//
//  Created by gao on 16/7/14.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "Helper.h"
#import "DefinitionHeader.h"
@implementation Helper
+ (void)saveMapSize:(CGSize)mapSize{
    [[NSUserDefaults standardUserDefaults] setFloat:mapSize.width forKey:H_SaveMapWidth];
    [[NSUserDefaults standardUserDefaults] setFloat:mapSize.height forKey:H_SaveMapHeight];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

+ (CGSize)readMapSize{
    CGFloat width =  [[NSUserDefaults standardUserDefaults] floatForKey:H_SaveMapWidth];
    CGFloat height =[[NSUserDefaults standardUserDefaults] floatForKey:H_SaveMapHeight];
    return CGSizeMake(width, height);
}

+ (NSInteger)getInter:(CGFloat)num{
    return getInteger(num);
}


+(NSString *)currentDateString{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"MM-dd-HH-mm-ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    return locationString;
}

int  getInteger(float num) {
    bool r = 0;
    if (num >= 0) {
        num = num;
    }else{
        num = - num;
        r = 1;
    }
    float  temp = num ;
    int integer;
    while (temp- 1 >= 0)
    {
        temp--;
    }
    integer = num - temp;
    if (r) {
        integer = -integer;
    }
    NSLog(@"%f 的整数:%d 小数:%f",num,integer,temp);
    
    return integer;
}


@end
