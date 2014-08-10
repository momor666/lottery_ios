//
//  WinningShareVC.m
//  TOTO
//
//  Created by Chanh Minh Vo on 24/6/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import "WinningShareVC.h"

@interface WinningShareVC ()
@property (weak, nonatomic) IBOutlet UIButton *shareAmount1;
@property (weak, nonatomic) IBOutlet UIButton *shareAmount2;
@property (weak, nonatomic) IBOutlet UIButton *shareAmount3;
@property (weak, nonatomic) IBOutlet UIButton *shareAmount4;
@property (weak, nonatomic) IBOutlet UIButton *shareAmount5;
@property (weak, nonatomic) IBOutlet UIButton *shareAmount6;
@property (weak, nonatomic) IBOutlet UIButton *noOfShares1;
@property (weak, nonatomic) IBOutlet UIButton *noOfShares2;
@property (weak, nonatomic) IBOutlet UIButton *noOfShares3;
@property (weak, nonatomic) IBOutlet UIButton *noOfShares4;
@property (weak, nonatomic) IBOutlet UIButton *noOfShares5;
@property (weak, nonatomic) IBOutlet UIButton *noOfShares6;
@end

@implementation WinningShareVC
@synthesize shareAmount1;
@synthesize shareAmount2;
@synthesize shareAmount3;
@synthesize shareAmount4;
@synthesize shareAmount5;
@synthesize shareAmount6;

@synthesize noOfShares1;
@synthesize noOfShares2;
@synthesize noOfShares3;
@synthesize noOfShares4;
@synthesize noOfShares5;
@synthesize noOfShares6;

@synthesize resultSet = _resultSet;

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
    WinningPrizeGroup *temp = (WinningPrizeGroup *)[self.resultSet.winningPrizeGroups objectAtIndex:0];
    [self.shareAmount1 setTitle:[NSString stringWithFormat:@"%8f", temp.shareAmount] forState:UIControlStateNormal];
    [self.noOfShares1 setTitle:[NSString stringWithFormat:@"%d", temp.numberOfWinningShares] forState:UIControlStateNormal];
    
    temp = (WinningPrizeGroup *)[self.resultSet.winningPrizeGroups objectAtIndex:1];
    [self.shareAmount2 setTitle:[NSString stringWithFormat:@"%8f", temp.shareAmount] forState:UIControlStateNormal];
    [self.noOfShares2 setTitle:[NSString stringWithFormat:@"%d", temp.numberOfWinningShares] forState:UIControlStateNormal];
    
    temp = (WinningPrizeGroup *)[self.resultSet.winningPrizeGroups objectAtIndex:2];
    [self.shareAmount3 setTitle:[NSString stringWithFormat:@"%8f", temp.shareAmount] forState:UIControlStateNormal];
    [self.noOfShares3 setTitle:[NSString stringWithFormat:@"%d", temp.numberOfWinningShares] forState:UIControlStateNormal];
    
    temp = (WinningPrizeGroup *)[self.resultSet.winningPrizeGroups objectAtIndex:3];
    [self.shareAmount4 setTitle:[NSString stringWithFormat:@"%8f", temp.shareAmount] forState:UIControlStateNormal];
    [self.noOfShares4 setTitle:[NSString stringWithFormat:@"%d", temp.numberOfWinningShares] forState:UIControlStateNormal];
    
    temp = (WinningPrizeGroup *)[self.resultSet.winningPrizeGroups objectAtIndex:4];
    [self.shareAmount5 setTitle:[NSString stringWithFormat:@"%8f", temp.shareAmount] forState:UIControlStateNormal];
    [self.noOfShares5 setTitle:[NSString stringWithFormat:@"%d", temp.numberOfWinningShares] forState:UIControlStateNormal];
    
    temp = (WinningPrizeGroup *)[self.resultSet.winningPrizeGroups objectAtIndex:5];
    [self.shareAmount6 setTitle:[NSString stringWithFormat:@"%8f", temp.shareAmount] forState:UIControlStateNormal];
    [self.noOfShares6 setTitle:[NSString stringWithFormat:@"%d", temp.numberOfWinningShares] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
