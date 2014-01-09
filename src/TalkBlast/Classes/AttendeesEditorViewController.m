//
//  AttendeesEditorViewController.m
//  iConferenceCall
//
//  Created by crash on 5/29/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "AttendeesEditorViewController.h"
#import "Attendee.h"
#import "CommunicationEvent.h"
#import "TalkBlastAppDelegate.h"
#import "AttendeePhoneSelectorViewController.h"

@implementation AttendeesEditorViewController

@synthesize applicationDelegate;
@synthesize attendeePhoneSelectorViewController;

/*!
 @function viewDidLoad
 @abstract gets called once during init - sets app delegate and inits the "add attendee" button
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	
	if (nil == applicationDelegate) {
		applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	}
	
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] 
											   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
											   target:self
											   action:@selector(add)]
											  autorelease];
	
}

/*!
 @function viewWillApear
 @abstract called every time the view s rendered - reloads the table data
 */
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

	// let's always reload the view here as the data is limited and it will make other views so much easier
	[self.tableView reloadData];
}


#pragma mark People Picker Delegate Methods
/*!
 @function peoplePickerNavigationControllerDidCancel
 @abstract returns to attendee list
 */
- (void) peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *) peoplePicker {
	[peoplePicker dismissModalViewControllerAnimated:YES];
	[peoplePicker autorelease];
}

/*!
 @function (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *) peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
 @abstract This is where we add the selected person to our list of attendees
 */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *) peoplePicker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
	// this is the info we want from the person record
	NSString *personName = (NSString *)ABRecordCopyCompositeName(person);
	NSString *personId = [[NSNumber numberWithInt:ABRecordGetRecordID(person)] stringValue];
	
	// retrieve all phone numbers
	NSMutableArray *phoneNumbers = [NSMutableArray array];
	NSMutableArray *phoneLabels = [NSMutableArray array];
	ABMultiValueRef allPhoneNumbers = (NSString *)ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSString* phoneNumber=@"";
	NSString* phoneLabel;
	
	for (CFIndex i = 0; i < ABMultiValueGetCount(allPhoneNumbers); i++) {
		phoneLabel = (NSString*)ABMultiValueCopyLabelAtIndex(allPhoneNumbers, i);
		
		// convert label into something readable
		phoneLabel = (NSString *)[self formatPhoneLabel:phoneLabel];
		phoneNumber = (NSString*)ABMultiValueCopyValueAtIndex(allPhoneNumbers, i);
		
		NSLog(@"Phone Label: %@, Phone Value: %@", phoneLabel, phoneNumber);
		[phoneLabels addObject:phoneLabel];
		[phoneNumbers addObject:phoneNumber];
	}
	
	NSMutableDictionary *contacts = self.applicationDelegate.communicationEvent.attendees;
	
	if (nil == contacts) {
		self.applicationDelegate.communicationEvent.attendees = [NSMutableDictionary dictionaryWithCapacity:1];
		contacts = self.applicationDelegate.communicationEvent.attendees;
	}
	
	// check that we are not adding duplicate contact to list
	if (nil == [contacts objectForKey:personId]) {
		// ok let's add the person to our list of attendees
		Attendee *attendee = [Attendee alloc];
		attendee.personId = personId;
		attendee.personName = personName;
		
		if ([phoneNumbers count] > 0) {
			attendee.availablePhoneNumbers = phoneNumbers;
			attendee.availablePhoneLabels = phoneLabels;
			// set the first phone number form the list as the phone number to use as default
			attendee.phoneNumber = [phoneNumbers objectAtIndex:0];
			attendee.phoneLabel = [phoneLabels objectAtIndex:0];
		}
		
		[contacts setObject:attendee forKey:personId];
		
	} else {
		NSLog(@"Duplicate personId: %@. Will not insert a person twice in attendee list.", personId);
	}
	
	// time to return to the list
	[peoplePicker dismissModalViewControllerAnimated:YES];
	[peoplePicker autorelease];
	
	[self.tableView reloadData];
	
	return NO;
}

/*!
 @function -(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *) peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier 
 @abstract after a contact has been selected the action should be to return to the list
 */
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *) peoplePicker 
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier{
	return NO;
}

