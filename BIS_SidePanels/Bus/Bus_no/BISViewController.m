//
//  BISViewController.m
//  BIS
//
//  Created by Harold Jinho YI on 13. 7. 1..
//
//

#import "BISViewController.h"

@interface BISViewController ()

@end

@implementation BISViewController

- (void)searchBarTextDidBeginEditing:(UISearchBar *)theSearchBar{
    
    searching = YES;
    letUserSelectRow = NO;
    //self.tableView.scrollEnabled = NO;
    
    //Add the Done Button
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneSearching_Clicked:)];
}

- (void)searchBar:(UISearchBar *)theSearchBar textDidChange:(NSString *)searchText{
    //Remove allobjects first.
    [copyListItems removeAllObjects];
    [copyListItems1 removeAllObjects];
    [copyListItems2 removeAllObjects];
    
    if ([searchText length] > 0) {
        searching = YES;
        letUserSelectRow = YES;
        _searchText = searchText;
        NSLog(@"%@", searchText);
        
        //self.tableView.scrollEnabled = YES;
        //[self searchTabView];
        
        dispatch_queue_t queue = dispatch_queue_create(NULL, NULL);
        dispatch_semaphore_t exeSig = dispatch_semaphore_create(2);
        dispatch_async(queue, ^{
            dispatch_semaphore_wait(exeSig, DISPATCH_TIME_FOREVER);
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 여기서 조회된 데이터가 출력됩니다.
                dispatch_semaphore_signal(exeSig);
                [self findEntityList];
                //[NSThread sleepForTimeInterval:0.1];
                dispatch_async(queue, ^{
                    
                    dispatch_async(dispatch_get_main_queue(), ^ {
                        
                        // 여기서 조회된 데이터가 출력됩니다.
                        dispatch_semaphore_signal(exeSig);
                        [tv reloadData];
                    });
                });
            });
        });
        
    } else {
        searching = NO;
        letUserSelectRow = NO;
        //tv.scrollEnabled = NO;
        [tv reloadData];
    }
    //[tv reloadData];
    //[self.nextResponder touchesBegan:touches withEvent:event];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //[[self nextResponder] touchesBegan:touches withEvent:event];
    //[super touchesBegan:touches withEvent:event];
    NSLog(@"TOUCHES");
    [self.view endEditing:YES];
    [tv resignFirstResponder];
    [searchBar resignFirstResponder];
}

-(void)keyboardWillHide:(NSNotification*)noti {
    NSLog(@"Keyboard will hide");
    //화면을 원래 상태로 되돌려줍니다.
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tv.contentInset = contentInsets;
    tv.scrollIndicatorInsets = contentInsets;
}

-(void)keyboardWasShown:(NSNotification*)noti
{
	NSLog(@"Keyboard was shown");
	
	NSDictionary* info = [noti userInfo];
	CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
	UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
	tv.contentInset = contentInsets;
	tv.scrollIndicatorInsets = contentInsets;
	
	// 현재 입력대기중인 텍스트필드가 inputText2일경우만 처리하기위해
	// 왜냐하면 inputText1은 키보드가 표시되는 위쪽에 있으므로 ...
	// (편의상 화면 Rotation은 없다고 가정했습니다.)
	if ( self.nTextField == 2 ) {
		CGRect aRect = self.view.frame;
		aRect.size.height -= kbSize.height; // 키보드의 높이만큼 빼줍니다.
		
		if ( !CGRectContainsPoint(aRect, searchBar.frame.origin)) {
			CGPoint scrollPoint = CGPointMake(0.0, searchBar.frame.origin.y-kbSize.height);
			[tv setContentOffset:scrollPoint animated:YES];
		}
	}
}

