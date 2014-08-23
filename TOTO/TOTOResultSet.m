//
//  TOTOResultSet.m
//  TOTO
//
//  Created by Chanh Minh Vo on 23/6/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//
#import "TOTOResultSet.h"
NSString * const DrawNumber = @"draw_number";
NSString * const Id = @"id";
NSString * const ResultDate = @"date";
NSString * const WinningNumbers = @"winning_numbers";
NSString * const AdditionalWinningNumber = @"additional_winning_number";
NSString * const WinningGroups = @"winning_groups";
NSString * const ShareAmountFormat = @"$%.0f";
NSString * const JackpotDate = @"jackpot_date_time";
NSString * const JackpotAmount = @"jackpot_result";

NSString * const GroupTier = @"group_tier";
NSString * const Amount = @"amount";
NSString * const NumOfWinningShares = @"num_of_winning_shares";
NSString * const WinningBooths = @"winning_booths";

@implementation TOTOResultSet
@synthesize resultDate;
@synthesize winningNumbers;
@synthesize winningNumber1;
@synthesize winningNumber2;
@synthesize winningNumber3;
@synthesize winningNumber4;
@synthesize winningNumber5;
@synthesize winningNumber6;
@synthesize additionalWinningNumber;
@synthesize jackpotAmount;
@synthesize jackpotDate;

@synthesize winningPrizeGroups;
@synthesize winningLocationsGroup1;
@synthesize winningLocationsGroup2;

+ (TOTOResultSet *) initWithDictionary:(NSDictionary *)dict {
    if (dict == nil || dict.count <=0)
        return nil;
    
    TOTOResultSet *result = [[super alloc] init];
    result.winningPrizeGroups = nil;
    NSString *value;
    for (NSString *key in dict)
    {
        if ([key isEqualToString:ResultDate]) {
            value = [dict objectForKey:key];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:@"yyyy-MM-dd"];
            result.resultDate = [df dateFromString: value];
        }
        else if ([key isEqualToString:WinningNumbers]) {
            value = [dict objectForKey:key];
            result.winningNumbers = [value componentsSeparatedByString:@","];
        }
        else if ([key isEqualToString:AdditionalWinningNumber]) {
            value = [dict objectForKey:key];
            result.additionalWinningNumber = [value intValue];
        }
        else if ([key isEqualToString:JackpotAmount]) {
            value = [dict objectForKey:key];
            if (![value isKindOfClass:[NSNull class]])
                result.jackpotAmount = [value intValue];
        }
        else if ([key isEqualToString:JackpotDate]) {
            value = [dict objectForKey:key];
            if (![value isKindOfClass:[NSNull class]])
                result.jackpotDate = value;
        }
        else if ([key isEqualToString:WinningGroups]) {
            NSArray *winGroups = (NSArray *) [dict objectForKey:key];
            if (winGroups != nil && winGroups.count > 0) {
                NSMutableArray *test = [[NSMutableArray alloc] init];
                for (NSDictionary *winGroup in winGroups) {
                    NSString *tier = [winGroup objectForKey:GroupTier];
                    NSString *shareAmount = [winGroup objectForKey:Amount];
                    NSString *noOfWinningShares = [winGroup objectForKey:NumOfWinningShares];
                    NSString *winningBooths = [winGroup objectForKey:WinningBooths];
                    NSString *processedValue = [value isKindOfClass:[NSNull class]] ? @"" : winningBooths;
                    [test addObject:[[WinningPrizeGroup alloc] initWithStringParameters:tier shareAmount:shareAmount numberOfWinningShares:noOfWinningShares winningBooths:processedValue]];
                }
                result.winningPrizeGroups = [test mutableCopy];
            }
        }
    }
    
    return result;
}

- (NSString *)getResultDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:self.resultDate];
    return dateString;
}

- (NSString *)getResultDateForDisplay {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd MMM yyyy (EEE)"];
    NSString *dateString = [dateFormatter stringFromDate:self.resultDate];
    return dateString;
}

- (NSString *)getWinningNumbersAsString {
    NSString *result = @"";
    for (int i=0; i<self.winningNumbers.count - 1; i++) {
        result = [result stringByAppendingString:[self.winningNumbers objectAtIndex:i]];
        result = [result stringByAppendingString:@" "];
    }
    result = [result stringByAppendingString:[self.winningNumbers objectAtIndex:5]];
    return result;
}

- (NSString *)getAdditionalNumbersAsString {
    NSString *result = [NSString stringWithFormat:@"%d", self.additionalWinningNumber];
    return result;
}

- (NSString *) getTotoResultAsStringForSms {
    NSString *result = [NSString stringWithFormat:@"Toto Result\r%@\r\rNumbers: %@\rAdditional: %@", [self getResultDate], [self getWinningNumbersAsString], [self getAdditionalNumbersAsString]];
    return result;
}

- (NSString *) getTotoResultAsStringForEmail {
    NSString *result = [NSString stringWithFormat:@"Draw Date: %@\n\r\n\rWinning Numbers: %@\n\rAdditional Number: %@", [self getResultDate], [self getWinningNumbersAsString], [self getAdditionalNumbersAsString]];
    return result;
}

+ (TOTOResultSet *)getResultAtUrl:(NSString *)url {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if (response != nil) {
        NSError *jsonParsingError = nil;
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:response options:0 error:&jsonParsingError];
        
        TOTOResultSet *temp = [[TOTOResultSet class] initWithDictionary:result];
        return temp;
    }

    return nil;
}

+ (TOTOResultSet *)getLatestResult {
    NSString *url = @"http://motailor.com/lottery/totoResult/getLatestResult";
    return [[TOTOResultSet class] getResultAtUrl:url];
}

- (TOTOResultSet *)getPreviousResult {
    NSString *url = @"http://motailor.com/lottery/totoResult/getPrevious/date/";
    url = [url stringByAppendingString:[self getResultDate]];
    return [[TOTOResultSet class] getResultAtUrl:url];
}

- (TOTOResultSet *)getNextResult {
    NSString *url = @"http://motailor.com/lottery/totoResult/getNext/date/";
    url = [url stringByAppendingString:[self getResultDate]];
    return [[TOTOResultSet class] getResultAtUrl:url];
}

+ (TOTOResultSet *)getResultForDate:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    
    NSString *url = @"http://motailor.com/lottery/totoResult/get/date/";
    url = [url stringByAppendingString:dateString];
    return [[TOTOResultSet class] getResultAtUrl:url];
}

@end

@implementation WinningPrizeGroup
@synthesize prizeGroup;
@synthesize numberOfWinningShares;
@synthesize shareAmount;
@synthesize winningBooths;

- (id)initWithPrizeGroup:(int)thePrizeGroup
             shareAmount:(double)theAmount
   numberOfWinningShares:(int)theShares
           winningBooths:(NSString *)theWinningBooths;

{
    self.prizeGroup = thePrizeGroup;
    self.shareAmount = theAmount;
    self.numberOfWinningShares = theShares;
    self.winningBooths = theWinningBooths;
    
    return self;
}

- (id)initWithStringParameters:(NSString *)thePrizeGroup
             shareAmount:(NSString *)amount
   numberOfWinningShares:(NSString *)shares
        winningBooths:(NSString *)theWinningBooths
{
    self.prizeGroup = [thePrizeGroup intValue];
    self.shareAmount = [amount doubleValue];
    self.numberOfWinningShares = (shares != nil && ![shares isKindOfClass:[NSNull class]]) ? [shares intValue] : 0;
    self.winningBooths = theWinningBooths;
    
    return self;
}
@end

@implementation WinningLocation
@synthesize prizeGroup;
@synthesize location;
@end

