//
//  VisitsLocationServiceViewController.m
//  CLLocationDemo
//
//  Created by imini on 23/11/2017.
//  Copyright © 2017 mrshyi. All rights reserved.
//

#import "VisitsLocationServiceViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface VisitsLocationServiceViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UILabel *status;
@end

@implementation VisitsLocationServiceViewController

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
    [self startReceivingVisitChanges];
}

- (IBAction)stop:(UIButton *)sender {
    [self stopReceivingVisitChanges];
}

#pragma mark -
//Listing 1
//Starting the visits location service
- (void)startReceivingVisitChanges {
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    // The visits location service requires always authorization.
    if (authorizationStatus != kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"User has not authorized access to location information.");
        [self.status setText:@"User has not authorized access to location information."];
        return;
    }
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"This service is not available.");
        [self.status setText:@"This service is not available."];
        return;
    }
    [locationManager startMonitoringVisits];
    NSLog(@"start Monitoring Visits");
    [self.status setText:@"Monitoring Visits"];
}

- (void)stopReceivingVisitChanges {
    [locationManager  stopMonitoringVisits];
    NSLog(@"stop Monitoring Visits");
    [self.status setText:@"stop Monitoring Visits"];
}

// Receiving Visit Updates
//Listing 2
//Receiving visit updates
- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    // Do something with the visit.
    NSLog(@"lat:%f,lon:%f,r:%f", visit.coordinate.latitude, visit.coordinate.longitude, visit.horizontalAccuracy);
    NSLog(@"arrival:%@,departure:%@", visit.arrivalDate, visit.departureDate);

    [self.status setText:[NSString stringWithFormat:@"lat:%f,lon:%f,r:%f,arrival:%@,departure:%@", visit.coordinate.latitude, visit.coordinate.longitude, visit.horizontalAccuracy, visit.arrivalDate, visit.departureDate]];
}

// Handling Location-Related Errors
//Listing 3
//Stopping location services when authorization is denied
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (error.code == kCLAuthorizationStatusDenied) {
        // Location updates are not authorized.
        [manager stopMonitoringVisits];
        [self.status setText:@"stop Monitoring Visits"];
        return;
    }
    // Notify the user of any errors.
}



@end
