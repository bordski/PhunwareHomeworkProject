//
//  OBJVenue.h
//  PhunwareHomeworkProject
//
//  Created by Retina01 on 4/8/15.
//
//

#import <Foundation/Foundation.h>

@interface OBJVenue : NSObject

@property (nonatomic, strong) NSString *venueID;
@property (nonatomic, strong) NSString *venueName;
@property (nonatomic, strong) NSString *venueDescription;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *imageURL;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *pcode;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *ticketLink;
@property (nonatomic, strong) NSString *tollFreePhone;
@property (nonatomic, strong) NSString *zip;
@property (nonatomic, strong) NSMutableArray *schedule;


@end