//Search in db
#pragma mark -
- (void)findEntityList {
    SQLiteManage *sqliteMgr = [[SQLiteManage alloc] init];
    
    if ([sqliteMgr open]) {
        
        NSString *SQLstring = @"SELECT * FROM route WHERE routeNumberKor like'%";
        
        SQLstring = [SQLstring stringByAppendingFormat:@"%@", _searchText];
        SQLstring = [SQLstring stringByAppendingFormat:@"%@ ORDER BY routeNumberKor ASC", @"%'"];
        
        NSArray *id_getArray = [sqliteMgr executeQuery:SQLstring];

        for(int i =0;i<[id_getArray count];i++){
            if ([[id_getArray[i] valueForKey:@"region"] intValue] == 0) {
                
                NSDictionary *routeSOL = [[NSDictionary alloc] initWithObjectsAndKeys:id_getArray[i], @"route", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"route" object:nil userInfo:routeSOL];
                [_dic setValue:@"A_SOL" forKey:@"A_SOL"];
                
            } else if ([[id_getArray[i] valueForKey:@"region"] intValue] == 1) {
                
                NSDictionary *routeGG = [[NSDictionary alloc] initWithObjectsAndKeys:id_getArray[i], @"route", nil];
                [_dic setValue:@"B_ICN" forKey:@"B_ICN"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"route" object:nil userInfo:routeGG];
                
            } else if ([[id_getArray[i] valueForKey:@"region"] intValue] == 2) {
                
                NSDictionary *routeICN = [[NSDictionary alloc] initWithObjectsAndKeys:id_getArray[i], @"route", nil];
                [_dic setValue:@"C_GG" forKey:@"C_GG"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"route" object:nil userInfo:routeICN];
            }
        }
    }
    
    NSArray *arr = [[_dic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    keys = arr;
}
/*
- (void)textfieldFinished:(id)sender{
    [tv resignFirstResponder];
    [searchBar resignFirstResponder];
}
    
- (void)backGroundTap:(id)sender{
    NSLog(@"TOUCHES");
    [self.view endEditing:YES];
    [tv resignFirstResponder];
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar{
    [tv resignFirstResponder];
    [searchBar resignFirstResponder];
}

- (void)searchTabView{
     
}
*/
- (void)recievSOL:(NSNotification *)noti {
    
    switch ([[[[noti userInfo] objectForKey:@"route"] objectForKey:@"region"] intValue]) {
        case 0:
        {
            NSDictionary *recievDic = [[NSDictionary alloc] initWithDictionary:[noti userInfo]];
            [copyListItems addObject:recievDic];
            break;
        }
            
        case 1:
        {
            NSDictionary *recievDic = [[NSDictionary alloc] initWithDictionary:[noti userInfo]];
            [copyListItems2 addObject:recievDic];
            break;
        }
            
        case 2:
        {
            NSDictionary *recievDic = [[NSDictionary alloc] initWithDictionary:[noti userInfo]];
            [copyListItems1 addObject:recievDic];
            break;
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recievSOL:) name:@"route" object:nil];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    copyListItems = [[NSMutableArray alloc] init];
    copyListItems1 = [[NSMutableArray alloc] init];
    copyListItems2 = [[NSMutableArray alloc] init];
    
    // 키보드 notification등록
    
    // 키보드가 보여질때를 위한 notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    // 키보드가 숨겨질때를 위한 notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    nTextField = 0;
    
    keys = [[NSArray alloc] init];
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, self.view.frame.size.width, (self.view.frame.size.height-40.0f)) style:UITableViewStyleGrouped];
    _dic = [[NSMutableDictionary alloc] init];
    
    [tv setRowHeight:50];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tv setSeparatorColor:[UIColor grayColor]];
    [self.view addSubview:tv];
    _searchText = @"";
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 45)];
    searchBar.delegate = self;
    searchBar.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:searchBar];
    //[searchBar keyboardType:UIKeyboardTypeNumberPad];
    //UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:searchBar];
    //self.navigationItem.leftBarButtonItem = barItem;
    
    //[self.view addSubview:searchBar];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (BOOL) textFieldShouldReturn:(UISearchBar *)searchBars {
    [self.view resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    key = [keys objectAtIndex:section];
    
    if ([key isEqualToString:@"A_SOL"]) {
        return [copyListItems count];
    } else if ([key isEqualToString:@"B_ICN"]) {
        return [copyListItems1 count];
    } else if ([key isEqualToString:@"C_GG"]) {
        return [copyListItems2 count];
    } else
        return 0;
}

