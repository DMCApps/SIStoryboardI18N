//
//  SIViewController.m
//  SIStoryboardI18N
//
//  Created by jsambells on 09/01/2015.
//  Copyright (c) 2015 jsambells. All rights reserved.
//

#import "SIViewController.h"
#import <SIStoryboardI18N/SIStoryboardI18N.h>

@interface SIViewController ()

@end

@implementation SIViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)changeFrench:(id)sender {
    [SILocalizationHelper si_setLocalization:@"fr"];
}
- (IBAction)changeEnglish:(id)sender {
    [SILocalizationHelper si_setLocalization:@"en"];
}

@end
