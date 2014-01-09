//
//  PlayerViewController.m
#import "PlayerViewController.h"
#import "TalkBlastAppDelegate.h"
#import "FrontController.h"
#import "GetMediaContentEvent.h"
#import "RecorderViewController.h"
#import "PreferencesService.h"
#import "MediaContent.h"
#import "MediaContentItem.h"

@implementation PlayerViewController

@synthesize applicationDelegate, alertView;
@synthesize recorderViewController;
@synthesize fileTable, stopButton, volumeSlider;

// keeps track of the row we are playing a recording in
NSIndexPath *selectedIndexPath;

/*!
 @function viewDidLoad
 @abstract sets up the view one time
 @discussion gets called once at load time and sets some i18n title strings along with the leftbar button.
 */
 - (void)viewDidLoad {
	 [super viewDidLoad];
	 
	 // make app delegate accessible to the view so we can access its services
	 if (nil == applicationDelegate) {
		 applicationDelegate = (TalkBlastAppDelegate *)[[UIApplication sharedApplication] delegate];
	 }
	 
	 self.title = NSLocalizedString(@"page.recordings.title", @"Recording title");
	 self.navigationController.tabBarItem.title = NSLocalizedString(@"tab.recordings", @"Recordings tab title");

	 self.navigationItem.leftBarButtonItem = self.editButtonItem;
 }

/*!
 @function viewWillAppear
 @abstract makes sure the view always looks the way it should as this method gets called every time the view appears
 @discussion Reloads existing recordings from disk every time.
 */
-(void) viewWillAppear: (BOOL) animated {
	[super viewWillAppear: animated];
	NSLog (@"player viewWillAppear");
	
	/*
	NSEnumerator *fileEnum = [[NSFileManager defaultManager] enumeratorAtPath:self.applicationDelegate.preferencesService.recordingsDirectory];
	NSString *aFile;
	
	// clear out filenames first because this will get refreshed every time we hit the page
	[self.applicationDelegate.preferencesService.fileNames removeAllObjects];
	
	// add files from directory
	while ( (aFile = [fileEnum nextObject]) != nil) {
		[self.applicationDelegate.preferencesService.fileNames addObject: [self.applicationDelegate.preferencesService.recordingsDirectory stringByAppendingPathComponent:aFile]];
	}
	
	[fileTable reloadData];
	 */
	
	// dispatch mediacontent event
	[self.applicationDelegate.frontController dispatchEvent:[GetMediaContentEvent initWithCaller:self 
																						  params:nil]];
}

- (id) mediaContentResult:(id)object, ... {
	if (nil == object) {
		// donno yet
	} else {
		if ([object class] == [MediaContent class]) {
			// do nothing - we will forward to the welcome view automatically
			// but we will set the accountUser object on the dialmService
			self.applicationDelegate.mediaContent = (MediaContent *)object;
			
			[fileTable reloadData];
		}
	}
}

- (id) mediaContentFault:(id)error, ... {
	
}

/*
 - (void)viewDidAppear:(BOOL)animated {
 [super viewDidAppear:animated];
 }
 */

/*
 - (void)viewDidDisappear:(BOOL)animated {
 [super viewDidDisappear:animated];
 }
 */

/*!
 @function viewWillDisappear
 @abstract gets called when view goes away. removes editing mode
 */
