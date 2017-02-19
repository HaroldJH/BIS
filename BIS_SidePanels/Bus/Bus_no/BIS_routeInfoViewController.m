//
//  BIS_routeInfoViewController.m
//  BIS
//
//  Created by Harold Jinho Yi on 9/16/13.
//
//

#import "BIS_routeInfoViewController.h"

@interface BIS_routeInfoViewController ()

@end

@implementation BIS_routeInfoViewController

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
    UIView *view = [[UIView alloc] init];
    [self.navigationController.navigationBar setTranslucent:NO];
    view1 = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 10.0f, self.view.frame.size.width, 60.0f)];
    [view1 setBackgroundColor:[UIColor whiteColor]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setText];
    
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, self.view.frame.size.width, self.view.frame.size.height - 150.0f) style:UITableViewStyleGrouped];
    [tv setRowHeight:50];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setBackgroundView:view];
    [tv setBackgroundColor:[UIColor whiteColor]];
    [imgv setFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 60.0f)];
    [imgv setBackgroundColor:[UIColor whiteColor]];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"route" style:UIBarButtonItemStylePlain target:self action:@selector(buttonEvent)];
    self.navigationItem.rightBarButtonItem = bar;
    
    [self.view addSubview:tv];
    [self resultDB];
}

- (void) setText{
    
    NSString *temp = [Single returnType];
    UILabel *lbl;
    UILabel *lbl2;
    
    switch ([Single returnRegion]) {
        case 2:
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(175.0f, 5.0f, self.view.frame.size.width, 60.0f)];
            lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(175.0f, 45.0f, self.view.frame.size.width, 60.0f)];
            break;
            
        case 0:
        case 1:
            lbl = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 5.0f, self.view.frame.size.width, 60.0f)];
            lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 45.0f, self.view.frame.size.width, 60.0f)];
            break;
    }
    
    if ([temp isEqualToString:RED] || [temp isEqualToString:REDM] || [temp isEqualToString:REDG]) {
        [lbl setTextColor:[UIColor redColor]];
    } else if ([temp isEqualToString:BLUE] || [temp isEqualToString:BLUEG]){
        [lbl setTextColor:[UIColor blueColor]];
    } else if ([temp isEqualToString:GREEN] || [temp isEqualToString:GREENG]) {
        [lbl setTextColor:[UIColor greenColor]];
    } else if ([temp isEqualToString:PURPLE] || [temp isEqualToString:PURPLEG] || [temp isEqualToString:PURPLET]) {
        [lbl setTextColor:[UIColor purpleColor]];
    } else if ([temp isEqualToString:ORANGE]) {
        [lbl setTextColor:[UIColor orangeColor]];
    } else if ([temp isEqualToString:CYAN]) {
        [lbl setTextColor:[UIColor cyanColor]];
    }
    
    if ([temp isEqualToString:PURPLET] || [temp isEqualToString:BLUEG]) {
        temp = @"좌석버스";
    }
    
    //NSLog(@"temp %@", temp);
    [lbl2 setText:temp];
    [lbl setText:[Single returnNo]];
    //[lbl setTextAlignment:UITextAlignmentRight];
    [lbl setFont:[UIFont systemFontOfSize:35]];
    [view1 addSubview:lbl2];
    [view1 addSubview:lbl];
}

#pragma mark - Button Actions
- (void)buttonEvent {
    switch (region) {
        case 0:
        {
            SL_Stn_listViewController *list = [[SL_Stn_listViewController alloc] init];
            [self.navigationController pushViewController:list animated:YES];
            break;
        }
        case 1:
        {
            SL_Stn_listViewController *list = [[SL_Stn_listViewController alloc] init];
            [self.navigationController pushViewController:list animated:YES];
            break;
        }
        case 2:
        {
            ICN_Stn_listViewController *list = [[ICN_Stn_listViewController alloc] init];
            [self.navigationController pushViewController:list animated:YES];
            break;
        }
    }
}

