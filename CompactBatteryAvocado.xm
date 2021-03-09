//  Copyright (c) 2021 udevs
//
//  This file is subject to the terms and conditions defined in
//  file 'LICENSE', which is part of this source code package.

#import "Common.h"
#import "CompactBatteryAvocado.h"
#import "PrivateHeaders.h"

static BOOL enabled;
static BOOL hideDummyRings;
static NSUInteger verticalStyle;
static NSUInteger horizontalStyle;
static NSUInteger lastNumberOfDevices;

static void updateRingView(BCUIRingItemView *ringView, NSUInteger numberOfDevices, BOOL async){
    
    [ringView setRingItemViewStyle:0];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor blackColor];
    shadow.shadowOffset = CGSizeZero;
    shadow.shadowBlurRadius = 3.0;
    
    CGFloat factor = 3.5;
    CGFloat gap = 2.3;
    
    if (numberOfDevices > 1){
        factor = 2.2;
    }
    
    BOOL numberOfDevicesChanged = lastNumberOfDevices != numberOfDevices;
    lastNumberOfDevices = numberOfDevices;
    
    void (^mashAvocado)(void) = ^{
        
        if (!ringView.cbaChargeLabel || numberOfDevicesChanged){
            
            if (numberOfDevicesChanged && ringView.cbaChargeLabel){
                [ringView.cbaChargeLabel removeFromSuperview];
            }
            
            //We create our own views for label and glyph since Apple calls setNeedsLayout everytime there's UI update, which makes the repositioned glyph glitch for a split seconds before return back to our customized position
            
            ringView.cbaChargeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            [ringView addSubview:ringView.cbaChargeLabel];
            
            ringView.cbaChargeLabel.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaChargeLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeLeading multiplier:1.f constant:((horizontalStyle == CBAStyleCenter || horizontalStyle == CBAStyleRight) ?  0.f : -2.f)];
            [ringView addConstraint:leadingConstraint];
            
            NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaChargeLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:((horizontalStyle == CBAStyleCenter || horizontalStyle == CBAStyleLeft) ?  0.f : 2.f)];
            [ringView addConstraint:trailingConstraint];
            
            if (verticalStyle == CBAStyleTop){
                NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaChargeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeTop multiplier:1.f constant:factor*(ringView.ringLineWidth - gap)];
                [ringView addConstraint:topConstraint];
            }else{
                NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaChargeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-factor*(ringView.ringLineWidth - gap)];
                [ringView addConstraint:bottomConstraint];
            }
            
            UIFont *chargeLabelFont = numberOfDevices > 1 ? [UIFont boldSystemFontOfSize:(horizontalStyle == CBAStyleCenter ?  12.f : 14.f)] : [UIFont boldSystemFontOfSize:28.f];
            
            ringView.cbaChargeLabel.font = chargeLabelFont;
        }
        
        BCUIChargeRing *chargeRing = [ringView valueForKey:@"_chargeRing"];
        UIImageView *glyphView = [chargeRing valueForKey:@"_glyphImageView"];
        ringView.cbaGlyphView.tintColor = glyphView.tintColor;

        if (!ringView.cbaGlyphView || numberOfDevicesChanged){
            
            if (numberOfDevicesChanged && ringView.cbaGlyphView){
                [ringView.cbaGlyphView removeFromSuperview];
            }
            
            ringView.cbaGlyphView = [[UIImageView alloc] initWithFrame:CGRectZero];
            [ringView addSubview:ringView.cbaGlyphView];
            ringView.cbaGlyphView.contentMode = UIViewContentModeScaleAspectFit;
            
            ringView.cbaGlyphView.translatesAutoresizingMaskIntoConstraints = NO;
            
            NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaGlyphView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeLeading multiplier:1.f constant:0];
            [ringView addConstraint:leadingConstraint];
            
            NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaGlyphView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeTrailing multiplier:1.f constant:0];
            [ringView addConstraint:trailingConstraint];
            
            CGFloat symbolFactor = 1.f;
            
            if (horizontalStyle == CBAStyleLeft || horizontalStyle == CBAStyleRight){
                if (ringView.glyph.symbolImage) symbolFactor = 3.f;

                NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaGlyphView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:glyphView.frame.size.height/symbolFactor];
                [ringView addConstraint:heightConstraint];
                
                NSLayoutConstraint *yConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaGlyphView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeCenterY multiplier:1.f constant:0];
                [ringView addConstraint:yConstraint];
                
            }else{
                if (ringView.glyph.symbolImage) symbolFactor = 2.f;

                if (verticalStyle == CBAStyleTop){
                    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaGlyphView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:ringView.cbaChargeLabel attribute:NSLayoutAttributeTop multiplier:1.f constant:symbolFactor*factor*(ringView.ringLineWidth + (numberOfDevices > 1 ? -1*gap : gap))];
                    [ringView addConstraint:topConstraint];
                    
                    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaGlyphView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeBottom multiplier:1.f constant:-1.f*symbolFactor*factor*(ringView.ringLineWidth - gap)];
                    [ringView addConstraint:bottomConstraint];
                }else{
                    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaGlyphView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:ringView attribute:NSLayoutAttributeTop multiplier:1.f constant:symbolFactor*factor*(ringView.ringLineWidth - gap)];
                    [ringView addConstraint:topConstraint];
                    
                    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:ringView.cbaGlyphView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:ringView.cbaChargeLabel attribute:NSLayoutAttributeBottom multiplier:1.f constant:-1.f*symbolFactor*factor*(ringView.ringLineWidth + (numberOfDevices > 1 ? -1*gap : gap))];
                    [ringView addConstraint:bottomConstraint];
                }
            }
        }
        
        if (!ringView.empty){
            ringView.cbaChargeLabel.text = [NSString stringWithFormat:@"%lld", ringView.percentCharge];
        }
        ringView.cbaGlyphView.image = ringView.glyph;
        glyphView.hidden = YES;
        
        NSMutableAttributedString *labelAttr = [ringView.cbaChargeLabel.attributedText mutableCopy];
        
        switch (horizontalStyle){
            case CBAStyleLeft:{
                [labelAttr addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, labelAttr.length)];
                ringView.cbaChargeLabel.attributedText = labelAttr;
                ringView.cbaChargeLabel.textAlignment = NSTextAlignmentLeft;
                break;
            }
            case CBAStyleCenter:{
                ringView.cbaChargeLabel.textAlignment = NSTextAlignmentCenter;
                break;
            }
            case CBAStyleRight:{
                [labelAttr addAttribute:NSShadowAttributeName value:shadow range:NSMakeRange(0, labelAttr.length)];
                ringView.cbaChargeLabel.attributedText = labelAttr;
                ringView.cbaChargeLabel.textAlignment = NSTextAlignmentRight;
                break;
            }
        }
    };
    
    if (async){
        dispatch_async(dispatch_get_main_queue(), mashAvocado);
    }else{
        mashAvocado();
    }
}

