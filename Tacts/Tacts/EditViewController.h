//
//  EditViewController.h
//  Tacts
//
//  Created by Angad Singh on 3/19/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "AddViewController.h"
#import "Contact.h"

@interface EditViewController : AddViewController

@property (strong, nonatomic) Contact *contact;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end
