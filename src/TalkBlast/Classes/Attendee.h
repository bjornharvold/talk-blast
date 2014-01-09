#import <Foundation/Foundation.h>

@interface Attendee : NSObject {
	NSString *personId;
	NSString *personName;
	NSString *phoneNumber;
	NSString *phoneLabel;
	NSMutableArray *availablePhoneNumbers;
	NSMutableArray *availablePhoneLabels;
}

@property (nonatomic, retain) NSString *personId;
@property (nonatomic, retain) NSString *personName;
@property (nonatomic, retain) NSString *phoneNumber;
@property (nonatomic, retain) NSString *phoneLabel;
@property (nonatomic, retain) NSMutableArray *availablePhoneNumbers;
@property (nonatomic, retain) NSMutableArray *availablePhoneLabels;

@end
