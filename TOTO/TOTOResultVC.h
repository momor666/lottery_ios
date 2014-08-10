//
//  TOTOResultVC.h
//  TOTO
//
//  Created by Chanh Minh Vo on 26/6/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "TOTOResultSet.h"
#import "Utilities.h"

@interface TOTOResultVC : UIViewController <TOTOResultVCDelegate>
@property (nonatomic, strong) TOTOResultSet *resultSet;
@property (nonatomic, strong) UIBarButtonItem *actionItem;
@end
