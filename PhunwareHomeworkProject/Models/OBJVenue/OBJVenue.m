//
//  OBJVenue.m
//  PhunwareHomeworkProject
//
//  Created by Retina01 on 4/8/15.
//
//

#import "OBJVenue.h"

@implementation OBJVenue

#pragma mark - Public Synthesizers

@synthesize venueID = _venueID;
@synthesize venueName = _venueName;
@synthesize venueDescription = _venueDescription;
@synthesize address = _address;
@synthesize city = _city;
@synthesize state = _state;
@synthesize imageURL = _imageURL;
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;
@synthesize pcode = _pcode;
@synthesize phone = _phone;
@synthesize ticketLink = _ticketLink;
@synthesize tollFreePhone = _tollFreePhone;
@synthesize zip = _zip;
@synthesize schedule = _schedule;

#pragma mark - Public Overridden Getters

- (NSString *)venueID {
    if (_venueID == nil) {
        _venueID = @"";
    }
    
    return _venueID;
}

- (NSString *)venueName {
    if (_venueName == nil) {
        _venueName = @"";
    }
    
    return _venueName;
}


- (NSString *)venueDescription {
    if (_venueDescription == nil) {
        _venueDescription = @"";
    }
    
    return _venueDescription;
}

- (NSString *)address {
    if (_address == nil) {
        _address = @"";
    }
    
    return _address;
}

- (NSString *)city {
    if (_city == nil) {
        _city = @"";
    }
    
    return _city;
}

- (NSString *)state {
    if (_state == nil) {
        _state = @"";
    }
    
    return _state;
}

- (NSString *)imageURL {
    if (_imageURL == nil) {
        _imageURL = @"";
    }
    
    return _imageURL;
}

- (NSString *)latitude {
    if (_latitude == nil) {
        _latitude = @"";
    }
    
    return _latitude;
}

- (NSString *)longitude {
    if (_longitude == nil) {
        _longitude = @"";
    }
    
    return _longitude;
}

- (NSString *)pcode {
    if (_pcode == nil) {
        _pcode = @"";
    }
    
    return _pcode;
}

- (NSString *)phone {
    if (_phone == nil) {
        _phone = @"";
    }
    
    return _phone;
}

- (NSString *)ticketLink {
    if (_ticketLink == nil) {
        _ticketLink = @"";
    }
    
    return _ticketLink;
}

- (NSString *)tollFreePhone {
    if (_tollFreePhone == nil) {
        _tollFreePhone = @"";
    }
    
    return _tollFreePhone;
}

- (NSString *)zip {
    if (_zip == nil) {
        _zip = @"";
    }
    
    return _zip;
}

- (NSMutableArray *)schedule {
    if (_schedule == nil) {
        _schedule = @[].mutableCopy;
    }
    
    return _schedule;
}

@end

