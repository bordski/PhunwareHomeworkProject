//
//  OBJVenueCollection.m
//  PhunwareHomeworkProject
//
//  Created by Retina01 on 4/24/15.
//
//

#import "OBJVenueCollection.h"

#import "OBJVenue.h"
#import "OBJVenueSchedule.h"

@implementation OBJVenueCollection

#pragma mark - Public Synthesizers

@synthesize venues = _venues;

#pragma mark - Public Overridden Getters

- (NSMutableArray *)venues {
    if (_venues == nil) {
        _venues = @[].mutableCopy;
    }
    
    return _venues;
}

#pragma mark - JSON Parsing Methods

- (void)addObjectsFromJSON:(id)json {
    
    @autoreleasepool {
        
        if (json == nil) {
            NSLog(@"Cannot add if object is nil");
            return;
        } else if ([json isKindOfClass:[NSArray class]] == NO) {
            NSLog(@"Expecting array format");
            return;
        }
        
        NSArray *venueCollection = (NSArray *)json;
        
        if (venueCollection.count == 0) {
            NSLog(@"No Venues Found");
            return;
        } else if ([venueCollection[0] isKindOfClass:[NSDictionary class]] == NO) {
            NSLog(@"Expecting dictionary type inside the venue collection");
            return;
        }
        
        [venueCollection enumerateObjectsUsingBlock:^(NSDictionary *venueInformation, NSUInteger idx, BOOL *stop) {
            
            OBJVenue *processedVenue = [self OBJVenueForInformation:venueInformation];
            [self.venues insertObject:processedVenue atIndex:self.venues.count];
            
            if ([self.delegate conformsToProtocol:@protocol(OBJVenueCollectionDelegate)]) {
                [self.delegate OBJVenueCollection:self didAddVenue:processedVenue atIndex:self.venues.count -1];
            }
            
        }];
    }
}

- (OBJVenue *)OBJVenueForInformation:(NSDictionary *)venueInformation {
    
    @autoreleasepool {
        
        OBJVenue *processedVenue = [[OBJVenue alloc] init];
        
        processedVenue.venueID = venueInformation[@"id"];
        processedVenue.venueName = venueInformation[@"name"];
        processedVenue.venueDescription = venueInformation[@"description"];
        processedVenue.address = venueInformation[@"address"];
        processedVenue.city = venueInformation[@"city"];
        processedVenue.state = venueInformation[@"state"];
        processedVenue.imageURL = venueInformation[@"image_url"];
        processedVenue.latitude = venueInformation[@"latitude"];
        processedVenue.longitude = venueInformation[@"longitude"];
        processedVenue.pcode = venueInformation[@"pcode"];
        processedVenue.phone = venueInformation[@"phone"];
        processedVenue.ticketLink = venueInformation[@"ticket_link"];
        processedVenue.tollFreePhone = venueInformation[@"tollfreehhone"];
        processedVenue.zip = venueInformation[@"zip"];
        processedVenue.schedule = [NSMutableArray arrayWithArray:[self OBJVenueScheduleFromRawScheduleCollection:venueInformation[@"schedule"]]];
        
        return processedVenue;
    }
    
}

- (NSMutableArray *)OBJVenueScheduleFromRawScheduleCollection:(NSArray *)rawScheduleCollection {
    
    @autoreleasepool {
        
        __block NSMutableArray *processedScheduleCollection = @[].mutableCopy;
        
        __block NSDateFormatter *rawDateFormatter = [[NSDateFormatter alloc] init];
        rawDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
        rawDateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"EN_US"];
        
        [rawScheduleCollection enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
            OBJVenueSchedule *processedSchedule = [[OBJVenueSchedule alloc] init];
            
            rawDateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
            rawDateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss zzz";

            NSDate *startDate = [rawDateFormatter dateFromString:obj[@"start_date"]];
            NSDate *endDate = [rawDateFormatter dateFromString:obj[@"end_date"]];
            
            rawDateFormatter.timeZone = [NSTimeZone localTimeZone];
            rawDateFormatter.dateFormat = @"EEEE M/dd h:mma";
            processedSchedule.startDate = [rawDateFormatter stringFromDate:startDate];
            
            rawDateFormatter.dateFormat = @"h:mma";
            processedSchedule.endDate = [rawDateFormatter stringFromDate:endDate];
            
            [processedScheduleCollection addObject:processedSchedule];
            
            startDate = nil;
            endDate = nil;
        }];
        
        return processedScheduleCollection;
    }
}



@end
