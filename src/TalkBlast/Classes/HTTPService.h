//
//  HTTPService.h
//  TalkBlast
//
//  Created by crash on 7/19/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Responder;

/*!
 @class HTTPService
 @abstract Responsible for all external interactiosn via the HTTP protocol
 */
@interface HTTPService : NSObject {

}

/*!
 @function doPostWithURL
 @abstract Executes a synchronous HTTP POST
 @param url The URL string
 @param params Name/Value pairs
 @param delegate Delegate to handle responses
 @param username Username to authenticate with
 @param password Password to authentiate with
 @param error Error object that gets populated if there was an error
 */
- (void) doAsynchronousPostWithURL:(NSString *) url 
							params:(NSDictionary *) params
						  responder:(Responder *)responder
						  username:(NSString *)username 
						  password:(NSString *)password  
							 error:(NSError **) error;

/*!
 @function doAuthenticatedAsynchronousGetWithURL:params:username:password:error
 @abstract Method performs an authenticated GET method and returns the result as a string
 @param url URL to resource
 @param params Name / Value pairs of stuff we want to add to the url
 @param delegate EventHandler object that will handle the result
 @param username Username to authenticate with
 @param password Password to authentiate with
 @param error Error object that gets populated if there was an error
 */
- (void) doAsynchronousGetWithURL:(NSString *)url 
						   params:(NSDictionary *)params
						 responder:(Responder *)responder 
						 username:(NSString *)username 
						 password:(NSString *)password 
							error:(NSError **)error;
@end
