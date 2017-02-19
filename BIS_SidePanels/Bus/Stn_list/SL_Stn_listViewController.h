//
//  SL_Stn_listViewController.h
//  BIS
//
//  Created by Harold Jinho Yi on 9/28/13.
//
//

#import <UIKit/UIKit.h>
#import "BIS_Stn_SL_ArriveViewController.h"

@interface SL_Stn_listViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tv;
    NSMutableArray *stnList;
    NSMutableArray *busList;
    int count;
    UILabel *lbl;
    UIView *lblv;
    UILabel *wlbl;
}

@end
