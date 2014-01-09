//
//  CommunicationEvent.h
//  iConferenceCall
//
//  Created by crash on 5/25/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * This is our model object and will contain all the information necessary to instantiate a conference call
 **/
@interface CommunicationEvent : NSObject <NSCopying> {
	// name of the conf call (optional)
	NSString *title;
	
	// date of conf call (optional - defaults to now)
	NSDate *scheduledDate;
	
	// people attending conf call - retrieved from Address Book
	// the key is the personId
	NSMutableDictionary *attendees;
	
	// natural identifier retrieved from server
	NSString *conferenceCallId;
	
	// index for recording to use - only to use when submitting a conf call
	NSString *filename;
	
	// unique identifier
	NSString *urlName;
	
	// event type is conference call
	NSString *eventType;
	
	// filtering mechanism we probably wont be needing
	NSString *destinationFilter;
	
	NSString *eventStatus;
	
	// when was this conf call created
	NSDate *dateCreated;
	
	// when was it last updated
	NSDate *lastUpdated;
	
	// when should the conf call start
	NSDate *scheduledDelivery;
	
	// list of recordings aka mediaContent
	NSMutableDictionary *recordings;
	
	// list of groups aka destinationGroups
	NSMutableDictionary *groups;
	
	// link to account
	NSString *accountUrl;
	
	// link to accountUser
	NSString *accountUserUrl;
}

// property accessors
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSDate *scheduledDate;
@property (nonatomic, retain) NSMutableDictionary *attendees;
@property (nonatomic, retain) NSString *conferenceCallId;
@property (nonatomic, retain) NSString *filename;
@property (nonatomic, retain) NSString *urlName;
@property (nonatomic, retain) NSString *eventType;
@property (nonatomic, retain) NSString *destinationFilter;
@property (nonatomic, retain) NSString *eventStatus;
@property (nonatomic, retain) NSDate *dateCreated;
@property (nonatomic, retain) NSDate *lastUpdated;
@property (nonatomic, retain) NSDate *scheduledDelivery;
@property (nonatomic, retain) NSMutableDictionary *recordings;
@property (nonatomic, retain) NSMutableDictionary *groups;
@property (nonatomic, retain) NSString *accountUrl;
@property (nonatomic, retain) NSString *accountUserUrl;

@end
