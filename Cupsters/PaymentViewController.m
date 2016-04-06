//
//  PaymentViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 27/02/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "PaymentViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "Server.h"
#import "AppDelegate.h"
#import <RKDropdownAlert.h>
//#import <CloudPaymentsAPI/CPService.h>
#import "AFNetworking.h"
#import <AFHTTPSessionManager.h>
#import <SVProgressHUD.h>
#import "User.h"
#import <SCLAlertView.h>

@interface PaymentViewController () <PLRWebViewDataSource, UIWebViewDelegate> {
//    CPService *_apiService;
    
    // These values you MUST store at your server.
    NSString *_apiPublicID;
    NSString *_apiSecret;
}

- (NSDictionary *)parseQueryString:(NSString *)query;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) PLRWebView *webView;

// new
//@property (nonatomic, weak) IBOutlet PLRWebView *webView;
//@property (nonatomic, weak) IBOutlet UIButton *chargeButton;
//@property (nonatomic, weak) IBOutlet UIButton *refundButton;
//@property (nonatomic, weak) IBOutlet UILabel *textLabel;

@property (nonatomic, strong) PLRSessionInfo *sessionInfo;
@property (nonatomic, strong) PaylerAPIClient *client;
@property (nonatomic, assign) PLRSessionType sessionType;


@end

@implementation PaymentViewController{
    NSUserDefaults *userDefaults;
    BOOL keyboard;
    BOOL isWebViewClose;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.date.delegate = self;
    self.cvv.delegate = self;
    self.name.delegate = self;
    self.number.delegate = self;
    
    // for test
    
    self.priceValue = @"100";
    self.sessionType = PLRSessionTypeOneStep;
    
    keyboard = NO;
    isWebViewClose = NO;
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    
//    self.sessionType = PLRSessionTypeTwoStep;
//    _apiService = [[CPService alloc] init];
    
//#pragma message "These values .you MUST store at your server."
//    _apiPublicID = @"pk_2eded2fc5dddab906da276add5fbc";
//    _apiSecret = @"a719ef1cabfcebeffc737bde9655cb70";
    
    
//    NSUInteger year = 0;
//    NSUInteger month = 0;
    
//    NSString *cardExpirationDateString = [NSString stringWithFormat:@"%02lu%02lu",(unsigned long)year%100, (unsigned long)month];
    
    self.price.text = [self formattedStringWithPrice:[NSString stringWithFormat:@"%@", self.priceValue]];
    
    // Do any additional setup after loading the view.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (!keyboard) {
        keyboard = YES;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 64 - keyboardSize.height, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification {
//    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if (keyboard) {
        keyboard = NO;
        self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
        }];
    }
}

- (void)customNavBar {
    
    // Set background color
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHEX:cBrown];
    self.navigationController.navigationBar.translucent = NO;
    
    
    // Set title view
    
    self.navigationItem.titleView = [self customTitleViewWithImage];
    
}

- (void)configureMenu {

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

- (void) backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.name resignFirstResponder];
    [self.number resignFirstResponder];
    [self.date resignFirstResponder];
    [self.cvv resignFirstResponder];
}

#pragma mark - PLRWebViewDataSource

- (PLRSessionInfo *)webViewSessionInfo:(PLRWebView *)sender {
    return self.sessionInfo;
}

- (PaylerAPIClient *)webViewClient:(PLRWebView *)sender {
    return self.client;
}


#pragma mark - make payment implementation

