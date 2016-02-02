//
//  OrderViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 19/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "OrderViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import <SCLAlertView.h>
#import "Server.h"
#import "User.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import "AppDelegate.h"

@interface OrderViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;

@end

@implementation OrderViewController {
    NSUserDefaults *userDefaults;
    User *user;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    self.code.delegate = self;
    self.notCode.delegate = self;
    
    self.upView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.upView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.upView.layer.shadowRadius = 1.0f;
    self.upView.layer.shadowOpacity = 0.5f;
    [self.upView.layer setMasksToBounds:NO];
    
    [self.name setText:[self.coffee valueForKey:@"name"]];
    [self.volume setText:[NSString stringWithFormat:@"%@ мл", [self.coffee valueForKey:@"volume"]]];
    NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://lk.cupsters.ru%@BIG3.png", [self.coffee valueForKey:@"icon"]]];
    [self.image setImageWithURL:imageURL];
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated {
    self.menu.view.frame = CGRectMake(self.menu.view.frame.origin.x, 0.f, 280.f, self.menu.view.frame.size.height + 60.f);
    [self customNavBar];

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
                                                      action:@selector(backAction)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
    
}


- (UILabel*)customTitleViewWithImage {
    
    // Create
    UILabel* navigationBarLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 30)];
    
    // Create text attachment, which will contain and set text and image
    NSTextAttachment *attachment = [[NSTextAttachment alloc] init];
    attachment.image = [UIImage imageNamed:@"smallCup"];
    NSAttributedString *attachmentString = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *myString= [[NSMutableAttributedString alloc] initWithString:[[NSUserDefaults standardUserDefaults] valueForKey:@"currentCounter"]];
    [myString appendAttributedString:attachmentString];
    
    // Configure our label
    navigationBarLabel.attributedText = myString;
    navigationBarLabel.font = [UIFont fontWithName:cFontMyraid size:18.f];
    navigationBarLabel.textColor = [UIColor whiteColor];
    navigationBarLabel.textAlignment = NSTextAlignmentCenter;
    
    return navigationBarLabel;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    _code.textAlignment = NSTextAlignmentLeft;
    
    return YES;
}


- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    
    UIColor *color = [UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0];
    
    SCLButton *firstButton = [alert addButton:@"Да" target:self selector:@selector(sendOrder)];
    
    firstButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        //buttonConfig[@"borderWidth"] = @2.0f;
        //buttonConfig[@"borderColor"] = [UIColor greenColor];
        
        return buttonConfig;
    };
    
    SCLButton *secondButton = [alert addButton:@"Нет" target:self selector:@selector(backAction)];
    
    secondButton.buttonFormatBlock = ^NSDictionary* (void)
    {
        NSMutableDictionary *buttonConfig = [[NSMutableDictionary alloc] init];
        
        buttonConfig[@"backgroundColor"] = [UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0];
        buttonConfig[@"textColor"] = [UIColor whiteColor];
        
        //buttonConfig[@"borderWidth"] = @2.0f;
        //buttonConfig[@"borderColor"] = [UIColor greenColor];
        
        return buttonConfig;
    };
    
    [alert showCustom:self image:[UIImage imageNamed:@"cup"] color:color title:@"Подтверждение" subTitle:[NSString stringWithFormat:@"Вы заказали %@, объем %@", self.name.text, self.volume.text]  closeButtonTitle:nil duration:0.0f];

}

- (void) backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage*) scaleImage:(UIImage*)image toSize:(CGSize)newSize {
    CGSize scaledSize = newSize;
    float scaleFactor = 1.0;
    if( image.size.width > image.size.height ) {
        scaleFactor = image.size.width / image.size.height;
        scaledSize.width = newSize.width;
        scaledSize.height = newSize.height / scaleFactor;
    }
    else {
        scaleFactor = image.size.height / image.size.width;
        scaledSize.height = newSize.height;
        scaledSize.width = newSize.width / scaleFactor;
    }
    
    UIGraphicsBeginImageContextWithOptions( scaledSize, NO, 0.0 );
    CGRect scaledImageRect = CGRectMake( 0.0, 0.0, scaledSize.width, scaledSize.height );
    [image drawInRect:scaledImageRect];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (void) agreeButton {
    NSLog(@"Подтверждено");
}
- (void) declineButton {
    NSLog(@"Отклонено");
}

-(void)closeAlertview
{
    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"%f", self.code.frame.origin.y);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.bg setBackgroundColor:[UIColor blackColor]];
        [self.bg setAlpha:0.85];
        
        self.bgBottom.constant += keyboardSize.height;
        [self.bg layoutIfNeeded];
        
        [self.code setTextColor:[UIColor whiteColor]];
        [self.notCode setTextColor:[UIColor whiteColor]];
        [self.labelCode setTextColor:[UIColor whiteColor]];

    }];
    
    NSLog(@"%f", self.code.frame.origin.y);
}

