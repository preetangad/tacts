//
//  Contact.h
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSDate * dateMet;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSNumber * lattitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSData * picture;
@property (nonatomic, retain) NSString * twitter;
@property (nonatomic, retain) NSString * unique;

@end
