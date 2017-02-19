//
//  BIS_Stn_ArriveViewController.h
//  BIS
//
//  Created by Harold Jinho Yi on 9/3/13.
//
//

#import <UIKit/UIKit.h>
#import "TFHpple.h"

@interface BIS_Stn_ICN_ArriveViewController : UIViewController<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>{
    NSMutableArray *data;
    UITableView *tv;
    UILabel *lbl;
    
    NSMutableArray *arr;
    NSArray *arrs;
    NSMutableDictionary *typeDic;
    
    int count;
    
    NSString *strs;
    NSArray *arrk;
    
    NSMutableArray *arrBlue;
    NSMutableArray *arrRed;
    NSMutableArray *arrGray;
    NSMutableArray *arrGreen;
    NSMutableArray *arrYello;
    NSMutableArray *arrPuple;
    
    NSString *soonArr;
}

- (void)setParameter:(NSString *)str :(NSString *)sId;
@property (nonatomic, weak) NSMutableArray *data;
@end
