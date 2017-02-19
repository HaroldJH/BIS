//
//  BISViewController.h
//  BIS
//
//  Created by Harold Jinho YI on 13. 7. 1..
//
//

#import <UIKit/UIKit.h>
#import "SQliteManage.h"
#import "ICN_Stn_listViewController.h"
#import "Single.h"
#import "BIS_routeInfoViewController.h"

@interface BISViewController : UIViewController <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>{

    NSMutableArray *copyListItems;
    NSMutableArray *copyListItems1;
    NSMutableArray *copyListItems2;
    
    UITableView *tv;
    UISearchBar *searchBar;
    BOOL searching;
    BOOL letUserSelectRow;
    
    NSString *_searchText;
    NSString *route_type;
    
    NSArray *keys;
    NSMutableDictionary *_dic;
    NSString *key;
    
    NSMutableArray *regionArr;
    int nTextField;
}
@property (nonatomic, assign) int nTextField;
@end
