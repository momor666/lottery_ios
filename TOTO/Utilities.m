//
//  Utilities.m
//  TOTO
//
//  Created by Chanh Minh Vo on 29/6/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import "Utilities.h"

@implementation Utilities

// return 0 for Sunday, 1 for Monday
+ (DayOfWeek) dayOfWeek:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    if ([dateString isEqualToString:@"Sun"]) {
        return Sunday;
    }
    else if ([dateString isEqualToString:@"Mon"]) {
        return Monday;
    }
    else if ([dateString isEqualToString:@"Tues"]) {
        return Tuesday;
    }
    else if ([dateString isEqualToString:@"Wed"]) {
        return Wednesday;
    }
    else if ([dateString isEqualToString:@"Thu"]) {
        return Thursday;
    }
    else if ([dateString isEqualToString:@"Fri"]) {
        return Friday;
    }
    else {
        return Saturday;
    }
}

+ (NSString *)getResultDateForDisplay:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy (EEE)"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

+ (NSDate *)dateFromString:(NSString *)value {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSDate *result = [df dateFromString:value];
    
    return result;
}

+ (NSDate *)dateTimeFromString:(NSString *)value {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh24:mm:ss"];
    NSDate *result = [df dateFromString:value];
    
    return result;
}
@end
