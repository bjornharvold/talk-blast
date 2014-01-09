//
//  Constants.h
//  TalkBlast
//
//  Created by crash on 8/8/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

extern int const UNAUTHORIZED;
extern int const INTERNAL_SERVER_ERROR;
extern NSString * const TALKBLAST_URL_KEY;
extern NSString * const ERROR_DOMAIN;
extern NSString * const TALKBLAST_URL;
extern NSString * const HTTP_GET;
extern NSString * const HTTP_PUT;
extern NSString * const HTTP_POST;
extern NSString * const HTTP_DELETE;
extern NSString * const USERNAME;
extern NSString * const PASSWORD;
extern NSString * const ACCOUNT;

// for parsing communicationEvents
extern NSString * const OriginationEventElement;
extern NSString * const UrlNameElement;
extern NSString * const CountAttribute;
extern NSString * const TitleElement;
extern NSString * const EventTypeElement;
extern NSString * const DestinationFilterElement;
extern NSString * const EventStatusElement;
extern NSString * const DateCreatedElement;
extern NSString * const LastUpdatedElement;
extern NSString * const ScheduledDeliveryElement;
extern NSString * const NameAttribute;
extern NSString * const HrefAttribute;
extern NSString * const SourceAttribute;
extern NSString * const AccountAttribute;
extern NSString * const AccountUserAttribute;
extern NSString * const LinkElement;
extern NSString * const DestinationGroupsElement;
extern NSString * const DestinationContactsElement;
extern NSString * const MediaContentElement;
extern NSString * const MediaContentItemElement;

// for parsing accounts
extern NSString * const AccountElement;
extern NSString * const AccountNameElement;
extern NSString * const UrlNameElement;
extern NSString * const AccountUsersElement;
extern NSString * const AccountUserElement;
extern NSString * const FirstNameElement;
extern NSString * const LastNameElement;
extern NSString * const UsernameElement;
extern NSString * const EmailAddressElement;
extern NSString * const PasswordElement;
extern NSString * const ActiveElement;
extern NSString * const AccountPreferenceElement;
extern NSString * const DefaultTimeZoneElement;
extern NSString * const OriginatingEmailAddressElement;
extern NSString * const OriginatingTelephoneElement;

@interface Constants : NSObject {

}

@end
