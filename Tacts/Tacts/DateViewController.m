//
//  DateViewController.m
//  Tacts
//
//  Created by Angad Singh on 3/20/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "DateViewController.h"

@interface DateViewController ()

@end

@implementation DateViewController

- (void) setContext:(NSManagedObjectContext *)context {
    _context = context;
    if (context) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
        request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"dateMet" ascending:NO selector:@selector(localizedCaseInsensitiveCompare:)]];
        request.predicate = nil;
        
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    } else {
        self.fetchedResultsController = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (!self.context) [self useNewDocument];
}

- (void) useNewDocument {
    
    UIManagedDocument *document = [RecentsDocument getRecentsDocument];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[document.fileURL path]]) {
        [document saveToURL:document.fileURL
           forSaveOperation:UIDocumentSaveForCreating
          completionHandler:^(BOOL success) {
              if (success) {
                  self.context = document.managedObjectContext;
              }
          }];
    } else if (document.documentState == UIDocumentStateClosed) {
        [document openWithCompletionHandler:^(BOOL success) {
            if (success) {
                self.context = document.managedObjectContext;
            }
        }];
    } else {
        self.context = document.managedObjectContext;
        [document saveToURL:document.fileURL
           forSaveOperation:UIDocumentSaveForOverwriting
          completionHandler:^(BOOL success) {
              if (!success) NSLog(@"failed to save document %@", document.localizedName);
          }];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"Add"]) {
        AddViewController *add = segue.destinationViewController;
        add.context = self.context;
    }
    if ([segue.identifier isEqualToString:@"Show Contact"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        ContactDetailViewController *view = segue.destinationViewController;
        view.context = self.context;
        Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
        view.contact = contact;
    }
}

@end
