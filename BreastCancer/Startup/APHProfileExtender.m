//
//  APHProfileExtender.m
//  Journey
//
//  Copyright (c) 2015 Apple, Inc. All rights reserved.
//

#import "APHProfileExtender.h"

@implementation APHProfileExtender

- (instancetype) init {


    self = [super init];

    if (self) {
        
    }
    
    return self;
}

- (UIView *)cellForRowAtAdjustedIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

//- (BOOL)willDisplayCell:(NSIndexPath *)indexPath {
//    return YES;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 10;
}

- (void)preparedContent:(NSArray *)array {
    
}

@end
