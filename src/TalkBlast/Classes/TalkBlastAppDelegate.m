#import "TalkBlastAppDelegate.h"
#import "CallHistoryViewController.h"
#import "ApplicationTabBarController.h"
#import "CommunicationEvent.h"
#import "Attendee.h"
#import "SoundService.h"
#import "PreferencesService.h"
#import "Account.h"
#import "AccountUser.h"
#import "FrontController.h"
#import "LoginEvent.h"
#import "ServerStatusCheckEvent.h"
#import "Constants.h"
#import "MediaContent.h"

@implementation TalkBlastAppDelegate

@synthesize window;
@synthesize applicationTabBarController;
@synthesize splashScreen;
@synthesize soundService;
@synthesize frontController;
@synthesize preferencesService;
@synthesize alertView;
@synthesize splashScreenTimer;
@synthesize account;
@synthesize talkBlastUrl;
@synthesize displayList;
@synthesize communicationEvent;
@synthesize mediaContent;

int counter = 0;

/*!
 @function applicationDidFinishLaunching
 @abstract initializes the application
 @param application The UIApplication (MainWindow.xib) that is being loaded from the main file
 @discussion 
 - Checks to see if the TalkBlast server is accepting calls
 
 - Loads up preferences into memory. Checks to see if there is a test server url specified in Settings otherwise defaults to a url
 
 - Initiates the Sound Service
 
 - Checks if user preferences already exists
 
 - If there are no user prefs, the user will be forwarded to the Settings page and other tabs will be disabled
 
 - If user prefs exist, log in to the TalkBlast server to retrieve call history and remaining minutes.
 
 - If the TalkBlast server is down, disable the application and leave it at the splash page
 
 - If the user session object is empty, disable the tabs and display an alert
 
 - If the user session object does exist, we automatically forward to the first view in the navigation stack: "Welcome" view

 */
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    // preferences should be initialized first as other service will depend on it
	self.preferencesService = [PreferencesService init];
	
    // grab the url to connect to from settings
	self.talkBlastUrl = [self.preferencesService userDefaultByKey:TALKBLAST_URL_KEY];
	// if it is empty, url will default to http://localhost:8080/talkblast as defined in our constants class	
	if (nil == self.talkBlastUrl) {
		self.talkBlastUrl = TALKBLAST_URL;
	}
    
	// initiate the front controller that handles all event dispatching
	self.frontController = [FrontController alloc];
	[self.frontController initMap];
    
    // here are the callback methods we want to have the command respond to
    SEL successSelector = @selector(serverStatusCheckResult:);
    SEL faultSelector = @selector(serverStatusCheckFault:);
    
    // let's make sure the TalkBlast server is operational
    // without it we don't want to have the user do anything
    [self.frontController dispatchEvent:[ServerStatusCheckEvent initWithCaller:self 
                                                               successSelector:successSelector 
                                                                 faultSelector:faultSelector 
                                                                        params:nil]];
    
    [window addSubview:self.splashScreen];
    [window makeKeyAndVisible];
}

/*!
 @function serverStatusCheckResult
 @abstract The result of pinging the TalkBlast server
 @discussion The object will be a BOOL true or this method won't be called. If it is true we can continue processing
 */
- (void) serverStatusCheckResult:(id)object {
	
    // instantiate the sound service
	self.soundService = [SoundService alloc];
    
	// what we really want to have happen here is to check if the user already has credentials saved
	// if not we should display an alert view telling the user to go to settings to set up an account
	//		after the user confirms his account, we should retrieve call history
	// if yes we retrieve the call history
	// User should not be allowed to go anywhere else but Settings until he has registered
	// User should not be allowed to initiate any calls until he has purchased enough minutes.
	self.account = [self.preferencesService retrieveObjectGraphForKey:AccountObjectKey];
	
    if (nil != self.account) {
		// log in with server and retrieve the call histories
		// if credentials don't match, forward to settings page
		NSString *username = self.account.accountUser.username;
		NSString *password = self.account.accountUser.password;
		
		// dispatch login event
		[self.frontController dispatchEvent:[LoginEvent initWithCaller:self 
																params:[NSDictionary dictionaryWithObjectsAndKeys:username, USERNAME, password, PASSWORD, nil]]];
	} else {
		// we want the first page to be the settings page so 
		// the user can register with the server before doing anything else
		// and we want to disable the call history tab and the recordings tab
		[self toggleTabBarItemAtIndex:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil] 
							  enabled:NO 
		 forwardToControllerWithIndex:(NSInteger *)3];
		
		// remove the splash screen
		self.splashScreenTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
																  target:self 
																selector:@selector(splashScreenTimerCheck)
																userInfo:NULL 
																 repeats:YES];
		
		// pop up alert to say they have to register first
		[self showRegistrationAlertView];
	}
}


/*!
 @function serverStatusCheckFault
 @abstract The result of pinging the TalkBlast server when the server is unavailable
 @discussion The object will be a BOOL true or this method won't be called. If it is true we can continue processing
 */
- (void) serverStatusCheckFault:(id)error {
	
    // show error message and stay on the splash screen
	[self showProblemConnectingToHostAlertView];
}

/*!
 @function loginResult
 @abstract The result of logging in to the TalkBlast server
 @discussion 
 If the request is successful, it will receive an AccountUser object from the TalkBlast server
 
 if it is valid or nil if no user could be found by that name.
 
 Notice that we grab an account from preferences in order to login to the server. Then when login is complete we have a new user object that
 
 we need to save to disk again.
 */
