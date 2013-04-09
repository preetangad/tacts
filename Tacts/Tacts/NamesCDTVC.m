//
//  NamesCDTVC.m
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "NamesCDTVC.h"
#import "Contact.h"
#import "AddViewController.h"

@implementation NamesCDTVC

- (void) setContext:(NSManagedObjectContext *)context {
    _context = context;
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}


@end
