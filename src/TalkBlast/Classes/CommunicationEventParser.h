//
//  CommunicationEventParser.h
//  TalkBlast
//
//  Created by crash on 8/9/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommunicationEvent;
@class DDXMLElement;

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
@interface CommunicationEventParser : NSObject {
	NSDateFormatter *xmlDateFormatter;
}

- (NSMutableArray *) parse:(NSData *)xml 
			  error:(NSError **)error;
- (NSMutableArray *) parseCommunicationEvents:(DDXMLElement *)element;
- (CommunicationEvent *) parseCommunicationEvent:(DDXMLElement *)element;
//- (NSMutableDictionary *) parseGroups:(NSArray *) element;
- (NSMutableDictionary *) parseContacts:(DDXMLElement *) element;
- (NSMutableDictionary *) parseMediaContent:(DDXMLElement *) element;
@end
