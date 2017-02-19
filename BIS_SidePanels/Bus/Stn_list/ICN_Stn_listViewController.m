//
//  BIS_Bus_no_ViewController.m
//  BIS
//
//  Created by Harold Jinho YI on 13. 6. 21..
//
//

#import "ICN_Stn_listViewController.h"
#import "XPathQuery.h"
#import "TFHppleElement.h"
#import "TFHpple.h"
@interface ICN_Stn_listViewController ()
@end

@implementation ICN_Stn_listViewController
@synthesize data = _data;
@synthesize indicator = _indicator;
@synthesize lbl = _lbl;
static NSString *_routeId, *_routeNo;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController.navigationBar setTranslucent:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievObj:) name:@"routeObj" object:nil];
    self.navigationItem.title = [@"" stringByAppendingString:@"데이터 수신 중"];
    self.view.backgroundColor = [UIColor whiteColor];
    indicator = [[UIActivityIndicatorView alloc] init];
    indicator = [[UIActivityIndicatorView alloc] init];
    [indicator hidesWhenStopped];
    [indicator startAnimating];
    [indicator setFrame:CGRectMake(self.view.frame.size.width/2 - 20.0f, self.view.frame.size.height/4 + 60.0f, 100.0f, 100.0f)];
    [self.view addSubview:indicator];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0.0f, self.view.frame.size.width, self.view.frame.size.height - 40.f)];
    
    [tv setRowHeight:50];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tv setSeparatorColor:[UIColor grayColor]];
    lbl = [[UILabel alloc] init];
    [lbl setText:@"데이터 로딩중입니다."];
    [lbl setTextAlignment:UITextAlignmentCenter];
    [lbl setFrame:CGRectMake(0, self.view.frame.size.height/5, self.view.frame.size.width, self.view.frame.size.height/2)];
    [lbl setFont:[UIFont systemFontOfSize:60]];
    [lbl setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:lbl];
    NSString *url;
   
   // NSLog(@"%@, %@", route_no, route_id);
    url = @"http://bus.incheon.go.kr/iwcm/retrieverouteruninfolist.laf?routenm=";
    url = [[[url stringByAppendingString:_routeNo] stringByAppendingString:@"&routeid="] stringByAppendingString:_routeId];
    //[Single saveRouteNum:route_no];
    NSLog(@"%@", url);
    [NSThread detachNewThreadSelector:@selector(getData:) toTarget:self withObject:url];
}

