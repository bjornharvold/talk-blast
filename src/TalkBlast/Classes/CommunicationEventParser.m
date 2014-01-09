//
//  CommunicationEventParser.m
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "CommunicationEventParser.h"
#import "CommunicationEvent.h"
#import "DDXML.h"
#import "DDXMLElement.h"
#import "DDXMLDocument.h"
#import "Constants.h"
#import "MediaContent.h"
#import "Attendee.h"

/*!
 @class CommunicationEventParser
 @abstract Parses an XML response that looks like this:
 
 <?xml version="1.0" encoding="UTF-8"?>
 <communicationEvents>
	 <communicationEvent>
		 <name>Test Conference</name>
		 <urlName></urlName>
		 <eventType>Conference</eventType>
		 <destinationFilter>ALL_PRIMARY</destinationFilter>
		 <eventStatus>COMPLETED_SUCCESSFULLY</eventStatus>
		 <dateCreated>DATE_GOES_HERE</dateCreated>
		 <lastUpdated>DATE_GOES_HERE</lastUpdated>
		 <scheduledDelivery>DATE_GOES_HERE</scheduledDelivery>
		 <link title="account" name="account" rel="get" href=""/>
		 <link title="accountUser" name="accountUser" rel="get" href=""/>
		 <destinationGroups count="18">
			 <link title="GROUPNAME" name="GROUPURLNAME" rel="get" href=""/>
		 </destinationGroups>
		 <destinationContacts count="30">
			 <link title="CONTACTNAME" name="CONTACTURLNAME" rel="get" href=""/>
		 </destinationContacts>
		 <mediaContent count="1">
			 <link title="RECORDINGNAME" name="RECORDINGURLNAME" rel="get" href=""/>
		 </mediaContent>
		 <status></status>
	 </communicationEvent>
 </communicationEvents>
 */
@implementation CommunicationEventParser

- (NSMutableArray *) parse:(NSData *)xml 
			  error:(NSError **)error {

	NSMutableArray *result = nil;
	
	// initialize the date formatter
	xmlDateFormatter = [[NSDateFormatter alloc] init];
	[xmlDateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"]; 
	
	DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:xml options:0 error:error];
	DDXMLElement *element = [doc rootElement];
	
	result = [self parseCommunicationEvents:element];
	
	[xmlDateFormatter release];
	
	return result;
}

- (NSMutableArray *) parseCommunicationEvents:(DDXMLElement *)element {
	NSMutableArray *result = nil;
	
	if (nil != element) {
		// populate data here
		// assuming that objective-c will handle null pointer exceptions
		NSArray *communicationEvents = [element elementsForName:OriginationEventElement];
		result = [[NSMutableArray alloc] initWithCapacity:[communicationEvents count]];
		
		if (nil != communicationEvents) {
			for (DDXMLElement *ce in communicationEvents) {
				[result addObject:[self parseCommunicationEvent:ce]];
			}
		}
	}
	
	return result;
}

/*!
 @function parseCommunicationEvent
 @abstract Parsed xml into a CommunicationEvent
 */
