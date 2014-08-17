//
//  WinningBoothsVC.m
//  TOTO
//
//  Created by Chanh Minh Vo on 28/6/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import "WinningBoothsVC.h"
#import <QuartzCore/QuartzCore.h>

@interface WinningBoothsVC ()
//- (IBAction)dismissVC:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WinningBoothsVC
NSString *const Group1LocationsTag = @"{Group1Locations}";
NSString *const Group2LocationsTag = @"{Group2Locations}";
NSString *const NewLineTag = @"\r\n";
NSString *const DisplayTemplate = @"<div style='font-family:Helvetica;'><div style='color:green;font-weight:600;'>Group 1</div>{Group1Locations}<br /><br /><div style='color:green;font-weight:600;'>Group 2</div>{Group2Locations}</div>";
NSString *const DataNotAvailable = @"Data not available";

@synthesize webView;
@synthesize delegate;
@synthesize resultSet;

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
    //self.navigationItem.hidesBackButton = YES;
//    self.lblLocation.layer.borderColor = [UIColor blackColor].CGColor;
//    self.lblLocation.layer.borderWidth = 2.0;
    
    NSString *temp = DisplayTemplate;
    WinningPrizeGroup *group1 = (WinningPrizeGroup *)[self.resultSet.winningPrizeGroups objectAtIndex:0];
    WinningPrizeGroup *group2 = (WinningPrizeGroup *)[self.resultSet.winningPrizeGroups objectAtIndex:1];
    NSString *finalValue1 = DataNotAvailable;
    NSString *finalValue2 = DataNotAvailable;
    
    if (group1 != nil)
        finalValue1 = [group1.winningBooths isKindOfClass:[NSNull class]] ? DataNotAvailable : group1.winningBooths;
    
    if (group2 != nil)
        finalValue2 = [group2.winningBooths isKindOfClass:[NSNull class]] ? DataNotAvailable : group2.winningBooths;
    
    temp = [temp stringByReplacingOccurrencesOfString:Group1LocationsTag withString:finalValue1];
    temp = [temp stringByReplacingOccurrencesOfString:Group2LocationsTag withString:finalValue2];
    temp = [temp stringByReplacingOccurrencesOfString:NewLineTag withString:@"<br />"];
    
    [webView loadHTMLString:temp baseURL:nil];
    [webView reload];
     
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (IBAction)dismissVC:(id)sender {
//    [self.delegate winningBoothDidCancel:self];
//}

@end

