//
//  CommonCDTVC.m
//  Tacts
//
//  Created by Angad Singh on 3/18/13.
//  Copyright (c) 2013 Angad Singh. All rights reserved.
//

#import "CommonCDTVC.h"
#import "AddViewController.h"
#import <MapKit/MapKit.h>
#import "Contact.h"

@interface CommonCDTVC ()

@end

@implementation CommonCDTVC


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Contact Item"];
    
    Contact *contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.textLabel.text = [contact.firstName stringByAppendingString:[@" " stringByAppendingString:contact.lastName]];
    UIImageView *image = [cell imageView];
    UIImage *thumb = nil;
    if(contact.picture) {
        thumb = [[UIImage alloc] initWithData:contact.picture];
    }
    else {
        thumb = [UIImage imageNamed:@"camera.png"];
    }
    [image setImage:thumb];
    
    return cell;
}


@end
