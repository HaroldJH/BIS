//
//  BIS_Stn_SL_ArriveViewController.h
//  BIS
//
//  Created by Harold Jinho Yi on 12/2/13.
//
//

#import <UIKit/UIKit.h>
#import "TBXML+HTTP.h"
#import "Single.h"

@interface BIS_Stn_SL_ArriveViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    UITableView *tv;
    NSMutableArray *stnList;
    UILabel *lbl;
    NSMutableDictionary *dic;
    NSArray *keys;
    
    NSString *arrSoon;
    
    NSMutableArray *arrBlue;
    NSMutableArray *arrRed;
    NSMutableArray *arrCrayon;
    NSMutableArray *arrGreen;
    NSMutableArray *arrYello;
}

@end
