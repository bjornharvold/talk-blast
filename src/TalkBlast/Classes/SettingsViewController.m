//
//  SettingsViewController.m
//  iConferenceCall
//
//  Created by crash on 5/26/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "SettingsViewController.h"
#import "TalkBlastAppDelegate.h"
#import "FrontController.h"
#import "GetMediaContentEvent.h"
#import "SettingsEditorViewController.h"
#import "PreferencesService.h"
#import "Account.h"
#import "AccountPreference.h"
#import "AccountUser.h"

@implementation SettingsViewController
@synthesize applicationDelegate;
@synthesize settingsEditorViewController;

/*!
 @function viewDidLoad
 @abstract Loaded one time during initialization. Sets the app delegate. Inits the setup button and sets titles
 */
- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(@"tab.settings", @"Settings");
	self.navigationController.tabBarItem.title = NSLocalizedString(@"tab.settings", @"Settings");
	
	if (nil == applicationDelegate) {
		self.applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	// Configure the save and cancel buttons.
	UIBarButtonItem *setupButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button.setup", @"Setup") 
																   style:UIBarButtonItemStyleBordered 
																  target:self 
																  action:@selector(setupAccount)];
	self.navigationItem.rightBarButtonItem = setupButton;
	[setupButton release];
}

/*!
 @function setupAccount
 @abstract Displays an editor view for changing user preferences
 */
- (void) setupAccount {
	// display modal view
	[self presentModalViewController:self.settingsEditorViewController animated:YES];
}

/*!
 @function viewWillAppear
 @abstract gets loaded every time view renders. reloads data in table with data from server
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	// dispatch get media content event
	[self.applicationDelegate.frontController dispatchEvent:[GetMediaContentEvent initWithCaller:self params:nil]];
}

/*!
 @function getMediaContentResult
 @abstract Called after successful completion of GetMediaContentEvent
 */
- (id) getMediaContentResult:(id)input, ... {
	[self.tableView reloadData];
	
	return nil;
}

- (id) getMediaContentFault:(id)error, ... {
	return nil;
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods
/*!
 @function numberOfSectionsInTableView
 @abstract shows 1 row if there are no preferences yet, shows 2 rows if preferences exists
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	if (nil != self.applicationDelegate.account) {
		return 2;
	} else {
		return 1;
	}
}

/*!
 @function numberOfRowsInSection
 @abstract Preferences section needs 3 rows and Minutes section should have 2 rows
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger *result;
	
	if (section == 0) {
		result = (NSInteger *) 5;
	} else if (section == 1) {
		result = (NSInteger *) 2;
	}
	
	return (NSInteger) result;
}

/*!
 @function cellForRowAtIndexPath
 @abstract display different section data
 @discussion The first section should display user preferences data. The second section should display a way to purchase minutes and display remaining minutes
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"SettingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
    }
    
	if (indexPath.section == 0) {
		if (indexPath.row == 0) {
			// caller id
			cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"page.settings.callerid", @"Caller ID")];
			if (nil != self.applicationDelegate.account) {
				cell.detailTextLabel.text = self.applicationDelegate.account.accountPreference.originatingTelephone;
			}
		} else if (indexPath.row == 1) {
			// company name
			cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"page.settings.company", @"Company")];
			if (nil != self.applicationDelegate.account) {
				cell.detailTextLabel.text = self.applicationDelegate.account.name;
			}
		} else if (indexPath.row == 2) {
			// username
			cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"page.settings.username", @"Username")];
			if (nil != self.applicationDelegate.account) {
				cell.detailTextLabel.text = self.applicationDelegate.account.accountUser.username;
			}
		} else if (indexPath.row == 3) {
			// email
			cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"page.settings.email", @"E-Mail")];
			if (nil != self.applicationDelegate.account) {
				cell.detailTextLabel.text = self.applicationDelegate.account.accountUser.email;
			}
		} else if (indexPath.row == 4) {
			// password
			cell.textLabel.text = [NSString stringWithFormat:@"%@:", NSLocalizedString(@"page.settings.password", @"Password")];
			
			if (nil != self.applicationDelegate.account) {
				cell.detailTextLabel.text = NSLocalizedString(@"page.settings.password.set", @"******");
			}
		}
	} else if (indexPath.section == 1) {
		if (indexPath.row == 0) {
			// price plans
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
			cell.textLabel.text = NSLocalizedString(@"page.settings.purchase.minutes", @"Purchase Minutes");
		} else if (indexPath.row == 1) {
			// minutes remaining
			cell.textLabel.text = NSLocalizedString(@"page.settings.remaining.minutes", @"Remaining minutes");
			cell.detailTextLabel.text = @"TBD";
		}
	}
	
    return cell;
}

/*!
 @function didSelectRowAtIndexPath
 @abstract Just deselects the row again. We're not doing anything here
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dealloc {
	[self.applicationDelegate release];
	[self.settingsEditorViewController release];
    [super dealloc];
}


@end

