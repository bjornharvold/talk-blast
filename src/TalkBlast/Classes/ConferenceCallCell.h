#import <UIKit/UIKit.h>

@class ConferenceCallView;
@class CommunicationEvent;

/*!
 @class ConferenceCallCell
 @abstract Custom TableViewCell for our conference calls
 */
@interface ConferenceCallCell : UITableViewCell {
	ConferenceCallView *conferenceCallView;
}

- (void) setConferenceCall:(CommunicationEvent *) newConferenceCall;

@property (nonatomic, retain) ConferenceCallView *conferenceCallView;

@end
