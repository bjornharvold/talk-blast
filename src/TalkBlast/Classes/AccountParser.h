//
//  AccountParser.h
//  TalkBlast
//
//  Created by crash on 7/20/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Account;
@class AccountPreference;
@class AccountUser;
@class DDXMLElement;

/*!
 @class AccountUserParser
 @abstract Parses account user xml that looks like this:
 
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
 and creates an Account object.
 
 We aren't using NSXMLParser here as the xml is tiny so we included kissxml in the utilities directory
 */
@interface AccountParser : NSObject {

}

// parsing xml
- (Account *) parse:(NSData *)xml 
			  error:(NSError **)error;
- (Account *) parseAccount:(DDXMLElement *)element;
- (AccountUser *) parseAccountUser:(DDXMLElement *)element;
- (AccountPreference *) parseAccountPreference:(DDXMLElement *)element;

// unmarshaling object
- (NSString *) unmarshal:(Account *)account;
- (DDXMLElement *) createAccountUsers:(AccountUser *)accountUser;
- (DDXMLElement *) createAccountPreference:(AccountPreference *)accountPreference;

@end
