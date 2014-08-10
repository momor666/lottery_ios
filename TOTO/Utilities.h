//
//  Utilities.h
//  TOTO
//
//  Created by Chanh Minh Vo on 29/6/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DayOfWeek) {
    Sunday,
    Monday,
    Tuesday,
    Wednesday,
    Thursday,
    Friday,
    Saturday
};

@interface Utilities : NSObject
+ (DayOfWeek) dayOfWeek:(NSDate *)date;
+ (NSString *)getResultDateForDisplay:(NSDate *)date;
+ (NSDate *)dateFromString:(NSString *)value;
+ (NSDate *)dateTimeFromString:(NSString *)value;
@end

@class WinningBoothsVC;

@protocol TOTOResultVCDelegate <NSObject>
- (void)winningBoothDidCancel:(WinningBoothsVC *)controller;
@end