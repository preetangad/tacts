//
//  ContactDetailViewController.h
//  Tacts
//
//  Created by Angad Singh on 3/19/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Contact+MKAnnotation.h"
@interface ContactDetailViewController : UIViewController

@property (strong, nonatomic) Contact *contact;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end
