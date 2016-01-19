//
//  CafeViewController.m
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "CafeViewController.h"
#import "Constants.h"
#import "UIColor+HEX.h"
#import "MenuRevealViewController.h"
#import "SWRevealViewController.h"
#import "CafeTableViewCell.h"

@interface CafeViewController ()

@property (strong, nonatomic) MenuRevealViewController *menu;
@property (strong, nonatomic) UIBarButtonItem *menuButton;
@property (strong, nonatomic) SWRevealViewController *reveal;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) HMSegmentedControl *segmentedControl;

@end

@implementation CafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self customNavBar];
    [self preferredStatusBarStyle];
    [self configureMenu];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
                                                      action:@selector(backAction:)];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
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
    attachment.image = [UIImage imageNamed:@"cup"];
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

#pragma mark - Table View

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:false];
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    NSLog(@"Select row at index %@", indexPath);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if(section == 0) {
        
        UIView *viewHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40.0)];
        [viewHeader setBackgroundColor:[UIColor clearColor]];
        
        _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(-0.5, -0.5, viewHeader.frame.size.width + 1.0, 40.0 + 0.5)];
        _segmentedControl.sectionTitles = @[@"Кофе", @"Чай",@"Другое"];
        _segmentedControl.selectedSegmentIndex = 1;
        _segmentedControl.backgroundColor = [UIColor whiteColor];
        _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor grayColor]};
        _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1]};
        _segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0];
        _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
        _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationUp;
        _segmentedControl.tag = 3;
        _segmentedControl.layer.borderColor = [UIColor colorWithRed:175.0/255.0 green:138.0/255.0 blue:93.0/255.0 alpha:1.0].CGColor;
        _segmentedControl.layer.borderWidth = 0.5f;
        
        [viewHeader addSubview:_segmentedControl];
        
        return viewHeader;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Tying up the segmented control to a scroll view



//__weak typeof(self) weakSelf = self;
//[self._segmentedControl4 setIndexChangeBlock:^(NSInteger index) {
//    [weakSelf.scrollView scrollRectToVisible:CGRectMake(viewWidth * index, 0, viewWidth, 200) animated:YES];
//}];

//self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 310, viewWidth, 210)];
//self.scrollView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:1];
//self.scrollView.pagingEnabled = YES;
//self.scrollView.showsHorizontalScrollIndicator = NO;
//self.scrollView.contentSize = CGSizeMake(viewWidth * 3, 200);
//self.scrollView.delegate = self;
//[self.scrollView scrollRectToVisible:CGRectMake(viewWidth, 0, viewWidth, 200) animated:NO];
//[self.view addSubview:self.scrollView];

//UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 210)];
//[self setApperanceForLabel:label1];
//label1.text = @"Worldwide";
//[self.scrollView addSubview:label1];
//
//UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth, 0, viewWidth, 210)];
//[self setApperanceForLabel:label2];
//label2.text = @"Local";
//[self.scrollView addSubview:label2];
//
//UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(viewWidth * 2, 0, viewWidth, 210)];
//[self setApperanceForLabel:label3];
//label3.text = @"Headlines";
//[self.scrollView addSubview:label3];


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CafeTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CafeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cafeCell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.makeButton addTarget:self action:@selector(makeOrder:) forControlEvents:UIControlEventTouchUpInside];
    [cell.coffeeName setText:@"lol"];
    NSLog(@"i'm here");
    
    return cell; //[self configurePlace:cell At:indexPath.row];
}

-(CafeTableViewCell*)configurePlace:(CafeTableViewCell*)cell At:(NSInteger)row {
    

    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y<=0) {
        scrollView.contentOffset = CGPointZero;
    }
}

- (void)makeOrder:(UIButton*)sender{
    [self performSegueWithIdentifier:@"makeOrder" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//- (IBAction)makeAnOrder:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"makeOrder" sender:self];
//}
@end