- (void)resultDB{
    SQLiteManage *sqliteMgr = [[SQLiteManage alloc] init];
    NSString *routeJson;
    NSString *routeRegion;
    UIImage *img = [[UIImage alloc] init];
    
    if ([sqliteMgr open]) {
        
        NSString *SQLstring = @"SELECT * FROM routeinfo WHERE routeId = ";
        SQLstring = [SQLstring stringByAppendingFormat:@"%@", [Single returnId]];
        
        NSArray *id_getArray = [sqliteMgr executeQuery:SQLstring];
        for (int i = 0; i < [id_getArray count]; i++) {
            routeJson = [[id_getArray objectAtIndex:i] objectForKey:@"json"];
            routeRegion = [[id_getArray objectAtIndex:i] objectForKey:@"region"];
            //NSLog(@"JSON %@", routeJson);
        }
        
        switch ([routeRegion intValue]) {
            case 0:
                img = [UIImage imageNamed:@"seoul.png"];
                region = [routeRegion intValue];
                break;
                
            case 1:
                img = [UIImage imageNamed:@"gg.png"];
                region = [routeRegion intValue];
                break;
                
            case 2:
                img = [UIImage imageNamed:@"ICN.png"];
                region = [routeRegion intValue];
                break;
        }
        
        imgv = [[UIImageView alloc] initWithImage:img];
        [view1 addSubview:imgv];
        [self.view addSubview:view1];
        SBJsonParser *jsonParse = [[SBJsonParser alloc] init];
        dic = (NSDictionary *)[jsonParse objectWithString:routeJson];
        NSArray *arr = [dic allKeys];
        key = arr;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [key count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[dic objectForKey:[key objectAtIndex:section]] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *temp = [key objectAtIndex:section];
    if([temp isEqualToString:@"general"]){
        return @"일반";
    } else if([temp isEqualToString:@"company"]){
        return @"운수업체";
    } else if([temp isEqualToString:@"end"]){
        return @"종점";
    } else if([temp isEqualToString:@"gap"]){
        return @"배차간격";
    } else if([temp isEqualToString:@"start"]){
        return @"기점";
    } else
        return @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 15.0f, 300.0f, 18.0f)];
    [lable2 setBackgroundColor:[UIColor clearColor]];
    [lable2 setNumberOfLines:1];
    [lable2 setTextAlignment:UITextAlignmentRight];
    NSMutableArray *tempk = (NSMutableArray *)[[dic objectForKey:[key objectAtIndex:[indexPath section]]] allKeys];
    NSString *tempstr;
    if ([[tempk objectAtIndex:[indexPath row]] isEqualToString:@"service"]) {
            tempstr = @"운행 시간";
        //tempk[[indexPath row]] = @"운행 시간";
    }   else if ([[tempk objectAtIndex:[indexPath row]] isEqualToString:@"serviceLow"]) {
        tempstr = @"운행 시간(저상)";
        //tempk[[indexPath row]] = @"종점";
    }   else if ([[tempk objectAtIndex:[indexPath row]] isEqualToString:@"end"]) {
            tempstr = @"종점";
        //tempk[[indexPath row]] = @"종점";
    }  else if ([[tempk objectAtIndex:[indexPath row]] isEqualToString:@"gap"]) {
            tempstr = @"배차 간격";
        //tempk[[indexPath row]] = @"배차 간격";
    }  else if ([[tempk objectAtIndex:[indexPath row]] isEqualToString:@"start"]) {
            tempstr = @"기점";
        //tempk[[indexPath row]] = @"기점";
    }  else if ([[tempk objectAtIndex:[indexPath row]] isEqualToString:@"length"]) {
            tempstr = @"운행 거리";
        //tempk[[indexPath row]] = @"운행 거리";
    }   else if ([[tempk objectAtIndex:[indexPath row]] isEqualToString:@"name"]) {
            tempstr = @"운수 업체";
        //tempk[[indexPath row]] = @"운행 거리";
    }   else if ([[tempk objectAtIndex:[indexPath row]] isEqualToString:@"tel"]) {
            tempstr = @"연락처";
        //tempk[[indexPath row]] = @"운행 거리";
    }   else
            tempstr = @"";

    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 15.0, 300, 18)];
    [lable setBackgroundColor:[UIColor clearColor]];
    [lable setNumberOfLines:1];
    [lable setText:[NSString stringWithFormat:@"%@", tempstr]];
    
    switch ([indexPath section]) {
        case 0:
        {
            //NSLog(@"%@ %@", [tempk objectAtIndex:[indexPath row]], [[dic objectForKey:[key objectAtIndex:[indexPath section]]] objectForKey:tempk[[indexPath row]]]);
            NSString *value = [[dic objectForKey:[key objectAtIndex:[indexPath section]]] objectForKey:tempk[[indexPath row]]];
            [lable2 setText:[NSString stringWithFormat:@"%@", value]];
            break;
        }
        case 1:
        {
            //NSLog(@"%@ %@", [tempk objectAtIndex:[indexPath row]], [[dic objectForKey:[key objectAtIndex:[indexPath section]]] objectForKey:tempk[[indexPath row]]]);
            NSString *value = [[dic objectForKey:[key objectAtIndex:[indexPath section]]] objectForKey:tempk[[indexPath row]]];
            [lable2 setText:[NSString stringWithFormat:@"%@", value]];
            break;
        }
        case 2:
        {
            //NSLog(@"%@ %@", [tempk objectAtIndex:[indexPath row]], [[dic objectForKey:[key objectAtIndex:[indexPath section]]] objectForKey:tempk[[indexPath row]]]);
            NSString *value = [[dic objectForKey:[key objectAtIndex:[indexPath section]]] objectForKey:tempk[[indexPath row]]];
            [lable2 setText:[NSString stringWithFormat:@"%@", value]];
            break;
        }
        case 3:
        {
            //NSLog(@"%@ %@", [tempk objectAtIndex:[indexPath row]], [[dic objectForKey:[key objectAtIndex:[indexPath section]]] objectForKey:tempk[[indexPath row]]]);
            NSString *value = [[dic objectForKey:[key objectAtIndex:[indexPath section]]] objectForKey:tempk[[indexPath row]]];
            [lable2 setText:[NSString stringWithFormat:@"%@", value]];
            break;
        }
    }
    [cell addSubview:lable];
    [cell addSubview:lable2];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
