//
//  PageAppVC.h
//  TOTO
//
//  Created by Chanh Minh Vo on 2/8/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface PageAppVC : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIActionSheetDelegate, MFMessageComposeViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) NSMutableArray *results;
@property (nonatomic) NSDate *date;
@end
