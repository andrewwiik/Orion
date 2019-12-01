@interface _UIButtonFeedbackGeneratorConfiguration : NSObject
+ (id)prominentConfiguration;
@end

@class _UIPreviewPlatterPanController;

@interface _UIPreviewPlatterLayoutArbiter : NSObject
@property (assign,nonatomic) unsigned long long currentLayout;
@end


@interface _UIPreviewPlatterView : UIView
@end

@interface _UIContextMenuStyle : NSObject
+(_UIContextMenuStyle *)defaultStyle;
@property (nonatomic, retain) NSNumber *orn_Special;
@property (assign,nonatomic) BOOL hasInteractivePreview;
@property (assign,nonatomic) BOOL preventPreviewRasterization;
@property (assign,nonatomic) BOOL reversesActionOrderWhenAttachedToTop;
@property (assign,nonatomic) NSUInteger preferredLayout;
@end


@interface UIInterfaceActionGroupView : UIView
@property (assign,nonatomic) BOOL scrubbingEnabled;
@end

@interface _UIContextMenuActionsListView : UIView
@property (nonatomic,retain) UIInterfaceActionGroupView * currentActionGroupView;
@end

@interface _UIPreviewPlatterPresentationController : NSObject
@property (nonatomic,copy) _UIContextMenuStyle * currentStyle; 
- (_UIPreviewPlatterView *)contentPlatterView;
- (void)_handlePlatterActionTapGesture:(id)arg1;
- (void)presentationTransitionWillBegin;
- (void)setActionScrubbingHandoffGestureRecognizer:(UIPanGestureRecognizer *)recognizer;
@property (nonatomic,retain) _UIPreviewPlatterPanController * platterPanController; 
-(void)_testing_dismissByTappingOutside;
@property (nonatomic,readonly) _UIContextMenuActionsListView * actionsView; 
- (void)platterPanControllerDidSwipeDown:(_UIPreviewPlatterPanController *)panController;
- (void)dismissalTransitionWillBegin;
-(void)_updatePlatterAndActionViewLayoutForce:(bool)arg2 updateAttachment:(bool)arg3;
@property (nonatomic,retain) _UIPreviewPlatterLayoutArbiter *layoutArbiter; 
@end

@interface _UIPreviewPlatterPanController : NSObject
- (_UIPreviewPlatterPresentationController *)delegate;
@property (assign,nonatomic) NSUInteger rubberbandingEdges;
@property (assign,nonatomic) NSUInteger initialDetentIndex;
@property (nonatomic,retain) UIPanGestureRecognizer * panGestureRecognizer; 

@end

@interface UIPanGestureRecognizer (Bob)
- (void)setState:(long long)state;
@property (nonatomic, retain) NSNumber *firstTouch;
@end

@interface UILongPressGestureRecognizer (Orion)
@property (nonatomic, retain) NSNumber *orn_lp;
@property (nonatomic, retain) NSNumber *firstTouch;
- (void)setState:(NSInteger)state;
- (void)setDelay:(CGFloat)delay;
@end

@interface _UITouchDurationObservingGestureRecognizer : UIGestureRecognizer
@property (assign,nonatomic) double minimumDurationRequired;
@property (nonatomic,readonly) double touchForce; 
@end

%hook _UITouchDurationObservingGestureRecognizer
- (CGFloat)minimumDurationRequired {
	return 200000000000.0;
}

// - (CGFloat)touchForce {
// 	return 2.5;
// }
%end

%hook UILongPressGestureRecognizer
%property (nonatomic, retain) NSNumber *orn_lp;
%property (nonatomic, retain) NSNumber *firstTouch;

- (id)initWithTarget:(id)target action:(SEL)action {
	UILongPressGestureRecognizer *recognizer = %orig;
	if (action && [NSStringFromSelector(action) isEqualToString:@"_handleMenuGesture:"]) {
		recognizer.orn_lp = @(1);
	}
	return recognizer;
}

-(void)addTarget:(id)target action:(SEL)action {
	%orig;
	if (action && [NSStringFromSelector(action) isEqualToString:@"_handleMenuGesture:"]) {
		self.orn_lp = @(1);
		[self setMinimumPressDuration:0.5];
		[self setDelay:0.0];
		[self setDelegate:nil];
	}
}

