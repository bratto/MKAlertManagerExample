//
//  MKAlertManager.m
//  SimpleMessageManager
//
//  Created by Michał Kaliniak on 02.07.2016.
//  Copyright © 2016 michal.k. All rights reserved.
//

#import "MKAlertManager.h"

@interface MKAlertManager ()

@property (nonatomic, strong) NSMutableArray *queue;
@property (nonatomic, assign) BOOL alertVisible;
@property (nonatomic, strong) UIWindow *customWindow;

@end

@implementation MKAlertManager

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _showDuration = 2.0f;
        _animationDuration = 0.4f;
        _queue = [NSMutableArray new];
        _alertVisible = NO;
        
        _showType = MKAlertShowTypeNormal;
        _messageStyle = MKAlertMessageSyleRounded;
    }
    
    return self;
}


+(MKAlertManager*)sharedManager
{
    static MKAlertManager *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[MKAlertManager alloc] init];
    });
    return _sharedInstance;
}

-(void)showAlertWithName:(NSString*)name
{
    [self showAlertWithName:name showType:_showType];
}

-(void)showAlertWithName:(NSString *)name showType:(MKAlertShowType)showType
{
    [self showAlertWithName:name showType:showType messageStyle:_messageStyle];
}

-(void)showAlertWithName:(NSString *)name showType:(MKAlertShowType)showType messageStyle:(MKAlertMessageSyle)messageStyle
{
    MKAlertObject *alert = [MKAlertObject new];
    alert.showType = showType;
    [alert setAlertText:name messageStyle:messageStyle];
    [_queue addObject:alert];
    
    if (!_alertVisible)
    {
        [self showAlertFromQueue];
    }
}

-(void)showAlertFromQueue
{
    if (_queue.count > 0)
    {
        _alertVisible = YES;
        
        MKAlertObject *alert = [_queue objectAtIndex:0];
        _customWindow.hidden = NO;
        [[self messageBarViewController].view addSubview:alert];
        
        switch (alert.showType) {
            case MKAlertShowTypeNormal:
            {
                [self showAlertFromQueueTypeNormal:alert];
                break;
            }
            case MKAlertShowTypeFromLeft:
            {
                [self showAlertFromQueueTypeFromLeft:alert];
                break;
            }
            case MKAlertShowTypeFromBottomOnBottom:
            {
                [self showAlertTypeFromBottomOnBottom:alert];
                break;
            }
            default:
                break;
        }
    }
}

-(void)showAlertFromQueueTypeNormal:(MKAlertObject*)alert
{
    alert.textLabel.alpha = 0;
    
    [UIView animateWithDuration:_animationDuration animations:^{
        alert.textLabel.alpha = 1;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideAlertTypeNormal:) withObject:alert afterDelay:_showDuration];
    }];
}

-(void)hideAlertTypeNormal:(MKAlertObject*)alert
{
    [UIView animateWithDuration:_animationDuration animations:^{
        alert.textLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [self alertDisapear:alert];
    }];
}

-(void)showAlertFromQueueTypeFromLeft:(MKAlertObject*)alert
{
    CGRect hiddenLabelFrame = alert.textLabel.frame;
    hiddenLabelFrame.origin.x = 0-hiddenLabelFrame.size.width;
    alert.textLabel.frame = hiddenLabelFrame;
    
    [UIView animateWithDuration:_animationDuration animations:^{
        alert.textLabel.center = alert.center;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hideAlertTypeFromLeft:) withObject:alert afterDelay:_showDuration];
    }];
}

-(void)hideAlertTypeFromLeft:(MKAlertObject*)alert
{
    alert.frame = [UIScreen mainScreen].bounds;
    alert.textLabel.center = alert.center;
    CGRect hiddenLabelFrame = alert.textLabel.frame;
    hiddenLabelFrame.origin.x = alert.frame.size.width;
    
    [UIView animateWithDuration:_animationDuration animations:^{
        alert.textLabel.frame = hiddenLabelFrame;
    } completion:^(BOOL finished) {
        [self alertDisapear:alert];
    }];
    
}

-(void)showAlertTypeFromBottomOnBottom:(MKAlertObject*)alert
{
    CGRect hiddenLabelFrame = alert.textLabel.frame;
    hiddenLabelFrame.origin.y = alert.bounds.size.height;
    alert.textLabel.frame = hiddenLabelFrame;
    
    [UIView animateWithDuration:_animationDuration animations:^{
        alert.textLabel.center = CGPointMake(alert.center.x, alert.center.y + alert.center.y - alert.textLabel.bounds.size.height/2);
    } completion:^(BOOL finished) {
        
        [self performSelector:@selector(hideAlertTypeFromBottomOnBottom:) withObject:alert afterDelay:_showDuration];
    }];
}

-(void)hideAlertTypeFromBottomOnBottom:(MKAlertObject*)alert
{

    CGRect hiddenLabelFrame = alert.textLabel.frame;
    hiddenLabelFrame.origin.y += hiddenLabelFrame.size.height;
    
    [UIView animateWithDuration:_animationDuration animations:^{
        alert.textLabel.frame = hiddenLabelFrame;
    } completion:^(BOOL finished) {
        [self alertDisapear:alert];
    }];
}

-(void)alertDisapear:(MKAlertObject*)alert
{
    _customWindow.hidden = YES;
    [alert removeFromSuperview];
    [_queue removeObject:alert];
    if (_queue.count > 0)
    {
        [self showAlertFromQueue];
    }
    else
    {
        _alertVisible = NO;
    }
}


- (UIViewController *)messageBarViewController
{
    if (!_customWindow)
    {
        _customWindow = [[UIWindow alloc] init];
        _customWindow.frame = [UIApplication sharedApplication].keyWindow.frame;
        _customWindow.hidden = NO;
        _customWindow.windowLevel = UIWindowLevelNormal;
        _customWindow.backgroundColor = [UIColor clearColor];
        _customWindow.rootViewController = [[UIViewController alloc] init];
    }
    return (UIViewController *)_customWindow.rootViewController;
}
@end

@implementation MKAlertObject

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor clearColor];
        _textLabel = [[UILabel alloc]init];
        _textLabel.numberOfLines = 5;
        _textLabel.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
        _textLabel.textColor = [UIColor whiteColor];
        [_textLabel setTextAlignment:NSTextAlignmentCenter];
        [_textLabel.layer setMasksToBounds:YES];
        [self setMessageStyle:MKAlertMessageSyleRounded];
        [self addSubview:_textLabel];
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin |  UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

    }
    return self;
}

-(void)didMoveToSuperview
{
    self.frame = [UIScreen mainScreen].bounds;
    CGSize labelNewSize = [_textLabel sizeThatFits:CGSizeMake(self.frame.size.width - 50, 300)];
    _textLabel.frame = CGRectMake(0, 0, labelNewSize.width+12, labelNewSize.height+12);
    _textLabel.center = self.center;
}

-(void)setAlertText:(NSString *)text messageStyle:(MKAlertMessageSyle)messageStyle
{
    _messageStyle = messageStyle;
    _textLabel.text = text;

    switch (_messageStyle) {
        case MKAlertMessageSyleRounded:
        {
            [_textLabel.layer setCornerRadius:5];
            break;
        }
        case MKAlertMessageSyleRectangle:
        {
            [_textLabel.layer setCornerRadius:0];
            break;
        }
            
        default:
            break;
    }

}

@end