- (void) loginResult:(id)object {
	
	// in all other cases of failure the login object will be nil
	if (nil == object) {
		// invalid user - forward to settings and disable the call history tab and the recordings tab
		[self toggleTabBarItemAtIndex:[NSArray arrayWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:2], nil] 
							  enabled:NO 
		 forwardToControllerWithIndex:(NSInteger *)3];
		
		// pop up alert to say the email and password is invalid
		[self showInvalidPreferencesAlertView];
	} else {
		if ([object class] == [Account class]) {
			// do nothing - we will forward to the welcome view automatically
			// but we will set the accountUser object on the dialmService
			self.account = (Account *)object;
			
			// save back to preferences as the object on disk could be outdated
			[self.preferencesService saveObjectGraph:self.account forKey:AccountObjectKey];
		}
	}
	
	// regardless whether the user is logged in successful or not - we still remove the splash screen
	self.splashScreenTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
															  target:self 
															selector:@selector(splashScreenTimerCheck)
															userInfo:NULL 
															 repeats:YES];
}

/*!
 @function loginFault
 @abstract If the login attempt fails because the server is down, this method will be called
 */
- (void) loginFault:(id)error {

}

/*!
 @function splashScreenTimerCheck
 @abstract Displays a splash screen for 4 seconds at start and removes it afterwards
 */
- (void) splashScreenTimerCheck {
	NSLog(@"Splash counter: %d", counter);
	
	if (counter == 3) {
		NSLog(@"Time to remove splash screen!");
		[self.splashScreenTimer invalidate];
		// remove splash screen and show application tabbar controller
		[self.splashScreen removeFromSuperview];
		
		// Configure and show the window
		[window addSubview:self.applicationTabBarController.view];
		[window makeKeyAndVisible];
	} else {
		counter++;
	}
}

/*!
 @function toggleTabBarItemAtIndex
 @param indexes The indexes in the navigationController we wish to modify
 @param enabled The action we wish to run on the desired tabs specified by their indexes
 @param forwardToIndex The tab view we wish to forward to after we are done running the action on the specified indexes (optional)
 @discussion
 The applicationTabBarController is our main tab bar. There we load up all our views. This function will disable / enable the 
 tab bar item(s) that we specify in our 'indexes' array.
 */
- (void) toggleTabBarItemAtIndex:(NSArray *) indexes 
						 enabled:(BOOL) enabled 
	forwardToControllerWithIndex:(NSInteger *)forwardToIndex {
	
	for (int i = 0; i < [indexes count]; i++) {
		NSNumber *tabIndex = (NSNumber *)[indexes objectAtIndex:i];
		
		[[[[self.applicationTabBarController viewControllers] objectAtIndex:[tabIndex intValue]] tabBarItem] setEnabled:enabled];
	}
	
	if (nil != forwardToIndex) {
		[self.applicationTabBarController setSelectedIndex:(NSInteger)forwardToIndex];
	}
}

/*!
 @function showRegistrationAlertView
 @abstract Displays an alert when user doesn't have any preferences set and needs to create a new account
 */
- (void) showRegistrationAlertView {
	NSString *title = NSLocalizedString(@"welcome", @"Welcome message");
	NSString *message = NSLocalizedString(@"welcome.info", @"Welcome informational");
	NSString *buttonTitle = NSLocalizedString(@"error.input.ok", @"OK");
	
	self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil, nil];
	[self.alertView show];
	[self.alertView release];
}

/*!
 @function showProblemConnectingToHostAlertView
 @abstract Shows an error message if the host could not be found
 */
- (void) showProblemConnectingToHostAlertView {
	// we are passing the error object but we're not currently using it as the error message contains enough information
	NSString *title = NSLocalizedString(@"error.server", @"Server error");
	NSString *message = NSLocalizedString(@"error.server.unreachable", @"Cannot reach the TalkBlast server at this time. Please try again in a few minutes. We apologize for the inconvenience");
	NSString *buttonTitle = NSLocalizedString(@"error.input.ok", @"OK");
	
	self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil, nil];
	[self.alertView show];
	[self.alertView release];
}
/*!
 @function showInvalidPreferencesAlertView
 @abstract Displays an alert when user has preferences but they don't validate with the server
 */
- (void) showInvalidPreferencesAlertView {
	NSString *title = NSLocalizedString(@"error.invalid.account", @"Invalid Account");
	NSString *message = NSLocalizedString(@"error.invalid.account.info", @"Invalid account informational");
	NSString *buttonTitle = NSLocalizedString(@"error.input.ok", @"OK");
	
	self.alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles:nil, nil];
	[self.alertView show];
	[self.alertView release];
}

/*!
 @function editConferenceCallAtIndex
 @abstract creates an editable object of an existing call history object
 @param index The index in the call history stack we'd like to use as an editable object
 */
- (void) editCommunicationEventAtIndex:(NSInteger) index {	
	// release existing conference call
	[self.communicationEvent release];
	
	if ([self.displayList count] > index) {
		
		// clone existing conference call as we are not modifying data from the server
		self.communicationEvent = [(CommunicationEvent *)[self.displayList objectAtIndex:index] copy];
	}
}

/*!
 @function newConferenceCall
 @abstract instantiates a new conference call object and sets it as the editable conference call
 */
- (void) newCommunicationEvent {
	// probably have to release the existing one first
	[self.communicationEvent release];
	
	self.communicationEvent = nil;
	
	// instantiate a new one
	self.communicationEvent = [CommunicationEvent alloc];
}

/*!
 @function dealloc
 @abstract Manual garbage collection
 */
- (void)dealloc {
	[self.applicationTabBarController release];
	[self.splashScreen release];
	[self.alertView release];
	[self.splashScreenTimer release];
	[self.soundService release];
	[self.preferencesService release];
	[self.account release];
	[self.displayList release];
	[self.communicationEvent release];
	[self.mediaContent release];
	[self.window release];
    [super dealloc];
}
@end
