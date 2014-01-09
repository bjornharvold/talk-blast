//
//  AccountParser.m
//  TalkBlast
//
//  Created by crash on 7/20/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "AccountParser.h"
#import "AccountUser.h"
#import "Account.h"
#import "AccountPreference.h"
#import "DDXML.h"
#import "DDXMLElement.h"
#import "DDXMLDocument.h"
#import "Constants.h"

@implementation AccountParser

/*!
 @function parse
 @abstract Parses xml into an Account object
 
 @discussion
 The xml looks like this:
 <account>
	 <active>true</active>
	 <name>Dial Mercury, Inc.</name>
	 <urlName>blah</urlName>
	 <accountUser>
		 <urlName>blah</urlName>
		 <firstName>Paul</firstName>
		 <lastName>Fisher</lastName>
		 <active>true</active>
		 <username>blah</username>
		 <password>foo</password>
		 <emailAddress></emailAddress>
	 </accountUser>
	 <accountPreference>
		 <defaultTimeZone></defaultTimeZone>
		 <originatingEmailAddress></originatingEmailAddress>
		 <orignatingTelephone></orignatingTelephone>
	 </accountPreference>
 </account>
 
 */
- (Account *) parse:(NSData *)xml 
			  error:(NSError **)error {
	Account *result = nil;
	
	DDXMLDocument *doc = [[DDXMLDocument alloc] initWithData:xml options:0 error:error];
	DDXMLElement *element = [doc rootElement];
	result = [self parseAccount:element];
	
	return result;
}

/*!
 @function unmarshal
 @abstract Creates xml out of an Account object
 */
- (NSString *) unmarshal:(Account *)account {
	NSString *result = nil;
	
	if (nil != account) {
		DDXMLElement *root = [DDXMLElement elementWithName:AccountElement];
		
		// first we create the first level elements
		if (nil != account.active) {
			DDXMLElement *accountActive = [[DDXMLElement alloc] initWithName:ActiveElement stringValue:account.active];
			[root addChild:accountActive];
		}
		
		if (nil != account.name) {
			DDXMLElement *accountName = [[DDXMLElement alloc] initWithName:AccountNameElement stringValue:account.name];
			[root addChild:accountName];
		}
		
		if (nil != account.urlName) {
			DDXMLElement *accountUrlName = [[DDXMLElement alloc] initWithName:UrlNameElement stringValue:account.urlName];
			[root addChild:accountUrlName];
		}
		
		// then we create second level elements such as accountUser and accountPreference
		if (nil != account.accountUser) {
			[root addChild:[self createAccountUsers:account.accountUser]];
		}
		
		if (nil != account.accountPreference) {
			[root addChild:[self createAccountPreference:account.accountPreference]];
		}
		
		result = [root XMLStringWithOptions:DDXMLNodePrettyPrint];
	}
	
	return result;
}

/*!
 @function createAccountUsers
 @abstract unmarshals the AccountUser object into XML
 */
- (DDXMLElement *) createAccountUsers:(AccountUser *)accountUser {
	DDXMLElement *accountUsersElem = [[DDXMLElement alloc] initWithName:AccountUsersElement];
	DDXMLElement *accountUserElem = [[DDXMLElement alloc] initWithName:AccountUserElement];
	
	if (nil != accountUser.urlName) {
		DDXMLElement *accountUserUrlName = [[DDXMLElement alloc] initWithName:UrlNameElement stringValue:accountUser.urlName];
		[accountUserElem addChild:accountUserUrlName];
	}
	
	if (nil != accountUser.active) {
		DDXMLElement *accountUserActive = [[DDXMLElement alloc] initWithName:ActiveElement stringValue:accountUser.active];
		[accountUserElem addChild:accountUserActive];
	}
	
	if (nil != accountUser.username) {
		DDXMLElement *accountUsername = [[DDXMLElement alloc] initWithName:UsernameElement stringValue:accountUser.username];
		[accountUserElem addChild:accountUsername];
	}
	
	if (nil != accountUser.email) {
		DDXMLElement *accountUserEmail = [[DDXMLElement alloc] initWithName:EmailAddressElement stringValue:accountUser.email];
		[accountUserElem addChild:accountUserEmail];
	}
	
	if (nil != accountUser.password) {
		DDXMLElement *accountUserPassword = [[DDXMLElement alloc] initWithName:PasswordElement stringValue:accountUser.password];
		[accountUserElem addChild:accountUserPassword];
	}
	
	[accountUsersElem addChild:accountUserElem];
	
	return accountUsersElem;
}

/*!
 @function createAccountPreference
 @abstract unmarshals an AccountPreference object into XML
 */
