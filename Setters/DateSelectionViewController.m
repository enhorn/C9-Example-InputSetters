//
//  DateSelectionViewController.m
//  Halsokollen
//
//  Created by Robin Enhorn on 2012-12-13.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import "DateSelectionViewController.h"

@interface DateSelectionViewController ()
@property (weak, nonatomic) IBOutlet UIView *toolsHolder;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) NSDate *defaultDate;
@property (nonatomic, copy) DateChangeBlock changeBlock;
@property (nonatomic, copy) DateDoneBlock doneBlock;
@property (nonatomic, readwrite) UIDatePickerMode pickerMode;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@end

@implementation DateSelectionViewController

static DateSelectionViewController *shared;
+ (DateSelectionViewController*) sharedDateSelector {
	if (!shared) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InputSetters" bundle: nil];
		shared = [storyboard instantiateViewControllerWithIdentifier:@"DateSelectionViewController"];
	}
	shared.defaultDate = [NSDate date];
	shared.changeBlock = nil;
	shared.doneBlock = nil;
	shared.pickerMode = UIDatePickerModeDate;
	shared.picker.maximumDate = nil;
	shared.picker.minimumDate = nil;
	return shared;
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - ViewController functions

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];

	NSArray *buttons = @[self.cancelButton, self.doneButton];
	for (NSInteger i = 0; i < buttons.count; i++) {
		UIBarButtonItem *button = [buttons objectAtIndex:i];
		[button setTitleTextAttributes:@{
										 UITextAttributeFont: [UIFont boldSystemFontOfSize:12.0f],
								   UITextAttributeTextColor : [UIColor whiteColor],
							 UITextAttributeTextShadowColor : [UIColor clearColor]
		 } forState:UIControlStateNormal];
	}

	[self addCancelView];
}

- (void) addCancelView {
	UIView *cancelView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, self.toolsHolder.frame.origin.y)];
	cancelView.backgroundColor = [UIColor clearColor];
	[self.view addSubview:cancelView];
	[cancelView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressedCancel:)]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[self setToolsHolder:nil];
	[self setToolbar:nil];
	[self setPicker:nil];
	[self setCancelButton:nil];
	[self setDoneButton:nil];
	[super viewDidUnload];
}

- (void) viewWillAppear:(BOOL)animated {
	self.picker.datePickerMode = self.pickerMode;
	if (self.defaultDate) {
		[self.picker setDate:self.defaultDate];
	}
}

- (void) viewDidAppear:(BOOL)animated {
	self.picker.datePickerMode = self.pickerMode;
	if (self.defaultDate) {
		[self.picker setDate:self.defaultDate];
	}
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Setup functions

- (void) setupForParentView:(UIView*)aView defaultDate:(NSDate*)aDate datePickerMode:(UIDatePickerMode)datePickerMode dateChangeBlock:(DateChangeBlock)dateChangeBlock dateDoneBlock:(DateDoneBlock)dateDoneBlock {
	self.defaultDate = aDate;
	self.changeBlock = dateChangeBlock;
	self.doneBlock = dateDoneBlock;
	self.picker.locale = [NSLocale currentLocale];
	self.pickerMode = datePickerMode;
	self.picker.datePickerMode = self.pickerMode;
	if (self.defaultDate) {
		[self.picker setDate:self.defaultDate];
	}
	[self addAndAnimateViews:aView];
}

- (void) addAndAnimateViews:(UIView*)aView {
	self.view.frame = CGRectMake(0.0f, 0.0f, aView.frame.size.width, aView.frame.size.height);
	self.view.alpha = 0.0;
	[aView addSubview:self.view];
	
	self.toolsHolder.frame = CGRectMake(0.0f, self.view.frame.size.height, self.toolsHolder.frame.size.width, self.toolsHolder.frame.size.height);
	
	[UIView animateWithDuration:0.25 animations:^(){
		self.view.alpha = 1.0;
		self.toolsHolder.frame = CGRectMake(0.0f, self.view.frame.size.height-self.toolsHolder.frame.size.height, self.toolsHolder.frame.size.width, self.toolsHolder.frame.size.height);
	}];
}

- (void) hideAndRemove {
	[UIView animateWithDuration:0.25 animations:^(){
		self.view.alpha = 0.0;
		self.toolsHolder.frame = CGRectMake(0.0f, self.view.frame.size.height, self.toolsHolder.frame.size.width, self.toolsHolder.frame.size.height);
	} completion:^(BOOL success){
		[self.view removeFromSuperview];
	}];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Button functions

- (IBAction)pressedDone:(UIBarButtonItem *)sender {
	if (self.doneBlock) {
		self.doneBlock([self.picker date]);
	}
	[self hideAndRemove];
}

- (IBAction)pressedCancel:(UIBarButtonItem *)sender {
	if (self.doneBlock) {
		self.doneBlock(nil);
	}
	[self hideAndRemove];
}


@end
