//
//  BIS_Stn_SL_ArriveViewController.m
//  BIS
//
//  Created by Harold Jinho Yi on 12/2/13.
//
//

#import "BIS_Stn_SL_ArriveViewController.h"

#define SERVICEKEY "VHPMOV36Vv4EA0i%2Bu6ATFvqF8o0wAzqvWqgwQihpBoBvjT3AeMGFlugn22HwyUzIrtCtTOhsHxkRfLBkvFYjJg%3D%3D"

@interface BIS_Stn_SL_ArriveViewController ()

@end

@implementation BIS_Stn_SL_ArriveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrSoon = @"   곧 도착 : ";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultDic:) name:@"resultDic" object:nil];
    
    arrBlue = [[NSMutableArray alloc] init];
    arrRed = [[NSMutableArray alloc] init];
    arrCrayon = [[NSMutableArray alloc] init];
    arrGreen = [[NSMutableArray alloc] init];
    arrYello = [[NSMutableArray alloc] init];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, self.view.frame.size.width, self.view.frame.size.height-80.0f) style:UITableViewStyleGrouped];
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 50.0f)];
    [lbl setBackgroundColor:[UIColor whiteColor]];
    
    [tv setRowHeight:50];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tv setSeparatorColor:[UIColor grayColor]];
   
    [self.view addSubview:lbl];

    [self.view addSubview:tv];
    
    stnList = [[NSMutableArray alloc] init];
    dic = [[NSMutableDictionary alloc] init];
    keys = [[NSArray alloc] init];
    [NSThread detachNewThreadSelector:@selector(parseXML) toTarget:self withObject:Nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)resultDic:(NSNotification *)noti{
    
    //[NSThread sleepForTimeInterval:1];
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:[noti userInfo]];
    [stnList addObject:resultDic];
    NSString *bType;
    switch ([[[noti userInfo] objectForKey:@"routeType"] intValue]) {
        case 1:
        {
            bType = @"공항리무진";
            NSMutableDictionary *bus = [[NSMutableDictionary alloc] init];
            [bus setObject:[[noti userInfo] objectForKey:@"rtNm"] forKey:@"rtNm"];
            [bus setObject:[[noti userInfo] objectForKey:@"traTime1"] forKey:@"traTime1"];
            [bus setObject:@"간선버스" forKey:@"routeType"];
            [bus setObject:[[noti userInfo] objectForKey:@"stationNm1"] forKey:@"stationNm1"];
            [arrCrayon addObject:bus];
            if([[[noti userInfo] objectForKey:@"soonStr"] isEqualToString:@"soon"]) {
                arrSoon = [arrSoon stringByAppendingFormat:@"%@, ", [[noti userInfo] objectForKey:@"rtNm"]];
            }
            break;
        }
        case 3:
        {
            bType = @"간선버스";
            NSMutableDictionary *bus = [[NSMutableDictionary alloc] init];
            [bus setObject:[[noti userInfo] objectForKey:@"rtNm"] forKey:@"rtNm"];
            [bus setObject:[[noti userInfo] objectForKey:@"traTime1"] forKey:@"traTime1"];
            [bus setObject:@"간선버스" forKey:@"routeType"];
            [bus setObject:[[noti userInfo] objectForKey:@"stationNm1"] forKey:@"stationNm1"];
            [arrBlue addObject:bus];
            if([[[noti userInfo] objectForKey:@"soonStr"] isEqualToString:@"soon"]) {
                arrSoon = [arrSoon stringByAppendingFormat:@"%@, ", [[noti userInfo] objectForKey:@"rtNm"]];
            }
            break;
        }
        case 4:
        {
            bType = @"지선버스";
            NSMutableDictionary *bus = [[NSMutableDictionary alloc] init];
            [bus setObject:[[noti userInfo] objectForKey:@"rtNm"] forKey:@"rtNm"];
            [bus setObject:[[noti userInfo] objectForKey:@"traTime1"] forKey:@"traTime1"];
            [bus setObject:@"간선버스" forKey:@"routeType"];
            [bus setObject:[[noti userInfo] objectForKey:@"stationNm1"] forKey:@"stationNm1"];
            [arrGreen addObject:bus];
            if([[[noti userInfo] objectForKey:@"soonStr"] isEqualToString:@"soon"]) {
                arrSoon = [arrSoon stringByAppendingFormat:@"%@, ", [[noti userInfo] objectForKey:@"rtNm"]];
            }
            break;
        }
        case 5:
        {
            bType = @"순환버스";
            NSMutableDictionary *bus = [[NSMutableDictionary alloc] init];
            [bus setObject:[[noti userInfo] objectForKey:@"rtNm"] forKey:@"rtNm"];
            [bus setObject:[[noti userInfo] objectForKey:@"traTime1"] forKey:@"traTime1"];
            [bus setObject:@"간선버스" forKey:@"routeType"];
            [bus setObject:[[noti userInfo] objectForKey:@"stationNm1"] forKey:@"stationNm1"];
            [arrYello addObject:bus];
            if([[[noti userInfo] objectForKey:@"soonStr"] isEqualToString:@"soon"]) {
                arrSoon = [arrSoon stringByAppendingFormat:@"%@, ", [[noti userInfo] objectForKey:@"rtNm"]];
            }
            break;
        }
        case 6:
        {
            bType = @"광역버스";
            NSMutableDictionary *bus = [[NSMutableDictionary alloc] init];
            [bus setObject:[[noti userInfo] objectForKey:@"rtNm"] forKey:@"rtNm"];
            [bus setObject:[[noti userInfo] objectForKey:@"traTime1"] forKey:@"traTime1"];
            [bus setObject:@"간선버스" forKey:@"routeType"];
            [bus setObject:[[noti userInfo] objectForKey:@"stationNm1"] forKey:@"stationNm1"];
            [arrRed addObject:bus];
            if([[[noti userInfo] objectForKey:@"soonStr"] isEqualToString:@"soon"]) {
                arrSoon = [arrSoon stringByAppendingFormat:@"%@, ", [[noti userInfo] objectForKey:@"rtNm"]];
            }
            break;
        }
    }
    NSLog(@"test %@", [[noti userInfo] objectForKey:@"soonStr"]);
    [dic setValue:@"busType" forKey:bType];
    NSArray *arr = [[dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    keys = arr;
    [tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    //[NSThread sleepForTimeInterval:0.1];
    [self performSelectorOnMainThread:@selector(soonTxt) withObject:nil waitUntilDone:NO];
}

- (void)soonTxt{
    [NSThread sleepForTimeInterval:0.1];
    //lbl.backgroundColor = [UIColor clearColor];
    [lbl setText:arrSoon];
    [lbl setFont:[UIFont systemFontOfSize:20]];
    [lbl setTextAlignment:UITextAlignmentLeft];
    //[txv setText:soonArr];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [keys count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [keys objectAtIndex:section];
    return key;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    int count = 0;
    NSString *_key = [keys objectAtIndex:section];
    if ([_key isEqualToString:@"공항리무진"]) {
        count = [arrCrayon count];
    } else if ([_key isEqualToString:@"간선버스"]) {
        count = [arrBlue count];
    } else if ([_key isEqualToString:@"지선버스"]) {
        count = [arrGreen count];
    } else if ([_key isEqualToString:@"순환버스"]) {
        count = [arrYello count];
    } else if ([_key isEqualToString:@"광역버스"]) {
        count = [arrRed count];
    }
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    // Configure the cell...
    //NSString *route_type;
    NSString *_routeNo;
    NSString *time;
    NSString *loc;
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 15.0, 300, 18)];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setNumberOfLines:1];
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(-20, 5.0, 300, 18)];
    [lable1 setBackgroundColor:[UIColor clearColor]];
    [lable1 setNumberOfLines:1];
    
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(-20, 25.0, 300, 18)];
    [lable2 setBackgroundColor:[UIColor clearColor]];
    [lable2 setNumberOfLines:1];
    
    if ([[keys objectAtIndex:[indexPath section]] isEqualToString:@"간선버스"]) {
        NSDictionary *_dic = [arrBlue objectAtIndex:indexPath.row];
        _routeNo = [_dic objectForKey:@"rtNm"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor blueColor]];
        time = [_dic objectForKey:@"traTime1"];
        loc = [_dic objectForKey:@"stationNm1"];
    } else if ([[keys objectAtIndex:[indexPath section]] isEqualToString:@"광역버스"]) {
        NSDictionary *_dic = [arrRed objectAtIndex:indexPath.row];
        _routeNo = [_dic objectForKey:@"rtNm"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor redColor]];
        time = [_dic objectForKey:@"traTime1"];
        loc = [_dic objectForKey:@"stationNm1"];
        //NSLog(@"광역%@", _routeNo);
    } else if ([[keys objectAtIndex:[indexPath section]] isEqualToString:@"지선버스"]) {
        NSDictionary *_dic = [arrGreen objectAtIndex:indexPath.row];
        _routeNo = [_dic objectForKey:@"rtNm"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor greenColor]];
        time = [_dic objectForKey:@"traTime1"];
        loc = [_dic objectForKey:@"stationNm1"];
        //NSLog(@"지선%@", _routeNo);
    } else if ([[keys objectAtIndex:[indexPath section]] isEqualToString:@"순환버스"]) {
        NSDictionary *_dic = [arrYello objectAtIndex:indexPath.row];
        _routeNo = [_dic objectForKey:@"rtNm"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor orangeColor]];
        time = [_dic objectForKey:@"traTime1"];
        loc = [_dic objectForKey:@"stationNm1"];
        //NSLog(@"순환%@", _routeNo);
    } else if ([[keys objectAtIndex:[indexPath section]] isEqualToString:@"공항리무진"]) {
        NSDictionary *_dic = [arrCrayon objectAtIndex:indexPath.row];
        _routeNo = [_dic objectForKey:@"rtNm"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor cyanColor]];
        time = [_dic objectForKey:@"traTime1"];
        loc = [_dic objectForKey:@"stationNm1"];
        //NSLog(@"급행간선%@", _routeNo);
    }
    
    [lable setText:[NSString stringWithFormat:@"%@", _routeNo]];
    [lable1 setText:[NSString stringWithFormat:@"%@", time]];
    [lable2 setText:[NSString stringWithFormat:@"%@", loc]];
    [lable1 setTextAlignment:UITextAlignmentRight];
    [lable2 setTextAlignment:UITextAlignmentRight];
    [cell.contentView addSubview:lable];
    [cell.contentView addSubview:lable1];
    [cell.contentView addSubview:lable2];

    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

