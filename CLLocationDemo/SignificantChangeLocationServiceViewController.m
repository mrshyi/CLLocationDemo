//
//  SignificantChangeLocationServiceViewController.m
//  CLLocationDemo
//
//  Created by imini on 24/11/2017.
//  Copyright © 2017 mrshyi. All rights reserved.
//

#import "SignificantChangeLocationServiceViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface SignificantChangeLocationServiceViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UILabel *status;
@end

@implementation SignificantChangeLocationServiceViewController

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
    [self startReceivingSignificantLocationChanges];
}

- (IBAction)stop:(UIButton *)sender {
    [self stopReceivingSignificantLocationChanges];
}

// The significant-change location service requires always authorization.
#pragma mark -
//  Listing 1 shows how to check for the availability of the significant-change location service and start it.
//Listing 1
//Starting the significant-change location service
- (void)startReceivingSignificantLocationChanges {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    // The significant-change location service requires always authorization.
    if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"User has not authorized access to location information.");
        [self.status setText:@"User has not authorized access to location information."];
        return;
    }
    if (![CLLocationManager significantLocationChangeMonitoringAvailable]) {
        NSLog(@"This service is not available.");
        [self.status setText:@"This service is not available."];
        return;
    }
    NSLog(@"start Monitoring Significant Location Changes");
    [self.status setText:@"start Monitoring Significant Location Changes"];
    [locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopReceivingSignificantLocationChanges {
    NSLog(@"stop Monitoring Significant Location Changes");
    [self.status setText:@"stop Monitoring Significant Location Changes"];
    [locationManager stopMonitoringSignificantLocationChanges];
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
        [manager stopMonitoringSignificantLocationChanges];
        [self.status setText:@"stop Monitoring Visits"];
        return;
    }
    // Notify the user of any errors.
}


@end
