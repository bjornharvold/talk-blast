//
//  MediaContent.m
//  TalkBlast
//
//  Created by crash on 8/12/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "MediaContent.h"
#import "MediaContentItem.h"

@implementation MediaContent
@synthesize items;

- (void) addItem:(MediaContentItem *)item {
	if (nil == items) {
		items = [NSMutableArray alloc];
	}
	
	[items addObject:item];
}

@end