-(void)touchesBegan:(NSSet *)touches withEvent:(id)arg2 {
	if (@available(iOS 11, *)) {
		if (self.orn_lp) {
			if (touches) {
				NSArray *allTouches = [touches allObjects];
				if ([allTouches count] > 0) {
					UITouch *touch = [allTouches objectAtIndex:0];
					if (touch.force > 2.5) {
						
						[self setState:UIGestureRecognizerStateBegan];
						return;
					}
					self.firstTouch = @(touch.timestamp);
				}
			}
		}
	}
	%orig;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(id)arg2 {
	if (@available(iOS 11, *)) {
		if (self.orn_lp) {
			if (touches) {
				NSArray *allTouches = [touches allObjects];
				if ([allTouches count] > 0) {
					UITouch *touch = [allTouches objectAtIndex:0];
					if (touch.force > 2.5 && self.firstTouch && (touch.timestamp - [self.firstTouch floatValue]) > 0.15) {
						
						[self setState:UIGestureRecognizerStateBegan];
						return;
					}
				}
			}
			return;
		}
	}
	%orig;
}

-(void)setMinimumPressDuration:(CGFloat)duration {
	if (self.orn_lp) {
		duration = 200000.00;
	}
	%orig(duration);
}

- (CGFloat)minimumPressDuration {
	if (self.orn_lp) {
		return 200000.00;
	}
	return %orig;
}

-(void)setDelay:(CGFloat)delay {
	if (self.orn_lp) {
		delay = 0.0;
	}
	%orig(delay);
}

- (void)setDelegate:(id)delegate {
	if (self.orn_lp) {
		delegate = nil;
	}
	%orig(delegate);
}
%end

%hook UIPanGestureRecognizer
%property (nonatomic, retain) NSNumber *firstTouch;

-(void)touchesBegan:(NSSet *)touches withEvent:(id)arg2 {
	if (@available(iOS 11, *)) {
		if (self.name && [self.name isEqualToString:@"com.apple.UIKit.PreviewPlatterPan"]) {
			if (touches) {
				NSArray *allTouches = [touches allObjects];
				if ([allTouches count] > 0) {
					UITouch *touch = [allTouches objectAtIndex:0];
					self.firstTouch = @(touch.timestamp);
				}
			}
		}
	}
	%orig;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(id)arg2 {
	if (@available(iOS 11, *)) {
		if (self.name && [self.name isEqualToString:@"com.apple.UIKit.PreviewPlatterPan"]) {
			if (touches) {
				NSArray *allTouches = [touches allObjects];
				if ([allTouches count] > 0) {
					UITouch *touch = [allTouches objectAtIndex:0];
					if (touch.force > 5.6 && self.firstTouch && (touch.timestamp - [self.firstTouch floatValue]) > 0.35) {
						if ([self delegate]) {
							if ([[self delegate] isKindOfClass:NSClassFromString(@"_UIPreviewPlatterPanController")]) {
								_UIPreviewPlatterPanController *panController = ((_UIPreviewPlatterPanController  *)[self delegate]);
								if ([panController delegate] && [[panController delegate] isKindOfClass:NSClassFromString(@"_UIPreviewPlatterPresentationController")]) {
									_UIPreviewPlatterPresentationController *presentationController = ((_UIPreviewPlatterPresentationController *)[panController delegate]);
									[self setState: UIGestureRecognizerStateEnded];
									[presentationController _handlePlatterActionTapGesture:self];
								}
							}
						}
					}
				}
			}
		}
	}
	%orig;
}

%end

%hook _UIContextMenuStyle
%property (nonatomic, retain) NSNumber *orn_Special;
+ (_UIContextMenuStyle *)defaultStyle {
	_UIContextMenuStyle *style = %orig;
	return style;
}

%end

%hook _UIPreviewPlatterPresentationController
-(id)initWithPresentingViewController:(id)arg1 configuration:(id)arg2 sourcePreview:(id)arg3 style:(_UIContextMenuStyle *)style {
	return %orig;
}

- (void)presentationTransitionWillBegin {
	BOOL doAfter = NO;
	if (self.currentStyle && self.currentStyle.preferredLayout == 0) {
		self.currentStyle.preferredLayout = 1;
		self.currentStyle.orn_Special = [NSNumber numberWithInteger:1];
		doAfter = YES;
	}
	%orig;
	if (doAfter && self.currentStyle) {
		self.currentStyle.preferredLayout = 0;
		self.currentStyle.orn_Special = nil;
	}
}

- (void)setActionScrubbingHandoffGestureRecognizer:(UIPanGestureRecognizer *)recognizer {
	%orig;
	if (self.currentStyle && self.currentStyle.orn_Special) {
		if ([self.currentStyle.orn_Special integerValue] == 1) {
			self.currentStyle.preferredLayout = 0;
		}
	}
}


- (void)_updateLayoutAndAttachment:(BOOL)arg2 {
	BOOL doAfter = NO;
	if (self.currentStyle) {
		doAfter = YES;
	}
	%orig;
	if (doAfter) {
		if (self.platterPanController) {
			self.platterPanController.rubberbandingEdges = 15;
		}
	}
}

-(void)platterPanInteractionEnded:(_UIPreviewPlatterPanController *)panController {
	if (self.currentStyle) {
		if (self.currentStyle.preferredLayout == 0) {
			BOOL dismiss = YES;
			CGPoint done = [panController.panGestureRecognizer locationInView:self.actionsView.currentActionGroupView];
			if (CGRectContainsPoint(self.actionsView.currentActionGroupView.frame, done)) {
				dismiss = NO;
			}

			if (dismiss) {
				%orig;
				[self dismissalTransitionWillBegin];
				[self performSelector:@selector(_testing_dismissByTappingOutside) withObject:nil afterDelay:.05];
				return;
			}
		}
	}
	%orig;
}

- (void)setLayoutArbiter:(_UIPreviewPlatterLayoutArbiter *)arbiter {
	if (self.currentStyle && self.currentStyle.orn_Special) {
		if ([self.currentStyle.orn_Special integerValue] == 1) {
			if (arbiter) {
				[arbiter setCurrentLayout: 0];
			}
		}
	}
	%orig;
}
%end


%group Apps
%hook _UIContextMenuLayoutArbiter

-(id)initWithContainerView:(id)arg1 layout:(NSUInteger)arg2 {
	return %orig(arg1, 0);
}
%end

%hook _UIPreviewPlatterLayoutArbiter

-(id)initWithContainerView:(id)arg1 layout:(NSUInteger)arg2 {
	return %orig(arg1, 0);
}

%end

%hook _UIPreviewPlatterPanController
- (void)setRubberbandingEdges:(NSUInteger)edges {
	if (edges == 11) edges = 15;
	if (edges == 12) edges = 11;
	%orig(edges);
}

-(void)_updateViewPositionsWithTranslation:(CGPoint)arg2 location:(CGPoint)arg3 ended:(BOOL)arg4 withVelocity:(BOOL)arg5 {
	if ([self rubberbandingEdges] == 15) {
		arg2.y = -400;
		//NSLog(@"ORION:\n X, %@ Y, %@\n X, %@ Y, %@,\n %@\n %@\n", @(arg2.x), @(arg2.y), @(arg3.x), @(arg3.y), @(arg4), @(arg5));
		self.rubberbandingEdges = 12;
		self.delegate.layoutArbiter.currentLayout = 1;
		%orig(arg2, arg3, arg4, arg5);
		self.rubberbandingEdges = 15;
		self.delegate.layoutArbiter.currentLayout = 0;
	} else {
		%orig;
	}
}
%end

@interface _UIClickPresentationFeedbackGenerator : NSObject
- (void)previewed;
- (void)popped;
- (void)dragged;
@end

static BOOL fakeThing = NO;
static BOOL fakeThing2 = NO;

// static BOOL useFakePreview = NO;
%hook _UIClickPresentationFeedbackGenerator
- (void)previewed {
	fakeThing2 = YES;

	%orig;
	fakeThing2 = NO;
}

- (void)popped {
	fakeThing = YES;

	%orig;
	fakeThing = NO;
}
%end


%hook _UIFeedbackParameters
- (void)setVolume:(float)volume {
	if (fakeThing) {
		volume = 1000.00;
	}

	if (fakeThing2) {
		volume = 0.70;
	}
	%orig(volume);
}
%end

%hook _UICustomDiscreteFeedback
+(id)customDiscreteFeedbackWithEventType:(unsigned long long)arg1 systemSoundID:(unsigned)arg2 {
	if (fakeThing && arg1 == 8023) arg1 = 23382;
	return %orig(arg1, arg2);
}
%end
%end


static BOOL useSpecialAnimation = NO;
%hook _UIRapidClickPresentationAssistant
-(void)_performPresentationAnimationsFromViewController:(id)arg1 {
	useSpecialAnimation = YES;
	%orig;
	useSpecialAnimation = NO;
}
%end

%hook UIView
+(void)_animateUsingSpringWithDampingRatio:(double)arg1 response:(double)arg2 tracking:(BOOL)arg3 dampingRatioSmoothing:(double)arg4 responseSmoothing:(double)arg5 targetSmoothing:(double)arg6 projectionDeceleration:(double)arg7 animations:(/*^block*/id)arg8 completion:(/*^block*/id)arg9
 {
	if (useSpecialAnimation) {
		arg2 = 0.15;
		arg1 = 0.8;
	}
	%orig;
}
%end

%ctor {
	%init;
	if ([NSBundle mainBundle] && ![[[NSBundle mainBundle] bundleIdentifier] isEqualToString:@"com.apple.springboard"]) {
		%init(Apps);
	}
}