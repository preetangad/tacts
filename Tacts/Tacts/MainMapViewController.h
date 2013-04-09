//
//  MainMapViewController.h
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "MapViewController.h"

@interface MainMapViewController : MapViewController

@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end
