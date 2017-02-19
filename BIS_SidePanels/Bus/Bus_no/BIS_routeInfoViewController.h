//
//  BIS_routeInfoViewController.h
//  BIS
//
//  Created by Harold Jinho Yi on 9/16/13.
//
//

#import <UIKit/UIKit.h>
#import "SBJson.h"
#import "SQliteManage.h"
#import "Single.h"
#import "ICN_Stn_listViewController.h"
#import "SL_Stn_listViewController.h"
#import "GG_Stn_listViewController.h"

#define RED @"광역 버스"
#define BLUE @"간선 버스"
#define GREEN @"지선 버스"
#define PURPLET @"좌석 버스(I)"
#define BLUEG @"좌석 버스(G)"
#define GREENG @"일반 버스"
#define CYAN @"공항리무진 버스"
#define REDG @"직행좌석 버스"
#define ORANGE @"순환 버스"
#define REDM @"광역급행(M) 버스"
#define PURPLE @"급행간선 버스"
#define PURPLEG @"시외직행 버스"

@interface BIS_routeInfoViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSDictionary *dic;
    NSArray *key;
    UITableView *tv;
    UIImageView *imgv;
    UIView *view1;
    
    int region;
}

@end
