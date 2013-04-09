//
//  ContactDetailViewController.m
//  Tacts
//
//  Created by Angad Singh on 3/19/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "ContactDetailViewController.h"
#import <MapKit/MapKit.h>
#import "EditViewController.h"
#import "MapViewController.h"
#import <Social/Social.h>

@interface ContactDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *dateMetLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *twitterLabel;
@property (strong, nonatomic) MapViewController *mapvc;

@end

@implementation ContactDetailViewController

- (void) viewWillAppear:(BOOL)animated {
    if(self.context && self.contact){
        self.nameLabel.text = self.contact.firstName;
        self.lastNameLabel.text = self.contact.lastName;
        if(self.contact.picture){
            self.imageView.image = [UIImage imageWithData:(self.contact.picture)];
        }
        self.dateMetLabel.text = [@"Met on " stringByAppendingString:[[self.contact.dateMet description] substringToIndex:10]];
        self.phoneLabel.text = self.contact.number;
        self.emailLabel.text = self.contact.email;
        self.twitterLabel.text = [@"@" stringByAppendingString:self.contact.twitter];
        
        //fix this
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.mapvc.mapview addAnnotation:self.contact];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Edit"]) {
        EditViewController *edit = segue.destinationViewController;
        edit.contact = self.contact;
        edit.context = self.context;
    }
    
    if ([segue.identifier isEqualToString:@"Embed Map"]) {
        if ([segue.destinationViewController isKindOfClass:[MapViewController class]]) {
            self.mapvc = segue.destinationViewController;
        }
    }
}
- (IBAction)tweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *tweetText = [@"@" stringByAppendingFormat:@"%@ How's it going, %@? - via Tacts", self.contact.twitter, self.contact.firstName];
        [tweetSheet setInitialText:tweetText];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Sorry"
                                  message:@"Can't tweet. Make sure you have internet and at least one Twitter account setup"
                                  delegate:self
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        
    }
}

@end
