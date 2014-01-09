//
//  AccountUser.h
//  TalkBlast
//
//  Created by crash on 7/20/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AccountUser : NSObject <NSCoding> {
	NSString *firstName;
	NSString *lastName;
	NSString *active;
	NSString *username;
	NSString *email;
	NSString *password;
	NSString *urlName;
}

@property (nonatomic, retain) NSString *firstName;
@property (nonatomic, retain) NSString *lastName;
@property (nonatomic, retain) NSString *active;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *urlName;

@end
