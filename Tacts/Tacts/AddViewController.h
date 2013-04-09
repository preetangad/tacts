//
//  AddViewController.h
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreData/CoreData.h>

@interface AddViewController : UIViewController

@property (strong, nonatomic) NSManagedObjectContext *context;

@end
