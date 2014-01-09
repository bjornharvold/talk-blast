//
//  FirstViewController.h

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "TalkBlastAppDelegate.h"
#import "LevelMeterView.h"
#import "SimpleMinutesSecondsFormatter.h"
#import "SoundService.h"

@class TalkBlastAppDelegate;
@class SoundService;
@class PreferencesService;

extern NSString * const TempRecordingKey;

/*!
 @class RecorderViewController
 @abstract Displays a view where the user can make a recording 
 */
@interface RecorderViewController : UIViewController <UITextFieldDelegate, AVAudioRecorderDelegate, AVAudioPlayerDelegate> {
	TalkBlastAppDelegate *applicationDelegate;
	UILabel *labelTitle;
	UITextField *filename;
	UIButton *recordButton;
	UIButton *playButton;
	UIButton *stopButton;
	UILabel* currentTimeLabel;
	UISlider *volumeSlider;
	SimpleMinutesSecondsFormatter* minutesSecondsFormatter;
	NSTimer* currentTimeUpdateTimer;
	LevelMeterView *levelMeter;
	UIAlertView *alertView;
}

@property (nonatomic, retain) TalkBlastAppDelegate *applicationDelegate;
@property (nonatomic, retain) UIAlertView *alertView;
@property (nonatomic, retain) IBOutlet UILabel *labelTitle;
@property (nonatomic, retain) IBOutlet UILabel* currentTimeLabel;
@property (nonatomic, retain) IBOutlet UITextField *filename;
@property (nonatomic, retain) IBOutlet UIButton *recordButton;
@property (nonatomic, retain) IBOutlet UIButton *playButton;
@property (nonatomic, retain) IBOutlet UIButton *stopButton;
@property (nonatomic, retain) IBOutlet UISlider *volumeSlider;
@property (nonatomic, retain) IBOutlet LevelMeterView *levelMeter;

- (void) moveFileToRecordingsDirectory:(NSString *) theFilename;
- (IBAction) save;
- (IBAction) cancel;
- (IBAction) record;
- (IBAction) play;
- (IBAction) stop;
- (IBAction) handleVolumeSliderValueChanged;
- (BOOL) alertIfNoAudioInput;
@end
