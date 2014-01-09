#import "Attendee.h"



@implementation Attendee
@synthesize personId;
@synthesize personName;
@synthesize phoneNumber;
@synthesize phoneLabel;
@synthesize availablePhoneNumbers; 
@synthesize	availablePhoneLabels;

- (void)dealloc {
	[personId release];
	[personName release];
	[phoneLabel release];
	[phoneNumber release];
	[availablePhoneNumbers release];
	[availablePhoneLabels release];
	[super dealloc];
}

@end