%hook BCUI2x2AvocadoViewController
-(BOOL)_includeEmptyDevices{
    if (enabled && hideDummyRings){
        return NO;
    }
    return %orig;;
}

//This is to fix the glyphs animating while layout changing
-(void)viewWillLayoutSubviews{
    if (enabled){
        [UIView performWithoutAnimation:^{
            %orig;
        }];
    }else{
        %orig;
    }
}

-(NSMutableArray <BCUIRingItemView *>*)_batteryDeviceViews{
    NSMutableArray <BCUIRingItemView *> *ret = %orig;
    if (enabled){
        for (BCUIRingItemView *ringView in ret){
            updateRingView(ringView, ret.count, YES);
        }
    }
    return ret;
}

%end

%hook BCUIRingItemView
%property (nonatomic, strong) UILabel *cbaChargeLabel;
%property (nonatomic, strong) UIImageView *cbaGlyphView;

-(void)setPercentCharge:(long long)charge{
    %orig;
    if (enabled && [self.superview.viewDelegate isKindOfClass:[%c(BCUI2x2AvocadoViewController) class]] && !self.empty){
        self.cbaChargeLabel.text = [NSString stringWithFormat:@"%lld", charge];
    }
}
%end

static id valueForKey(NSString *key){
    CFStringRef appID = (__bridge CFStringRef)COMPACT_BATTERY_AVOCADO_IDENTIFIER;
    CFPreferencesAppSynchronize(appID);
    
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    if (keyList != NULL){
        BOOL containsKey = CFArrayContainsValue(keyList, CFRangeMake(0, CFArrayGetCount(keyList)), (__bridge CFStringRef)key);
        CFRelease(keyList);
        if (!containsKey) return nil;
        
        return CFBridgingRelease(CFPreferencesCopyAppValue((__bridge CFStringRef)key, appID));
    }
    return nil;
}

static void reloadPrefs(){
    id enabledVal = valueForKey(@"enabled");
    enabled = enabledVal ? [enabledVal boolValue] : YES;
    id hideDummyRingsVal = valueForKey(@"hideDummyRings");
    hideDummyRings = hideDummyRingsVal ? [hideDummyRingsVal boolValue] : YES;
    id verticalStyleVal = valueForKey(@"verticalStyle");
    verticalStyle = verticalStyleVal ? [verticalStyleVal intValue] : CBAStyleTop;
    id horizontalStyleVal = valueForKey(@"horizontalStyle");
    horizontalStyle = horizontalStyleVal ? [horizontalStyleVal intValue] : CBAStyleCenter;
}

%ctor{
    reloadPrefs();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadPrefs, (CFStringRef)PREFS_CHANGED_NN, NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
