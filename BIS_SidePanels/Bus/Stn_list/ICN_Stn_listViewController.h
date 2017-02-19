//
//  BIS_Bus_no_ViewController.h
//  BIS
//
//  Created by Harold Jinho YI on 13. 6. 21..
//
//

#import <UIKit/UIKit.h>
#import "Single.h"
#import "BIS_Stn_ICN_ArriveViewController.h"

@interface ICN_Stn_listViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    UITableView *tv;
    
    NSMutableArray *data;
    UIActivityIndicatorView *indicator;
    UILabel *lbl;
}

- (void)setIdnNo:(NSString *)routeId :(NSString *)routeNo;

@property (nonatomic, weak) NSMutableArray *data;
@property (nonatomic, weak) UIActivityIndicatorView *indicator;
@property (nonatomic, weak) UILabel *lbl;
@end
