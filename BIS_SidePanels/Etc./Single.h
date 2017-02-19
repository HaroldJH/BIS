//
//  Single.h
//  ALICE
//
//  Created by Harold Jinho YI on 13. 7. 27..
//
//

#import <Foundation/Foundation.h>

@interface Single : NSObject{
    
}
+ (NSString *)returnRouteNum;
+ (void)saveRouteNum:(NSString *)a;
+ (NSString *)returnRouteid;
+ (void)saveRouteid:(NSString *)a;
+ (int)returnCount;
+ (void)saveCount:(int)count1;
+ (NSString *)returnNo;
+ (void)saveNo:(NSString *)count1;
+ (NSString *)returnId;
+ (void)saveId:(NSString *)count1;
+ (NSString *)returnType;
+ (void)saveType:(NSString *)count1;
+ (int)returnRegion;
+ (void)saveRegion:(int)count1;
+ (NSString *)returnStnId;
+ (void)saveStnId:(NSString *)a;
@end
