//
//  MediaContentParser.m
//  TalkBlast
//
//  Created by crash on 8/15/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "MediaContentParser.h"
#import "MediaContent.h"
#import "MediaContentItem.h"
#import "DDXMLElement.h"
#import "DDXMLDocument.h"
#import "Constants.h"

@implementation MediaContentParser

- (MediaContent *) parse:(NSData *)xml 
			  error:(NSError **)error {
	MediaContent *result = nil;
	
	// initialize the date formatter
	xmlDateFormatter = [[NSDateFormatter alloc] init];
	[xmlDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"]; 
	
	DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:xml options:0 error:error];
	DDXMLElement *element = [doc rootElement];
	
	result = [self parseMediaContent:element];
	
	[xmlDateFormatter release];
	
	return result;
}

- (MediaContent *) parseMediaContent:(DDXMLElement *)element {
	MediaContent *result = nil;
	
	if (nil != element) {
		result = [MediaContent alloc];
		// populate data here
		// assuming that objective-c will handle null pointer exceptions
		NSArray *mediaContent = [element elementsForName:MediaContentElement];
		NSArray *mediaContentItems = [[mediaContent objectAtIndex:0] elementsForName:MediaContentItemElement];
		result = [[NSMutableArray alloc] initWithCapacity:[mediaContentItems count]];
		
		if (nil != mediaContentItems) {
			for (DDXMLElement *item in mediaContentItems) {
				[result addItem:[self parseMediaContentItem:item]];
			}
		}
	}
	
	return result;
}

- (MediaContentItem *) parseMediaContentItem:(DDXMLElement *)element {
	MediaContentItem *item = nil;
	// now come the links that need to be handled a little differently
	// we'll grab the attributes instead of the values
	NSArray *links = [element elementsForName:LinkElement];
	
	if (nil != links) {
		for (DDXMLElement *link in links) {
			NSString *name = [[link attributeForName:NameAttribute] stringValue];
			NSString *href = [[link attributeForName:HrefAttribute] stringValue];
			NSString *src = [[link attributeForName:SourceAttribute] stringValue];
			
			MediaContentItem *item = [MediaContentItem alloc];
			item.name = name;
			item.href = href;
			item.source = src;
		}
	}
	
	return item;
}

@end