- (IBAction)makePaymentAction:(id)sender {
    
    CGRect rect = self.view.frame;
    rect.origin.y = 0;
    rect.size.height -= 64;
    self.webView = [[PLRWebView alloc] initWithFrame:rect];

    self.webView.delegate = self;
    self.webView.dataSource = self;
    [self.view addSubview:self.webView];
    
    [self startPayment];
    
//    if (![self validateFields]) {
//        [RKDropdownAlert title:@"Невозможно выполнить платеж" message:@"Проверьте правильность ввода полей" backgroundColor:[UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0] textColor:nil time:3];
//        return;
//    }
//    
//    // ExpDate must be in YYMM format
//    NSArray *cardDateComponents = [self.date.text componentsSeparatedByString:@"/"];
//    if ([cardDateComponents count] < 2) {
//        cardDateComponents = @[@"00", @"00"];
//    }
//    NSString *cardExpirationDateString = [NSString stringWithFormat:@"%@%@",cardDateComponents[1],cardDateComponents[0]];
//    
//    NSString *numberText = @"";
//    NSArray *numberCardComponents = [self.number.text componentsSeparatedByString:@" "];
//    for (NSString *part in numberCardComponents) {
//        numberText = [NSString stringWithFormat:@"%@%@", numberText, part];
//    }
    
    // create dictionary with parameters for send
//    NSMutableDictionary *paramsDictionary = [[NSMutableDictionary alloc] init];
//    
//    NSString *cryptogramPacket = [_apiService makeCardCryptogramPacket:numberText
//                                                            andExpDate:cardExpirationDateString
//                                                                andCVV:self.cvv.text
//                                                      andStorePublicID:_apiPublicID];
//    
//    [paramsDictionary setObject:cryptogramPacket forKey:@"CardCryptogramPacket"];
//    [paramsDictionary setObject:self.priceValue forKey:@"Amount"];
//    [paramsDictionary setObject:@"RUB" forKey:@"Currency"];
//    [paramsDictionary setObject:self.name.text forKey:@"Name"];
//    
//    NSString *apiURLString = @"https://api.cloudpayments.ru/payments/cards/charge";
//    
//    // setup AFHTTPSessionManager HTTP BasicAuth and serializers
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_apiPublicID password:_apiSecret];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    // implement success block
//    void (^successBlock)(NSURLSessionDataTask*, id) = ^(NSURLSessionDataTask *operation, id responseObject) {
//        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
//            BOOL isSuccess = [[responseObject objectForKey:@"Success"] boolValue];
//            if (isSuccess) {
//                [SVProgressHUD showSuccessWithStatus:@"Ok"];
//            } else {
//                NSDictionary *model = [responseObject objectForKey:@"Model"];
//                if (([responseObject objectForKey:@"Message"]) && ![[responseObject objectForKey:@"Message"] isKindOfClass:[NSNull class]]) {
//                    // some error
//                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"Message"]];
//                } else if (([model objectForKey:@"CardHolderMessage"]) && ![[model objectForKey:@"CardHolderMessage"] isKindOfClass:[NSNull class]]) {
//                    // some error from acquier
//                    [SVProgressHUD showErrorWithStatus:[model objectForKey:@"CardHolderMessage"]];
//                } else if (([model objectForKey:@"AcsUrl"]) && ![[model objectForKey:@"AcsUrl"] isKindOfClass:[NSNull class]]) {
//                    // need for 3DSecure request
//                    [self make3DSPaymentWithAcsURLString:(NSString *) [model objectForKey:@"AcsUrl"] andPaReqString:(NSString *) [model objectForKey:@"PaReq"] andTransactionIdString:[[model objectForKey:@"TransactionId"] stringValue]];
//                }
//            }
//        }
//    };
    
    // implement failure block
//    void (^failureBlock)(NSURLSessionDataTask*,NSError*) = ^(NSURLSessionDataTask *operation, NSError *error) {
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    };
//    
//    [SVProgressHUD showWithStatus:@"Отправка данных"];
//    [manager POST:apiURLString parameters:paramsDictionary progress:nil success:successBlock failure:failureBlock];
}

- (IBAction)useCouponAction:(UIButton *)sender {
    
    [self performSegueWithIdentifier:@"toTariff" sender:self];
}

