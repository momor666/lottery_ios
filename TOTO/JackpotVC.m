//
//  JackpotVC.m
//  TOTO
//
//  Created by Chanh Minh Vo on 1/8/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import "JackpotVC.h"
#import "TOTOResultSet.h"
#import "Utilities.h"

@interface JackpotVC ()
@property (weak, nonatomic) IBOutlet UILabel *jackpotAmount;
@property (weak, nonatomic) IBOutlet UILabel *jackpotDate;
@property (weak, nonatomic) IBOutlet UILabel *jackpotTime;
- (IBAction)refreshNextJackpot:(id)sender;

@property (nonatomic, strong) TOTOResultSet *resultSet;
@end

@implementation JackpotVC
@synthesize jackpotAmount;
@synthesize jackpotDate;
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
    [self getResult];
    
}

- (void)getResult{
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGPoint aPoint;
    aPoint.x = self.view.bounds.size.width /2;
    aPoint.y = self.view.bounds.size.height/2;
    [spinner setCenter:aPoint];
    [spinner startAnimating];
    [self.view addSubview:spinner];
    
    NSURLRequest *request = nil;
    NSString *url = @"http://motailor.com/lottery/totoResult/getLatestResult";
    request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    dispatch_queue_t aQueue = dispatch_queue_create("GetResult", NULL);
    dispatch_async(aQueue, ^{
        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        NSError *jsonParsingError = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        
        if (result == nil || result.count <= 1) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [spinner removeFromSuperview];
            });
            return;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.resultSet = [TOTOResultSet initWithDictionary:result];
            self.jackpotAmount.text = [NSString localizedStringWithFormat:@"$%d", self.resultSet.jackpotAmount];
            NSString *datePart = [self.resultSet.jackpotDate substringToIndex:10];
            NSDate *date = [[Utilities class] dateFromString:datePart];
            self.jackpotDate.text = [[Utilities class] getResultDateForDisplay:date];
            NSString *saleClose = [self.resultSet.jackpotDate substringWithRange:NSMakeRange(11, 5)];
            self.jackpotTime.text = [@"Sales close at: " stringByAppendingString:saleClose];
            [spinner removeFromSuperview];
        });
    });
}

- (IBAction)refreshNextJackpot:(id)sender {
    [self getResult];
}
@end
