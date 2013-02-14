//
//  TextEditorViewController.h
//  Halsokollen
//
//  Created by Robin Enhorn on 2012-12-12.
//  Copyright (c) 2012 Cloud Nine. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^EditDoneBlock)(NSString *newText);

@interface TextEditorViewController : UIViewController <UITextViewDelegate>

+ (TextEditorViewController*) sharedTextEditor;
- (void) setupForParentView:(UIView*)aView defaultString:(NSString*)current placeholderText:(NSString*)placeholderText doneBlock:(EditDoneBlock)editDoneBlock;
- (void) setupNumbersForParentView:(UIView*)aView defaultString:(NSString*)current placeholderText:(NSString*)placeholderText doneBlock:(EditDoneBlock)editDoneBlock;

@end
