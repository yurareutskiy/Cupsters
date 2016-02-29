//
//  SingleTariffViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 18/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "SingleTariffViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "User.h"
#import "Server.h"
#import <SCLAlertView.h>
#import "PaymentViewController.h"

@interface SingleTariffViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;
@property (strong, nonatomic) NSArray *source;
@property (strong, nonatomic) NSString *priceValue;

@end

@implementation SingleTariffViewController {

    int currentValue;
    NSManagedObject *tariff;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    self.upView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.upView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.upView.layer.shadowRadius = 1.0f;
    self.upView.layer.shadowOpacity = 0.5f;
    [self.upView.layer setMasksToBounds:NO];
    
    self.amount.font = [UIFont fontWithName:@"MyriadPro-Regular" size:42];

    if ([self.type isEqualToString:@"standart"]) {
        self.tariffName.text = @"Любитель";
    } else {
        self.tariffName.text = @"Кофеман";
    }
    self.tariffType.text = @"Тариф";
    
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tariffs" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", self.type];
    [fetchRequest setPredicate:predicate];
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"price"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@", [error debugDescription]);
    }
    self.source = fetchedObjects;
    [self.slider setMaximumValue:[self.source count]];
    self.slider.value = self.slider.maximumValue / 2;
    [self sliderValue:self.slider];
    currentValue = (int)self.slider.value;
    [self configureData];
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
//    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow"]
//                                                       style:UIBarButtonItemStyleDone
//                                                      target:self
//                                                      action:@selector(toList:)];
    
    self.menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"arrow"] style:UIBarButtonItemStyleDone target:self action:@selector(backAction:)];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.navigationController.navigationBar.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    self.navigationController.navigationBar.layer.shadowRadius = 1.0f;
    self.navigationController.navigationBar.layer.shadowOpacity = 0.5f;
    
    self.navigationItem.leftBarButtonItem = self.menuButton;
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sliderValue:(UISlider *)sender {
        
    if (((int)sender.value) != currentValue && sender.value != sender.maximumValue) {
        currentValue = ((int)sender.value);
        [self configureData];
    }
}

- (void)configureData {
    tariff = self.source[currentValue];
    NSNumber *count = [tariff valueForKey:@"counter"];
    NSNumber *price = [tariff valueForKey:@"price"];
    self.priceValue = price;
    [self.price setText:[self formattedStringWithPrice:price.stringValue]];
    [self.amount setText:[NSString stringWithFormat:@"%@", [count stringValue]]];
    int avr = [price intValue] / [count intValue];
    [self.avgPrice setText:[NSString stringWithFormat:@"%d", avr]];
    if (count.intValue < 0) {
        [self.time setText:@"Действует 1 месяц"];
        [self.amount setText:@"∞"];
        self.avgPrice.text = @"120";
    } else {
        [self.time setText:@"Действует 3 месяца"];
    }
    [self.cups setText:@"чашек"];
}

- (NSString*)formattedStringWithPrice:(NSString*)price {

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

- (void)setTariffForUser {

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *tariffID = [tariff valueForKey:@"id"];
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

        if ([self.type isEqualToString:@"advanced"]) {
            SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
            [alert showSuccess:@"Успешно" subTitle:@"Вы подключили тариф 'Расширенный'" closeButtonTitle:@"Ок" duration:5.0];
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
            [self presentViewController:vc animated:true completion:nil];
        } else if ([self.type isEqualToString:@"standart"]){
            [alert showSuccess:@"Успешно" subTitle:@"Вы подключили тариф 'Базовый'" closeButtonTitle:@"Ок" duration:5.0];
            UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:cSBMenu];
            [self presentViewController:vc animated:true completion:nil];
        }
    } OrFailure:^(NSError *error) {
        [alert showSuccess:@"Ошибка" subTitle:@"Не удалось выполнить подключение" closeButtonTitle:@"Ок" duration:5.0];
        NSLog(@"%@", [error debugDescription]);
    }];
}


- (IBAction)connect:(UIButton *)sender {
    //[self setTariffForUser];
    [self performSegueWithIdentifier:@"toPay" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toPay"]) {
        PaymentViewController *vc = segue.destinationViewController;
        vc.priceValue = self.priceValue;
    }
}



@end
