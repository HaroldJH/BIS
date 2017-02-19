//
//  SL_Stn_listViewController.m
//  BIS
//
//  Created by Harold Jinho Yi on 9/28/13.
//
//

#import "SL_Stn_listViewController.h"
#import "TBXML+HTTP.h"
#import "Single.h"

#define SERVICEKEY "VHPMOV36Vv4EA0i%2Bu6ATFvqF8o0wAzqvWqgwQihpBoBvjT3AeMGFlugn22HwyUzIrtCtTOhsHxkRfLBkvFYjJg%3D%3D"

@interface SL_Stn_listViewController ()

@end

@implementation SL_Stn_listViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        count = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultStnDic:) name:@"resultStnDic" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resultBusDic:) name:@"resultBusDic" object:nil];
    
    lblv = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0f, 100, 100)];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height - 70.f)];
    /*
    wlbl = [[UILabel alloc] init];
    [wlbl setText:@"데이터 로딩중입니다."];
    [wlbl setTextAlignment:UITextAlignmentCenter];
    [wlbl setFrame:CGRectMake(0, self.view.frame.size.height/5, self.view.frame.size.width, self.view.frame.size.height/2)];
    [wlbl setFont:[UIFont systemFontOfSize:60]];
    [wlbl setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:wlbl];
    */
    [lblv setBackgroundColor:[UIColor clearColor]];
    [lblv setAlpha:1.0f];
    
    [tv addSubview:lblv];
    
    [tv setDataSource:self];
    [tv setDelegate:self];
    
    stnList = [[NSMutableArray alloc] init];
    busList = [[NSMutableArray alloc] init];
    [self.view addSubview:tv];
    [NSThread detachNewThreadSelector:@selector(parseXMLStn) toTarget:self withObject:Nil];
    [NSThread detachNewThreadSelector:@selector(parseXMLBus) toTarget:self withObject:Nil];
  
    count = 1;
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"refresh" style:UIBarButtonItemStylePlain target:self action:@selector(buttonEvent)];
    self.navigationItem.rightBarButtonItem = bar;
}

#pragma mark - Button Actions
- (void)buttonEvent {
    [busList removeAllObjects];
    count = 1;
    [NSThread detachNewThreadSelector:@selector(parseXMLBus) toTarget:self withObject:Nil];
}

- (void) drawBusLoc {
    for (int i = 0; i < [stnList count]; i++) {
        NSDictionary *temp = [stnList objectAtIndex:i];
        
        for (int j = count;  j <= [busList count]; j++) {
            NSDictionary *busTemp = [busList objectAtIndex:j-1];
            //NSLog(@"%@", [busTemp objectForKey:@"plainNo"]);
           if ([[busTemp objectForKey:@"sectOrd"] intValue] == [[temp objectForKey:@"seq"] intValue]) {
                
                float height = 40 * ([[temp objectForKey:@"seq"] intValue]-3) + 20 + (40 * ([[busTemp objectForKey:@"sectDist"] floatValue] / [[busTemp objectForKey:@"fullSectDist"] floatValue]));
                lbl = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 150.f, height-10, 150, 100)];
                [lbl setTag:123];
                [lbl setText:[busTemp objectForKey:@"plainNo"]];
                [lblv addSubview:lbl];
                
                count ++;
                break;
            }
            //else
              //  break;
        }
    }
}

