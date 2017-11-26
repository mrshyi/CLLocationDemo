//
//  RequestAlwaysAuthorizationViewController.m
//  CLLocationDemo
//
//  Created by imini on 23/11/2017.
//  Copyright © 2017 mrshyi. All rights reserved.
//

#import "RequestAlwaysAuthorizationViewController.h"
#import <CoreLocation/CoreLocation.h>

@interface RequestAlwaysAuthorizationViewController ()<CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
}
@property (weak, nonatomic) IBOutlet UILabel *authstatus;

@end

@implementation RequestAlwaysAuthorizationViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    locationManager = [[CLLocationManager alloc] init];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)enable:(UIButton *)sender {
    [self enableLocationServices];
}

- (IBAction)escalateAction:(UIButton *)sender {
    [self escalateLocationServiceAuthorization];
}

#pragma mark - Requesting Always Authorization

/*
 To configure always authorization for location services, do the following:

 1.Add the NSLocationWhenInUseUsageDescription key and the NSLocationAlwaysAndWhenInUsageDescription key to your Info.plist file. (Xcode displays these keys as "Privacy - Location When In Use Usage Description" and "Privacy - Location Always and When In Use Usage Description" in the Info.plist editor.)

 2.If your app supports iOS 10 and earlier, add the NSLocationAlwaysUsageDescription key to your Info.plist file. (Xcode displays this key as "Privacy - Location Always Usage Description" in the Info.plist editor.)

 3.Create and configure your CLLocationManager object.

 4.Call the requestWhenInUseAuthorization initially to enable your app's basic location support.

 5.Call the requestAlwaysAuthorization method only when you use services that require that level of authorization.
 */

/*
 note 1:
 You are required to include the NSLocationWhenInUseUsageDescription and NSLocationAlwaysAndWhenInUsageDescription keys in your app's Info.plist file. (If your app supports iOS 10 and earlier, the NSLocationAlwaysUsageDescription key is also required.) If those keys are not present, authorization requests fail immediately.
 */

/*
 note 2：
 The availability of location services may change at any time. The user can disable location services in the system settings, either for your app specifically or for all apps. Location services are also disabled when a device enters Airplane mode, and they may resume when the device leaves Airplane mode. If your app is running (either in the foreground or in the background) when the availability status changes, the system calls your locationManager:didChangeAuthorizationStatus: method to notify you of the change.
 */

/*
 note 3:
 The system lets your app escalate its authorization level only once, displaying an appropriate interface to the user when you do. Subsequent attempts do not display a system interface and do not change your app's authorization level.
 */


// Configure When-In-Use Authorization Initially
// Listing 1
// Requesting authorization to use location services
- (void)enableLocationServices {

    locationManager.delegate = self;
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            NSLog(@"Request when-in-use authorization initially");
            [self.authstatus setText:@"Request when-in-use authorization initially"];
            [locationManager requestWhenInUseAuthorization];
            break;
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            NSLog(@"Disable location features");
            [self.authstatus setText:@"Disable location features"];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Enable basic location features");
            [self.authstatus setText:@"Enable basic location features"];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Enable any of your app's location features");
            [self.authstatus setText:@"Enable any of your app's location features"];
            break;
    }

}

// Escalate the App's Authorization Level
// Listing 2
// Escalating your app's authorization level
- (void) escalateLocationServiceAuthorization {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse) {
        [locationManager requestAlwaysAuthorization];
    }
}

// Respond to Changes in Authorization Status
// Listing 3
// Getting changes to the app's authorization
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {

    switch (status) {
        case kCLAuthorizationStatusRestricted:
        case kCLAuthorizationStatusDenied:
            NSLog(@"Disable your app's location features");
            [self.authstatus setText:@"Disable your app's location features"];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            NSLog(@"Enable only your app's when-in-use features.");
            [self.authstatus setText:@"Enable only your app's when-in-use features."];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            NSLog(@"Enable any of your app's location services.");
            [self.authstatus setText:@"Enable any of your app's location services."];
            break;
        case kCLAuthorizationStatusNotDetermined:
            break;
    }
}

@end
