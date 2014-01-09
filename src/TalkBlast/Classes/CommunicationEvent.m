//
//  CommunicationEvent.m
//  iConferenceCall
//
//  Created by crash on 5/25/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "CommunicationEvent.h"

@implementation CommunicationEvent
@synthesize title, scheduledDate, attendees, conferenceCallId, filename, urlName, eventType;
@synthesize destinationFilter, eventStatus, dateCreated, lastUpdated, scheduledDelivery, recordings, groups;
@synthesize accountUrl, accountUserUrl;

- (void) dealloc {
	[title release];
	[scheduledDate release];
	[attendees release];
	[conferenceCallId release];
	[filename release];
	[urlName release];
	[eventType release];
	[destinationFilter release];
	[eventStatus release];
	[dateCreated release];
	[lastUpdated release];
	[scheduledDelivery release];
	[recordings release];
	[groups release];
	[accountUrl release];
	[accountUserUrl release];
	
	[super dealloc];
}

- (id)copyWithZone:(NSZone *)zone {
	CommunicationEvent *result = [CommunicationEvent alloc];
	
	result.title = self.title;
	result.scheduledDate = self.scheduledDate;
	result.attendees = self.attendees;
	result.conferenceCallId = self.conferenceCallId;
	result.filename = self.filename;
	result.urlName = self.urlName;
	result.eventType = self.eventType;
	result.destinationFilter = self.destinationFilter;
	result.eventStatus = self.eventStatus;
	result.dateCreated = self.dateCreated;
	result.lastUpdated = self.lastUpdated;
	result.scheduledDelivery = self.scheduledDelivery;
	result.recordings = self.recordings;
	result.groups = self.groups;
	result.accountUrl = self.accountUrl;
	result.accountUserUrl = self.accountUserUrl;
	
	return result;
}

@end
