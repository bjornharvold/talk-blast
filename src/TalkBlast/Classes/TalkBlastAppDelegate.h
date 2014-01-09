#import <UIKit/UIKit.h>

@class ApplicationTabBarController;
@class CommunicationEvent;
@class Attendee;
@class SoundService;
@class PreferencesService;
@class Account;
@class FrontController;
@class MediaContent;

/*!
 @class ConferenceCalAppDelegate
 @abstract This is TalkBlast's application delegate that gets loaded as our first class in our application
 @discussion Welcome to the TalkBlast application. This is an application intended for a mobile platform such as the iPhone, Blackberry and Symbian platforms.
 It enables the user to initiate a conference call from the users mobile device, using the user's existing address book contacts. The typical steps a user
 would take to set up TalkBlast would be:
 
 1. Start the application
 
 2. If the user is starting the application for the first time he will need to login/setup an account with TalkBlast. Other functionality will 
 not be available before the user has been registered with our server
 
 3. Once the user has an account with TalkBlast, he will need to buy minutes with which he can initiate a conference call. Buying of minutes is done using the
 iPhone's InApp Purchase functionality. The user is now ready to make a conference call.
 
 4. The user should then create an introductory recording for his first conference call. He can do so by clicking on the Recordings tab where he will see
 a list of recordings and the ability to create a new one.
 
 5. The user can then create a new conference call by clicking on the Blasts tab. There he will see a list of 'Past Blasts' that he can reuse to create 
 a new conference call or he can create a conference call from scratch.
 
 6. When the user creates a new conference call, he is presented with a page where he can: 
 
	- enter a descriptive name for the conference call (optional),

	- enter in a date/time for a scheduled conference call (optional, defaults to now),
 
	- select attendees from his address book
 
	- select an introductory recording to initiate the conference call
 

 These are the main features of this application. For more details on all the business rules, read the documentation on the various controllers
 
 The method:
 - (void)applicationDidFinishLaunching:(UIApplication *)application {} is the first method that gets called. This is where
 we do the application initialization. For detailed information about the method does, look at the function description.
 The application delegate is concerned about initializing our services, such as the dialmService that communicates with the
 external VoIP service and the soundService, which is responsible for playing and recording audio. It will initialize any directories that
 are needed for storage and will check if user preferences have been created.
*/
@interface TalkBlastAppDelegate : NSObject <UIApplicationDelegate> {	
	UIWindow *window;
	// our tabbar
	ApplicationTabBarController *applicationTabBarController;
	// intro screen
	UIImageView *splashScreen;
	// handles our recording
	SoundService *soundService;
	// handles our preferences that are file based
	PreferencesService *preferencesService;
	// manages our list of asynchronous commands
	FrontController *frontController;
	// generic joect to handle errors
	UIAlertView *alertView;
	// timer for intro screen
	NSTimer *splashScreenTimer;
	// user who logs in will get this object set
	Account *account;
	// root url for the talkblast server
	NSString *talkBlastUrl;
	// list of past conference calls
	NSArray *displayList;
	// the current conf call being worked on
	CommunicationEvent *communicationEvent;
	// media content we received from the talkblast server
	MediaContent *mediaContent;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ApplicationTabBarController *applicationTabBarController;
@property (nonatomic, retain) IBOutlet UIImageView *splashScreen;
@property (nonatomic, retain) SoundService *soundService;
@property (nonatomic, retain) FrontController *frontController;
@property (nonatomic, retain) PreferencesService *preferencesService;
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) NSTimer *splashScreenTimer;
@property (nonatomic, retain) Account *account;
@property (nonatomic, retain) NSString *talkBlastUrl;
@property (nonatomic, retain) NSArray *displayList;
@property (nonatomic, retain) CommunicationEvent *communicationEvent;
@property (nonatomic, retain) MediaContent *mediaContent;

/*!
 @function toggleTabBarItemAtIndex:enabled:forwardToControllerWithIndex
 @abstract Utility method to enable/disable certain tabs
 @param indexes The tabs we want to disable/enable
 @param enabled YES/NO for enabling/disabling
 @param forwardToControllerWithIndex optional forward to tab with specified index
 */
- (void) toggleTabBarItemAtIndex:(NSArray *) indexes 
						 enabled:(BOOL) enabled 
	forwardToControllerWithIndex:(NSInteger *)forwardToIndex;

/*!
 @function showRegistrationAlertView
 @abstract When user starts the application for the first time he will see a pop-up telling him to register
 */
- (void) showRegistrationAlertView;

/*!
 @function showInvalidPreferencesAlertView
 @abstract Preferences exists but they are invalid so this method is called that displays a pop-up
 */
- (void) showInvalidPreferencesAlertView;

/*!
 @function showProblemConnectingToHostAlertView
 @abstract When the TalkBlast server is offline the application stays at the splash page and this pop-up is displayed
 */
- (void) showProblemConnectingToHostAlertView;

/*!
 @function loginResult
 @abstract Called on successful login
 */
- (void) loginResult:(id)object;

/*!
 @function loginFault
 @abstract Called on unsuccessful login
 */
- (void) loginFault:(id)error;

/*!
 @function serverStatusCheckResult
 @abstract Server availability is a go
 */
- (void) serverStatusCheckResult:(id)object;

/*!
 @function serverStatusCheckFault
 @abstract Server availability is a no-go
 */
- (void) serverStatusCheckFault:(id)error;

/*!
 @function editConferenceCallAtIndex
 @abstract Takes an existing conference call and makes a copy of it to reuse as the template for a new conference call
 */
- (void) editCommunicationEventAtIndex:(NSInteger) index;

/*!
 @function newConferenceCall
 @abstract Creates a new conference call object to interact with
 */
- (void) newCommunicationEvent;

@end
