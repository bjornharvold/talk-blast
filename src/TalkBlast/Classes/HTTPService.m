//
//  HTTPService.m
//  TalkBlast
//
//  Created by crash on 7/19/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "HTTPService.h"
#import "Responder.h"

int const CONNECTION_ERROR = -1004;

NSMutableData *mutableData = nil;
Responder *theResponder = nil;
NSString *theUsername = nil;
NSString *thePassword = nil;

@implementation HTTPService

- (void) doAsynchronousPostWithURL:(NSString *) url 
							params:(NSDictionary *) params
						 responder:(Responder *)responder
						  username:(NSString *)username 
						  password:(NSString *)password  
							 error:(NSError **) error; {
	theUsername = username;
	thePassword = password;
	theResponder = responder;
	
	NSString *postLength = @"0";
	NSData *postData = nil;
	
	// now we convert the dictionary to a string of name - value pairs
	if (nil != params) {
		// get all the keys in the dictionary so we can loop through them
		NSArray *allKeys = [params allKeys];
		NSString *post = @"";
		for (int i = 0; i < [allKeys count]; i++) {
			NSString *paramName = (NSString *)[allKeys objectAtIndex:i];
			NSString *paramValue = (NSString *) [params valueForKey:paramName];
			
			// we append name value pairs here e.g. key1=value1&key2=value2
			post = [NSString stringWithFormat:@"%@%@=%@", post, paramName, paramValue];
			
			// add a delimiter to every name - value pair except the last one
			if (i+1 < [allKeys count]) {
				post=[NSString stringWithFormat:@"%@&", post];
			}
		}
		
		// finally we encode the string
		NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];  
		
		// data length
		postLength = [NSString stringWithFormat:@"%d", [postData length]]; 
		
		NSLog(@"Post data: %@, Length: %d", post, postLength);
	}
	
	// create out url object first
	NSURL *theURL = [NSURL URLWithString:url];
	
	// then the actual request to send to the url
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:theURL 
														   cachePolicy:NSURLRequestReloadIgnoringCacheData 
													   timeoutInterval:30.0f];
	[request setHTTPMethod:@"POST"];
	[request setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:postData];

	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	
	// if for some reason the connection could not be created, it will be nil
	if (nil == theConnection) {
		//An error occurred
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:@"Could not create url connection" forKey:NSLocalizedDescriptionKey];
		
		*error = [NSError errorWithDomain:@"talkblast" code:CONNECTION_ERROR userInfo:errorDetail];
	}
}

- (void) doAsynchronousGetWithURL:(NSString *)url 
						   params:(NSDictionary *)params
						 responder:(Responder *)responder 
						 username:(NSString *)username 
						 password:(NSString *)password 
							error:(NSError **)error {
	theUsername = username;
	thePassword = password;
	theResponder = responder;
	
	NSURLRequest *theRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:url]
											  cachePolicy:NSURLRequestUseProtocolCachePolicy
										  timeoutInterval:30.0];
	
	// create the connection with the request
	// and start loading the data
	NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:theRequest delegate:self];	
	
	// if for some reason the connection could not be created, it will be nil
	if (nil == theConnection) {
		//An error occurred
		NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
		[errorDetail setValue:@"Could not create url connection" forKey:NSLocalizedDescriptionKey];
		
		*error = [NSError errorWithDomain:@"talkblast" code:CONNECTION_ERROR userInfo:errorDetail];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
	NSLog(@"HTTP connection received an authentication challenge");
	
	if ([challenge previousFailureCount] == 0) {
		NSURLCredential *newCredential;
		newCredential = [NSURLCredential credentialWithUser:theUsername 
												   password:thePassword 
												persistence:NSURLCredentialPersistenceNone];
		[[challenge sender] useCredential:newCredential forAuthenticationChallenge:challenge];
	} else {
		[[challenge sender] cancelAuthenticationChallenge:challenge];
	}
	
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"HTTP connection received response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	NSLog(@"HTTP connection received data");
	
	if (nil == mutableData) {
		mutableData = [NSMutableData alloc];
	}
	
	// keep on appending data until the response is complete
	[mutableData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"HTTP connection failed with error");
	
	// release any data that came in through the wire
	[mutableData release];
	
	[theResponder fault:error];
}

/*!
 @function connectionDidFinishLoading
 @abstract called when all data has been received. at that time we want to save the data on an object and dispatch a notification
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	NSLog(@"HTTP connection finished loading");
	
	[theResponder result:mutableData];
	
	[mutableData release];
}


- (void) dealloc {
	[super dealloc];
}
@end