- (void)recievObj:(NSNotification *)noti {
    NSDictionary *recievDic = [[NSDictionary alloc] initWithDictionary:[noti userInfo]];
    [data addObject:recievDic];
    [tv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
}

- (void)getData:(NSString *)url {
    
    NSString *htmlUrl = [NSString stringWithContentsOfURL:[NSURL URLWithString:url] encoding:-2147481280 error:nil];
    NSData *htmlData = [htmlUrl dataUsingEncoding:NSUnicodeStringEncoding];
    if (htmlData) {
        TFHpple *xpathParser = [[TFHpple alloc] initWithHTMLData:htmlData];
        NSArray *elements = [xpathParser searchWithXPathQuery:@"//*"];
        
        //NSLog(@"%@", elements[0]);
        //NSLog(@"test");
        NSString *titleOfAlips;
        for(int i=0;i<[elements count];i++){
            TFHppleElement *element = [elements objectAtIndex:i];
            if([[element firstChild] content] != NULL){
                titleOfAlips = [[element firstChild] content];
                //NSLog(@"%@", titleOfAlips);
            }
        }
        [self drawRoute:titleOfAlips];
        [self performSelectorOnMainThread:@selector(drawTable) withObject:titleOfAlips waitUntilDone:YES];
    } else if (!htmlData){
        //[txtV setText:@"데이터 로딩 실패! 네트워크 연결 확인해주세요"];
        [self performSelectorOnMainThread:@selector(failLoading:) withObject:@"FAIL" waitUntilDone:YES];
    }
}

- (void)failLoading:(NSString *)msg {
    if ([msg isEqual: @"FAIL"]) {
        [lbl setText:@"데이터 로딩 실패!\n 네트워크 연결 확인해주세요"];
        [lbl setNumberOfLines:0];
        [indicator stopAnimating];
    }
}

- (void) drawTable {
    [self.view addSubview:tv];
}

- (void)drawRoute:(NSString *)titleOfAlips{

    //url = @"http://bus.incheon.go.kr/iwcm/retrieverouteruninfolist.laf?routenm=111-2-1&routeid=165000180";
    
    data = [[NSMutableArray alloc] init];
    if (![titleOfAlips rangeOfString:@"routeData="].length) {
        [self failLoading:@"FAIL"];
    } else{
    
    NSArray *items = [titleOfAlips componentsSeparatedByString:@"||"];
        
    NSString *stn = (NSString *)items[0];
    stn = [stn substringFromIndex:10];
    NSArray *stn_list = [stn componentsSeparatedByString:@"|"];
    NSArray *stn_str;
    NSArray *stn_name[[stn_list count]];
    NSArray *stn_id[[stn_list count]];
    NSArray *stn_YN[[stn_list count]];
    NSArray *stn_no[[stn_list count]];
    
    NSString *bus_no = (NSString *) items[4];
    NSArray *bus_no_list = [bus_no componentsSeparatedByString:@"|"];
    NSArray *bus_no_str;
    NSArray *bus_no_array[[bus_no_list count]];
    NSArray *bus_no_locate[[bus_no_list count]];
    
    NSString *bus_traffic = (NSString*)items[3];
    NSArray *bus_traffic_list = [bus_traffic componentsSeparatedByString:@"|"];
    NSArray *bus_traffic_array;
    NSArray *traffic_color[[bus_traffic_list count]];
    NSArray *traffic_no[[bus_traffic_list count]];
    
    for (int i=0; i<[bus_no_list count]; i++) {
        if ([items count] == 6) {
            bus_no_str = [bus_no_list[i] componentsSeparatedByString:@";"];
            bus_no_array[i] = bus_no_str[0];
            bus_no_locate[i] = bus_no_str[2];
            
            NSString *str = (NSString *)[(NSString *)bus_no_array[i] substringToIndex:2];
            NSString *str1 = (NSString *)[(NSString *)bus_no_array[i] substringFromIndex:3];
            
            char chr = [(NSString *)bus_no_array[i] characterAtIndex:2];
            
            if(chr == '1')
                bus_no_array[i] = (NSArray *)[@"" stringByAppendingFormat:@"인천%@바%@", str, str1];
            
            else if (chr == '3')
                bus_no_array[i] = (NSArray *)[@"" stringByAppendingFormat:@"인천%@아%@", str, str1];
        }
    }
    //NSString *route_no = [Single returnRouteNum];
    
    for(int i=0;i<[bus_traffic_list count];i++){
        bus_traffic_array = [bus_traffic_list[i] componentsSeparatedByString:@";"];
        traffic_color[i] = bus_traffic_array[2];
        traffic_no[i] = bus_traffic_array[0];
        //NSLog(@"%@", traffic_no[i]);
    }
        
    for (int i=0; i<[stn_list count]; i++) {
        stn_str = [stn_list[i] componentsSeparatedByString:@";"];
        stn_name[i] = stn_str[2];
        stn_id[i] = stn_str[1];
        stn_YN[i] = stn_str[3];
        stn_no[i] = stn_str[0];
        
        if ([stn_YN[i] isEqual: @"1"] && ([stn_name[i] isEqual: @"없음"] || [stn_name[i] isEqual: @"생성노드"])){
            stn_name[i] = (NSArray *)@"-";
        }
        else if ([stn_YN[i] isEqual: @"1"] && !([stn_name[i] isEqual: @"없음"] || [stn_name[i] isEqual: @"생성노드"])){
            stn_name[i] = (NSArray *)[(NSString *)stn_name[i] stringByAppendingFormat:@" %@", @"(경유)"];
        }
        
        NSDictionary *route = [[NSMutableDictionary alloc]init];
        
        for (int j = 0; j < [bus_traffic_list count] ; j++) {
            if (([(NSString *)traffic_no[j] intValue] == [(NSString *)stn_no[i] intValue])) {
                [route setValue:stn_no[i] forKey:@"bus_stn_no"];
                [route setValue:stn_name[i] forKey:@"bus_stn"];
                [route setValue:stn_YN[i] forKey:@"bus_stn_YN"];
                [route setValue:stn_id[i] forKey:@"bus_stn_id"];
                [route setValue:traffic_color[j] forKey:@"bus_traffic"];
                [route setValue:traffic_no[j] forKey:@"traffic_no"];
            }
        }
        //NSLog(@"%d", [traffic_no[i] count]);
        //NSLog(@"%@", traffic_no[i]);
        //NSDictionary *route = [[NSDictionary alloc] initWithObjectsAndKeys:stn_name[i], @"bus_stn", stn_YN[i], @"bus_stn_YN", traffic_color[i], @"bus_traffic", traffic_no[i], @"traffic_no", nil];
        for (int j=0; j<[bus_no_list count]; j++) {
            
            if([(NSString *)stn_no[i] intValue] == [(NSString *)bus_no_locate[j] intValue]){
                
                NSString *bstr = @"";
                
                if(j==0)
                    [route setValue:bus_no_array[j] forKey:@"bus_no"];
                    //[Str stringByAppendingFormat:@"%@;", bus_no_array[j]];
                
                else if (([(NSString *)bus_no_locate[j] intValue] == [(NSString *)bus_no_locate[j-1] intValue]) && j>0) {
                    if([bstr isEqual:@""])
                        bstr = [(NSString *)bus_no_array[j-1] stringByAppendingFormat:@", %@", bus_no_array[j]];
                    else if(![bstr isEqual:@""])
                        [bstr stringByAppendingFormat:@", %@", bus_no_array[j]];
                    [route setValue:bstr forKey:@"bus_no"];
                    //[Str stringByAppendingFormat:@"%@", bstr];
                    
                }
                
                else if ([(NSString *)bus_no_locate[j] intValue] != [(NSString *)bus_no_locate[j-1] intValue] && j>0){
                    bstr = (NSString *)bus_no_array[j];
                    [route setValue:bstr forKey:@"bus_no"];
                    //[Str stringByAppendingFormat:@"%@", bstr];
                }
                
            }
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"routeObj" object:nil userInfo:route];
        //[data addObject:route];
        
    }
        //if ([items count] == 5) {
        //  self.navigationItem.title = [_routeNo stringByAppendingString:@"번 노선(인천)(운행 중 차량이 없습니다.)"];
        //} else
        self.navigationItem.title = [_routeNo stringByAppendingString:@"번 노선(인천)"];
    [indicator stopAnimating];
    [lbl setText:@""];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *str;
    str = [data objectAtIndex:indexPath.row];
    if ([str valueForKey:@"bus_stn"] != NULL) {
        
    
    //NSLog(@"%@", str[0]);
    NSString *bus_traffic_color;
    
    {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 7.0, 300, 18)];
        [lable setBackgroundColor:[UIColor clearColor ]];
        [lable setNumberOfLines:1];
        [lable setText:[NSString stringWithFormat:@"%@", [str valueForKey:@"bus_stn"]]];
        if([(NSString *)[str valueForKey:@"bus_stn_no"] intValue] ==  [(NSString *)[str valueForKey:@"traffic_no"] intValue]){
            //NSLog(@"%d", [(NSString *)[str valueForKey:@"bus_stn_no"] intValue]);
            //NSLog(@"%d", [(NSString *)[str valueForKey:@"traffic_no"] intValue]);
            switch([[str valueForKey:@"bus_stn_YN"] intValue]){
                case 1:
                    [lable setTextColor:[UIColor grayColor]];
                    [lable setFont:[UIFont systemFontOfSize:10]];
                    switch ([(NSString *)[str valueForKey:@"bus_traffic"] intValue]) {
                        case 1:
                            bus_traffic_color = @"ico_realtime_green_small.png";
                            break;
                    
                        case 2:
                            bus_traffic_color = @"ico_realtime_orange_small.png";
                            break;
                    
                        case 3:
                            bus_traffic_color = @"ico_realtime_red_small.png";
                            break;
                    }break;
                case 2:{
                    [lable setFont:[UIFont systemFontOfSize:14]];
                    switch ([(NSString *)[str valueForKey:@"bus_traffic"] intValue]) {
                        case 1:
                            bus_traffic_color = @"ico_realtime_green.png";
                            break;
                    
                        case 2:
                            bus_traffic_color = @"ico_realtime_orange.png";
                            break;
                    
                        case 3:
                            bus_traffic_color = @"ico_realtime_red.png";
                            break;
                    }

                }break;
            }
        }
        [cell.contentView addSubview:lable];
    }
    
    {
        UIImage *img = [UIImage imageNamed:bus_traffic_color];
        UIImageView *iv;
        
        if([[[UIDevice currentDevice] model] isEqual:@"iPhone Simulator"] || [[[UIDevice currentDevice] model] isEqual:@"iPhone"])
            iv = [[UIImageView alloc] initWithFrame:CGRectMake(270, 0.0, 20, 50)];
        
        else if ([[[UIDevice currentDevice] model] isEqual:@"iPad Simulator"] || [[[UIDevice currentDevice] model] isEqual:@"iPad"])
            iv = [[UIImageView alloc] initWithFrame:CGRectMake(700, 0.0, 20, 50)];
        
        [iv setImage:img];
        [cell.contentView addSubview:iv];
    }
    
    {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 28.0, 300, 18)];
        [lable setBackgroundColor:[UIColor clearColor ]];
        [lable setNumberOfLines:1];
        [lable setFont:[UIFont systemFontOfSize:10]];
        
        if ([str valueForKey:@"bus_no"] == NULL)
            [lable setText:@""];
        else if ([str valueForKey:@"bus_no"] != NULL){
            [lable setText:[NSString stringWithFormat:@"%@", [str valueForKey:@"bus_no"]]];
        
            UIImage *img2 = [UIImage imageNamed:@"bus_blue.png"];
            UIImageView *iv;
            
            if([[[UIDevice currentDevice] model] isEqual:@"iPhone Simulator"] || [[[UIDevice currentDevice] model] isEqual:@"iPhone"])
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(260, 15.0, 40, 15)];
            
            else if ([[[UIDevice currentDevice] model] isEqual:@"iPad Simulator"] || [[[UIDevice currentDevice] model] isEqual:@"iPad"])
                 iv = [[UIImageView alloc] initWithFrame:CGRectMake(690, 15.0, 40, 15)];
            
            [iv setImage:img2];
            [cell.contentView addSubview:iv];
        }
        [cell.contentView addSubview:lable];
    }
    } else {
        //회색그려넣기
        NSLog(@"회색");
        
        UIImage *img = [UIImage imageNamed:@"ico_realtime_gray_small.png"];
        UIImageView *iv = [[UIImageView alloc] initWithImage:img];
        
        if([[[UIDevice currentDevice] model] isEqual:@"iPhone Simulator"] || [[[UIDevice currentDevice] model] isEqual:@"iPhone"])
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(270, 0.0, 20, 50)];
        
            
        else if ([[[UIDevice currentDevice] model] isEqual:@"iPad Simulator"] || [[[UIDevice currentDevice] model] isEqual:@"iPad"])
                iv = [[UIImageView alloc] initWithFrame:CGRectMake(700, 0.0, 20, 50)];
            
        //[iv setImage:img];
        [cell.contentView addSubview:iv];
    }
    return cell;
}

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    NSDictionary *str;
    str = [data objectAtIndex:indexPath.row];
    
    switch ([[str valueForKey:@"bus_stn_YN"] intValue]) {
        case 1:{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!" message:@"This isn't stn!\n Please select the other cell!" delegate:self cancelButtonTitle:@"OK!" otherButtonTitles:nil];
            [alert show];
            break;
        }
        case 2:{
            BIS_Stn_ICN_ArriveViewController *arrive = [[BIS_Stn_ICN_ArriveViewController alloc] init];
            NSString *string1 = @"http://bus.incheon.go.kr/iwcm/retrievebusstopcararriveinfo.laf?bstopid=";
            string1 = [string1 stringByAppendingString:[[str valueForKey:@"bus_stn_id"] stringByAppendingString:@"&routeid="]];
            string1 = [string1 stringByAppendingString:_routeId];
            
            NSString *string2 = @"http://bus.incheon.go.kr/iw/pda/03/retrievePdaRouteBstop.laf?nodeid=";
            string2 = [string2 stringByAppendingString:[str valueForKey:@"bus_stn_id"]];
            [arrive setParameter:string1 :string2];
            [self.navigationController pushViewController:arrive animated:YES];
            //arrive.modalPresentationStyle = UIModalPresentationPageSheet;
            //[self presentModalViewController:arrive animated:YES];
        }
            break;
    }
}

- (void)setIdnNo:(NSString *)routeId :(NSString *)routeNo{
    _routeNo = routeNo;
    _routeId = routeId;
}

@end
