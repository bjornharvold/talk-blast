//
//  AbstractCommand.m
//  TalkBlast
//
//  Created by crash on 8/8/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "AbstractCommand.h"
#import "Constants.h"

@implementation AbstractCommand

/*!
 @function didRetrieveData
 @abstract Abstract implementation of WrapperDelegate didRetrieveData method
 @discussion 
 
 This method should be overridden by the extending classes and they forget they will get this message
 
 */
- (void)wrapper:(Wrapper *)wrapper didRetrieveData:(NSData *)data {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dev error" 
                                                    message:@"You have to implement this method in the concrete class"  
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK" 
                                          otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}

/*!
 @function wrapperHasBadCredentials
 @abstract Occurs when we receive a 401 from the server
 @discussion 
 
 This is common to all extending classes and there is no reason to override this method.
 
 If the user doesn't have the correct BASIC AUTH credentials, this method will get executed at which time
 
 we create an error object and pass it back to the caller.
 
 */
- (void)wrapperHasBadCredentials:(Wrapper *)wrapper {
	[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
	// create new error message to let caller know why his call failed
	NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:NSLocalizedString(@"error.authentication", @"Authentication error") forKey:NSLocalizedDescriptionKey];
    NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:UNAUTHORIZED userInfo:errorDetail];
	
	// let caller know about the error
	if ([caller respondsToSelector:faultSelector]) {
		[caller faultSelector:error];
	}
}

/*!
 @function didCreateResourceAtURL
 @abstract This happens when we wanted to do a PUT and got a successful 201 code back
 @discussion 
 
 This application is currently not using PUTS. But if it did, this method should be enough for all extending classes.
 
 */
- (void)wrapper:(Wrapper *)wrapper didCreateResourceAtURL:(NSString *)url {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if ([caller respondsToSelector:successSelector]) {
		[caller successSelector:nil];
	}
}

/*!
 @function didFailWithError
 @abstract If the TalkBlast server is not available, the wrapper engine will execute this method
 @discussion 
 
 The server could, for some reason, not be reached. We create an error message and pass to back to the caller.
 
 */
- (void)wrapper:(Wrapper *)wrapper didFailWithError:(NSError *)error {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // create new error message to let caller know why his call failed
	NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:NSLocalizedString(@"error.server.unreachable", @"TalkBlast server is unavailable") forKey:NSLocalizedDescriptionKey];
    
    // we could use the generated error but we wouldn't have as much constrol over the message because we don't want
    // to make the engine error domain specific
    NSError *newError = [NSError errorWithDomain:ERROR_DOMAIN code:INTERNAL_SERVER_ERROR userInfo:errorDetail];
	
	// let caller know about the error only if he has a method called loginCommandFault
	if ([caller respondsToSelector:faultSelector]) {
		[caller faultSelector:newError];
	}
}

/*!
 @function didReceiveStatusCode
 @abstract If a status code is not a "good" status code, the wrapper engine will execute this method.
 @discussion 
 
 The server returned a bad error code. We create an error message and pass to back to the caller.
 
 */
- (void)wrapper:(Wrapper *)wrapper didReceiveStatusCode:(int)statusCode {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    // create new error message to let caller know why his call failed
	NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
    [errorDetail setValue:NSLocalizedString(@"error.server.statuscode", statusCode) forKey:NSLocalizedDescriptionKey];
    
    NSError *error = [NSError errorWithDomain:ERROR_DOMAIN code:INTERNAL_SERVER_ERROR userInfo:errorDetail];
	
	// let caller know about the error only if he has a method called loginCommandFault
	if ([caller respondsToSelector:faultSelector]) {
		[caller faultSelector:error];
	}
}

@end
