#import <UIKit/UIKit.h>
@class CommunicationEvent;
@class TalkBlastAppDelegate;
@class ConferenceCallEditorNavigationController;
@class ConferenceCallEditorViewController;
@class DialmService;

/*!
 @class CallHistoryViewController
 @abstract Displays a list of past conference calls and add the ability to create a new conference call
 */
@interface CallHistoryViewController : UITableViewController {
	ConferenceCallEditorNavigationController *conferenceCallEditorNavigationController;
	TalkBlastAppDelegate *applicationDelegate;
	ConferenceCallEditorViewController *conferenceCallEditorViewController;
}

@property (nonatomic, retain) IBOutlet ConferenceCallEditorNavigationController *conferenceCallEditorNavigationController;
@property (nonatomic, retain) IBOutlet ConferenceCallEditorViewController *conferenceCallEditorViewController;
@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;

- (IBAction)addAction:(id)sender;

- (id) blastsResult:(id)object, ...;

- (id) blastsFault:(id)error, ...;

@end
