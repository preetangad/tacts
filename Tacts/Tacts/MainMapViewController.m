//
//  MainMapViewController.m
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "MainMapViewController.h"
#import "Contact+MKAnnotation.h"
#import "RecentsDocument.h"
#import "ContactDetailViewController.h"

@interface MainMapViewController ()

@end

@implementation MainMapViewController

// always fetch from Core Data after our outlets (mapView) are set

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reload];
}

// when we appear, if our managedObjectContext
//   (our Model inherited from our superclass)
//   has not been set, we open a demo document to get it

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.context) [self useNewDocument];
    [self reload];
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

// fetches contacts
// then just loads them up as the MKMapView's annotations
// this works because Photo objects have been made to conform to MKAnnotation
//   (via the Photo+MKAnnotation category)

- (void)reload
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Contact"];
    request.predicate = nil;
    
    NSArray *contacts = [self.context executeFetchRequest:request error:NULL];
    [self.mapview removeAnnotations:self.mapview.annotations];
    [self.mapview addAnnotations:contacts];
    Contact *contact = [contacts lastObject];
    if (contact) self.mapview.centerCoordinate = [contact coordinate];
}

// sent to the mapView's delegate (us) when any {left,right}CalloutAccessoryView
//   that is a UIControl is tapped on
// in this case, we manually segue using the setPhoto: segue

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    [self performSegueWithIdentifier:@"Show Contact" sender:view];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Show Contact"]) {
        if ([sender isKindOfClass:[MKAnnotationView class]]) {
            MKAnnotationView *aView = sender;
            if ([aView.annotation isKindOfClass:[Contact class]]) {
                Contact *contact = aView.annotation;
                ContactDetailViewController *view = segue.destinationViewController;
                view.context = self.context;
                view.contact = contact;
            }
        }
    }
}

@end
