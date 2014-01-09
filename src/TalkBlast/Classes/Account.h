//
//  Account.h
//  TalkBlast
//
//  Created by crash on 8/1/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AccountUser;
@class AccountPreference;

/*!
 @class Account
 @abstract Model object for our definition of an Account
 */
@interface Account : NSObject <NSCoding> {
	NSString *active;
	NSString *name;
	NSString *urlName;
	AccountUser *accountUser;
	AccountPreference *accountPreference;
}

@property (nonatomic, retain) NSString *active;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *urlName;
@property (nonatomic, retain) AccountUser *accountUser;
@property (nonatomic, retain) AccountPreference *accountPreference;

+ (Account *) init;

@end
