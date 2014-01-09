#import "ConferenceCallView.h"
#import "CommunicationEvent.h"

//static UIImage *image;

@implementation ConferenceCallView

@synthesize communicationEvent;
@synthesize dateFormatter;
@synthesize timeFormatter;
@synthesize highlighted;
@synthesize editing;


- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		/*
		 Cache the formatter. Normally you would use one of the date formatter styles (such as NSDateFormatterShortStyle), but here we want a specific format that excludes seconds.
		 */
		timeFormatter = [[NSDateFormatter alloc] init];
		[timeFormatter setDateFormat:@"h:mm a"]; 
		
		dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"MM/dd/yyyy"]; 
		
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
//		image = [UIImage imageNamed:@"recording_small.png"];
	}
	
	return self;
}

- (void) setConferenceCall:(CommunicationEvent *) newConferenceCall {
	if (communicationEvent != newConferenceCall) {
		[communicationEvent release];
		communicationEvent = [newConferenceCall retain];
	}
	
	// May be the same wrapper, but the date may have changed, so mark for redisplay
	[self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)lit {
	// If highlighted state changes, need to redisplay.
	if (highlighted != lit) {
		highlighted = lit;	
		[self setNeedsDisplay];
	}
}

- (void)drawRect:(CGRect)rect {
	
#define LEFT_COLUMN_OFFSET 10
#define LEFT_COLUMN_WIDTH 130
	
#define MIDDLE_COLUMN_OFFSET 140
#define MIDDLE_COLUMN_WIDTH 110
	
#define RIGHT_COLUMN_OFFSET 285
	
#define UPPER_ROW_TOP 8
#define LOWER_ROW_TOP 34
	
#define MAIN_FONT_SIZE 14
#define MIN_MAIN_FONT_SIZE 14
#define SECONDARY_FONT_SIZE 12
#define MIN_SECONDARY_FONT_SIZE 10
	
	// Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
	
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *secondaryTextColor = nil;
	UIFont *secondaryFont = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
	
	// Choose font color based on highlighted state.
	if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
		secondaryTextColor = [UIColor whiteColor];
	}
	else {
		mainTextColor = [UIColor blackColor];
		secondaryTextColor = [UIColor darkGrayColor];
		self.backgroundColor = [UIColor whiteColor];
	}
	
	CGRect contentRect = self.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern.
    if (!self.editing) {
		
		CGFloat boundsX = contentRect.origin.x;
		CGPoint point;
		
		CGFloat actualFontSize;
		CGSize size;
		
		// Set the color for the main text items
		[mainTextColor set];
		
		/*
		 Draw the locale name top left; use the NSString UIKit method to scale the font size down if the text does not fit in the given area
		 */
		point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, UPPER_ROW_TOP);
		[communicationEvent.title drawAtPoint:point forWidth:LEFT_COLUMN_WIDTH withFont:mainFont minFontSize:MIN_MAIN_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
		
		/*
		 Draw the current time, right-aligned in the middle column.
		 To ensure it is right-aligned, first find its width with the given font and minimum allowed font size. Then draw the string at the appropriate offset.
		 */
		NSString *timeString = [timeFormatter stringFromDate:communicationEvent.scheduledDate];
		size = [timeString sizeWithFont:mainFont minFontSize:MIN_MAIN_FONT_SIZE actualFontSize:&actualFontSize forWidth:MIDDLE_COLUMN_WIDTH lineBreakMode:UILineBreakModeTailTruncation];
		
		point = CGPointMake(boundsX + MIDDLE_COLUMN_OFFSET + MIDDLE_COLUMN_WIDTH - size.width, UPPER_ROW_TOP);
		[timeString drawAtPoint:point forWidth:MIDDLE_COLUMN_WIDTH withFont:mainFont minFontSize:actualFontSize actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
		
		
		// Set the color for the secondary text items
		[secondaryTextColor set];
		
		/*
		 Draw the number of attendees botton left; use the NSString UIKit method to scale the font size down if the text does not fit in the given area
		 */
		NSString *attendeesCount = [NSString stringWithFormat:NSLocalizedString(@"attendee.count", @"Attendees: %d"), [communicationEvent.attendees count]];
		point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, LOWER_ROW_TOP);
		[attendeesCount drawAtPoint:point forWidth:LEFT_COLUMN_WIDTH withFont:secondaryFont minFontSize:MIN_SECONDARY_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
		
		/*
		 Draw the whichDay string, right-aligned in the middle column.
		 To ensure it is right-aligned, first find its width with the given font and minimum allowed font size. Then draw the string at the appropriate offset.
		 */
		NSString *dateString = [dateFormatter stringFromDate:communicationEvent.scheduledDate];
		size = [dateString sizeWithFont:secondaryFont minFontSize:MIN_SECONDARY_FONT_SIZE actualFontSize:&actualFontSize forWidth:MIDDLE_COLUMN_WIDTH lineBreakMode:UILineBreakModeTailTruncation];
		
		point = CGPointMake(boundsX + MIDDLE_COLUMN_OFFSET + MIDDLE_COLUMN_WIDTH - size.width, LOWER_ROW_TOP);
		[dateString drawAtPoint:point forWidth:LEFT_COLUMN_WIDTH withFont:secondaryFont minFontSize:actualFontSize actualFontSize:&actualFontSize lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];		
		
		/*
		// Draw the quarter image
		CGFloat imageY = (contentRect.size.height - image.size.height) / 2;
		
		point = CGPointMake(boundsX + RIGHT_COLUMN_OFFSET, imageY);
		[image drawAtPoint:point];
		 */
	}
}

- (void)dealloc {
	[self.dateFormatter release];
	[self.timeFormatter release];
	[self.communicationEvent release];
    [super dealloc];
}


@end
