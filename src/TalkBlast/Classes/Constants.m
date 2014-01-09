//
//  Constants.m
//  TalkBlast
//
//  Created by crash on 8/8/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "Constants.h"

// HTTP related
int const UNAUTHORIZED = 401;
int const INTERNAL_SERVER_ERROR = 500;
NSString * const TALKBLAST_URL_KEY = @"talkblasturl";
NSString * const ERROR_DOMAIN = @"talkblast";
NSString * const TALKBLAST_URL = @"http://localhost:8080/TalkBlastTestServer";
NSString * const HTTP_GET = @"GET";
NSString * const HTTP_PUT = @"PUT";
NSString * const HTTP_POST = @"POST";
NSString * const HTTP_DELETE = @"DELETE";
NSString * const USERNAME = @"username";
NSString * const PASSWORD = @"password";

// business related
NSString * const ACCOUNT = @"account";

// for parsing communicationEvents
NSString * const OriginationEventElement = @"originationEvent";
NSString * const UrlNameElement = @"urlName";
NSString * const CountAttribute = @"count";
NSString * const TitleElement = @"title";
NSString * const EventTypeElement = @"eventType";
NSString * const DestinationFilterElement = @"destinationFilter";
NSString * const EventStatusElement = @"eventStatus";
NSString * const DateCreatedElement = @"dateCreated";
NSString * const LastUpdatedElement = @"lastUpdated";
NSString * const ScheduledDeliveryElement = @"scheduledDelivery";
NSString * const NameAttribute = @"name";
NSString * const HrefAttribute = @"href";
NSString * const SourceAttribute = @"src";
NSString * const AccountAttribute = @"account";
NSString * const AccountUserAttribute = @"accountUser";
NSString * const LinkElement = @"link";
NSString * const DestinationGroupsElement = @"destinationGroups";
NSString * const DestinationContactsElement = @"destinationContacts";
NSString * const MediaContentElement = @"mediaContent";
NSString * const MediaContentItemElement = @"mediaContentItem";

// for parsing accounts
NSString * const AccountElement = @"account";
NSString * const AccountNameElement = @"name";
NSString * const AccountUsersElement = @"accountUsers";
NSString * const AccountUserElement = @"accountUser";
NSString * const FirstNameElement = @"firstName";
NSString * const LastNameElement = @"lastName";
NSString * const UsernameElement = @"username";
NSString * const EmailAddressElement = @"emailAddress";
NSString * const PasswordElement = @"password";
NSString * const ActiveElement = @"active";
NSString * const AccountPreferenceElement = @"accountPreference";
NSString * const DefaultTimeZoneElement = @"defaultTimeZone";
NSString * const OriginatingEmailAddressElement = @"originatingEmailAddress";
NSString * const OriginatingTelephoneElement = @"originatingTelephone";

@implementation Constants

@end
