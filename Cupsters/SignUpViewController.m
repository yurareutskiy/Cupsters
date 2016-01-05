//
//  SignUpViewController.m
//  Cupsters
//
//  Created by Reutskiy Jury on 1/5/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "SignUpViewController.h"

@interface SignUpViewController ()

@property (nonatomic, strong) UITextField *activeField;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    self.scrollView.bounces = false;
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.scrollView.frame.size.height);
    
    for (UITextField *textField in self.fields) {
        textField.delegate = self;
    }
    
    [self.agreeButton setImage: [UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [self.agreeButton setImage: [UIImage imageNamed:@"checkIn"] forState:UIControlStateSelected];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.scrollView addGestureRecognizer:tapRecognizer];

//    self.scrollView.scrollEnabled = false;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

// Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) ) {
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)editDidBeginAction:(UITextField *)sender {
    if (sender.tag == 4) {
        sender.secureTextEntry = true;
    }
    sender.text = @"";
    self.activeField = sender;
    
    NSLog(@"%f", sender.frame.origin.x);
}

- (IBAction)editDidEndAction:(UITextField *)sender {
    if ([sender.text isEqualToString:@""]) {
        switch (sender.tag) {
            case 1:
                sender.text = @"Имя";
                break;
            case 2:
                sender.text = @"Фамилия";
                break;
            case 3:
                sender.text = @"Email";
                break;
            case 4:
                sender.text = @"Пароль";
                sender.secureTextEntry = false;
                break;
            default:
                break;
        }
    }
    self.activeField = nil;
}

- (IBAction)didEndOnExit:(UITextField *)sender {
    NSLog(@"didEndOnExit");
}

- (IBAction)agreeButtonAction:(UIButton *)sender {

    if (sender.isSelected == true) {
        sender.alpha = 0.6;
        sender.selected = false;
    } else {
        sender.alpha = 1;

        sender.selected = true;
    }
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}


-(void) hideKeyboard {
    for (UITextField *tf in self.fields) {
        [tf resignFirstResponder];
    }
}

@end
