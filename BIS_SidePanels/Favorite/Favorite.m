/*
 Copyright (c) 2012 Jesse Andersen. All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 If you happen to meet one of the copyright holders in a bar you are obligated
 to buy them one pint of beer.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 
 Edited by Harold Jinho YI at 21 June 2013
 */

#import "Favorite.h"

@interface Favorite ()

@end

@implementation Favorite

- (id)init {
    if (self = [super init]) {
        self.title = @"Favorite";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    data = [NSMutableArray new];
    
    [data addObject:@"1st"];
    [data addObject:@"2nd"];
    [data addObject:@"3rd"];
    [data addObject:@"4th"];
    [data addObject:@"5th"];
   
    tv = [[UITableView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
    
    [tv setRowHeight:50];
    [tv setDataSource:self];
    [tv setDelegate:self];
    [tv setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [tv setSeparatorColor:[UIColor grayColor]];
    [self.view addSubview:tv];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [data count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    
    NSString *str = (NSString *)[NSMutableDictionary new];
    str = [data objectAtIndex:indexPath.row];
    
    {
        UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 300, 18)];
        [lable setBackgroundColor:[UIColor clearColor ]];
        [lable setNumberOfLines:1];
        [lable setFont:[UIFont systemFontOfSize:14]];
        [lable setText:str];
        [cell.contentView addSubview:lable];
    }
    return cell;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)dealloc {
    //[super dealloc];
}
@end
