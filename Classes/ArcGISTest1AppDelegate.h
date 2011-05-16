//
//  ArcGISTest1AppDelegate.h
//  ArcGISTest1
//
//  Created by Chris Burns on 11-05-04.
//  Copyright Skyhunter Exploration Ltd.  2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MethodSender.h"
#import "MethodReceiver.h"

@class ArcGISTest1ViewController;
@class MBProgressHUD; 

@interface ArcGISTest1AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    ArcGISTest1ViewController *viewController;
	
	MethodSender *sender; 
	MethodReceiver *receiver; 
	
	MBProgressHUD *hud; 
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet ArcGISTest1ViewController *viewController;


@property (nonatomic, assign) MethodSender *sender; 
@property (nonatomic, assign) MethodReceiver *receiver; 

@end