//-(void) make3DSPaymentWithAcsURLString: (NSString *) acsUrlString andPaReqString: (NSString *) paReqString andTransactionIdString: (NSString *) transactionIdString {
//    
//    NSDictionary *postParameters = @{@"MD": transactionIdString, @"TermUrl": @"http://cloudpayments.ru/", @"PaReq": paReqString};
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST"
//                                                                                 URLString:acsUrlString
//                                                                                parameters:postParameters
//                                                                                     error:nil];
//    
//    [request setValue:@"ru;q=1, en;q=0.9" forHTTPHeaderField:@"Accept-Language"];
//    
//    NSHTTPURLResponse *response;
//    NSError *error;
//    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
//                                                 returningResponse:&response
//                                                             error:&error];
//    
//    
//    if ([response statusCode] == 200 || [response statusCode] == 201) {
//        [SVProgressHUD dismiss];
//        CGRect rect = self.view.frame;
//        rect.origin.y = 64;
//        rect.size.height -= 64;
//        UIWebView *webView = [[UIWebView alloc] initWithFrame:rect];
//        
//        webView.delegate = self;
//        [self.view addSubview:webView];
//
//        [webView loadData:responseData
//                 MIMEType:[response MIMEType]
//         textEncodingName:[response textEncodingName]
//                  baseURL:[response URL]];
//    } else {
//        NSString *messageString = [NSString stringWithFormat:@"Unable to load 3DS autorization page.\nStatus code: %d", (unsigned int)[response statusCode]];
//        [SVProgressHUD showErrorWithStatus:messageString];
//    }
//}
//
//-(void) complete3DSPaymentWithPaResString: (NSString *) paResString andTransactionIdString: (NSString *) transactionIdString {
//    
//    // create dictionary with parameters for send
//    NSMutableDictionary *paramsDictionary = [[NSMutableDictionary alloc] init];
//    
//    [paramsDictionary setObject:paResString forKey:@"PaRes"];
//    [paramsDictionary setObject:transactionIdString forKey:@"TransactionId"];
//    
//    NSString *apiURLString = @"https://api.cloudpayments.ru/payments/post3ds";
//    
//    // setup AFHTTPSessionManager HTTP BasicAuth and serializers
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    [manager.requestSerializer setAuthorizationHeaderFieldWithUsername:_apiPublicID password:_apiSecret];
//    
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//    
//    // implement success block
//    void (^successBlock)(NSURLSessionDataTask*, id) = ^(NSURLSessionDataTask *operation, id responseObject) {
//        if (responseObject && [responseObject isKindOfClass:[NSDictionary class]]) {
//            BOOL isSuccess = [[responseObject objectForKey:@"Success"] boolValue];
//            if (isSuccess) {
//                NSDictionary *model = [responseObject objectForKey:@"Model"];
//                if (([model objectForKey:@"CardHolderMessage"]) && ![[model objectForKey:@"CardHolderMessage"] isKindOfClass:[NSNull class]]) {
//                    // some error from acquier
//                    [SVProgressHUD showSuccessWithStatus:[model objectForKey:@"CardHolderMessage"]];
//                    NSLog(@"%@", [model objectForKey:@"CardHolderMessage"]);
//                    [self setTariffForUser];
//                } else {
//                    [SVProgressHUD showSuccessWithStatus:@"Ok"];
//                    [self setTariffForUser];
//                }
//            } else {
//                NSDictionary *model = [responseObject objectForKey:@"Model"];
//                if (([responseObject objectForKey:@"Message"]) && ![[responseObject objectForKey:@"Message"] isKindOfClass:[NSNull class]]) {
//                    // some error
//                    [SVProgressHUD showErrorWithStatus:[responseObject objectForKey:@"Message"]];
//                } else if (([model objectForKey:@"CardHolderMessage"]) && ![[model objectForKey:@"CardHolderMessage"] isKindOfClass:[NSNull class]]) {
//                    // some error from acquier
//                    [SVProgressHUD showErrorWithStatus:[model objectForKey:@"CardHolderMessage"]];
//                } else {
//                    [SVProgressHUD showErrorWithStatus:@"Some error"];
//                }
//            }
//        }
//    };
//    
//    // implement failure block
//    void (^failureBlock)(NSURLSessionDataTask*,NSError*) = ^(NSURLSessionDataTask *operation, NSError *error) {
//        [SVProgressHUD dismiss];
//        [SVProgressHUD showErrorWithStatus:error.localizedDescription];
//    };
//    
//    [SVProgressHUD showWithStatus:@"Отправка данных"];
//    
//    [manager POST:apiURLString parameters:paramsDictionary progress:nil success:successBlock failure: failureBlock];
//}
//
//#pragma mark - UITextFieldDelegate implementation
//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//    
//    if ([textField isEqual:self.cvv]) {
//        
//    }
//    
//    // check if card number valid
//    if ([textField isEqual:self.number]) {
//        NSString *cardNumberString = textField.text;
//        if ([CPService isCardNumberValid:cardNumberString]) {
//            [textField resignFirstResponder];
//            return YES;
//        } else {
//            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"Введите корректный номер карты" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//            [alertView show];
//            return NO;
//        }
//    }
//    
//    // check if valid length of expiration date
//    if ([textField isEqual:self.date]) {
//        NSString *cardExpirationDateString = textField.text;
//        if (cardExpirationDateString.length < 5) {
//            [SVProgressHUD showErrorWithStatus:@"Введите 4 цифры даты окончания действия карты в формате MM/YY"];
//            return NO;
//        }
//        
//        NSArray *dateComponents = [textField.text componentsSeparatedByString:@"/"];
//        if(dateComponents.count == 2) {
//            NSDate *date = [NSDate date];
//            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
//            NSDateComponents *components = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit) fromDate:date];
//            NSInteger currentMonth = [components month];
//            NSInteger currentYear = [[[NSString stringWithFormat:@"%ld",(long)[components year]] substringFromIndex:2] integerValue];
//            
//            if([dateComponents[1] intValue] < currentYear) {
//                [SVProgressHUD showErrorWithStatus:@"Карта недействительна."];
//                [textField becomeFirstResponder];
//                return NO;
//            }
//            
//            if (([dateComponents[0] intValue] > 12)) {
//                [SVProgressHUD showErrorWithStatus:@"Карта недействительна."];
//                [textField becomeFirstResponder];
//                return NO;
//            }
//            
//            if([dateComponents[0] integerValue] < currentMonth && [dateComponents[1] intValue] <= currentYear) {
//                [SVProgressHUD showErrorWithStatus:@"Карта недействительна."];
//                [textField becomeFirstResponder];
//                return NO;
//            }
//        }
//        
//        [textField resignFirstResponder];
//        return YES;
//    }
//    
//    [textField resignFirstResponder];
//    return YES;
//}
//
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    
//    if ([textField isEqual:self.date]) {
//        
//        // handle backspace
//        if (range.length > 0 && [string length] == 0) {
//            return YES;
//        }
//        
//        if (textField.text.length >= 5) {
//            return NO;
//        }
//        
//        if (textField.text.length == 2) {
//            textField.text = [textField.text stringByAppendingString:[NSString stringWithFormat:@"/"]];
//        }
//        
//        return YES;
//    } else if ([textField isEqual:self.number]) {
//        
//        // Only the 16 digits + 3 spaces
//        if (range.location == 19) {
//            return NO;
//        }
//        
//        if ([textField.text length] == 19) {
//            if ([string length] == 0) {
//                return YES;
//            } else {
//                return NO;
//            }
//        }
//        
//        // Backspace
//        if ([string length] == 0)
//            return YES;
//        
//        if ((range.location == 4) || (range.location == 9) || (range.location == 14))
//        {
//            NSString *str = [NSString stringWithFormat:@"%@ ", textField.text];
//            textField.text = str;
//        }
//    } else if ([textField isEqual:self.cvv]) {
//        if (range.location > 2){
//            return NO;
//        }
//    }
//    
//    return YES;
//}

