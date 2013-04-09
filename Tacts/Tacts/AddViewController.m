//
//  AddViewController.m
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "AddViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "Contact.h"
#import "SOTextField.h"
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface AddViewController ()    <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverControllerDelegate, UIGestureRecognizerDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *twitterField;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (strong, nonatomic) UIImage *picture;
@property (nonatomic) double lattitude;
@property (nonatomic) double longitude;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic) BOOL located;
@property (strong, nonatomic) UIActionSheet *socialActionSheet;
@end

@implementation AddViewController
CGFloat animatedDistance;
static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 162;

- (void)viewDidLoad{
    [super viewDidLoad];
    self.picture = nil;
    self.located = false;
    self.firstNameField.delegate = self;
    self.lastNameField.delegate = self;
    self.emailField.delegate = self;
    self.phoneField.delegate = self;
    self.twitterField.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.locationManager.distanceFilter = 50;
}

- (void) viewDidAppear:(BOOL)animated {
    [self.locationManager startUpdatingLocation];
}

- (IBAction)takePicture:(id)sender {
    [self presentImagePicker:UIImagePickerControllerSourceTypeCamera sender:sender];
}

- (void)presentImagePicker:(UIImagePickerControllerSourceType)sourceType sender:(UIBarButtonItem *)sender
{
    
}
- (IBAction)clickImage:(UITapGestureRecognizer *)sender {
    if (!self.imagePickerPopover && [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        if ([availableMediaTypes containsObject:(NSString *)kUTTypeImage]) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = @[(NSString *)kUTTypeImage];
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePickerPopover = nil;
}

// UIImagePickerController was canceled, so dismiss it

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (!image) image = info[UIImagePickerControllerOriginalImage];
    if (image) {
        self.picture = image;
        [self.imageView setImage:image];
    }
    if (self.imagePickerPopover) {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (CLLocationCoordinate2D *) coordinates {
    return nil;
}

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
        if (self.picture != nil) {
            NSData *imageData = UIImagePNGRepresentation(self.imageView.image);
            contact.picture = imageData;
        }
        else {
            contact.picture = nil;
        }
        contact.dateMet = [NSDate date];
        contact.unique = [self.firstNameField.text
                          stringByAppendingString:[self.lastNameField.text
                                                   stringByAppendingString:[self.phoneField.text
                                                                            stringByAppendingString:[self.emailField.text
                                                                                                     stringByAppendingString:self.twitterField.text]]]];
        
        //fix these
        self.coordinate = self.locationManager.location.coordinate;
        
        //if no location, go to Paris :)
        if (!self.located) {
            CLLocationCoordinate2D coord;
            coord.latitude = 48.857875;
            coord.longitude = 2.294635;
            self.coordinate = coord;
        }
        
        contact.lattitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.latitude];
        contact.longitude = [NSNumber numberWithDouble:self.locationManager.location.coordinate.longitude];
        
        [self socialize:contact];
    }
}

- (void)socialize:(Contact *)contact {
    
    self.socialActionSheet = [[UIActionSheet alloc] initWithTitle:@"Send a quick note!"
                                                         delegate:self
                                                cancelButtonTitle:@"Skip"
                                           destructiveButtonTitle:nil
                                                otherButtonTitles:@"Tweet", nil];
    
    [self.socialActionSheet showFromToolbar:self.navigationController.toolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex == actionSheet.cancelButtonIndex)
        [self tweet];
}


- (void)tweet {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        NSString *tweetText = [@"@" stringByAppendingFormat:@"%@ Hi %@. Nice meeting you! See you around. - via Tacts", self.twitterField.text, self.firstNameField.text];
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




- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.located = true;
}

//http://stackoverflow.com/questions/1347779/how-to-navigate-through-textfields-next-done-buttons
- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    
    BOOL didResign = [textField resignFirstResponder];
    if (!didResign) return NO;
    
    if ([textField isKindOfClass:[SOTextField class]])
        dispatch_async (dispatch_get_main_queue(),
                        ^ { [[(SOTextField *)textField nextField] becomeFirstResponder]; });
    
    return YES;
    
}

//http://www.cocoawithlove.com/2008/10/sliding-uitextfields-around-to-avoid.html
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect textFieldRect =
    [self.view.window convertRect:textField.bounds fromView:textField];
    CGRect viewRect =
    [self.view.window convertRect:self.view.bounds fromView:self.view];
    
    CGFloat midline = textFieldRect.origin.y + 0.5 * textFieldRect.size.height;
    CGFloat numerator =
    midline - viewRect.origin.y
    - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator =
    (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION)
    * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
    
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
    
    UIInterfaceOrientation orientation =
    [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||
        orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
    
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y -= animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect viewFrame = self.view.frame;
    viewFrame.origin.y += animatedDistance;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    
    [self.view setFrame:viewFrame];
    
    [UIView commitAnimations];
}



@end
