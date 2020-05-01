//
//  SIStoryboardI18N.h
//  Pods
//
//  Created by Jeffrey Sambells on 2015-09-03.
//
//

#import "SIStoryboardI18N.h"


@interface SIStoryboardI18N()

@property(nonatomic, strong, nonnull, readwrite) NSMutableSet<Class> *disabledClasses;
@property(nonatomic, strong, nonnull, readwrite) NSMutableSet<Class> *enabledClasses;
@property(nonatomic, strong, nonnull, readwrite) NSMutableSet<NSString *> *searchTables;

@end


@implementation SIStoryboardI18N

/** Override +load method to enable KeyboardManager when class loader load IQKeyboardManager. Enabling when app starts (No need to write any code) */
+(void)load
{
    //Enabling IQKeyboardManager.
    [[SIStoryboardI18N sharedManager] setEnable:YES];
}

/*  Automatically called from the `+(void)load` method. */
+ (SIStoryboardI18N *)sharedManager
{
    //Singleton instance
    static SIStoryboardI18N *manager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[self alloc] init];
    });
    
    return manager;
}

/*  Singleton Object Initialization. */
-(instancetype)init
{
    if (self = [super init])
    {
        __weak typeof(self) weakSelf = self;
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            __strong typeof(self) strongSelf = weakSelf;
            
//            //  Registering for orientation changes notification
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willChangeStatusBarOrientation:) name:UIApplicationWillChangeStatusBarOrientationNotification object:[UIApplication sharedApplication]];
//            
//            //  Registering for status bar frame change notification
//            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeStatusBarFrame:) name:UIApplicationDidChangeStatusBarFrameNotification object:[UIApplication sharedApplication]];
            
            NSArray *disable = nil;
            disable = @[NSClassFromString(@"UIRemoteKeyboardWindow"),
                        NSClassFromString(@"UIKeyboardEmojiCollectionInputView"),
                        NSClassFromString(@"UIKBKeyplaneView"),
                        NSClassFromString(@"UIKBBackgroundView"),
                        NSClassFromString(@"UITableViewWrapperView"),
                        NSClassFromString(@"UIInputSwitcherTableView"),
                        [UIImageView class]];
            strongSelf.disabledClasses = [[NSMutableSet alloc] initWithArray:disable];
            
            
            strongSelf.enabledClasses = [[NSMutableSet alloc] init];

            strongSelf.searchTables = [[NSMutableSet alloc] init];

        });
    }
    return self;
}

#pragma mark - Dealloc
-(void)dealloc
{
    //  Disable the keyboard manager.
    [self setEnable:NO];
    
    //Removing notification observers on dealloc.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setEnable:(BOOL)enable
{
    // If not enabled, enable it.
    if (enable == YES && _enable == NO)
    {
        //Setting NO to _enable.
        _enable = enable;
        
        [self showLog:SILocalizedString(@"enabled")];
    }
    //If not disable, desable it.
    else if (enable == NO && _enable == YES)
    {
        
        //Setting NO to _enable.
        _enable = enable;
        
        [self showLog:SILocalizedString(@"disabled")];
    }
    //If already disabled.
    else if (enable == NO && _enable == NO)
    {
        [self showLog:SILocalizedString(@"already disabled")];
    }
    //If already enabled.
    else if (enable == YES && _enable == YES)
    {
        [self showLog:SILocalizedString(@"already enabled")];
    }
}

//- (void)setForcedLocale:(NSString *)forcedLocale {
//    
//}

-(BOOL)subviewIsEnabled:(UIView *)subview
{
    
    /*
     if ([NSStringFromClass([self class]) hasPrefix:@"UIKeyboard"]
     || [NSStringFromClass([self class]) hasPrefix:@"UIKB"]) {
     DDLogVerbose(@"UIKeyboard class Ignoring: %@", self);
     return;
     }
     */
    
    BOOL enable = _enable;
    
    if (enable)
    {
        //If view is kind of disable viewController class, then assuming it's disable.
        if ([_disabledClasses containsObject:[subview class]]) {
            
            return NO;
        }
        
        //If superview is kind of disable viewController class, then assuming it's disable.
        UIView *s = subview.superview;
        while (s) {
            if ([_disabledClasses containsObject:[s class]]) {
                return NO;
            }
            s = s.superview;
        }
        
    }
    
    
    UIViewController *viewController = [subview si_viewController];
    
    if (viewController)
    {
        if (enable == NO)
        {
            //If viewController is kind of enable viewController class, then assuming it's enabled.
            for (Class enabledClass in _enabledClasses)
            {
                if ([viewController isKindOfClass:enabledClass])
                {
                    enable = YES;
                    break;
                }
            }
        }
        
        if (enable)
        {
            //If viewController is kind of disable viewController class, then assuming it's disable.
            for (Class disabledClass in _disabledClasses)
            {
                if ([viewController isKindOfClass:disabledClass])
                {
                    enable = NO;
                    break;
                }
            }
        }
    }
    
    return enable;
}


-(BOOL)viewControllerIsEnabled:(UIViewController *)viewController
{
    BOOL enable = _enable;
        
    if (viewController)
    {
        if (enable == NO)
        {
            //If viewController is kind of enable viewController class, then assuming it's enabled.
            for (Class enabledClass in _enabledClasses)
            {
                if ([viewController isKindOfClass:enabledClass])
                {
                    enable = YES;
                    break;
                }
            }
        }
        
        if (enable)
        {
            //If viewController is kind of disable viewController class, then assuming it's disable.
            for (Class disabledClass in _disabledClasses)
            {
                if ([viewController isKindOfClass:disabledClass])
                {
                    enable = NO;
                    break;
                }
            }
        }
    }
    
    return enable;
}

-(void)showLog:(NSString*)logString
{
    if (_enableDebugging)
    {
        NSLog(@"SIStoryboardI18N: %@",logString);
    }
}

@end