/*!
 @function add
 @abstract Displays the people picker component
 */
- (void)add {
	ABPeoplePickerNavigationController *peoplePicker = [[ABPeoplePickerNavigationController alloc] init];
	peoplePicker.peoplePickerDelegate = self;
	[self presentModalViewController:peoplePicker animated:YES];
}

#pragma mark Table view methods
/*!
 @unction numberOfSectionsInTableView
 @abstract TableDelegate - we display 2 sections if there are attendees. The top section will be to clear out list
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	int result = 1;
	
	if (nil != self.applicationDelegate.communicationEvent.attendees) {
		result = 2;
	}
	
	return (NSInteger)result;
}

/*!
 @function numberOfRowsInSection
 @abstract first section has 1 row, 2 section has as many rows as selected contacts
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSInteger *result = 0;
	
	if (nil != self.applicationDelegate.communicationEvent.attendees) {
		if (section == 0) {
			return 1;
		} else {
			result = (NSInteger *)[self.applicationDelegate.communicationEvent.attendees count];
		}
	}
	
	return (NSInteger)result;
}

/*!
 @function cellForRowAtIndexPath
 @abstract First section has one row that gives the user the ability to clear out the attendee list. The
 second section contains a list of contacts.
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *CellIdentifier = @"PeopleCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	
	if (indexPath.section == 0) {
		if (cell == nil) {
			CGRect startingRect = CGRectMake(0.0, 0.0, 320.0, 40);
			cell = [[[UITableViewCell alloc] initWithFrame:startingRect reuseIdentifier:CellIdentifier] autorelease];
		}
		
		cell.textLabel.text = NSLocalizedString(@"page.conferencecall.editor.attendee.clear", @"Clear list of attendees");
		cell.textLabel.font =[UIFont boldSystemFontOfSize:14];
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		cell.textLabel.textColor = [UIColor redColor];
	} else {
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
		}
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		
		// loop through attendees dictionary
		NSArray *attendees = [self.applicationDelegate.communicationEvent.attendees allValues];
		Attendee *attendee = [attendees objectAtIndex:indexPath.row];
		
		// display the person's name and phone number
		cell.textLabel.text = attendee.personName;
		[cell.textLabel setFont:[UIFont systemFontOfSize:12]];
		cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ : %@", attendee.phoneLabel, attendee.phoneNumber];
		[cell.detailTextLabel setFont:[UIFont systemFontOfSize:12]];
	}
	
	return cell;
}

/*!
 @function didSelectRowAtIndexPath
 @abstract If the user presses the first section, we'll clean out the attendee list. If the user
 presses any other row, we'll push another view to the nav controller to make the user select what phone number to call the attendee on
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		// now we just want to clear the attendee table of data because user pressed the CLEAR LIST button
		self.applicationDelegate.communicationEvent.attendees = nil;
		[self.tableView reloadData];
	} else {
		NSArray *attendees = [self.applicationDelegate.communicationEvent.attendees allValues];
		Attendee *attendee = [attendees objectAtIndex:indexPath.row];
		self.attendeePhoneSelectorViewController.personId = attendee.personId;
		self.attendeePhoneSelectorViewController.title = NSLocalizedString(@"page.conferencecall.editor.attendee.select.number", @"Desired phone number");
		[self.navigationController pushViewController:attendeePhoneSelectorViewController animated:YES];
	}
}

/*!
 @function formatPhoneLabel
 @abstract Phone labels coming from address book look like this: _$!<Mobile>!$_ so we need to parse it out and i18n the string
 */
- (NSString *) formatPhoneLabel:(NSString *)phoneLabel {
	NSString *prefix = @"_$!<";
	NSString *postfix = @">!$_";
	NSString *result = [phoneLabel stringByReplacingOccurrencesOfString:prefix withString:@""];
	result = [result stringByReplacingOccurrencesOfString:postfix withString:@""];
	
	return (NSString *)result;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}

- (void)dealloc {
	[self.applicationDelegate release];
	[self.attendeePhoneSelectorViewController release];
	[super dealloc];
}


@end