- (NSArray *) sectionIndexTitlesForTableView:(UITableView *)tableView {
 	NSArray *key1 = [[NSArray alloc] initWithObjects:@"서울", @"인천", @"경기", nil];
	return key1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    key = [keys objectAtIndex:section];
    if ([key isEqualToString:@"A_SOL"]) {
        return @"서울";
    } else if ([key isEqualToString:@"B_ICN"]) {
        return @"인천";
    } else if ([key isEqualToString:@"C_GG"]) {
        return @"경기";
    } else
        return key;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dics = [[NSDictionary alloc] init];
    NSString *routeNo;
    
    if ([[keys objectAtIndex:[indexPath section]] isEqualToString:@"A_SOL"]) {
        NSDictionary *dic = [copyListItems objectAtIndex:indexPath.row];
        dics = [dic objectForKey:@"route"];
        routeNo = [dics objectForKey:@"routeNumberKor"];
    } else if ([[keys objectAtIndex:[indexPath section]] isEqualToString:@"B_ICN"]) {
        NSDictionary *dic = [copyListItems1 objectAtIndex:indexPath.row];
        dics = [dic objectForKey:@"route"];
        routeNo = [dics objectForKey:@"routeNumberKor"];
    } else if ([[keys objectAtIndex:[indexPath section]] isEqualToString:@"C_GG"]) {
        NSDictionary *dic = [copyListItems2 objectAtIndex:indexPath.row];
        dics = [dic objectForKey:@"route"];
        routeNo = [dics objectForKey:@"routeNumberKor"];
    }
    
    // Configure the cell...
            
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 7.0, 300, 18)];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setNumberOfLines:1];
    [lable setText:[NSString stringWithFormat:@"%@", routeNo]];
    
    NSString *region = [dics valueForKey:@"routeAdminKor"];
    int region_no = [[dics valueForKey:@"region"] intValue];
    int route_type_no = [[dics valueForKey:@"routeType"] intValue];
             
    switch (region_no) {
        case 0:
            switch (route_type_no) {
                case 01:
                    route_type = @"간선 버스";
                    [lable setTextColor:[UIColor blueColor]];
                    break;
             
                case 02:
                    route_type = @"순환 버스";
                    [lable setTextColor:[UIColor orangeColor]];
                    break;
             
                case 03:
                    route_type = @"공항리무진 버스";
                    [lable setTextColor:[UIColor cyanColor]];
                    break;
             
                case 04:
                    route_type = @"지선 버스";
                    [lable setTextColor:[UIColor greenColor]];
                    break;
             
                case 05:
                    route_type = @"광역 버스";
                    [lable setTextColor:[UIColor redColor]];
                    break;
             }
             break;
             
        case 1:
             switch (route_type_no) {
                 case 11:
                     route_type = @"일반 버스";
                     [lable setTextColor:[UIColor greenColor]];
                     break;
             
                 case 12:
                     route_type = @"좌석 버스";
                     [lable setTextColor:[UIColor blueColor]];
                     break;
             
                 case 13:
                     route_type = @"직행좌석 버스";
                     [lable setTextColor:[UIColor redColor]];
                     break;
             
                 case 14:
                     route_type = @"시외직행 버스";
                     [lable setTextColor:[UIColor purpleColor]];
                     break;
             
                 case 15:
                     route_type = @"공항리무진 버스";
                     [lable setTextColor:[UIColor cyanColor]];
                     break;
             
                 case 16:
                     route_type = @"광역급행(M) 버스";
                     [lable setTextColor:[UIColor redColor]];
                     break;
                }
                break;
             
        case 2:
            switch (route_type_no) {
                case 21:
                    route_type = @"간선 버스";
                    [lable setTextColor:[UIColor blueColor]];
                    break;
             
                case 22:
                    route_type = @"급행간선 버스";
                    [lable setTextColor:[UIColor purpleColor]];
                    break;
             
                case 23:
                    route_type = @"지선 버스";
                    [lable setTextColor:[UIColor greenColor]];
                    break;
             
                case 24:
                    route_type = @"좌석 버스";
                    [lable setTextColor:[UIColor purpleColor]];
                    break;
             
                case 25:
                    route_type = @"순환 버스";
                    [lable setTextColor:[UIColor orangeColor]];
                    break;
             
                case 26:
                    route_type = @"광역 버스";
                    [lable setTextColor:[UIColor redColor]];
                    break;
            }
        break;
    }
             
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(30, 28.0, 300, 18)];
    [lable2 setBackgroundColor:[UIColor clearColor]];
    [lable2 setNumberOfLines:1];
    [lable2 setFont:[UIFont systemFontOfSize:10]];
    
    if (region_no == 1)
        [lable2 setText:[NSString stringWithFormat:@"%@ (운행지역 : %@)", route_type, region]];
    
    else 
        [lable2 setText:[NSString stringWithFormat:@"%@", route_type]];
        
    
    [cell.contentView addSubview:lable2];
    [cell.contentView addSubview:lable];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //NSLog(@"SCROLL TEST");
    [self.view endEditing:YES];
    [tv resignFirstResponder];
    [searchBar resignFirstResponder];
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
    [self.view endEditing:YES];
    [tv resignFirstResponder];
    [searchBar resignFirstResponder];
    ICN_Stn_listViewController *stn_list_view = [[ICN_Stn_listViewController alloc] init];
    BIS_routeInfoViewController *routeInfoView = [[BIS_routeInfoViewController alloc] init];
    NSDictionary *dics = [[NSDictionary alloc] init];
    NSString *routeNo;
    NSString *routeId;
    
    switch ([indexPath section]) {
        case 0:
        {
            NSDictionary *dic = [copyListItems objectAtIndex:indexPath.row];
            dics = [dic objectForKey:@"route"];
            routeNo = [dics objectForKey:@"routeNumberKor"];
            routeId = [dics objectForKey:@"routeId"];
            break;
        }
        case 1:
        {
            NSDictionary *dic = [copyListItems1 objectAtIndex:indexPath.row];
            dics = [dic objectForKey:@"route"];
            routeNo = [dics objectForKey:@"routeNumberKor"];
            routeId = [dics objectForKey:@"routeId"];
            break;
        }
        case 2:
        {
            NSDictionary *dic = [copyListItems2 objectAtIndex:indexPath.row];
            dics = [dic objectForKey:@"route"];
            routeNo = [dics objectForKey:@"routeNumberKor"];
            routeId = [dics objectForKey:@"routeId"];
            break;
        }
    }

    int region_no = [[dics valueForKey:@"region"] intValue];
    int route_type_no = [[dics valueForKey:@"routeType"] intValue];
    
    switch (region_no) {
        case 0:
            switch (route_type_no) {
                case 01:
                    route_type = @"간선 버스";
                    break;
                    
                case 02:
                    route_type = @"순환 버스";
                    break;
                    
                case 03:
                    route_type = @"공항리무진 버스";
                    break;
                    
                case 04:
                    route_type = @"지선 버스";
                    break;
                    
                case 05:
                    route_type = @"광역 버스";
                    break;
            }
            break;
            
        case 1:
            switch (route_type_no) {
                case 11:
                    route_type = @"일반 버스";
                    break;
                    
                case 12:
                    route_type = @"좌석 버스(G)";
                    break;
                    
                case 13:
                    route_type = @"직행좌석 버스";
                    break;
                    
                case 14:
                    route_type = @"시외직행 버스";
                    break;
                    
                case 15:
                    route_type = @"공항리무진 버스";
                    break;
                    
                case 16:
                    route_type = @"광역급행(M) 버스";
                    break;
            }
            break;
            
        case 2:
            switch (route_type_no) {
                case 21:
                    route_type = @"간선 버스";
                    break;
                    
                case 22:
                    route_type = @"급행간선 버스";
                    break;
                    
                case 23:
                    route_type = @"지선 버스";
                    break;
                    
                case 24:
                    route_type = @"좌석 버스(I)";
                    break;
                    
                case 25:
                    route_type = @"순환 버스";
                    break;
                    
                case 26:
                    route_type = @"광역 버스";
                    break;
            }
            break;
    }
    
    [Single saveRegion:region_no];
    [Single saveId:routeId];
    [Single saveNo:routeNo];
    [Single saveType:route_type];
    [stn_list_view setIdnNo:routeId :routeNo];
    //[self.navigationController pushViewController:stn_list_view animated:YES];
    [self.navigationController pushViewController:routeInfoView animated:YES];
}

@end
