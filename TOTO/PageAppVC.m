//
//  PageAppVC.m
//  TOTO
//
//  Created by Chanh Minh Vo on 2/8/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import "PageAppVC.h"
#import "TOTOResultVC.h"

@interface PageAppVC ()
- (IBAction)showActionSheet:(id)sender;
//- (IBAction)getLatest:(id)sender;
@property (nonatomic, strong) UIBarButtonItem *leftButton;
@end

@implementation PageAppVC
@synthesize leftButton;
@synthesize results = _results;
@synthesize date = _date;

- (void)setDate:(NSDate *)dateValue {
    // from Past Results TVC
    _date = dateValue;
    // replace refresh button on the navigation bar with Back button
    [self initializeContent];
}

- (void) initializeContent
{
    _results = [[NSMutableArray alloc] init];
    
    if (_date == nil) {
        TOTOResultSet *latest = [[TOTOResultSet class] getLatestResult];
        if (latest == nil) {
            [self showStatus:@"Computing" timeout:4.5];
        }
        else {
            [_results addObject:latest];
            _date = latest.resultDate;
            
            UIImage *refreshImage = [UIImage imageNamed:@"today_result.png"];
            if (refreshImage != nil) {
                UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:refreshImage style:UIBarButtonItemStyleBordered target:self action:@selector(getLatest:)];
                self.navigationItem.leftBarButtonItem = item;
            }
        }
    }
    else {
        TOTOResultSet *one = [[TOTOResultSet class] getResultForDate:_date];
        [_results addObject:one];
        
        self.navigationItem.leftBarButtonItem = leftButton;
    }
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObject:
                             [NSNumber numberWithInteger:UIPageViewControllerSpineLocationMin]
                                                        forKey: UIPageViewControllerOptionSpineLocationKey];
    
    _pageController = [[UIPageViewController alloc]
                       initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                       navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                       options: options];
    
    _pageController.dataSource = self;
    _pageController.delegate = self;
    [[_pageController view] setFrame:[[self view] bounds]];
    
    TOTOResultVC *initialViewController = [self viewControllerAtIndex:0];
    self.navigationItem.title = [initialViewController.resultSet getResultDateForDisplay];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageController setViewControllers:viewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    
    [self addChildViewController:_pageController];
    [[self view] addSubview:[_pageController view]];
    [_pageController didMoveToParentViewController:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    
    // save the left bar button
    leftButton = self.navigationItem.leftBarButtonItem;
    
    [self initializeContent];
    
}

- (TOTOResultVC *)viewControllerAtIndex:(NSUInteger)index
{
    // Return the data view controller for the given index.
    if (([self.results count] == 0) ||
        (index >= [self.results count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    /*
     ContentViewController *dataViewController =
     [[ContentViewController alloc] init];
     */
    
    TOTOResultVC *dataViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ResultScreen"];
    dataViewController.resultSet = _results[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(TOTOResultVC *)viewController
{
    return [_results indexOfObject:viewController.resultSet];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    TOTOResultVC *vc = (TOTOResultVC *)viewController;
    
    NSUInteger index = [self indexOfViewController:vc];
    if (index == NSNotFound) {
        return nil;
    }
    
    index--;
    if (index == -1) {
        index = 0;
        TOTOResultSet *nextResult = [vc.resultSet getNextResult];
        if (nextResult.resultDate == nil)
            return nil;
        else {
            NSArray *temp = [_results mutableCopy];
            _results = [[NSMutableArray alloc] init];
            [_results addObject:nextResult];
            for(int i=0; i<temp.count; i++) {
                [_results addObject:temp[i]];
            }
        }
    }
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    TOTOResultVC *vc = (TOTOResultVC *)viewController;
    
    NSUInteger index = [self indexOfViewController:vc];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.results count]) {
        TOTOResultSet *prevResult = [vc.resultSet getPreviousResult];
        if (prevResult == nil) {
            return nil;
            index--;
        }
        else
            [_results addObject:prevResult];
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return (UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown);
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    TOTOResultVC *vc =(TOTOResultVC *)_pageController.viewControllers[0];
    NSUInteger index = [self indexOfViewController:vc];
    self.navigationItem.title = [_results[index] getResultDateForDisplay];
}

- (IBAction)showActionSheet:(id)sender {
    UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select option:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:
                            @"SMS",
                            @"Email",
                            @"Copy to Clipboard",
                            nil];
    popup.tag = 1;
    [popup showInView:[UIApplication sharedApplication].keyWindow];
}

- (IBAction)getLatest:(id)sender {
    self.date = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    TOTOResultVC *vc =(TOTOResultVC *)_pageController.viewControllers[0];
    switch (actionSheet.tag) {
        case 1: {
            switch (buttonIndex) {
                case 0:
                    [self sendSms:[vc.resultSet getTotoResultAsStringForSms] recipientList:nil];
                    break;
                case 1:
                    NSLog(@"Email");
                    [self sendEmail];
                    break;
                case 2:
                    NSLog(@"Copy To Clipboard");
                    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                    pasteboard.string = [vc.resultSet getTotoResultAsStringForEmail];
                    break;
            }
        }
            break;
    }
}

- (void)sendSms:(NSString *)bodyOfMessage recipientList:(NSArray *)recipients {
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    if ([MFMessageComposeViewController canSendText]) {
        controller.body = bodyOfMessage;
        controller.recipients = nil;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

- (void)sendEmail {
    TOTOResultVC *vc =(TOTOResultVC *)_pageController.viewControllers[0];
    // From within your active view controller
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;
        
        [mailCont setSubject:@"Toto Result"];
        [mailCont setToRecipients:[NSArray arrayWithObject:@""]];
        [mailCont setMessageBody:[vc.resultSet getTotoResultAsStringForEmail] isHTML:NO];
        
        [self presentViewController:mailCont animated:YES completion:nil];
    }
}

- (void)showStatus:(NSString *)message timeout:(double)timeout {
    statusAlert = [[UIAlertView alloc] initWithTitle:nil
                                             message:message
                                            delegate:nil
                                   cancelButtonTitle:nil
                                   otherButtonTitles:nil];
    [statusAlert show];
    [NSTimer scheduledTimerWithTimeInterval:timeout
                                     target:self
                                   selector:@selector(timerExpired:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)timerExpired:(NSTimer *)timer {
    [statusAlert dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (result == MessageComposeResultCancelled)
        NSLog(@"Message cancelled");
    else if (result == MessageComposeResultSent)
        NSLog(@"Message sent");
    else
        NSLog(@"Message failed");
}

#pragma MFMailComposeViewControllerDelegate
// Then implement the delegate method
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
