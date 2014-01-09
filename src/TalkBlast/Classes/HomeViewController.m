//
//  HomeViewController.m
//  iConferenceCall
//
//  Created by crash on 6/11/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import "HomeViewController.h"


@implementation HomeViewController
@synthesize webView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSURL *url = NULL;
	NSString *aboutPath = [[NSBundle mainBundle] pathForResource:@"home"
														  ofType:@"html"];
		url = [[NSURL alloc] initFileURLWithPath: aboutPath];
	
	if (url != NULL) {
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL: url];
		[self.webView loadRequest: request];
		[request release];
		[url release];
		
	}
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
	[self.webView release];
    [super dealloc];
}


@end
