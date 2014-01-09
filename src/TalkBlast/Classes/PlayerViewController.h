//
//  PlayerViewController.h
//  StreamingAudioExercises
//
//  Created by crash
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
@class TalkBlastAppDelegate;
@class RecorderViewController;
@class PreferencesService;

/*!
 @class PlayerViewController
 @abstract Display list of created recordings. You can access this page by clicking on the recordings tab in the application
 */
@interface PlayerViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, AVAudioPlayerDelegate> {
	TalkBlastAppDelegate *applicationDelegate;
	RecorderViewController *recorderViewController;
	UITableView *fileTable;
	UIButton *stopButton;
	UISlider *volumeSlider;
	UIAlertView *alertView;
}

@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) IBOutlet RecorderViewController *recorderViewController;
@property (nonatomic, retain) IBOutlet UITableView *fileTable;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;

- (IBAction) handleStopTapped;
- (IBAction) handleVolumeSliderValueChanged;
- (IBAction) add;

@end
