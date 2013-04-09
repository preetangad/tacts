//
//  RecentsDocument.m
//  Photomania
//
//  Created by Angad Singh on 2/28/13.
//  Copyright (c) 2013 Stanford University. All rights reserved.
//

#import "RecentsDocument.h"

@interface RecentsDocument()

@end

@implementation RecentsDocument

static UIManagedDocument *document = nil;

+ (UIManagedDocument *) getRecentsDocument {
    
    if (!document) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"New Document"];
        document = [[UIManagedDocument alloc] initWithFileURL:url];
    }
    
    return document;
}

@end
