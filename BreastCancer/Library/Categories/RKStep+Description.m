//
//  RKSTStep+Description.m
//  Parkinson
//
//  Created by Henry McGilton on 8/20/14.
//  Copyright (c) 2014 Y Media Labs. All rights reserved.
//

#import "RKSTStep+Description.h"

@implementation RKSTStep (Description)

- (NSMutableString *)doStep
{
    NSMutableString  *desc = [NSMutableString string];
    if (self.identifier == nil) {
        [desc appendFormat:@"identifier = nil, "];
    } else {
        [desc appendFormat:@"identifier = %@, ", self.identifier];
    }
    if (self.name == nil) {
        [desc appendFormat:@"name = nil"];
    } else {
        [desc appendFormat:@"name = %@", self.name];
    }
    return  desc;
}

- (NSString *)description
{
    NSMutableString  *desc = [self doStep];
    return  desc;
}

@end

@implementation RKSTActiveStep (Description)

- (NSString *)description
{
    NSMutableString  *desc = [self doStep];
    [desc appendFormat:@", countDown = %f, ", self.countDown];
    return  desc;
}

@end
