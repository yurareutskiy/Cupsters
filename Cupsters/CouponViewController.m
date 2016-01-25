//
//  CouponViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 18/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "CouponViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"

@interface CouponViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
@property (strong, nonatomic) UIViewController *vc;

@end

@implementation CouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self customNavBar];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    self.code.delegate = self;
    self.notCode.delegate = self;
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    self.menu.view.frame = CGRectMake(self.menu.view.frame.origin.x, 0.f, 280.f, self.menu.view.frame.size.height + 60.f);
}

- (void)customNavBar {
    
    // Set background color
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHEX:cBrown];
    self.navigationController.navigationBar.translucent = NO;
    
    
    // Set title view
    
    self.navigationItem.titleView = [self customTitleViewWithImage];
    
}

- (void)configureMenu {
    
    self.reveal = self.revealViewController;
    
    if (!self.reveal) {
        return;
    }
    
    
    // Add gesture recognizer
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    // Set menu button
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow"]
                                                       style:UIBarButtonItemStyleDone
                                                      target:self
                                                      action:@selector(toList:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}

- (void)toList:(id)sender {
    
    [self presentViewController:self.vc animated:true completion:nil];
    
}

- (UILabel*)customTitleViewWithImage {
    
    // Create
    UILabel* navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    // Create text attachment, which will contain and set text and image
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"smallCup"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:@"1 ЧАШКА  "];
    [myString appendAttributedString:attachmentString];
    
    // Configure our label
    navigationBarLabel.attributedText = myString;
    navigationBarLabel.font = [UIFont fontWithName:cFontMyraid size:18.f];
    navigationBarLabel.textColor = [UIColor whiteColor];
    navigationBarLabel.textAlignment = NSTextAlignmentCenter;
    
    return navigationBarLabel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    _code.textAlignment = NSTextAlignmentLeft;
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *code = [self formatCode:_code.text];
    int length2 = [self getLength:code];
    
    NSString *space = @"_";
    
    if(length2 == 1)
    {
        NSString *code = [self formatCode:_code.text];
        const char *c = [code UTF8String];
        _code.text = [NSString stringWithFormat:@"%c ",c[0]];
        //_notCode.text = [NSString stringWithFormat:@"  %@ %@ %@ %@ %@", space, space, space, space, space];
        
        
        if(range.length > 0)
            _code.text = [NSString stringWithFormat:@"%c",c[0]];
    }
    if(length2 == 2)
    {
        NSString *code = [self formatCode:_code.text];
        const char *c = [code UTF8String];
        
        _code.text = [NSString stringWithFormat:@"%c %c ",c[0],c[1]];
        //_notCode.text = [NSString stringWithFormat:@"    %@ %@ %@ %@", space, space, space, space];
        if(range.length > 0)
            _code.text = [NSString stringWithFormat:@"%c %c",c[0],c[1]];
    }
    if(length2 == 3)
    {
        NSString *code = [self formatCode:_code.text];
        const char *c = [code UTF8String];
        
        _code.text = [NSString stringWithFormat:@"%c %c %c ",c[0],c[1],c[2]];
        //_notCode.text = [NSString stringWithFormat:@"      %@ %@ %@", space, space, space];
        
        if(range.length > 0)
            _code.text = [NSString stringWithFormat:@"%c %c %c",c[0],c[1],c[2]];
        
    }
    
    if(length2 == 4)
    {
        NSString *code = [self formatCode:_code.text];
        const char *c = [code UTF8String];
        
        _code.text = [NSString stringWithFormat:@"%c %c %c %c ",c[0],c[1],c[2],c[3]];
        //_notCode.text = [NSString stringWithFormat:@"        %@ %@", space, space];
        
        if(range.length > 0)
            _code.text = [NSString stringWithFormat:@"%c %c %c %c",c[0],c[1],c[2],c[3]];
        
    }

    if(length2 == 5)
    {
        NSString *code = [self formatCode:_code.text];
        const char *c = [code UTF8String];
        
        _code.text = [NSString stringWithFormat:@"%c %c %c %c %c ",c[0],c[1],c[2],c[3],c[4]];
        //_notCode.text = [NSString stringWithFormat:@"          %@", space];
        
        if(range.length > 0)
            _code.text = [NSString stringWithFormat:@"%c %c %c %c %c",c[0],c[1],c[2],c[3],c[4]];
        
    }

    if (length2 == 6)
    {
        NSString *code = [self formatCode:_code.text];
        const char *c = [code UTF8String];
        
        _code.text = [NSString stringWithFormat:@"%c %c %c %c %c %c",c[0],c[1],c[2],c[3],c[4],c[5]];
        //_notCode.text = [NSString stringWithFormat:@"           "];
        
        if(range.length == 0)
            return NO;
    }

    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.code resignFirstResponder];
}

-(NSString *)formatCode:(NSString *)code{
    code = [code stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return code;
}

-(int)getLength:(NSString*)code
{
    code = [code stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    int length = [code length];
    
    return length;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
