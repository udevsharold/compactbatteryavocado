#import "Common.h"

@interface UIView (Private)
@property (assign,setter=_setViewDelegate:,getter=_viewDelegate,nonatomic) UIViewController * viewDelegate;
@end

@interface BCUIChargeRing : UIView
@end

@interface BCUIRingItemView : UIView
@property (nonatomic, strong) UILabel *cbaChargeLabel;
@property (nonatomic, strong) UIImageView *cbaGlyphView;
@property (assign,nonatomic) double ringLineWidth;
@property (assign,nonatomic) long long percentCharge;
@property (nonatomic,retain) UIImage * glyph;
@property (assign,getter=isEmpty,nonatomic) BOOL empty;
-(void)setRingItemViewStyle:(long long)arg1 ;
-(long long)ringItemViewStyle;
@end

@interface BCUIAvocadoViewController : UIViewController
@property (nonatomic,copy) NSArray * batteryDevices;
-(NSMutableArray *)_batteryDeviceViews;
@end

@interface BCUI2x2AvocadoViewController : BCUIAvocadoViewController
@end
