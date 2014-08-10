//
//  WinningBoothsVC.h
//  TOTO
//
//  Created by Chanh Minh Vo on 28/6/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TOTOResultSet.h"
#import "Utilities.h"

@interface WinningBoothsVC : UIViewController

@property (nonatomic, weak) id <TOTOResultVCDelegate> delegate;
@property (nonatomic, strong) TOTOResultSet *resultSet;
@end
