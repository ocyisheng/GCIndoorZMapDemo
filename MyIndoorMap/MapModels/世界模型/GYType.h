//
//  GYType.h
//  GCMapDemo
//
//  Created by gao on 16/5/19.
//  Copyright © 2016年 高春阳. All rights reserved.
//

#ifndef GYType_h
#define GYType_h
#import <Foundation/Foundation.h>
typedef uint64_t GYID;
typedef double GYFloat;
struct GYCoordinate {
    GYFloat longitude;
    GYFloat latitude;
};
typedef struct GYCoordinate GYCoordinate;

struct GYPoint3D{
    GYFloat x;
    GYFloat y;
    GYFloat z;
};
typedef struct GYPoint3D GYPoint3D;

GYCoordinate GYCoordinateMake(GYFloat longitude, GYFloat latitude) {
    GYCoordinate coordinate; coordinate.longitude = longitude; coordinate.latitude = latitude;
    return coordinate;
}

GYPoint3D GYPoint3DMake(GYFloat x, GYFloat y, GYFloat z) {
    GYPoint3D point3D; point3D.x = x; point3D.y = y; point3D.z = z; return point3D;
}



#endif /* GYType_h */
