//
//  MKAlertManager.h
//  SimpleMessageManager
//
//  Created by Michał Kaliniak on 02.07.2016.
//  Copyright © 2016 michal.k. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    MKAlertShowTypeNormal,
    MKAlertShowTypeFromLeft,
    MKAlertShowTypeFromBottomOnBottom, // not working with change device orientation during animation
} MKAlertShowType;

typedef enum : NSUInteger {
    MKAlertMessageSyleRounded,
    MKAlertMessageSyleRectangle,
} MKAlertMessageSyle;

@interface MKAlertManager : NSObject

@property (nonatomic, assign) float showDuration;
@property (nonatomic, assign) float animationDuration;
@property (nonatomic, assign) MKAlertMessageSyle messageStyle;
@property (nonatomic, assign) MKAlertShowType showType;

+(MKAlertManager*)sharedManager;

-(void)showAlertWithName:(NSString*)name;

-(void)showAlertWithName:(NSString *)name showType:(MKAlertShowType)showType;

-(void)showAlertWithName:(NSString *)name showType:(MKAlertShowType)showType messageStyle:(MKAlertMessageSyle)messageStyle;


@end

@interface MKAlertObject : UIView

@property (nonatomic, assign) MKAlertMessageSyle messageStyle;
@property (nonatomic, assign) MKAlertShowType showType;
@property (nonatomic, strong) UILabel *textLabel;

-(void)setAlertText:(NSString*)text messageStyle:(MKAlertMessageSyle)messageStyle;


@end