- (CommunicationEvent *) parseCommunicationEvent:(DDXMLElement *)element {
	CommunicationEvent *result = nil;
	
	if (nil != element) {
		result = [CommunicationEvent alloc];
		
		if (nil != [element elementsForName:TitleElement]) {
			NSArray *titleElement = [element elementsForName:TitleElement];
			result.title = [[titleElement objectAtIndex:0] stringValue];
		}
		
		if (nil != [element elementsForName:UrlNameElement]) {
			NSArray *urlNameElement = [element elementsForName:UrlNameElement];
			result.urlName = [[urlNameElement objectAtIndex:0] stringValue];
		}
		
		if (nil != [element elementsForName:EventTypeElement]) {
			NSArray *eventTypeElement = [element elementsForName:EventTypeElement];
			result.eventType = [[eventTypeElement objectAtIndex:0] stringValue];
		}
		
		if (nil != [element elementsForName:DestinationFilterElement]) {
			NSArray *destinationFilterElement = [element elementsForName:DestinationFilterElement];
			result.destinationFilter = [[destinationFilterElement objectAtIndex:0] stringValue];
		}
		
		if (nil != [element elementsForName:EventStatusElement]) {
			NSArray *eventStatusElement = [element elementsForName:EventStatusElement];
			result.eventStatus = [[eventStatusElement objectAtIndex:0] stringValue];
		}
		
		// these are date objects
		if (nil != [element elementsForName:DateCreatedElement]) {
			NSArray *dateCreatedElement = [element elementsForName:DateCreatedElement];
			result.dateCreated = [xmlDateFormatter dateFromString:[[dateCreatedElement objectAtIndex:0] stringValue]];
		}
		
		if (nil != [element elementsForName:LastUpdatedElement]) {
			NSArray *lastUpdatedElement = [element elementsForName:LastUpdatedElement];
			result.lastUpdated = [xmlDateFormatter dateFromString:[[lastUpdatedElement objectAtIndex:0] stringValue]];
		}
		
		if (nil != [element elementsForName:ScheduledDeliveryElement]) {
			NSArray *scheduledDeliveryElement = [element elementsForName:ScheduledDeliveryElement];
			result.scheduledDelivery = [xmlDateFormatter dateFromString:[[scheduledDeliveryElement objectAtIndex:0] stringValue]];
		}
		
		// now come the links that need to be handled a little differently
		// we'll grab the attributes instead of the values
		NSArray *links = [element elementsForName:LinkElement];
		
		if (nil != links) {
			for (DDXMLElement *link in links) {
				NSString *attributeName = [[link attributeForName:NameAttribute] stringValue];
				if (attributeName == AccountAttribute) {
					result.accountUrl = [[link attributeForName:HrefAttribute] stringValue];
				} else if (attributeName == AccountUserAttribute) {
					result.accountUserUrl = [[link attributeForName:HrefAttribute] stringValue];
				}
			}
		}
		
		// destinationGroups, destinationContacts and mediaContent
		// NSArray *groupsElement = [element elementsForName:DestinationGroupsElement];
		// result.groups = [self parseGroups:groupsElement];
		NSArray *contactsElement = [element elementsForName:DestinationContactsElement];
		result.attendees = [self parseContacts:[contactsElement objectAtIndex:0]];
		NSArray *mediaContentElement = [element elementsForName:MediaContentElement];
		result.groups = [self parseContacts:[mediaContentElement objectAtIndex:0]];
	}
	
	return result;
}

/*!
 @function parseGroups
 @abstract implement when we are actually using group
 */
/*
- (NSMutableDictionary *) parseGroups:(DDXMLElement *) element {
	NSMutableDictionary result = nil;
	
	if (nil != element) {
		result = [[NSMutableDictionary alloc] initWithCapacity:[elements count]];
		
		for (DDXMLElement *element in elements) {
			
		}
	}
}
 */

- (NSMutableDictionary *) parseContacts:(DDXMLElement *) element {
	NSMutableDictionary *result = nil;
	
	if (nil != element) {
		int count = [[[element attributeForName:CountAttribute] stringValue] intValue];
		result = [[NSMutableDictionary alloc] initWithCapacity:count];
		NSArray *links = [element elementsForName:LinkElement];
		
		for (DDXMLElement *element in links) {
			Attendee *attendee = [Attendee alloc];
			
			
		}
	}
	
	return result;
}

- (NSMutableDictionary *) parseMediaContent:(DDXMLElement *) element {
	NSMutableDictionary *result = nil;
	
	if (nil != element) {
		int count = [[[element attributeForName:CountAttribute] stringValue] intValue];
		result = [[NSMutableDictionary alloc] initWithCapacity:count];
		NSArray *links = [element elementsForName:LinkElement];
		
		for (DDXMLElement *element in links) {
			MediaContent *mediaContent = [MediaContent alloc];
			
			
		}
	}
	
	return result;
}

- (void) dealloc {
	[super dealloc];
}

@end
