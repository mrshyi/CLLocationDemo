//
//  StandardLocationServiceViewController.m
//  CLLocationDemo
//
//  Created by imini on 24/11/2017.
//  Copyright © 2017 mrshyi. All rights reserved.
//

#import "StandardLocationServiceViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface StandardLocationServiceViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet UILabel *status;
@end

@implementation StandardLocationServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;

    // Another way to save power
    locationManager.pausesLocationUpdatesAutomatically = YES;
    locationManager.activityType = CLActivityTypeFitness; // track fitness activities such as walking, running, cycling, and so on

    // Enable background location updates
    locationManager.allowsBackgroundLocationUpdates = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)start:(UIButton *)sender {
    [self startReceivingLocationChanges];
}

- (IBAction)stop:(UIButton *)sender {
    [self stopReceivingLocationChanges];
}

#pragma mark -
// Listing 1 shows how to check for the availability of the standard location service and configure it for use.
//Listing 1
//Starting the standard location service
- (void)startReceivingLocationChanges {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    // The significant-change location service requires always authorization.
    if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways && authorizationStatus != kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"User has not authorized access to location information.");
        [self.status setText:@"User has not authorized access to location information."];
        return;
    }
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"This service is not available.");
        [self.status setText:@"This service is not available."];
        return;
    }
    // Configure and start the service.
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = 1.0;  // In meters.


    NSLog(@"start Updating Location");
    [self.status setText:@"start Updating Location"];
    [locationManager startUpdatingLocation];
}

- (void)stopReceivingLocationChanges {
    NSLog(@"stop Updating Location");
    [self.status setText:@"stop Updating Location"];
    [locationManager stopUpdatingLocation];
}

// Receiving Location Updates
//Listing 2
//Processing the most recent location update
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {

    /*
     note:
     Before using a location value, check the time stamp of the CLLocation object. Because the system may return cached locations, checking the time stamp lets you know whether to update your interface right away or perhaps wait for a new location.
     */
    CLLocation *location = [locations lastObject];
    NSLog(@"%@", location);
    [self.status setText:[NSString stringWithFormat:@"%@", location]];
}

// Handling Location-Related Errors
//Listing 3
//Stopping location services when authorization is denied
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLAuthorizationStatusDenied) {
        // Location updates are not authorized.
        [manager stopUpdatingLocation];
        NSLog(@"stop Updating Location - kCLAuthorizationStatusDenied");
        [self.status setText:@"stop Updating Location - kCLAuthorizationStatusDenied"];
        return;
    }
    // Notify the user of any errors.
}



@end
