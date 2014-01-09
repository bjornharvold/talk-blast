#import "ConferenceCallCell.h"
#import "CommunicationEvent.h"
#import "ConferenceCallView.h"
#import "TalkBlastAppDelegate.h"

@implementation ConferenceCallCell

@synthesize conferenceCallView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        // Create a time zone view and add it as a subview of self's contentView.
		CGRect tzvFrame = CGRectMake(6.0, 0.0, self.contentView.bounds.size.width, self.contentView.bounds.size.height);
		self.conferenceCallView = [[ConferenceCallView alloc] initWithFrame:tzvFrame];
		self.conferenceCallView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:self.conferenceCallView];
    }
    
    /*
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier]) {
		
		
	}
     */
    
	return self;
}

- (void) setConferenceCall:(CommunicationEvent *) newConferenceCall {
	// pass the conference call to the view
	self.conferenceCallView.communicationEvent = newConferenceCall;
}

- (void)dealloc {
	[self.conferenceCallView release];
    [super dealloc];
}


@end
