// 
//  APHScoring.h 
//  Share the Journey 
// 
//  Copyright (c) 2014 Apple, Inc. All rights reserved. 
// 
 
#import <Foundation/Foundation.h>

@import APCAppCore;

@interface APHScoring : NSEnumerator <APCLineGraphViewDataSource>

- (instancetype)initWithHealthKitQuantityType:(HKQuantityType *)quantityType
                                 numberOfDays:(NSUInteger)numberOfDays;

- (instancetype)initWithTask:(NSString *)taskId
                numberOfDays:(NSUInteger)numberOfDays
                    valueKey:(NSString *)valueKey
                     dataKey:(NSString *)dataKey;

- (NSNumber *)minimumDataPoint;
- (NSNumber *)maximumDataPoint;
- (NSNumber *)averageDataPoint;
- (id)nextObject;

@end
