//
//  OBJVenueCollection.h
//  PhunwareHomeworkProject
//
//  Created by Retina01 on 4/24/15.
//
//

#import <Foundation/Foundation.h>

@class OBJVenue;

@interface OBJVenueCollection : NSObject

@property (nonatomic, strong) NSMutableArray *venues;

@property (nonatomic, strong) id delegate;

- (void)addObjectsFromJSON:(id)json;

@end


@protocol OBJVenueCollectionDelegate <NSObject>

@required

- (void)OBJVenueCollection:(OBJVenueCollection *)venueCollection didAddVenue:(OBJVenue *)venue atIndex:(NSInteger)index;

@end