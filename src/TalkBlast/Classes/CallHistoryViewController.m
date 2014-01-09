#import "CallHistoryViewController.h"
#import "ConferenceCallCell.h"
#import "CommunicationEvent.h"
#import "TalkBlastAppDelegate.h"
#import "ConferenceCallEditorNavigationController.h"
#import "ConferenceCallEditorViewController.h"
#import "TalkBlastAppDelegate.h"
#import "BlastsEvent.h"
#import "FrontController.h"

#define ROW_HEIGHT 60

@implementation CallHistoryViewController

@synthesize conferenceCallEditorNavigationController;
@synthesize applicationDelegate;
@synthesize conferenceCallEditorViewController;

/*!
 @function addAction
 @abstract This method is called when the + button is clicked and presents the user with a way to create a new conf call
 */
- (IBAction)addAction:(id)sender
{	
	// make new conference call object that the editor can use
	[self.applicationDelegate newCommunicationEvent];
	
	// display modal view
	[self presentModalViewController:self.conferenceCallEditorNavigationController animated:YES];
}

/*!
 @function viewDidLoad
 @abstract Gets called the first time the view is loaded and never again. Grabs the app delegate, sets row height and some titles
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (nil == applicationDelegate) {
		applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	self.tableView.rowHeight = ROW_HEIGHT;
	
	self.title = NSLocalizedString(@"page.blasts.title", @"Blasts");
	self.navigationController.tabBarItem.title = NSLocalizedString(@"tab.blasts", @"Blasts");
}

/*!
 @function viewWillAppear
 @abstract This method will get called every time the view is displayed. Reloads call history every time.
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// all good - retrieve call history
	// grab call history data
	[self.applicationDelegate.frontController dispatchEvent:[BlastsEvent initWithCaller:self 
																				 params:nil]];
}

/*!
 @function blastsResult
 @abstract Returns the result from the BlastsEvent that was dispatched in viewWillAppear
 */
- (id) blastsResult:(id)object, ... {
	if (nil == object) {
		// donno yet
	} else {
		if ([object class] == [NSArray class]) {
			// do nothing - we will forward to the welcome view automatically
			// but we will set the accountUser object on the dialmService
			self.applicationDelegate.displayList = (NSArray *)object;
			
			[self.tableView reloadData];
		}
	}
	
	return nil;
}

/*!
 @function blastsFault
 @abstract Returns an error from having issued with BlastsEvent
 */
- (id) blastsFault:(id)error, ... {
	
	return nil;
}

/*!
 @function titleForHeaderInSection
 @abstract Just one section and we want the header title name to be X
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *result = nil;
	
	if (section == 0) {
		result = NSLocalizedString(@"table.section.call.history", @"Call History");
	}
	
	return result;
}

/*!
 @function numberOfSectionsInTableView
 @abstract Only one section in this view
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 1;
}

/*!
 @function numberOfRowsInSection
 @abstract Return a row count based on the number of call histories in our list
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	// Number of rows is the number of conf calls
	return [applicationDelegate.displayList count];
}

/*!
 @function cellForRowAtIndexPath
 @abstract Displays custom TableViewCells called ConferenceCallCell that has a layout that differs from the regular styles
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {
		
	static NSString *CellIdentifier = @"ConferenceCallCell";
		
	ConferenceCallCell *cell = (ConferenceCallCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (cell == nil) {
		CGRect startingRect = CGRectMake(0.0, 0.0, 320.0, ROW_HEIGHT);
		cell = [[[ConferenceCallCell alloc] initWithFrame:startingRect reuseIdentifier:CellIdentifier] autorelease];
	}
	
	// Get the time zones for the region for the section
	CommunicationEvent *cc = [applicationDelegate.displayList objectAtIndex:indexPath.row];
	
	// display a chevron next to the table row
	cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
	
	// Get the time zone wrapper for the row
	[cell setConferenceCall:cc];
	
	return cell;
}

- (void)didReceiveMemoryWarning {
	
	[super didReceiveMemoryWarning];
}

/*!
 @function didSelectRowAtIndexPath
 @abstract Offers a way to either just view a past conf call or to resend it. Loads up the conference call editor view
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog(@"Row: %d, was selected", indexPath.row);
	
	[self.applicationDelegate editCommunicationEventAtIndex:indexPath.row];
	[conferenceCallEditorViewController.tableView reloadData];
	
	if (nil != self.navigationController) { 
		[self.navigationController pushViewController:conferenceCallEditorViewController animated:YES];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)dealloc {
	[conferenceCallEditorNavigationController release];
	[conferenceCallEditorViewController release];
	[applicationDelegate release];	
	[super dealloc];
}


@end
