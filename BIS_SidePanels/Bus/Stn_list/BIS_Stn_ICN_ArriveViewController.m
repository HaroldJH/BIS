//
//  BIS_Stn_ArriveViewController.m
//  BIS
//
//  Created by Harold Jinho Yi on 9/3/13.
//
//

#import "BIS_Stn_ICN_ArriveViewController.h"

@interface BIS_Stn_ICN_ArriveViewController ()

@end

@implementation BIS_Stn_ICN_ArriveViewController

static NSString *url1;
static NSString *url2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController.navigationBar setTranslucent:NO];
    
    
    typeDic = [[NSMutableDictionary alloc] init];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 50.0f, self.view.frame.size.width, self.view.frame.size.height-80.0f) style:UITableViewStyleGrouped];
    
    lbl = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 50.0f)];
    [lbl setBackgroundColor:[UIColor whiteColor]];
    
    [tv setRowHeight:50];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tv setSeparatorColor:[UIColor grayColor]];
   
    [self.view addSubview:tv];
    [self.view addSubview:lbl];
    
    [NSThread detachNewThreadSelector:@selector(getData) toTarget:self withObject:nil];
    //[self compareStn];
}

- (void)getData{
    
    NSString *_url = [NSString stringWithContentsOfURL:[NSURL URLWithString:url1] encoding:-2147481280 error:nil];
    NSString *_url1 = [NSString stringWithContentsOfURL:[NSURL URLWithString:url2] encoding:-2147481280 error:nil];
    NSLog(@"URL %@", url2);
    NSData *htmldata = [_url dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmldata];
    NSData *htmldata1 = [_url1 dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple *xpathParser1 = [[TFHpple alloc] initWithHTMLData:htmldata1];
    
    NSMutableArray *elements = (NSMutableArray *)[xpathParser searchWithXPathQuery:@"//td[@align=\"center\"] [@bgcolor=\"#FFFFFF\"]"];
    NSMutableArray *elements1 = (NSMutableArray *)[xpathParser1 searchWithXPathQuery:@"//td[@height=\"25\"] [@align=\"center\"] [@bgcolor=\"#FFFFFF\"] [@class=\"t6\"]//a"];
    
    int count1 = [elements count] / 6;
    
    NSArray *temp_routeNo[count1];
    NSArray *temp_routeDir[count1];
    NSArray *temp_routeStart[count1];
    NSArray *temp_routeEnd[count1];
    NSArray *temp_nowLoc[count1];
    NSArray *temp_ArriveTime[count1];
    
    NSMutableArray *routeNo = [[NSMutableArray alloc] init];
    NSMutableArray *routeDir = [[NSMutableArray alloc] init];
    NSMutableArray *routeStart = [[NSMutableArray alloc] init];
    NSMutableArray *routeEnd = [[NSMutableArray alloc] init];
    NSMutableArray *nowLoc = [[NSMutableArray alloc] init];
    NSMutableArray *ArriveTime = [[NSMutableArray alloc] init];
    
    NSString *titleOfAlips = [[NSString alloc] init];
    NSMutableArray *titleOfAlips1 = [[NSMutableArray alloc] init];
    
    strs = @"";
    arr = [[NSMutableArray alloc] init];
    
    for(int i = 0;i < [elements1 count];i++){
        TFHppleElement *element = [elements1 objectAtIndex:i];
        if([[element firstChild] content] != NULL){
            [titleOfAlips1 addObject:(NSMutableArray *)[[element firstChild] content]];
        }
    }
    //NSLog(@"dsfsdfsfsdf %d", [elements count]);
    for(int i = 0;i < [elements count];i++){
        TFHppleElement *element = [elements objectAtIndex:i];
        if([[element firstChild] content] != NULL){
            titleOfAlips = [[element firstChild] content];
            int j= i/6;
            
            switch (i % 6) {
                case 0:{
                    temp_routeNo[j] = (NSArray *)titleOfAlips;
                    
                    break;
                }
                case 1:
                    temp_routeDir[j] = (NSArray *)titleOfAlips;
                    break;
                case 2:
                    temp_routeStart[j] = (NSArray *)titleOfAlips;
                   // NSLog(@"TE %@", temp_routeStart[j]);
                    break;
                case 3:
                    temp_routeEnd[j] = (NSArray *)titleOfAlips;
                    break;
                case 4:
                    temp_nowLoc[j] = (NSArray *)titleOfAlips;
                    break;
                case 5:
                    temp_ArriveTime[j] = (NSArray *)titleOfAlips;
                    break;
            }
        }
    }
    
    for (int i = 0; i < [titleOfAlips1 count]; i++) {
        for (int k = 0; k < ([elements count]); k++) {
            int j= k/6;
            if ([(NSString *)[titleOfAlips1 objectAtIndex:i] isEqualToString:(NSString *)temp_routeNo[j]]) {
                
                switch (k % 6) {
                    case 0:{
                        [routeNo addObject:temp_routeNo[j]];
                        strs = [strs stringByAppendingString:(NSString *)temp_routeNo[j]];
                        strs = [strs stringByAppendingString:@"번+"];
                        break;
                    }
                    case 1:
                        [routeDir addObject:temp_routeDir[j]];
                        break;
                    case 2:
                        [routeStart addObject:temp_routeStart[j]];
                        break;
                    case 3:
                        [routeEnd addObject:temp_routeEnd[j]];
                        break;
                    case 4:
                        [nowLoc addObject:temp_nowLoc[j]];
                        break;
                    case 5:
                        [ArriveTime addObject:temp_ArriveTime[j]];
                        break;
                }
            } else
                continue;
        }
    }
    
    count = [routeNo count];
    
    for (int i = 0; i < count; i++) {
        NSString *str = [(NSString *)routeNo[i] stringByAppendingString:@"번"];
        //NSLog(@"%@", str);
        str = [str stringByAppendingFormat:@";%@", routeDir[i]];
        str = [str stringByAppendingFormat:@";%@", routeStart[i]];
        str = [str stringByAppendingFormat:@";%@", routeEnd[i]];
        str = [str stringByAppendingFormat:@";%@", nowLoc[i]];
        str = [str stringByAppendingFormat:@";%@", ArriveTime[i]];
        [arr addObject:str];
    }
    arrs = [arr sortedArrayUsingSelector:@selector(compare:)];
    
    [NSThread detachNewThreadSelector:@selector(compareStn) toTarget:self withObject:nil];
}

- (void) compareStn{
    NSString *url = [NSString stringWithContentsOfURL:[NSURL URLWithString:url2] encoding:-2147481280 error:nil];
    
    NSData *htmldata = [url dataUsingEncoding:NSUnicodeStringEncoding];
    TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmldata];
    
    NSMutableArray *elements1 = (NSMutableArray *)[xpathParser searchWithXPathQuery:@"//td[@height=\"25\"] [@align=\"center\"] [@bgcolor=\"#FFFFFF\"] [@class=\"t6\"]//a"];
    NSMutableArray *elements2 = (NSMutableArray *)[xpathParser searchWithXPathQuery:@"//td[@align=\"center\"] [@bgcolor=\"#FFFFFF\"] [@class=\"t6\"]"];
    
    NSString *titleOfAlips;
    NSString *titleOfAlips1;
    NSString *titleOfAlips2;
    
    NSMutableArray *arrTime = [[NSMutableArray alloc]init];
    NSMutableArray *nowloca = [[NSMutableArray alloc]init];
    NSMutableArray *returnRoute = [[NSMutableArray alloc] init];
    NSMutableArray *returnRouteId = [[NSMutableArray alloc] init];
    NSMutableArray *returnRouteType = [[NSMutableArray alloc] init];
    
    //NSLog(@"%@", url1);
   //NSLog(@"%@", url2);
    
    NSArray *_routeNo[count];
    NSArray *_routeDir[count];
    NSArray *_routeStart[count];
    NSArray *_routeEnd[count];
    NSArray *_nowLoc[count];
    NSArray *_ArriveTime[count];
    
    arrBlue = [[NSMutableArray alloc] init];
    arrRed = [[NSMutableArray alloc] init];
    arrGray = [[NSMutableArray alloc] init];
    arrGreen = [[NSMutableArray alloc] init];
    arrYello = [[NSMutableArray alloc] init];
    arrPuple = [[NSMutableArray alloc] init];
    
    if(count != 0){
        for (int i = 0; i < count; i++) {
            
            NSMutableArray *ary = (NSMutableArray *)[[arrs objectAtIndex:i] componentsSeparatedByString:@";"];
            for (int j = 0; j < 6; j++) {
                switch (j % 6) {
                    case 0:{
                        _routeNo[i] = [ary objectAtIndex:j];
                        break;
                    }
                    case 1:
                        _routeDir[i] = [ary objectAtIndex:j];
                        break;
                    case 2:
                        _routeStart[i] = [ary objectAtIndex:j];
                        break;
                    case 3:
                        _routeEnd[i] = [ary objectAtIndex:j];
                        break;
                    case 4:
                        _nowLoc[i] = [ary objectAtIndex:j];
                        break;
                    case 5:
                        _ArriveTime[i] = [ary objectAtIndex:j];
                        break;
                }
                
            }
        }
    }
    for(int i=0;i<[elements1 count];i++){
        TFHppleElement *element = [elements1 objectAtIndex:i];
        if([element objectForKey:@"href"] != NULL){
            titleOfAlips1 = [element objectForKey:@"href"];
            
            titleOfAlips = [[element firstChild] content];
            titleOfAlips = [titleOfAlips stringByAppendingString:@"번"];
            
            titleOfAlips1 = [titleOfAlips1 substringFromIndex:27];
            titleOfAlips1 = [titleOfAlips1 substringToIndex:9];
            [returnRouteId addObject:titleOfAlips1];
            [returnRoute addObject:titleOfAlips];
            //NSLog(@"%@", titleOfAlips);
        }
    }
    
    for(int i=0;i<[elements2 count];i++){
        TFHppleElement *element = [elements2 objectAtIndex:i];
        if([[element firstChild] content] != NULL){
            titleOfAlips2 = [[element firstChild] content];
            
            [returnRouteType addObject:titleOfAlips2];
        }
    }
    NSMutableArray *before_sort = [[NSMutableArray alloc] init];
    for (int i = 0; i < [elements1 count]; i++) {
        NSString *temp = [@"" stringByAppendingFormat:@"%@;%@;%@", [returnRoute objectAtIndex:i], [returnRouteId objectAtIndex:i], [returnRouteType objectAtIndex:i]];
        before_sort[i] = (NSArray *)temp;
    }
    
    NSArray *after_sort = [before_sort sortedArrayUsingSelector:@selector(compare:)];
    NSArray *sorted_routeNo[[elements1 count]];
    NSArray *sorted_routeId[[elements1 count]];
    NSArray *sorted_routeType[[elements1 count]];
    
    for (int i = 0; i < [elements1 count]; i++) {
        NSArray *temp = [(NSString *)after_sort[i] componentsSeparatedByString:@";"];
        sorted_routeNo[i] = temp[0];
        sorted_routeId[i] = temp[1];
        sorted_routeType[i] = temp[2];
    }
    
    NSLog(@"%d, %d, %d", [elements1 count], [returnRoute count], [returnRoute count]);
    
    NSMutableArray *arrMin = [[NSMutableArray alloc] init];
    soonArr = @"   곧 도착 : ";
    
    //int _cnt = 0;
    int cnt = 0;
    
    for (int i = 0; i <count; i++) {
        NSLog(@"ddddd %@ %@", _ArriveTime[i],_nowLoc[i]);
    }
    if(count == 0){
        for (int z = 0; z < [returnRoute count]; z++) {
            arrTime[z] = @"NO BUS!";
            arrMin[z] = @"-1";
            nowloca[z] = @"";
        }
    }
    
    else if (count == 1){
        for (int h = 0; h < [elements1 count];h++) {
            if ( NSNotFound == [strs rangeOfString:(NSString *)sorted_routeNo[h]].location) {
                arrTime[h] = @"NO BUS!";
                arrMin[h] = @"-1";
                nowloca[h] = @"";
            } else {
                arrTime[h] = _ArriveTime[h];
                arrMin[h] = [[arrTime[h] componentsSeparatedByString:@"분"] objectAtIndex:0];
                nowloca[h] = _nowLoc[h];
                
                if ([[arrMin objectAtIndex:h] intValue] <= 2 && [[arrMin objectAtIndex:h] intValue] != -1) {
                    soonArr = [soonArr stringByAppendingFormat:@"%@, ", sorted_routeNo[h]];
                    cnt ++;
                }
                 
            }
        }
    }
    
    else if(count != 0){
        
        for (int j = 0;j < count;) {
            
            for (int h = 0; h < [returnRoute count]; h++) {
                if ( NSNotFound == [strs rangeOfString:(NSString *)sorted_routeNo[h]].location) {
                    
                    int temp = [(NSString *)sorted_routeNo[h] rangeOfString:@"("].location;
                    int temp1 = [(NSString *)sorted_routeNo[h] rangeOfString:@"(T"].location;
                    int temp2 = [(NSString *)sorted_routeNo[h] rangeOfString:@"(강화"].location;
                    int temp3 = [(NSString *)sorted_routeNo[h] rangeOfString:@"(계양"].location;
                    int temp4 = [(NSString *)sorted_routeNo[h] rangeOfString:@"(순환"].location;
                    int temp5 = [(NSString *)sorted_routeNo[h] rangeOfString:@"(A"].location;
                    int temp6 = [(NSString *)sorted_routeNo[h] rangeOfString:@"(B"].location;
                    
                    if (temp != NSNotFound && temp1 != NSNotFound) {
                    sorted_routeNo[h] = (NSArray *)[(NSString *)sorted_routeNo[h] substringToIndex:temp1+2];
                        if (NSNotFound != [strs rangeOfString:(NSString *)sorted_routeNo[h]].location) {
                            arrTime[h] = _ArriveTime[j];
                            arrMin[h] = [[arrTime[h] componentsSeparatedByString:@"분"] objectAtIndex:0];
                            nowloca[h] = _nowLoc[j];
                            if ([[arrMin objectAtIndex:h] intValue] <= 2 && [[arrMin objectAtIndex:h] intValue] != -1) {
                                soonArr = [soonArr stringByAppendingFormat:@"%@, ", sorted_routeNo[h]];
                                cnt ++;
                            }
                            j++;
                        } else {
                            arrTime[h] = @"NO BUS!";
                            arrMin[h] = @"-1";
                            nowloca[h] = @"";
                        }
                        
                    } else if (temp != NSNotFound && temp1 == NSNotFound && temp2 != NSNotFound && temp3 != NSNotFound && temp4 != NSNotFound && temp5 != NSNotFound && temp6 != NSNotFound) {
                        sorted_routeNo[h] = (NSArray *)[(NSString *)sorted_routeNo[h] substringToIndex:temp];
                        if (NSNotFound != [strs rangeOfString:(NSString *)sorted_routeNo[h]].location) {
                            arrTime[h] = _ArriveTime[j];
                            arrMin[h] = [[arrTime[h] componentsSeparatedByString:@"분"] objectAtIndex:0];
                            nowloca[h] = _nowLoc[j];
                            if ([[arrMin objectAtIndex:h] intValue] <= 2 && [[arrMin objectAtIndex:h] intValue] != -1) {
                                soonArr = [soonArr stringByAppendingFormat:@"%@, ", sorted_routeNo[h]];
                                cnt ++;
                            }
                            j++;
                        } else {
                            arrTime[h] = @"NO BUS!";
                            arrMin[h] = @"-1";
                            nowloca[h] = @"";
                        }
                        
                    } else {
                        int temp = [(NSString *)sorted_routeNo[h] rangeOfString:@"번"].location;
                        sorted_routeNo[h] = (NSArray *)[(NSString *)sorted_routeNo[h] substringToIndex:temp];
                        arrTime[h] = @"NO BUS!";
                        arrMin[h] = @"-1";
                        nowloca[h] = @"";
                    }
                    //NSLog(@"위치 %d", temp);
                } else {
                    int temp = [(NSString *)sorted_routeNo[h] rangeOfString:@"번"].location;
                    //if(temp == 2147483647)
                    //  break;
                    //NSLog(@"TESTSTE %@", sorted_routeNo[h]);
                    sorted_routeNo[h] = (NSArray *)[(NSString *)sorted_routeNo[h] substringToIndex:temp];
                    arrTime[h] = _ArriveTime[j];
                    arrMin[h] = [[arrTime[h] componentsSeparatedByString:@"분"] objectAtIndex:0];
                    nowloca[h] = _nowLoc[j];
                    if ([[arrMin objectAtIndex:h] intValue] <= 2 && [[arrMin objectAtIndex:h] intValue] != -1) {
                        soonArr = [soonArr stringByAppendingFormat:@"%@, ", sorted_routeNo[h]];
                        cnt ++;
                    }
                    j++;
                }
            }
        }
    }
    
    for (int i = 0; i < [returnRoute count];i++) {
        if ([(NSString *)sorted_routeType[i]isEqualToString:@"간선형"]) {
            
            NSMutableDictionary *blue = [[NSMutableDictionary alloc] init];
            [blue setObject:sorted_routeNo[i] forKey:@"routeNo"];
            [blue setObject:sorted_routeId[i] forKey:@"routeId"];
            [blue setObject:@"간선버스" forKey:@"routeType"];
            [blue setObject:[arrTime objectAtIndex:i] forKey:@"arrMin"];
            [blue setObject:[nowloca objectAtIndex:i] forKey:@"nowLoc"];
            [arrBlue addObject:blue];
            [typeDic setValue:@"routeType" forKey:@"간선버스"];
        } else if ([(NSString *)sorted_routeType[i] isEqualToString:@"광역형"]) {
            
            NSMutableDictionary *red = [[NSMutableDictionary alloc] init];
            [red setObject:sorted_routeNo[i] forKey:@"routeNo"];
            [red setObject:sorted_routeId[i] forKey:@"routeId"];
            [red setObject:@"광역버스" forKey:@"routeType"];
            [red setObject:[arrTime objectAtIndex:i] forKey:@"arrMin"];
            [red setObject:[nowloca objectAtIndex:i] forKey:@"nowLoc"];
            [arrRed addObject:red];
            [typeDic setValue:@"routeType" forKey:@"광역버스"];
        } else if ([(NSString *)sorted_routeType[i] isEqualToString:@"좌석형"]) {
            
            NSMutableDictionary *gray = [[NSMutableDictionary alloc] init];
            [gray setObject:sorted_routeNo[i] forKey:@"routeNo"];
            [gray setObject:sorted_routeId[i] forKey:@"routeId"];
            [gray setObject:@"좌석버스" forKey:@"routeType"];
            [gray setObject:[arrTime objectAtIndex:i] forKey:@"arrMin"];
            [gray setObject:[nowloca objectAtIndex:i] forKey:@"nowLoc"];
            [arrGray addObject:gray];
            [typeDic setValue:@"routeType" forKey:@"좌석버스"];
        } else if ([(NSString *)sorted_routeType[i] isEqualToString:@"지선형"]) {
            
            NSMutableDictionary *green = [[NSMutableDictionary alloc] init];
            [green setObject:sorted_routeNo[i] forKey:@"routeNo"];
            [green setObject:sorted_routeId[i] forKey:@"routeId"];
            [green setObject:@"지선버스" forKey:@"routeType"];
            [green setObject:[arrTime objectAtIndex:i] forKey:@"arrMin"];
            [green setObject:[nowloca objectAtIndex:i] forKey:@"nowLoc"];
            [arrGreen addObject:green];
            [typeDic setValue:@"routeType" forKey:@"지선버스"];
        } else if ([(NSString *)sorted_routeType[i] isEqualToString:@"지선(순환)"]) {
            
            NSMutableDictionary *yello = [[NSMutableDictionary alloc] init];
            [yello setObject:sorted_routeNo[i] forKey:@"routeNo"];
            [yello setObject:sorted_routeId[i] forKey:@"routeId"];
            [yello setObject:@"순환버스" forKey:@"routeType"];
            [yello setObject:[arrTime objectAtIndex:i] forKey:@"arrMin"];
            [yello setObject:[nowloca objectAtIndex:i] forKey:@"nowLoc"];
            [arrYello addObject:yello];
            [typeDic setValue:@"routeType" forKey:@"순환버스"];
        } else if ([(NSString *)sorted_routeType[i] isEqualToString:@"급행간선"]) {
            
            NSMutableDictionary *puple = [[NSMutableDictionary alloc] init];
            [puple setObject:sorted_routeNo[i] forKey:@"routeNo"];
            [puple setObject:sorted_routeId[i] forKey:@"routeId"];
            [puple setObject:@"급행간선버스" forKey:@"routeType"];
            [puple setObject:[arrTime objectAtIndex:i] forKey:@"arrMin"];
            [puple setObject:[nowloca objectAtIndex:i] forKey:@"nowLoc"];
            [arrPuple addObject:puple];
            [typeDic setValue:@"routeType" forKey:@"급행간선버스"];
        }
    }
    
    NSArray *ar
    = [[typeDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    arrk = ar;
    for (int i =0; i<[ar count]; i++) {
         NSLog(@"KEY %@", [ar objectAtIndex:i]);
    }
    /*
    //NSLog(@"IS %d", [elements1 count]);
    for (int h = 0; h < [elements1 count]-1; h++) {
        if ([[arrMin objectAtIndex:h] intValue] <= 2 && [[arrMin objectAtIndex:h] intValue] != -1 && cnt != 0) {
            NSLog(@"TESTS %d %d", _cnt, cnt);
            if (_cnt < cnt) {
                soonArr = [soonArr stringByAppendingFormat:@"%@, ", sorted_routeNo[h]];
                _cnt++;
                continue;
            } else if (_cnt == cnt){
                soonArr = [soonArr stringByAppendingString:(NSString *)sorted_routeNo[h]];
                break;
            }
        } else if (cnt == 0){
            break;
        } else
            continue;
    }
     */
    //NSLog(@"len %d", [soonArr length]);
    if (cnt != 0) {
        soonArr = [soonArr substringToIndex:([soonArr length]-2)];
    }
    [tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    [self performSelectorOnMainThread:@selector(soonTxt) withObject:nil waitUntilDone:NO];
    //NSLog(@"%@", [soonArr substringToIndex:[soonArr length]-1]);
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //arrk = [[NSArray alloc] initWithObjects:@"간선버스", @"광역버스", @"좌석버스", @"지선버스", @"순환버스", @"급행간선버스", nil];
    return [arrk count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *key = [arrk objectAtIndex:section];
    return key;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *_key = [arrk objectAtIndex:section];
    
    if ([_key isEqualToString:@"간선버스"]) {
        return [arrBlue count];
    } else if ([_key isEqualToString:@"광역버스"]) {
        return [arrRed count];
    } else if ([_key isEqualToString:@"좌석버스"]) {
        return [arrGray count];
    } else if ([_key isEqualToString:@"지선버스"]) {
        return [arrGreen count];
    } else if ([_key isEqualToString:@"순환버스"]) {
        return [arrYello count];
    } else if ([_key isEqualToString:@"급행간선버스"]) {
        return [arrPuple count];
    } else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
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

    if ([[arrk objectAtIndex:[indexPath section]] isEqualToString:@"간선버스"]) {
        NSDictionary *dic = [arrBlue objectAtIndex:indexPath.row];
        _routeNo = [dic objectForKey:@"routeNo"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor blueColor]];
        time = [dic objectForKey:@"arrMin"];
        loc = [dic objectForKey:@"nowLoc"];
        //NSLog(@"간선%@ %@ %@", _routeNo, time, loc);
    } else if ([[arrk objectAtIndex:[indexPath section]] isEqualToString:@"광역버스"]) {
        NSDictionary *dic = [arrRed objectAtIndex:indexPath.row];
        _routeNo = [dic objectForKey:@"routeNo"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor redColor]];
        time = [dic objectForKey:@"arrMin"];
        loc = [dic objectForKey:@"nowLoc"];
        //NSLog(@"광역%@ %@ %@", _routeNo, time, loc);
    } else if ([[arrk objectAtIndex:[indexPath section]] isEqualToString:@"지선버스"]) {
        NSDictionary *dic = [arrGreen objectAtIndex:indexPath.row];
        _routeNo = [dic objectForKey:@"routeNo"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor greenColor]];
        time = [dic objectForKey:@"arrMin"];
        loc = [dic objectForKey:@"nowLoc"];
        //NSLog(@"지선%@ %@ %@", _routeNo, time, loc);
    } else if ([[arrk objectAtIndex:[indexPath section]] isEqualToString:@"좌석버스"]) {
        NSDictionary *dic = [arrGray objectAtIndex:indexPath.row];
        _routeNo = [dic objectForKey:@"routeNo"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor blackColor]];
        time = [dic objectForKey:@"arrMin"];
        loc = [dic objectForKey:@"nowLoc"];
        //NSLog(@"좌석%@ %@ %@", _routeNo, time, loc);
    } else if ([[arrk objectAtIndex:[indexPath section]] isEqualToString:@"순환버스"]) {
        NSDictionary *dic = [arrYello objectAtIndex:indexPath.row];
        _routeNo = [dic objectForKey:@"routeNo"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor orangeColor]];
        time = [dic objectForKey:@"arrMin"];
        loc = [dic objectForKey:@"nowLoc"];
        //NSLog(@"순환%@ %@ %@", _routeNo, time, loc);
    } else if ([[arrk objectAtIndex:[indexPath section]] isEqualToString:@"급행간선버스"]) {
        NSDictionary *dic = [arrPuple objectAtIndex:indexPath.row];
        _routeNo = [dic objectForKey:@"routeNo"];
        //routeNo = [routeNo arrayByAddingObject:[dics objectForKey:@"routeNumberKor"]];
        //[routeNo addObject:[dics objectForKey:@"routeNumberKor"]];
        [lable setTextColor:[UIColor purpleColor]];
        time = [dic objectForKey:@"arrMin"];
        loc = [dic objectForKey:@"nowLoc"];
        //NSLog(@"급행간선%@ %@ %@", _routeNo, time, loc);
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

- (void)soonTxt{
    //lbl.backgroundColor = [UIColor clearColor];
    [lbl setText:soonArr];
    [lbl setFont:[UIFont systemFontOfSize:20]];
    [lbl setTextAlignment:UITextAlignmentLeft];
    //[txv setText:soonArr];
}

- (void)setParameter:(NSString *)str :(NSString *)sId{
    url1 = str;
    url2 = sId;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