-(void)keyboardWillHide:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSLog(@"%f", self.code.frame.origin.y);
    
    [UIView animateWithDuration:0.5 animations:^{
        [self.bg setBackgroundColor:[UIColor clearColor]];
        [self.bg setAlpha:1.0];
        
        self.bgBottom.constant -= keyboardSize.height;
        
        [self.code setTextColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0]];
        [self.notCode setTextColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0]];
        [self.labelCode setTextColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0]];
        
    }];
    
    NSLog(@"%f", self.code.frame.origin.y);
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
        
        _code.text = [NSString stringWithFormat:@"%c %c %c %c",c[0],c[1],c[2],c[3]];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) sendOrder {
    user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
    if (![self checkUserCanMakeOrder]) {
        
        return;
    }
    
    NSManagedObject *coffeeId = [self.coffee valueForKey:@"id"];;
    NSNumber *userID = user.id;
    NSNumber *number = @1;
    
    NSDictionary *body = @{@"coffee_id":coffeeId, @"user_id":userID, @"number":number};
    NSLog(@"im work");
    NSLog(@"%@", body);
    
    Server *server = [[Server alloc] init];
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST With:body To:OrderURLStrring];
    [server sentToServer:request OnSuccess:^(NSDictionary *result) {
        [self addOrderToHistory:result[@"order"]];
        if ([user.plan[@"counter"] isEqualToString:@"-1"]) {
        } else {
            NSString *cupsString = user.plan[@"counter"];
            NSInteger cups = [cupsString intValue] - 1;
            NSString *text;
            if (cups == 1) {
                text = @"ЧАШКА";
            } else if (cups == 2 || cups == 3 || cups == 4) {
                text = @"ЧАШКИ";
            } else {
                text = @"ЧАШЕК";
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld %@  ", (long)cups, text] forKey:@"currentCounter"];
            NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:user.plan];
            mutDict[@"counter"] = [NSString stringWithFormat:@"%d", cups];
            user.plan = mutDict;
            [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"user"];
            if (cups == 0) {
                [[NSUserDefaults standardUserDefaults] setObject:@"НЕТ ЧАШЕК  " forKey:@"currentCounter"];
            }
        }
        NSLog(@"Блять, работает?!");
    } OrFailure:^(NSError *error) {
        NSLog(@"%@", [error debugDescription]);
    }];
}

- (void) addOrderToHistory:(NSDictionary*)orderDict {
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Orders" inManagedObjectContext:context];
    NSManagedObject *order = [[NSManagedObject alloc] initWithEntity:entity insertIntoManagedObjectContext:context];
    [order setValue:orderDict[@"cafe"] forKey:@"cafe"];
    [order setValue:orderDict[@"coffee"] forKey:@"coffee"];
    [order setValue:orderDict[@"volume"] forKey:@"volume"];
    [order setValue:orderDict[@"date_accept"] forKey:@"date"];
    [order setValue:orderDict[@"cafe_id"] forKey:@"cafe_id"];
    [order setValue:orderDict[@"coffee_id"] forKey:@"coffee_id"];
    [order setValue:[NSNumber numberWithInt:((NSString*)orderDict[@"id"]).intValue] forKey:@"id"];
    NSError *error = nil;
    [context save:&error];
    if (error) {
        NSLog(@"%@", [error debugDescription]);
    }

}

- (BOOL)checkUserCanMakeOrder {
    NSInteger counter = [user.plan[@"counter"] intValue];
    if (counter == 0) {
        return NO;
    } else if (counter == -1) {
        NSDate *expiredDate = user.plan[@"endDate"];
        NSInteger result = [expiredDate compare:[NSDate date]];
        if (result != 1) {
            return NO;
        }
    }
    return YES;
}



@end