void (^tbmlListSucessBlock)(TBXML *) = ^(TBXML * tbxml){
    //This is generate that Pointer designate top element, elementFood, elementNa
    TBXMLElement *elementRoot = nil, *msgBody = nil, *itemList = nil, *busType1 = nil, *traTime1 = nil, *staOrd = nil, *sectOrd1 = nil, *rtNm = nil, *routeType = nil, *stationNm1 = nil, *isLast1 = nil;
    
    //Fetch address of top-level element
    elementRoot = tbxml.rootXMLElement;
    
    if(elementRoot){ //If top-level element is existed(That is, if this is fetch xml normally)
        msgBody = [TBXML childElementNamed:@"msgBody" parentElement:elementRoot];
        if(msgBody){
            itemList = [TBXML childElementNamed:@"itemList" parentElement:msgBody];
            
            int cnt = 0;
            
            while(itemList){
                
                rtNm = [TBXML childElementNamed:@"rtNm" parentElement:itemList];
                stationNm1 = [TBXML childElementNamed:@"stationNm1" parentElement:itemList];
                busType1 = [TBXML childElementNamed:@"busType1" parentElement:itemList];
                traTime1 = [TBXML childElementNamed:@"traTime1" parentElement:itemList];
                staOrd = [TBXML childElementNamed:@"staOrd" parentElement:itemList];
                sectOrd1 = [TBXML childElementNamed:@"sectOrd1" parentElement:itemList];
                //sectOrd2 = [TBXML childElementNamed:@"sectOrd2" parentElement:itemList];
                routeType = [TBXML childElementNamed:@"routeType" parentElement:itemList];
                traTime1 = [TBXML childElementNamed:@"traTime1" parentElement:itemList];
                isLast1 = [TBXML childElementNamed:@"isLast1" parentElement:itemList];

                NSString *busType1Str = [TBXML textForElement:busType1];
                NSString *staOrdStr = [TBXML textForElement:staOrd];
                NSString *sectOrdStr1 = [TBXML textForElement:sectOrd1];
                NSString *traTime1Str = [TBXML textForElement:traTime1];
                //NSString *sectOrdStr2 = [TBXML textForElement:sectOrd2];
                NSString *routeTypeStr = [TBXML textForElement:routeType];
                NSString *rtNmStr = [TBXML textForElement:rtNm];
                NSString *isLast1tr = [TBXML textForElement:isLast1];
                NSString *stationNm1Str;
                NSString *arrSoonStr = @"";
                
                if(stationNm1 == nil || [isLast1tr intValue] < 0) {
                    stationNm1Str = @"대기중";
                    traTime1Str = @"도착예정 버스 없음.";
                }
                else {
                    stationNm1Str = [TBXML textForElement:stationNm1];
                    sectOrdStr1 = [@"" stringByAppendingFormat:@"%d", ([staOrdStr intValue] - [sectOrdStr1 intValue])];
                    traTime1Str = [@"" stringByAppendingFormat:@"%@번째 전, %d분 %d초", sectOrdStr1, (int)([traTime1Str intValue]/60), ([traTime1Str intValue]%60)];
                }
                
                if((int)([[TBXML textForElement:traTime1] intValue] < 120) && ![stationNm1Str isEqualToString:@"대기중"]){
                    arrSoonStr = @"soon";
                } else {
                    arrSoonStr = @"Not soon";
                }
                
                if([routeTypeStr intValue] != 8 && [routeTypeStr intValue] != 7){
                    sectOrdStr1 = [@"" stringByAppendingFormat:@"%d", ([staOrdStr intValue] - [sectOrdStr1 intValue])];
                    //sectOrdStr2 = [@"" stringByAppendingFormat:@"%d", ([staOrdStr intValue] - [sectOrdStr2  intValue])];
                    
                    //NSLog(@"%@번째 전 정류소, %@번째 전 정류소", sectOrdStr1, sectOrdStr2);
                    NSLog(@"%@번째 전 정류소, %d분 %d초 후 도착예정(%@)", sectOrdStr1, (int)([traTime1Str intValue]/60), ([traTime1Str intValue]%60), stationNm1Str);
                    
                    //NSString *stationNm = [TBXML valueOfAttributeNamed:@"stationNm" forElement:itemList];
                    //NSString *stationNo = [TBXML valueOfAttributeNamed:@"stationNo" forElement:itemList];
                    
                    //NSLog(@"RESULT : %@, %@, %@", stationStr, stationNmStr, directionStr);
                    //NSLog(@"test%@", plainNoStr);
                    itemList = itemList->nextSibling;
                    //elementNam = elementNam->nextSibling;
                    //elementName = elementName->nextSibling;
                    cnt++;
                    
                    //NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:busType1Str, @"busType1", traTime1Str, @"traTime1", sectOrdStr1, @"staOrd1", sectOrdStr2, @"staOrdStr2", nil];
                    
                    NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:rtNmStr, @"rtNm", busType1Str, @"busType1", traTime1Str, @"traTime1", sectOrdStr1, @"staOrd1", stationNm1Str, @"stationNm1", routeTypeStr, @"routeType", arrSoonStr, @"soonStr", nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"resultDic" object:nil userInfo:resultDic];
 
                } else if ([routeTypeStr intValue] == 8 || [routeTypeStr intValue] == 9){
                    NSLog(@"인천버스 or 경기버스");
                    itemList = itemList->nextSibling;
                }
            }
        }
    }
};

//If fail loading data, This method is run
void (^FailureBlock)(TBXML *, NSError *) = ^(TBXML * tbxml, NSError * error){
    NSLog(@"ERROR : %@", error);
};

- (void)parseXML{
    //Create URL which XML is existed
    NSString *stnStr = [Single returnStnId];
    NSString *urlStnStr = @"http://ws.bus.go.kr/api/rest/stationinfo/getStationByUid?serviceKey=";
    
    urlStnStr = [urlStnStr stringByAppendingFormat:@"%s&arsid=%@", SERVICEKEY, stnStr];
    NSLog(@"%@", urlStnStr);
    
    NSURL *stnUrl = [NSURL URLWithString:urlStnStr];
    
    //Start to parsing
    [TBXML newTBXMLWithURL:stnUrl success:tbmlListSucessBlock failure:FailureBlock];
}

@end
