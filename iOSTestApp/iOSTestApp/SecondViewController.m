//
//  SecondViewController.m
//  SampleTest
//
//  Created by Apple3 on 13/02/16.
//  Copyright © 2016 Apple3. All rights reserved.
//

#import "SecondViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
@interface SecondViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    CLLocationManager *locationManager;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end

float const kRegionSpan = 5.50;

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mapView.delegate = self;
   
    locationManager = [[CLLocationManager alloc] init];
    geocoder = [[CLGeocoder alloc] init];
    locationManager.delegate = self;
    
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLLocationAccuracyBest;
    
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
     self.mapView.showsUserLocation = YES;
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [locationManager startUpdatingLocation];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [locationManager stopUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    // If error...
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    CLLocation *currentLocation = newLocation;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         [locationManager stopUpdatingLocation];
         
         if (!(error))
         {
             placemark = [placemarks objectAtIndex:0];
             placemark = [placemarks lastObject];
             MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc] init];
             myAnnotation.coordinate = newLocation.coordinate;
             
             NSString *subString = [NSString stringWithFormat:@"%@,%@", placemark.subAdministrativeArea, placemark.administrativeArea];
             NSString *subString2 = [NSString stringWithFormat:@"%@,%@,%@",placemark.subLocality, placemark.postalCode, placemark.country];
             myAnnotation.title = subString;
             myAnnotation.subtitle = subString2;
             [self.mapView addAnnotation:myAnnotation];
             
             MKCoordinateRegion region;
             region.center = newLocation.coordinate;
             MKCoordinateSpan span;
             span.latitudeDelta = kRegionSpan;
             span.longitudeDelta = kRegionSpan;
             
             region.span=span;
             [_mapView setRegion:region animated:TRUE];
             [_mapView regionThatFits:region];
         }
     }];
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    MKAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"loc"];
    annotationView.canShowCallout = YES;
    
    return annotationView;
}
- (IBAction)indexDidChangeForSegmentedControl:(UISegmentedControl *)aSegmentedControl {
    
    switch (aSegmentedControl.selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType  = MKMapTypeSatellite;
            break;
        case 2:
            self.mapView.mapType  = MKMapTypeHybrid;
            break;
            
        default:
            break;
    }
}
@end
