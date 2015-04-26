//
//  TVCVenueList.m
//  PhunwareHomeworkProject
//
//  Created by Retina01 on 4/8/15.
//
//

#import "TVCVenueList.h"
#import "OBJVenue.h"
#import "Reachability.h"

#import "OBJVenueCollection.h"
#import "VCVenueDetails.h"

@interface TVCVenueList () <NSURLConnectionDataDelegate, OBJVenueCollectionDelegate>

@property (nonatomic, strong) Reachability *connectionChecker;
@property (nonatomic, strong) NSURLConnection *venueDataConnection;

@property (nonatomic, strong) NSMutableData *venueRawData;

@property (nonatomic, strong) OBJVenueCollection *venueCollection;

@end

@implementation TVCVenueList

#pragma mark - Private Synthesizers

@synthesize connectionChecker = _connectionChecker;
@synthesize venueDataConnection = _venueDataConnection;

@synthesize venueRawData = _venueRawData;

@synthesize venueCollection = _venueCollection;


#pragma mark - Private Overridden Getters

- (Reachability *)connectionChecker {
    if (_connectionChecker == nil) {
        _connectionChecker = [Reachability reachabilityWithHostname:@"www.google.com"];
    }
    
    return _connectionChecker;
}

- (NSURLConnection *)venueDataConnection {
    if (_venueDataConnection == nil) {
        NSURLRequest *venueDataRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://s3.amazonaws.com/jon-hancock-phunware/nflapi-static.json"]];
        _venueDataConnection = [NSURLConnection connectionWithRequest:venueDataRequest delegate:self];
        [_venueDataConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
        venueDataRequest = nil;
    }
    
    return _venueDataConnection;
}

- (NSMutableData *)venueRawData {
    if (_venueRawData == nil) {
        _venueRawData = [NSMutableData data];
    }
    
    return _venueRawData;
}

- (OBJVenueCollection *)venueCollection {
    if (_venueCollection == nil) {
        _venueCollection = [[OBJVenueCollection alloc] init];
        _venueCollection.delegate = self;
    }
    return _venueCollection;
}

#pragma mark - Initialisation 

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupInternetConnectionHandler];
    
}

#pragma mark - View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;

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
    //make sure the checker is removed from memory
    self.connectionChecker = nil;
    //make sure the venue isn't downloading or anything
    [self.venueDataConnection cancel];
    self.venueDataConnection = nil;
    
}

#pragma mark - Memory Warning Handler

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    self.connectionChecker = nil;
}

#pragma mark - Setup

- (void)setupInternetConnectionHandler {
    
    __block TVCVenueList *instanceOfMyself = self;
    
    self.connectionChecker.reachableBlock = ^(Reachability*reach)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"Internet connection checked and is valid, proceeding to venue data retrieval from server");
            [instanceOfMyself retrieveVenueRawData];
            
        });
    };
    
    self.connectionChecker.unreachableBlock = ^(Reachability*reach)
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"There is no internet connection");
            
        });
    };
    
    [self.connectionChecker startNotifier];
}

#pragma mark - Helper

- (void)retrieveVenueRawData {

    NSLog(@"Retrieving venue raw data");
    
    [self.venueDataConnection start];
    
}

#pragma mark - URL Connection Delegate

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
    NSLog(@"the connection to the server failed with the following error:%@", error.debugDescription);
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (data == nil) {
        NSLog(@"for some reason the data received was nil please double check this with the server");
    } else {
        [self.venueRawData appendData:data];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *parsingError;
    
    if (self.venueRawData == nil) {
        NSLog(@"Something went wrong in the data receiving process and is returning nil");
    } else if (self.venueRawData.length == 0) {
        NSLog(@"Something went wrong in the data receiving process and has no data");
    } else {
        id parsedRawData = [NSJSONSerialization JSONObjectWithData:self.venueRawData options:kNilOptions error:&parsingError];
        
        if (parsingError) {
            NSLog(@"Something went wrong while parsing the json data, please check the data being parsed if it is valid [%@]", [parsingError description]);
        } else {
            NSLog(@"parsed Raw Data : %@", parsedRawData);
            [self.venueCollection addObjectsFromJSON:parsedRawData];
        }
    }
}

#pragma mark - OBJ Venu Collection Delegate

- (void)OBJVenueCollection:(OBJVenueCollection *)venueCollection didAddVenue:(OBJVenue *)venue atIndex:(NSInteger)index {
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.venueCollection.venues.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"venueCell" forIndexPath:indexPath];
    
    [self setupCell:cell forRow:indexPath.row];
    
    return cell;
}

- (void)setupCell:(UITableViewCell *)cell forRow:(NSInteger)row{
    OBJVenue *venue = self.venueCollection.venues[row];
    cell.textLabel.text = venue.venueName;
    cell.detailTextLabel.text = venue.address;
}

#pragma mark - Navigation


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        OBJVenue *selectedVenue = (OBJVenue *)self.venueCollection.venues[indexPath.row];
        
        VCVenueDetails *venueDetails = (VCVenueDetails *)[(UINavigationController *)segue.destinationViewController viewControllers][0];
        venueDetails.venue = selectedVenue;
        
    } else {
        NSLog(@"Unknown segue identifier passed:%@", segue.identifier);
    }
    
}

- (BOOL)shouldAutorotate {
    return YES;
}

@end