#pragma mark - UIWebViewDelegate implementation
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"%@", request.URL);
    
    CGRect rect = webView.frame;
    rect.origin.y = 0;
    rect.size.height += 64;
    webView.frame = rect;
    [self.view endEditing:YES];
    NSString *urlString = [request.URL absoluteString];
    if ([urlString isEqualToString:@"http://cloudpayments.ru/"]) {
        NSString *response = [[NSString alloc] initWithData:request.HTTPBody encoding:NSASCIIStringEncoding];
        
        
        NSDictionary *responseDictionary = [self parseQueryString:response];
        [webView removeFromSuperview];
        self.view.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
        
//        [self complete3DSPaymentWithPaResString:[responseDictionary objectForKey:@"PaRes"] andTransactionIdString:[responseDictionary objectForKey:@"MD"]];
        return NO;
    }
    
    return YES;
}


//-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {}

#pragma mark - Utilities
- (NSDictionary *)parseQueryString:(NSString *)query {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:6];
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    
    for (NSString *pair in pairs) {
        NSArray *elements = [pair componentsSeparatedByString:@"="];
        NSString *key = [[elements objectAtIndex:0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *val = [[elements objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [dict setObject:val forKey:key];
    }
    return dict;
}

- (NSString*)formattedStringWithPrice:(NSString*)price {
    
    price = [price substringToIndex:price.length - 2];
    
    NSInteger lenghtString = [price length];
    NSMutableString *resultString = [NSMutableString stringWithString:@""];
    NSInteger counter = lenghtString;
    for (int i = 0; i < lenghtString; i++) {
        char ch = [price characterAtIndex:i];
        if (counter % 3 == 0 && lenghtString != counter) {
            [resultString appendString:@" "];
        }
        [resultString appendString:[NSString stringWithFormat:@"%c", ch]];
        counter--;
    }
    [resultString appendString:@" ₽"];
    return resultString;
}

- (BOOL)validateFields {
    if ([self.number.text length] == 0 || [self.cvv.text length] == 0 || [self.number.text length] == 0 || [self.name.text length] == 0) {
        return NO;
    }
    
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"[A-Z]" options:0 error:NULL];
    
    NSUInteger matches = [regex numberOfMatchesInString:self.name.text options:0 range:NSMakeRange(0, [self.name.text length])];
    
//    if (matches != [self.name.text length]) {
//        return NO;
//    }
    
    regex = [[NSRegularExpression alloc] initWithPattern:@"[^(0[1-9]|1[0-2])\/(20[0-9]{2})$]" options:0 error:NULL];
    
    
    return YES;
}


- (void)setTariffForUser {
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *tariffID = [self.tariff valueForKey:@"id"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"user"]];
    NSNumber *userID = user.id;
    NSDictionary *body = @{@"user_id":userID, @"tariff_id":tariffID};
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    Server *server = [[Server alloc] init];
    ServerRequest *request = [ServerRequest initRequest:ServerRequestTypePOST With:body To:SetTariffURLStrring];
    [server sentToServer:request OnSuccess:^(NSDictionary *result) {
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"y-M-d H:m:s";
        NSDateComponents *monthComponent = [[NSDateComponents alloc] init];
        NSCalendar *theCalendar = [NSCalendar currentCalendar];
        NSDate *beginDate = [formatter dateFromString:result[@"tariff"][0][@"create_date"]];
        
        if ([result[@"tariff"][0][@"counter"] isEqualToString:@"-1"]) {
            monthComponent.month = 1;
            [ud setObject:@"∞ ЧАШЕК  " forKey:@"currentCounter"];
            user.counter = @-1;
        } else if (result[@"tariff"][0][@"counter"]) {
            monthComponent.month = 3;
            NSInteger cups = ((NSString*)result[@"tariff"][0][@"counter"]).intValue;
            user.counter = [NSNumber numberWithInteger:cups];
            NSString *text;
            if (cups == 1) {
                text = @"ЧАШКА";
            } else if (cups == 2 || cups == 3 || cups == 4) {
                text = @"ЧАШКИ";
            } else {
                text = @"ЧАШЕК";
            }
            [ud setObject:[NSString stringWithFormat:@"%ld %@  ", (long)cups, text] forKey:@"currentCounter"];
        }
        NSDate *endDate = [theCalendar dateByAddingComponents:monthComponent toDate:beginDate options:0];
        NSMutableDictionary *mutDict = [[NSMutableDictionary alloc] initWithDictionary:result[@"tariff"][0]];
        [mutDict setObject:endDate forKey:@"endDate"];
        user.plan = mutDict;
        NSData *userData = [NSKeyedArchiver archivedDataWithRootObject:user];
        [ud setObject:userData forKey:@"user"];
        
        if ([[self.tariff valueForKey:@"type"] isEqualToString:@"advanced"]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showSuccess:@"Успешно" subTitle:@"Вы подключили тариф 'Расширенный'" closeButtonTitle:@"Ок" duration:5.0];
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
            [self presentViewController:vc animated:true completion:nil];
        } else if ([[self.tariff valueForKey:@"type"] isEqualToString:@"standart"]){
            [alert showSuccess:@"Успешно" subTitle:@"Вы подключили тариф 'Базовый'" closeButtonTitle:@"Ок" duration:5.0];
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
            [self presentViewController:vc animated:true completion:nil];
        }
    } OrFailure:^(NSError *error) {
        [alert showSuccess:@"Ошибка" subTitle:@"Не удалось выполнить подключение" closeButtonTitle:@"Ок" duration:5.0];
        NSLog(@"%@", [error debugDescription]);
    }];
}

#pragma mark - Private methods

- (void)startPayment {             
    
    NSString *paymentId = [NSString stringWithFormat:@"SDK_iOS_%@", [[NSUUID UUID] UUIDString]];
    PLRPayment *payment = [[PLRPayment alloc] initWithId:paymentId amount:[self.priceValue intValue] status:nil product:@"" total:1.f];

    NSURL *callbackURL = [NSURL URLWithString:[@"http://api.cupster.ru/check?order_id=" stringByAppendingString:paymentId]];
            
    self.sessionInfo = [[PLRSessionInfo alloc] initWithPaymentInfo:payment callbackURL:callbackURL sessionType:self.sessionType];
    self.client = [PaylerAPIClient testClientWithMerchantKey:@"b0fdeec9-7b5a-4b7d-bfa0-e3fb79ddb954" password:@"prbmBXvkSL"];
    
    [self.webView payWithCompletion:^(PLRPayment *payment, NSError *error) {
        if (!error) {
            [self setTariffForUser];
            if (self.sessionType == PLRSessionTypeTwoStep) {
//                self.textLabel.text = @"Средства успешно заблокированы";
            }
            self.webView.hidden = YES;
        }
    }];
}



@end