- (void)resultStnDic:(NSNotification *)noti{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:[noti userInfo]];
    [stnList addObject:resultDic];
    [tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)resultBusDic:(NSNotification *)noti{
    NSDictionary *resultDic = [[NSDictionary alloc] initWithDictionary:[noti userInfo]];
    [busList addObject:resultDic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return [data count];
    //NSLog(@"%d", [stnList count]);
    return [stnList count];
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSDictionary *temp = [stnList objectAtIndex:indexPath.row];
    
    NSString *stationNo = [temp objectForKey:@"stationNo"];
    NSString *stationNm = [temp objectForKey:@"stationNm"];
    NSString *direction = [temp objectForKey:@"direction"];
    
    UILabel *_stationNm = [[UILabel alloc] initWithFrame:CGRectMake(10, 5.0, 300, 18)];
    UILabel *_stationNdir = [[UILabel alloc] initWithFrame:CGRectMake(10, 20.0, 300, 18)];
    
    NSString *stnId = [[stationNo substringToIndex:2] stringByAppendingString:@"-"];
    stnId = [stnId stringByAppendingString:[stationNo substringFromIndex:2]];
    [_stationNm setText:stationNm];
    [_stationNdir setText:[@"" stringByAppendingFormat:@"ID : %@ / %@ 방향", stnId, direction]];
    
    [cell.contentView addSubview:_stationNm];
    [cell.contentView addSubview:_stationNdir];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    BIS_Stn_SL_ArriveViewController *arrive = [[BIS_Stn_SL_ArriveViewController alloc] init];
    NSDictionary *temp = [stnList objectAtIndex:indexPath.row];
    NSString *station = [temp objectForKey:@"stationNo"];
    [Single saveStnId:station];
    [self.navigationController pushViewController:arrive animated:YES];
}

//If Success loading data, This method is run
#pragma mark - XML Parsing
void (^tbmlListStnSucessBlock)(TBXML *) = ^(TBXML * tbxml){
    //This is generate that Pointer designate top element, elementFood, elementNa
    TBXMLElement *elementRoot = nil, *msgBody = nil, *itemList = nil, *stationNm = nil, *stationNo = nil, *direction = nil, *seq = nil;
    
    //Fetch address of top-level element
    elementRoot = tbxml.rootXMLElement;
    
    if(elementRoot){ //If top-level element is existed(That is, if this is fetch xml normally)
        msgBody = [TBXML childElementNamed:@"msgBody" parentElement:elementRoot];
        if(msgBody){
            itemList = [TBXML childElementNamed:@"itemList" parentElement:msgBody];
            
            int cnt = 0;
            
            while(itemList){
                
                stationNm = [TBXML childElementNamed:@"stationNm" parentElement:itemList];
                stationNo = [TBXML childElementNamed:@"stationNo" parentElement:itemList];
                direction = [TBXML childElementNamed:@"direction" parentElement:itemList];
                seq = [TBXML childElementNamed:@"seq" parentElement:itemList];
                
                NSString *stationNmStr = [TBXML textForElement:stationNm];
                NSString *stationNoStr = [TBXML textForElement:stationNo];
                NSString *directionStr = [TBXML textForElement:direction];
                NSString *seqStr = [TBXML textForElement:seq];
                
                //NSString *stationNm = [TBXML valueOfAttributeNamed:@"stationNm" forElement:itemList];
                //NSString *stationNo = [TBXML valueOfAttributeNamed:@"stationNo" forElement:itemList];
                
                //NSLog(@"RESULT : %@, %@, %@", stationStr, stationNmStr, directionStr);
                //NSLog(@"%@", fc);
                itemList = itemList->nextSibling;
                //elementNam = elementNam->nextSibling;
                //elementName = elementName->nextSibling;
                cnt++;
                
                
                NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:stationNoStr, @"stationNo", stationNmStr, @"stationNm", directionStr, @"direction", seqStr, @"seq", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resultStnDic" object:nil userInfo:resultDic];
            }
        }
    }
};

void (^tbmlListBusSucessBlock)(TBXML *) = ^(TBXML * tbxml){
    //This is generate that Pointer designate top element, elementFood, elementNa
    TBXMLElement *elementRoot = nil, *msgBody = nil, *itemList = nil, *fullSectDist = nil, *sectDist = nil, *plainNo = nil, *sectOrd = nil;
    
    //Fetch address of top-level element
    elementRoot = tbxml.rootXMLElement;
    
    if(elementRoot){ //If top-level element is existed(That is, if this is fetch xml normally)
        msgBody = [TBXML childElementNamed:@"msgBody" parentElement:elementRoot];
        if(msgBody){
            itemList = [TBXML childElementNamed:@"itemList" parentElement:msgBody];
            
            int cnt = 0;
            
            while(itemList){
                
                fullSectDist = [TBXML childElementNamed:@"fullSectDist" parentElement:itemList];
                sectDist = [TBXML childElementNamed:@"sectDist" parentElement:itemList];
                plainNo = [TBXML childElementNamed:@"plainNo" parentElement:itemList];
                sectOrd = [TBXML childElementNamed:@"sectOrd" parentElement:itemList];
                
                NSString *fullSectDistStr = [TBXML textForElement:fullSectDist];
                NSString *sectDistStr = [TBXML textForElement:sectDist];
                NSString *plainNoStr = [TBXML textForElement:plainNo];
                NSString *sectOrdStr = [TBXML textForElement:sectOrd];
                
                //NSString *stationNm = [TBXML valueOfAttributeNamed:@"stationNm" forElement:itemList];
                //NSString *stationNo = [TBXML valueOfAttributeNamed:@"stationNo" forElement:itemList];
                
                //NSLog(@"RESULT : %@, %@, %@", stationStr, stationNmStr, directionStr);
                //NSLog(@"test%@", plainNoStr);
                itemList = itemList->nextSibling;
                //elementNam = elementNam->nextSibling;
                //elementName = elementName->nextSibling;
                cnt++;
                
                NSDictionary *resultDic = [[NSDictionary alloc] initWithObjectsAndKeys:fullSectDistStr, @"fullSectDist", sectDistStr, @"sectDist", plainNoStr, @"plainNo", sectOrdStr, @"sectOrd", nil];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"resultBusDic" object:nil userInfo:resultDic];
            }
        }
    }
};


//If fail loading data, This method is run
void (^tbmlFailureBlock)(TBXML *, NSError *) = ^(TBXML * tbxml, NSError * error){
    NSLog(@"ERROR : %@", error);
};

- (void)parseXMLStn{
    //Create URL which XML is existed
    NSString *busStr = [Single returnId];
    NSString *urlStnStr = @"http://ws.bus.go.kr/api/rest/busRouteInfo/getStaionByRoute?serviceKey=";
    
    urlStnStr = [urlStnStr stringByAppendingFormat:@"%s&busRouteId=%@", SERVICEKEY, busStr];
    
    NSURL *stnurl = [NSURL URLWithString:urlStnStr];
    
    //Start to parsing
    [TBXML newTBXMLWithURL:stnurl success:tbmlListStnSucessBlock failure:tbmlFailureBlock];
}

- (void)parseXMLBus{
    //Create URL which XML is existed
    NSString *busStr = [Single returnId];
    NSString *urlBusStr = @"http://ws.bus.go.kr/api/rest/buspos/getBusPosByRtid?serviceKey=";
    
    urlBusStr = [urlBusStr stringByAppendingFormat:@"%s&busRouteId=%@", SERVICEKEY, busStr];
    //NSLog(@"%@", urlBusStr);
    
    NSURL *busurl = [NSURL URLWithString:urlBusStr];
    
    //Start to parsing
    [TBXML newTBXMLWithURL:busurl success:tbmlListBusSucessBlock failure:tbmlFailureBlock];
    [NSThread sleepForTimeInterval:1];
    NSArray *subviews = [lblv subviews];
    [subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self performSelectorOnMainThread:@selector(drawBusLoc) withObject:nil waitUntilDone:YES];
    //NSLog(@"TEST");
}


@end
