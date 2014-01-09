//
//  HomeViewController.h
//  iConferenceCall
//
//  Created by crash on 6/11/09.
//  Copyright 2009 Health XCEL, Inc.. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HomeViewController : UIViewController {
	UIWebView *webView;
}

@property (nonatomic, retain) IBOutlet UIWebView *webView;

@end
