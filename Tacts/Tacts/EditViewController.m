//
//  EditViewController.m
//  Tacts
//
//  Created by Angad Singh on 3/19/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "EditViewController.h"

@interface EditViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *twitterField;
@property (strong, nonatomic) UIImage *picture;
@end

@implementation EditViewController

- (void)viewWillAppear:(BOOL)animated {
    if(self.contact) {
        self.firstNameField.text = self.contact.firstName;
        self.lastNameField.text = self.contact.lastName;
        self.phoneField.text = self.contact.number;
        self.emailField.text = self.contact.email;
        self.twitterField.text = self.contact.twitter;
        //self.imageView.image = [UIImage imageWithData:self.contact.picture];
    }
}

- (IBAction)takeImage:(UITapGestureRecognizer *)sender {
    NSLog(@"tap");
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Save"]) {
        self.contact.firstName = self.firstNameField.text;
        self.contact.lastName = self.lastNameField.text;
        self.contact.number = self.phoneField.text;
        self.contact.email = self.emailField.text;
        self.contact.twitter = self.twitterField.text;
        if(self.picture)
            //self.contact.picture = [NSData dataWithData:(UIImagePNGRepresentation(self.picture))];
        self.contact.unique = [self.firstNameField.text
                               stringByAppendingString:[self.lastNameField.text
                                                        stringByAppendingString:[self.phoneField.text
                                                                                 stringByAppendingString:[self.emailField.text
                                                                                                          stringByAppendingString:self.twitterField.text]]]];
        
        [self.context save:NULL];
    }
}
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Save"]) {
        //Contact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.context];
        
        Contact *contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.context];
        contact.firstName = self.firstNameField.text;
        contact.lastName = self.lastNameField.text;
        contact.number = self.phoneField.text;
        contact.email = self.emailField.text;
        contact.twitter = self.twitterField.text;
        //contact.picture = [NSData dataWithData:(UIImagePNGRepresentation[self picture])];
        contact.dateMet = [NSDate date];
        contact.unique = [self.firstNameField.text
                          stringByAppendingString:[self.lastNameField.text
                                                   stringByAppendingString:[self.phoneField.text
                                                                            stringByAppendingString:[self.emailField.text
                                                                                                     stringByAppendingString:self.twitterField.text]]]];
        
        //fix these
        contact.lattitude = [NSNumber numberWithDouble:(37.2521)];
        contact.longitude = [NSNumber numberWithDouble:(-122.955)];
        
    }
    
}
*/

/* http://stackoverflow.com/questions/1247113/iphone-keyboard-covers-text-field */

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

/* http://stackoverflow.com/questions/1247113/iphone-keyboard-covers-text-field */

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}

/* http://stackoverflow.com/questions/1247113/iphone-keyboard-covers-text-field */

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    
    const int movementDistance = 140; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
    
}

@end
