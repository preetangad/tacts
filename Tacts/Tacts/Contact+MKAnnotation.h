//
//  Contact+MKAnnotation.h
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "Contact.h"
#import <MapKit/MapKit.h>

@interface Contact (MKAnnotation)

- (UIImage *)thumbnail;
- (CLLocationCoordinate2D)coordinate;

@end
