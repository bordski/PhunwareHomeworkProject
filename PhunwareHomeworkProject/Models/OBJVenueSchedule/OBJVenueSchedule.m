//
//  OBJVenueSchedule.m
//  PhunwareHomeworkProject
//
//  Created by Retina01 on 4/26/15.
//
//

#import "OBJVenueSchedule.h"

@implementation OBJVenueSchedule

#pragma mark - Public Synthesizers

@synthesize startDate = _startDate;
@synthesize endDate = _endDate;

#pragma mark - Public Overridden Getters

- (NSString *)startDate {
    if (_startDate == nil) {
        _startDate = @"";
    }
    
    return _startDate;
}

- (NSString *)endDate {
    if (_endDate == nil) {
        _endDate = @"";
    }
    
    return _endDate;
}

@end
