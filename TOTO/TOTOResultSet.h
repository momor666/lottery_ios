//
//  TOTOResultSet.h
//  TOTO
//
//  Created by Chanh Minh Vo on 23/6/14.
//  Copyright (c) 2014 USV Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, GetResultType) {
    GetLatest,
    GetPrevious,
    GetNext
};


@interface TOTOResultSet : NSObject
extern NSString * const DrawNumber;
extern NSString * const Id;
extern NSString * const ResultDate;
extern NSString * const WinningNumbers;
extern NSString * const AdditionalWinningNumber;
extern NSString * const WinningGroups;
extern NSString * const ShareAmountFormat;
extern NSString * const JackpotDate;
extern NSString * const JackpotAmount;

extern NSString * const GroupTier;
extern NSString * const Amount;
extern NSString * const NumOfWinningShares;
extern NSString * const WinningBooths;

@property (nonatomic, retain) NSDate *resultDate;
@property (nonatomic, retain) NSArray *winningNumbers;
@property (nonatomic) int winningNumber1;
@property (nonatomic) int winningNumber2;
@property (nonatomic) int winningNumber3;
@property (nonatomic) int winningNumber4;
@property (nonatomic) int winningNumber5;
@property (nonatomic) int winningNumber6;
@property (nonatomic) int additionalWinningNumber;
@property (nonatomic) int jackpotAmount;
@property (nonatomic) NSString *jackpotDate;
@property (nonatomic, retain) NSArray *winningPrizeGroups;
@property (nonatomic, retain) NSString *winningLocationsGroup1;
@property (nonatomic, retain) NSString *winningLocationsGroup2;

- (NSString *)getResultDate;
- (NSString *)getResultDateForDisplay;
- (NSString *)getWinningNumbersAsString;
- (NSString *)getAdditionalNumbersAsString;
- (NSString *) getTotoResultAsStringForSms;
- (NSString *) getTotoResultAsStringForEmail;

+ (TOTOResultSet *) initWithDictionary:(NSDictionary *)dict;
+ (TOTOResultSet *)getResultAtUrl:(NSString *)url;
+ (TOTOResultSet *)getLatestResult;
+ (TOTOResultSet *)getResultForDate:(NSDate *)date;
- (TOTOResultSet *)getPreviousResult;
- (TOTOResultSet *)getNextResult;



@end

@interface WinningPrizeGroup : NSObject
@property int prizeGroup;
@property double shareAmount;
@property int numberOfWinningShares;
@property NSString *winningBooths;

- (id)initWithPrizeGroup:(int)thePrizeGroup
             shareAmount:(double)theAmount
   numberOfWinningShares:(int)theShares
           winningBooths:(NSString *)theWinningBooths;

- (id)initWithStringParameters:(NSString *)thePrizeGroup
                   shareAmount:(NSString *)amount
         numberOfWinningShares:(NSString *)shares
                 winningBooths:(NSString *)theWinningBooths;

@end

@interface WinningLocation : NSObject
@property int prizeGroup;
@property (nonatomic, retain) NSString * location;
@end