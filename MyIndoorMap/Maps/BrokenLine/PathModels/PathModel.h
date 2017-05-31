//
//  PathModel.h
//  ScrollViewScale
//
//  Created by gao on 16/7/27.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#import "BaseModel.h" 
#import "ArcModel.h"
#import "LineModel.h"
@interface PathModel : BaseModel


@property (nonatomic ,strong) LineModel *line;


@property (nonatomic ,strong) ArcModel *arc;


@end
