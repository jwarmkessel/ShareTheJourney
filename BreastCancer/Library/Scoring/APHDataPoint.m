// 
//  APHDataPoint.m 
//  Share the Journey 
// 
//  Copyright (c) 2014 <INSTITUTION-NAME-TBD> All rights reserved. 
// 
 
#import "APHDataPoint.h"

@implementation APHDataPoint

- (instancetype)initWithValue:(NSNumber *)value timestamp:(NSDate *)timestamp
{
    self = [super init];
    
    if (self) {
        _value = value;
        _timestamp = timestamp;
    }
    
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ - %@", self.value, self.timestamp];
}

@end
