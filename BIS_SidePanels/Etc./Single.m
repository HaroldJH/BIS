//
//  Single.m
//  ALICE
//
//  Created by Harold Jinho YI on 13. 7. 27..
//
//

#import "Single.h"

@implementation Single

static NSString * __sharedObject;
static NSString * __sharedRouteId;
static int count = 0;
static NSString *routeNo;
static NSString *routeId;
static NSString *routeType;
static NSString *stnStr;

+ (NSString *)returnRouteNum {
    return __sharedObject;
}

+ (void)saveRouteNum:(NSString *)a {
    __sharedObject = a;
}

+ (NSString *)returnRouteid {
    return __sharedRouteId;
}

+ (void)saveRouteid:(NSString *)a {
    __sharedRouteId = a;
}

+ (int)returnCount {
    return count;
}

+ (void)saveCount:(int)count1 {
    count = count1;
}

+ (NSString *)returnNo {
    return routeNo;
}

+ (void)saveNo:(NSString *)count1 {
    routeNo = count1;
}

+ (NSString *)returnId {
    return routeId;
}

+ (void)saveId:(NSString *)count1 {
    routeId = count1;
}

+ (NSString *)returnType {
    return routeType;
}

+ (void)saveType:(NSString *)count1 {
    routeType = count1;
}

+ (int)returnRegion {
    return count;
}

+ (void)saveRegion:(int)count1 {
    count = count1;
}

+ (NSString *)returnStnId {
    return stnStr;
}

+ (void)saveStnId:(NSString *)a {
    stnStr = a;
}

@end
