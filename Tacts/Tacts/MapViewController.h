//
//  MapViewController.h
//  Tacts
//
//  Created by Angad Singh on 3/20/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapview;

@end
