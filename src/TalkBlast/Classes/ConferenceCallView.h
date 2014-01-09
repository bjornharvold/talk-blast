#import <UIKit/UIKit.h>

@class CommunicationEvent;
@class Attendee;

/*!
 @class ConferenceCalView
 @abstract Custom view for displaying a conference call object
 */
@interface ConferenceCallView : UIView {
	CommunicationEvent *communicationEvent;
	NSDateFormatter *dateFormatter;
	NSDateFormatter *timeFormatter;
	BOOL highlighted;
	BOOL editing;
}

@property (nonatomic, retain) CommunicationEvent *communicationEvent;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDateFormatter *timeFormatter;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (nonatomic, getter=isEditing) BOOL editing;

@end