- (DDXMLElement *) createAccountPreference:(AccountPreference *)accountPreference {
	DDXMLElement *accountPreferenceElem = [[DDXMLElement alloc] initWithName:AccountPreferenceElement];
	
	if (nil != accountPreference.defaultTimeZone) {
		DDXMLElement *defaultTimeZone = [[DDXMLElement alloc] initWithName:DefaultTimeZoneElement stringValue:accountPreference.defaultTimeZone];
		[accountPreferenceElem addChild:defaultTimeZone];
	}
	
	if (nil != accountPreference.originatingTelephone) {
		DDXMLElement *originatingTelephone = [[DDXMLElement alloc] initWithName:OriginatingTelephoneElement stringValue:accountPreference.originatingTelephone];
		[accountPreferenceElem addChild:originatingTelephone];
	}
	
	if (nil != accountPreference.originatingEmailAddress) {
		DDXMLElement *originatingEmailAddress = [[DDXMLElement alloc] initWithName:OriginatingEmailAddressElement stringValue:accountPreference.originatingEmailAddress];
		[accountPreferenceElem addChild:originatingEmailAddress];
	}
	
	return accountPreferenceElem;
}

/*!
 @function parseAccount
 @abstract Parses out xml data to populate an Account object
 */
- (Account *) parseAccount:(DDXMLElement *)element {
	Account *result = nil;
	
	if (nil != element) {
		result = [Account alloc];
		
		// populate data here
		// assuming that objective-c will handle null pointer exceptions
		NSArray *nameElement = [element elementsForName:AccountNameElement];
		result.name = [[nameElement objectAtIndex:0] stringValue];
		
		NSArray *urlNameElement = [element elementsForName:UrlNameElement];
		result.urlName = [[urlNameElement objectAtIndex:0] stringValue];
		
		NSArray *activeElement = [element elementsForName:ActiveElement];
		result.active = [[activeElement objectAtIndex:0] stringValue];
		
		NSArray *accountUserElement = [element elementsForName:AccountUserElement];
		result.accountUser = [self parseAccountUser:[accountUserElement objectAtIndex:0]];
		
		NSArray *accountPreferenceElement = [element elementsForName:AccountPreferenceElement];
		result.accountPreference = [self parseAccountPreference:[accountPreferenceElement objectAtIndex:0]];
	}
	
	return result;
}

/*!
 @function parseAccountUser
 @abstract Parses out xml data to populate an AccountUser object
 */
- (AccountUser *) parseAccountUser:(DDXMLElement *)element {
	AccountUser *result = nil;
	
	if (nil != element) {
		result = [AccountUser alloc];
		
		// populate data here
		// assuming that objective-c will handle null pointer exceptions
		NSArray *urlNameElement = [element elementsForName:UrlNameElement];
		result.urlName = [[urlNameElement objectAtIndex:0] stringValue];
		
		NSArray *activeElement = [element elementsForName:ActiveElement];
		result.active = [[activeElement objectAtIndex:0] stringValue];
		
		NSArray *firstNameElement = [element elementsForName:FirstNameElement];
		result.firstName = [[firstNameElement objectAtIndex:0] stringValue];
		
		NSArray *lastNameElement = [element elementsForName:LastNameElement];
		result.lastName = [[lastNameElement objectAtIndex:0] stringValue];
		
		NSArray *usernameElement = [element elementsForName:UsernameElement];
		result.username = [[usernameElement objectAtIndex:0] stringValue];
		
		NSArray *passwordElement = [element elementsForName:PasswordElement];
		result.password = [[passwordElement objectAtIndex:0] stringValue];
		
		NSArray *emailElement = [element elementsForName:EmailAddressElement];
		result.email = [[emailElement objectAtIndex:0] stringValue];
	}
	
	return result;
}

/*!
 @function parseAccountPreference
 @abstract Parses out xml data to populate an AccountPreference object
 */
- (AccountPreference *) parseAccountPreference:(DDXMLElement *)element {
	AccountPreference *result = nil;
	
	if (nil != element) {
		result = [AccountPreference alloc];
		
		// populate data here
		// assuming that objective-c will handle null pointer exceptions
		NSArray *defaultTimeZoneElement = [element elementsForName:DefaultTimeZoneElement];
		result.defaultTimeZone = [[defaultTimeZoneElement objectAtIndex:0] stringValue];
		
		NSArray *originatingEmailAddressElement = [element elementsForName:OriginatingEmailAddressElement];
		result.originatingEmailAddress = [[originatingEmailAddressElement objectAtIndex:0] stringValue];
		
		NSArray *originatingTelephoneElement = [element elementsForName:OriginatingTelephoneElement];
		result.originatingTelephone = [[originatingTelephoneElement objectAtIndex:0] stringValue];
	}
	
	return result;
}

- (void) dealloc {
	[super dealloc];
}

@end
