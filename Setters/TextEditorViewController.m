//
//  TextEditorViewController.m
//  Halsokollen
//
//  Created by Robin Enhorn on 2012-12-12.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import "TextEditorViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface TextEditorViewController () {
	BOOL isNumbers;
}
@property (weak, nonatomic) IBOutlet UIView *textBackgroundView;
@property (weak, nonatomic) IBOutlet UITextView *textview;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (nonatomic, copy) EditDoneBlock doneBlock;
@property (nonatomic, retain) NSString *standard;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;
@property (nonatomic, retain) NSString *placeHolderText;
@end

@implementation TextEditorViewController

static TextEditorViewController *shared;
+ (TextEditorViewController*) sharedTextEditor {
	if (!shared) {
		UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InputSetters" bundle: nil];
		shared = [storyboard instantiateViewControllerWithIdentifier:@"TextEditorViewController"];
	}
	shared.doneBlock = nil;
	shared.textview.text = @"";
	shared.backgroundLabel.text = @"";
	shared.placeHolderText = nil;
	return shared;
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - ViewController functions

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
		isNumbers = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
	self.textBackgroundView.layer.cornerRadius = 10.0f;

	NSArray *buttons = @[self.cancelButton, self.doneButton];
	for (NSInteger i = 0; i < buttons.count; i++) {
		UIBarButtonItem *button = [buttons objectAtIndex:i];
		[button setTitleTextAttributes:@{
				   UITextAttributeFont: [UIFont boldSystemFontOfSize:12.0f],
			 UITextAttributeTextColor : [UIColor whiteColor],
	   UITextAttributeTextShadowColor : [UIColor clearColor]
		 } forState:UIControlStateNormal];
	}
}

- (void) viewWillAppear:(BOOL)animated {
	self.textview.keyboardType = isNumbers ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
	[self.textview becomeFirstResponder];
	if (self.standard) {
		self.textview.text = self.standard;
	} else {
		self.textview.text = @"";
	}
	if (self.placeHolderText) {
		self.backgroundLabel.text = self.placeHolderText;
	}
}

- (void) viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	self.textview.keyboardType = isNumbers ? UIKeyboardTypeNumberPad : UIKeyboardTypeDefault;
	[self.textview becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[self setTextBackgroundView:nil];
	[self setTextview:nil];
	[self setToolbar:nil];
	[self setCancelButton:nil];
	[self setDoneButton:nil];
	[self setBackgroundLabel:nil];
	[super viewDidUnload];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Setup functions

- (void) setupForParentView:(UIView*)aView defaultString:(NSString*)current placeholderText:(NSString*)placeholderText doneBlock:(EditDoneBlock)editDoneBlock {
	self.doneBlock = editDoneBlock;
	self.standard = current;
	isNumbers = NO;

	if (placeholderText) {
		self.placeHolderText = placeholderText;
	}

	self.textview.keyboardType = UIKeyboardTypeDefault;
	[self addAndAnimateViews:aView];
}

- (void) setupNumbersForParentView:(UIView*)aView defaultString:(NSString*)current placeholderText:(NSString*)placeholderText doneBlock:(EditDoneBlock)editDoneBlock {
	self.doneBlock = editDoneBlock;
	self.standard = current;
	isNumbers = YES;

	if (placeholderText) {
		self.placeHolderText = placeholderText;
	}

	self.textview.keyboardType = UIKeyboardTypeNumberPad;
	[self addAndAnimateViews:aView];
}

- (void) addAndAnimateViews:(UIView*)aView {
	CGFloat add = 0.0f;

	// If a fullscreen view, make room for the status bar.
	if (aView.frame.size.height == 568 || aView.frame.size.height == 480) {
		add = 20.0f;
	}

	self.view.frame = CGRectMake(0.0f, add, aView.frame.size.width, aView.frame.size.height - add);
	self.view.alpha = 0.0;
	self.textBackgroundView.alpha = 0.0f;
	[aView addSubview:self.view];
	
	CGFloat originalPosition = self.toolbar.frame.origin.y;
	
	self.toolbar.frame = CGRectMake(0.0f, self.view.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);

	if (self.standard) {
		self.textview.text = self.standard;
	} else {
		self.textview.text = @"";
	}
	if (self.placeHolderText) {
		self.backgroundLabel.text = self.placeHolderText;
	}

	[self.textview becomeFirstResponder];
	[UIView animateWithDuration:0.25 animations:^(){
		self.view.alpha = 1.0;
		self.textBackgroundView.alpha = 1.0f;
		self.toolbar.frame = CGRectMake(0.0f, originalPosition, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
	}];
}

- (void) hideAndRemove {
	[self.textview resignFirstResponder];
	CGFloat originalPosition = self.toolbar.frame.origin.y;
	[UIView animateWithDuration:0.25 animations:^(){
		self.view.alpha = 0.0;
		self.toolbar.frame = CGRectMake(0.0f, self.view.frame.size.height, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
	} completion:^(BOOL success){
		self.toolbar.frame = CGRectMake(0.0f, originalPosition, self.toolbar.frame.size.width, self.toolbar.frame.size.height);
		[self.view removeFromSuperview];
	}];
}

/* -------------------------------------------------------------------------------------- */
#pragma mark - Button functions

- (IBAction)pressedCancel:(id)sender {
	[self hideAndRemove];
}


- (IBAction)pressedDone:(id)sender {
	if (self.doneBlock) {
		self.doneBlock(self.textview.text);
	}
	[self hideAndRemove];
}

@end
