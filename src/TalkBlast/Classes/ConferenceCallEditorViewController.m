//
//  NewConferenceCallViewController.m
//  iConferenceCall
//
//  Created by crash on 5/26/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "ConferenceCallEditorViewController.h"
#import "CommunicationEvent.h"
#import "ConferenceNameEditorViewController.h"
#import "ConferenceTimeEditorViewController.h"
#import "ConferenceRecordingEditorViewController.h"
#import "TalkBlastAppDelegate.h"
#import "AttendeesEditorViewController.h"
#import "PreferencesService.h"

@implementation ConferenceCallEditorViewController
@synthesize conferenceNameEditorViewController;
@synthesize conferenceTimeEditorViewController;
@synthesize conferenceRecordingEditorViewController;
@synthesize applicationDelegate;
@synthesize dateFormatter;
@synthesize attendeesEditorViewController;

/*!
 @function cancel
 @abstract Used when we create a new conference call and we don't want to continue
 */
- (IBAction) cancel {
	[[self parentViewController] dismissModalViewControllerAnimated:YES];
}

/*!
 @function startConference
 @abstract This will validate the data and if everything's ok, will fire off an event to the dialmService to create a conf call
 */
- (IBAction) startConference {
	NSLog(@"Clicked DONE button. This will fire off the conference to server");
	
	// release the conference call object
	// [applicationDelegate.communicationEvent release];
	
}

/*!
 @function viewDidLoad
 @abstract This method will only called once during instantiation. Grabs app delegate. Creates the custom BlastIt button.
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (nil == applicationDelegate) {
		applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	// Configure the save and cancel buttons.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"button.blastit", @"BlastIT") style:UIBarButtonItemStyleBordered target:self action:@selector(startConference)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
}

/*!
 @function viewWillAppear
 @abstract This method will get called every time the view is displayed. We set some titles and reload the table data as they might have changed
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	if (nil == self.applicationDelegate.communicationEvent || nil == self.applicationDelegate.communicationEvent.title) {
		self.title = NSLocalizedString(@"page.conferencecall.editor.new", @"Conference call editor title");
	} else {
		self.title = self.applicationDelegate.communicationEvent.title;
	}
	
	// let's always reload the view here as the data is limited and it will make other views so much easier
	[self.tableView reloadData];
}

/*!
 @function titleForHeaderInSection
 @abstract We want to add one header for the top section called X
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *result = nil;
	
	if (section == 0) {
		result = NSLocalizedString(@"table.section.info", @"Call Details");
	}
	
	return result;
}

/*!
 @function numberOfSectionsInTableView
 @abstract We want 3 sections. One for name and time of conf call. One for attendees and one for recording
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
	return 3;
}

/*!
 @function numberOfRowsInSection
 @abstract For section 1 there should be 2 rows (name and time). For section 2 and 3 there should be only one row.
 */
- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
	NSInteger result;
	
	if (section == 0) {
		result = 2;
	} else if (section == 1) {
		result = 1;
	} else if (section == 2) {
		result = 1;
	} else {
		NSLog(@"Shouldn't be here!! There should only be 3 sections.");
	}
	
	return result;
}

/*!
 @function cellForRowAtIndexPath
 @abstract Set up all the different types of rows for this page
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *MyIdentifier = @"ConferenceCallEditor";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier] autorelease];
	}
	
	if (indexPath.section == 0 && indexPath.row == 0) {
		// This sets up name row
		cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"page.conferencecall.editor.name", @"Name")];
		cell.detailTextLabel.text = self.applicationDelegate.communicationEvent.title;
		
		//[cell.textLabel setTextColor:[UIColor darkGrayColor]];
		//[cell.textLabel setFont:[UIFont systemFontOfSize:14]];
	} else if (indexPath.section == 0 && indexPath.row == 1) {
		// This sets up time row
		cell.textLabel.text = [NSString stringWithFormat:NSLocalizedString(@"page.conferencecall.editor.time", @"Time")];
		cell.detailTextLabel.text = [self.dateFormatter stringFromDate:self.applicationDelegate.communicationEvent.scheduledDate];
		
		//[cell.textLabel setTextColor:[UIColor darkGrayColor]];
		//[cell.textLabel setFont:[UIFont systemFontOfSize:14]];
	} else if (indexPath.section == 1) {
		// This sets up attendees row
		[cell.textLabel setText:NSLocalizedString(@"page.conferencecall.editor.attendees", @"Attendees")];
	} else if (indexPath.section == 2) {
		// This sets up recording row where we grab the recording filename based on the name of the file
		[cell.textLabel setText:NSLocalizedString(@"page.conferencecall.editor.recording", @"Recording")];
		if (nil != self.applicationDelegate.preferencesService.fileNames && nil != self.applicationDelegate.communicationEvent.filename) {
			cell.detailTextLabel.text = self.applicationDelegate.communicationEvent.filename;
		}
	}
	
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	
	return cell;
}

/*!
 @function didSelectRowAtIndexPath
 @abstract Show edit pages for the different conference call variables
 @discussion Depending on which row the user selects, he will be presented with an view where he can write/select the data he desires
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	if (indexPath.section == 0 && indexPath.row == 0) {
		// load the view that sets the name of the conference call
		self.conferenceNameEditorViewController.title = NSLocalizedString(@"page.conferencecall.editor.title.name", @"Name");
		[self.navigationController pushViewController:conferenceNameEditorViewController animated:YES];
	} else if (indexPath.section == 0 && indexPath.row == 1) {
		// load the view that sets the date/time of the conference call
		self.conferenceTimeEditorViewController.title = NSLocalizedString(@"page.conferencecall.editor.title.time", @"Time");
		[self.navigationController pushViewController:conferenceTimeEditorViewController animated:YES];
	} else if (indexPath.section == 1) {
		// load the view that sets the attendees for the conference call
		self.attendeesEditorViewController.title = NSLocalizedString(@"page.conferencecall.editor.attendees", @"Attendees");
		[self.navigationController pushViewController:attendeesEditorViewController animated:YES];
	} else if (indexPath.section == 2) {
		// load the view that sets the recording for the conference call
		[self.navigationController pushViewController:conferenceRecordingEditorViewController animated:YES];
	}
	
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*!
 @function dateFormatter
 @abstract init date formatter which sets out time format
 */
- (NSDateFormatter *)dateFormatter {	
	if (dateFormatter == nil) {
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[dateFormatter setTimeStyle:NSDateFormatterShortStyle];
	}
	return dateFormatter;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[dateFormatter release];
	[applicationDelegate release];
	[conferenceNameEditorViewController release];
	[conferenceTimeEditorViewController release];
	[conferenceRecordingEditorViewController release];
	[attendeesEditorViewController release];
    [super dealloc];
}


@end
