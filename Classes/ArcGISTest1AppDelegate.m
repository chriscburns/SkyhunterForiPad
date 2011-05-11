//
//  ArcGISTest1AppDelegate.m
//  ArcGISTest1
//
//  Created by Chris Burns on 11-05-04.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "ArcGISTest1AppDelegate.h"
#import "ArcGISTest1ViewController.h"

@implementation ArcGISTest1AppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
