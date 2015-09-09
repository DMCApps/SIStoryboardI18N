//
//  SIViewController.m
//  SIStoryboardI18N
//
//  Created by jsambells on 09/01/2015.
//  Copyright (c) 2015 jsambells. All rights reserved.
//

#import "ViewController.h"
#import <SIStoryboardI18N/SIStoryboardI18N.h>

@interface ViewController ()

@end

@implementation ViewController

- (IBAction)toggleLanguage:(UISegmentedControl *)controller {
    if (controller.selectedSegmentIndex == 0) {
        [SILocalizationHelper si_setLocalization:@"en"];
    } else {
        [SILocalizationHelper si_setLocalization:@"fr"];
    }
}

@end
