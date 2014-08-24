//
//  PastResultsTVC.m
//  TOTO
//
//  Created by Chanh Minh Vo on 3/7/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import "PastResultsTVC.h"
#import "TOTOResultVC.h"
#import "PageAppVC.h"

@interface PastResultsTVC ()
@property (nonatomic) int selectedRow;
@end

@implementation PastResultsTVC
@synthesize results = _results;
@synthesize selectedRow = _selectedRow;
bool _bAlertShown = false;

- (NSArray *)results
{
    if (!_results) {
        [self getAllResults];
    }
    return _results;
}

- (void)getAllResults
{
    UIActivityIndicatorView *spinner = [[Utilities class] getSpinner:self];
    [self.view addSubview:spinner];
    
    dispatch_queue_t aQueue = dispatch_queue_create("GetAllResult", NULL);
    dispatch_async(aQueue, ^{
        NSURL *url = [NSURL URLWithString:@"http://motailor.com/lottery/totoResult/get"];
        NSData *response = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            [spinner removeFromSuperview];
            [self.refreshControl endRefreshing];
            if (response == nil) {
                if (!_bAlertShown) {
                    [[Utilities class] showNoConnectionAlert:self];
                    _bAlertShown = true;
                }
            }
            else {
                NSError *jsonParsingError = nil;
                //NSDictionary *temp = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
                NSArray *resultsFromJson = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingAllowFragments error:&jsonParsingError];
                NSMutableArray *resultsTemp = [NSMutableArray array];
                for (NSString *result in resultsFromJson) {
                    [resultsTemp addObject:[[Utilities class] dateFromString:result]];
                }
                
                _results = [[NSArray alloc] initWithArray:resultsTemp];
                [self.tableView reloadData];
                [self.refreshControl endRefreshing];
            }
        });
    });
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIRefreshControl *refreshCtrl = [[UIRefreshControl alloc] init];
    refreshCtrl.tintColor = [[UIColor alloc] initWithRed:210.0/255 green:54.0/255 blue:45.0/255 alpha:100];
    [refreshCtrl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshCtrl;
}

- (void)refreshData {
    [self getAllResults];
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
    if (self.results != nil)
        return [self.results count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ResultDateCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (self.results != nil) {
        NSDate *resultDate = [self.results objectAtIndex:indexPath.row];
        if (resultDate != nil) {
            cell.textLabel.text = [[Utilities class] getResultDateForDisplay:resultDate];
        }
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    UIViewController *appVC = [self.navigationController.viewControllers lastObject];
    if ([appVC isKindOfClass:[PageAppVC class]]) {
        NSDate *resultDate = [self.results objectAtIndex:indexPath.row];
        ((PageAppVC *)appVC).date = resultDate;
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//{
//    if ([[segue identifier] isEqualToString:@"ShowPageVC"]) {
//        PageAppVC *appVC = (PageAppVC *) segue.destinationViewController;
//        NSDate *resultDate = [self.results objectAtIndex:_selectedRow];
//        appVC.date = resultDate;
//    }
//}

@end