- (void)viewWillDisappear:(BOOL)animated {
	[self setEditing:NO animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}

#pragma mark Table view methods
/*!
 @function numberOfSectionsInTableView
 @abstract TableDelegate function - We only want 1 section in this table
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

/*!
 @function numberOfRowsInSection
 @abstract TableDelegate function - Customize the number of rows in the table view. 
 We're grabbing the number of recordings on the file system
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [self.applicationDelegate.mediaContent.items count];
}


// Customize the appearance of table view cells.
/*
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSString *result = nil;
	
	if (section == 0) {
		result = NSLocalizedString(@"page.recordings.header", @"Past Recordings");
	}
	
	return result;
}
 */

/*!
 @function cellForRowAtIndexPath
 @abstract TableDelegate function - displays a list of recording names with a play icon next to them
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RecordingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Set up the cell...
	MediaContentItem *item = [self.applicationDelegate.mediaContent.items objectAtIndex:indexPath.row];
	cell.textLabel.text = item.name;
	cell.imageView.image = [UIImage imageNamed:@"play.png"];
	cell.imageView.highlightedImage = [UIImage imageNamed:@"play_grey.png"];
    return cell;
}

/*!
 @function didSelectRowAtIndexPath
 @abstract TableDelegate function - when a row is selected, we stop whatever is currently playing and start playing the corresponding recording
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	NSLog (@"select row %d", indexPath.row);
	@try {
		if ([self.applicationDelegate.soundService isPlaying]) {
			[self handleStopTapped];
		}
		
		// try to play the file
		NSError *error = nil;
		MediaContentItem *item = [self.applicationDelegate.mediaContent.items objectAtIndex:indexPath.row];
		[self.applicationDelegate.soundService playWithUrl:item.source 
												  delegate:self
													volume:self.volumeSlider.value 
													 error:&error];
		
		// display an error if file could not be played
		if (nil != error) {
			self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.playing", @"Can't play")
														message:[error localizedDescription]
													   delegate:nil
											  cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
											  otherButtonTitles:nil, nil];
			[self.alertView show];
			[self.alertView release];
		}
	}
	@catch (NSException* exception){
		self.alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"error.playing", @"Can't play")
													message:[exception reason]
												   delegate:nil
										  cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
										  otherButtonTitles:nil, nil];
		[self.alertView show];
		[self.alertView release];
	}
	
	// want to be able to track what is selected
	selectedIndexPath = indexPath;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */
 
/*!
 @function commitEditingStyle
 @abstract Deletes the recording from the file system
 */
- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
	if(editingStyle == UITableViewCellEditingStyleDelete) {
		// remove from file name array
		[self.applicationDelegate.preferencesService deleteRecordingAtIndex:(NSInteger *)indexPath.row];
		
		// remove from table
		[tv deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
	}
}

/*!
 @function setEditing
 @abstract toggles table editing mode
 */
- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	if(self.editing != editing) {
		[super setEditing:editing animated:animated];
		[self.fileTable setEditing:editing animated:animated];
	}
}

/*!
 @function handleStopTapped
 @abstract stops whichever recording is currently playing through the soundService
 */
- (IBAction) handleStopTapped {
	[self.applicationDelegate.soundService stop];
}

/*!
 @function handleVolumeSliderValueChanged
 @abstract updates the volume for playback of recording file
 */
- (IBAction) handleVolumeSliderValueChanged {
	[self.applicationDelegate.soundService resetVolume:self.volumeSlider.value];
}

/*!
 @function add
 @abstract Displays a new form where the user can create a recording
 */
- (IBAction) add {
	// display modal view
	[self presentModalViewController:self.recorderViewController animated:YES];
}

// START AVAudioPlayerDelegate
/*!
 @function audioPlayerDecodeErrorDidOccur
 @abstract AudioPlayerDelegate function - decoder error. Displays an alert window if the format is not supported
 */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error {
	self.alertView =
	[[UIAlertView alloc] initWithTitle: NSLocalizedString(@"error.playing", @"Can't play")
							   message: [error localizedDescription]
							  delegate: nil
					 cancelButtonTitle:NSLocalizedString(@"error.input.ok", @"OK")
					 otherButtonTitles:nil, nil];
	[self.alertView show];
	[self.alertView release]; 
}

/*!
 @function audioPlayerDidFinishPlaying
 @abstract AudioPlayerDelegate function - gets called when the current recording finishes playing. we just want to deselect the row here
 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
	NSLog (@"did finish playing");
	[self.fileTable deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

/*!
 @function audioPlayerBeginInterruption
 @abstract AudioPlayerDelegate function - interruption was received such as an incoming phone call. Don't need to do anything.
 */
- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player {
	NSLog (@"audio player begin interruption. the audio player is automatically stopped so maybe we don't haev to do anythng here");
}

/*!
 @function audioPlayerEndInterruption
 @abstract AudioPlayerDelegate function - interruption was ended. Don't want to do anything here.
 */
- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player {
	NSLog (@"audio player end interruption");
}
// END AVAudioPlayerDelegate

- (void)dealloc {
	[self.applicationDelegate release];
	[self.recorderViewController release];
	[self.fileTable release];
	[self.stopButton release];
	[self.volumeSlider release];
	[self.alertView release];
    [super dealloc];
}


@end

