//
//  HotelTableViewController.m
//  PushingTableView
//
//  Created by 刘智月 on 2/15/16.
//  Copyright (c) 2016 zhiyue. All rights reserved.
//

#import "HotelTableViewController.h"
#import "HotelDetailsViewController.h"
#import "RestaurantTableViewController.h"

@interface HotelTableViewController ()

@end

@implementation HotelTableViewController{
    NSMutableArray * hotel_titles;
    NSMutableArray * hotel_addresses;
    NSMutableArray * hotel_imgs;
    NSMutableArray * hotel_review_cnts;
    NSMutableArray * hotel_ratings;
    NSMutableArray * hotel_review_list;
    
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    int retrievalSize = 5;
    
    //Example: return the top 2 sopt in New York City
    NSString* path  = [NSString stringWithFormat:@"%@%@%@", @"http://ec2-52-90-95-189.compute-1.amazonaws.com:8888/searchhotel?count",[NSString stringWithFormat:@"%i", retrievalSize], @"&category=hotel&city=newyork"];

    NSURL* url = [NSURL URLWithString:path];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    NSData* jsonData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
    NSArray* arrayResult =[dic objectForKey:@"result"];
    //arrayResult is a NSArray saving the JSON data. Each element is one row in database. You could find the detail of arrayResult by using the commented code in the next line
//    NSLog(@"%@", arrayResult);
    
    //Example: Get the first element of the JSON and print the title of it
//    NSDictionary* review_list = [resultDic objectForKey:@"review_list"];
//    NSLog(@"review_list in first element: %@", review_list);
//    NSLog(@"@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
//    NSLog(@"resultDic:%@", resultDic);
    
    if(!hotel_titles){
        hotel_titles = [[NSMutableArray alloc] init];
    }
    if(!hotel_imgs){
        hotel_imgs = [[NSMutableArray alloc] init];
    }
    if(!hotel_addresses){
        hotel_addresses = [[NSMutableArray alloc] init];
    }
    
    if(!hotel_review_cnts){
        hotel_review_cnts = [[NSMutableArray alloc] init];
    }
    if(!hotel_ratings){
        hotel_ratings = [[NSMutableArray alloc] init];
    }
    if(!hotel_review_list){
        hotel_review_list  = [[NSMutableArray alloc] init];
    }
    
    for (int i=0; i<retrievalSize; i++) {
        NSDictionary* resultDic = [arrayResult objectAtIndex:i];
        
        [hotel_titles addObject:[resultDic objectForKey:@"title"]];
        [hotel_addresses addObject:[resultDic objectForKey:@"address"]];
        [hotel_imgs addObject:[resultDic objectForKey:@"img_url"]];
        [hotel_review_cnts addObject:[resultDic objectForKey:@"review_count"]];
        [hotel_ratings addObject:[resultDic objectForKey:@"rating_string"]];
        [hotel_review_list addObject: [resultDic objectForKey:@"review_list"]];
        
    }
    
//    hotels = [NSMutableArray arrayWithObjects:@"Westin", @"Sheraton", @"Quarter Club", nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [hotel_titles count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *simpleTableIdentifier = @"HotelCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = [hotel_titles objectAtIndex:indexPath.row];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:@"showHotelDetail"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HotelDetailsViewController *destController = segue.destinationViewController;
        destController.hotelName = [hotel_titles objectAtIndex:indexPath.row];
        destController.hotelAddr = [hotel_addresses objectAtIndex:indexPath.row];
        destController.hotelImg = [hotel_imgs objectAtIndex:indexPath.row];
        destController.reviewCnt= [hotel_review_cnts objectAtIndex:indexPath.row];
        destController.hotelRating = [hotel_ratings objectAtIndex:indexPath.row];
        destController.hotelReviews = [hotel_review_list objectAtIndex:indexPath.row];
        destController.title = destController.hotelName;
    }else if([segue.identifier isEqualToString:@"passSelectedHotel2Restaurant"]){
        
        UINavigationController *navController = segue.destinationViewController;
        RestaurantTableViewController *dest =(RestaurantTableViewController*) navController.topViewController;
        dest.selectedHotels = @"westin";
        dest.selectedFlights = self.selectedFlights;
//        NSLog(@"%@", dest.selectedHotels);
//        NSLog(@"%@", dest.selectedFlights);
    }
}


@end
