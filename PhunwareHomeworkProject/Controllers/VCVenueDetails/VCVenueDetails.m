//
//  VCVenueDetails.m
//  PhunwareHomeworkProject
//
//  Created by Retina01 on 4/24/15.
//
//

#import "VCVenueDetails.h"

#import "OBJVenue.h"
#import "OBJVenueSchedule.h"
#import "Reachability.h"

@interface VCVenueDetails ()

@property (weak, nonatomic) IBOutlet UIImageView *venueImage;
@property (weak, nonatomic) IBOutlet UILabel *venueName;
@property (weak, nonatomic) IBOutlet UILabel *venueAddress;
@property (weak, nonatomic) IBOutlet UILabel *venueSchedule;

@property (strong, nonatomic) CABasicAnimation *rotationAnimation;

@property (strong, nonatomic) NSData *downloadedImage;

@end

@implementation VCVenueDetails

#pragma mark - Public Synthesizers
@synthesize venue = _venue;

#pragma mark - Private Synthesizers
@synthesize rotationAnimation = _rotationAnimation;
@synthesize downloadedImage = _downloadedImage;
@synthesize venueImage = _venueImage;

#pragma mark - Private Overridden getters
- (NSData *)downloadedImage {
    if (_downloadedImage == nil) {
        _downloadedImage = [[NSData alloc] init];
    }
    
    return _downloadedImage;
}

- (CABasicAnimation *)rotationAnimation {
    
    if (_rotationAnimation == nil) {
        _rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        _rotationAnimation.fromValue = [NSNumber numberWithFloat: M_PI * 2.0];
        _rotationAnimation.duration = 2;
        _rotationAnimation.cumulative = YES;
        _rotationAnimation.repeatCount = 1000000000;
    }
    
    return _rotationAnimation;
}

#pragma mark - Public Overridden setters
- (void)setVenue:(OBJVenue *)venue {
    if (venue == nil) {
        NSLog(@"Venue being set is nil!");
    } else {
        _venue = venue;
        
        NSURL *venueURL = [NSURL URLWithString:self.venue.imageURL];
        
        [self downloadImageFromURL:venueURL];
    }
}

#pragma mark - Private Overridden setters
- (void)setDownloadedImage:(NSData *)downloadedImage {
    if (downloadedImage == nil) {
        NSLog(@"Downloaded Image is nil!");
    } else {
        _downloadedImage = downloadedImage;
        [self willAllowVenueImageRotation:NO];
        self.venueImage.contentMode = UIViewContentModeScaleAspectFit;
        self.venueImage.image = [UIImage imageWithData:self.downloadedImage];
    }
}

#pragma mark - Initialisation

- (void)awakeFromNib {
    [super awakeFromNib];
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.venue) {
        self.venueImage.image = [UIImage imageNamed:@"loadingWheel"];
        [self willAllowVenueImageRotation:YES];
        self.venueName.text = self.venue.venueName;
        self.venueAddress.text =[NSString stringWithFormat:@"%@\n%@, %@ %@", self.venue.address, self.venue.city, self.venue.state, self.venue.zip];
        
        NSMutableString *schedule = @"".mutableCopy;
        for (OBJVenueSchedule *venueSchedule in self.venue.schedule) {
            [schedule appendFormat:@"%@ to %@\n", venueSchedule.startDate, venueSchedule.endDate];
        }
        self.venueSchedule.text = schedule;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    @autoreleasepool {
        [self willAllowVenueImageRotation:NO];
        self.rotationAnimation = nil;
        self.downloadedImage = nil;
    }
}

#pragma mark - Memory Warning Handler

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    @autoreleasepool {
        // Dispose of any resources that can be recreated.
        [self willAllowVenueImageRotation:NO];
        self.rotationAnimation = nil;
        self.downloadedImage = nil;
    }
}

#pragma mark - Setup

- (void)willAllowVenueImageRotation:(BOOL)allow {
    @autoreleasepool {
        if (allow) {
            [self.venueImage.layer addAnimation:self.rotationAnimation forKey:@"rotationAnimation"];
        } else {
            [self.venueImage.layer removeAnimationForKey:@"rotationAnimation"];
        }
    }
}

- (void)downloadImageFromURL:(NSURL *)venueURL {
    
    @autoreleasepool {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            
            NSData *data = [NSData dataWithContentsOfURL:venueURL];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                self.downloadedImage = data;
            });
            
        });
    }
}

- (BOOL)shouldAutorotate {
    return YES;
}


@end
