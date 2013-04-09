//
//  Contact+MKAnnotation.m
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "Contact+MKAnnotation.h"

@implementation Contact (MKAnnotation)

- (NSString *)title
{
    return [self.firstName stringByAppendingString:[@" " stringByAppendingString:self.lastName]];;
}

// part of the MKAnnotation protocol

- (NSString *)subtitle
{
    return [@"Met on " stringByAppendingString:[[self.dateMet description] substringToIndex:10]];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D coordinate;
    coordinate.latitude = [self.lattitude doubleValue];
    coordinate.longitude = [self.longitude doubleValue];
    return coordinate;
}

// MapViewController likes annotations to implement this

- (UIImage *)thumbnail
{
    if (!self.picture) {
        return [UIImage imageNamed:@"camera.png"];
    }
    return [UIImage imageWithData:self.picture];
}

@end
