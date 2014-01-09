//
//  MediaContentItem.m
//  TalkBlast
//
//  Created by crash on 8/22/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "MediaContentItem.h"


@implementation MediaContentItem
@synthesize name, href, source;

- (void) dealloc {
	[name release];
	[href release];
	[source release];
	[super dealloc];
}
@end
