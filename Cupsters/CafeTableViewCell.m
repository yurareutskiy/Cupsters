//
//  CafeTableViewCell.m
//  Cupsters
//
//  Created by Anton Scherbakov on 17/01/16.
//  Copyright © 2016 Styleru. All rights reserved.
//

#import "CafeTableViewCell.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@interface CafeTableViewCell ()

//@property (strong, nonatomic) NSArray *source;

@end

@implementation CafeTableViewCell {
    NSUserDefaults *userDefaults;
    
}
@synthesize delegate;

- (void)awakeFromNib {
    
    
    // Initialization code
}

- (void)loadDataInCell {
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Coffees" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    
    //    NSString *url;
    //    NSString *drinkName = _coffeeName.text;
    //    if ([_coffeeName.text isEqualToString:@"Латте"]) {
    //        url = @"/img/icons/latte";
    //    } else if ([_coffeeName.text isEqualToString:@"Чай"]) {
    //        url = @"/img/icons/tea";
    //    } else if ([_coffeeName.text isEqualToString:@"Капучино"]) {
    //        url = @"/img/icons/cappuchino";
    //    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_cafe = %@ ", [userDefaults objectForKey:@"id"]];
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id_cafe = %@", [userDefaults objectForKey:@"id"]];
    [fetchRequest setPredicate:predicate];
    fetchRequest.propertiesToFetch = @[[[entity propertiesByName] objectForKey:@"volume"], [[entity propertiesByName] objectForKey:@"name"]];
    //    fetchRequest.returnsDistinctResults = YES;
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"volume" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    NSError *error = nil;
    NSArray *fetchedResults = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *coffeeNameWithVolumes = [[NSMutableArray alloc] init];
    NSLog(@"%@", self.coffeeName.text);
    for (NSManagedObject *object in fetchedResults) {
        NSString *name = [object valueForKey:@"name"];
        if ([name isEqualToString:self.coffeeName.text]) {
            [coffeeNameWithVolumes addObject:object];
        }
    }
    self.source = coffeeNameWithVolumes;
    
    
    NSAssert(_source != nil, @"Failed to execute %@: %@", fetchRequest, error);
    
    
    _volumeNum = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < _source.count; i++) {
        [_volumeNum addObject:_source[i][@"volume"]];
    }
    
    userDefaults = [NSUserDefaults standardUserDefaults];
    _index = 0;
    if (_volumeNum.count != 0){
        [_volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index]]];
    }
    
    if (self.volumeNum.count == 1) {
        self.plus.enabled = NO;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)plusBtn:(UIButton *)sender{
    
    if ((_index >= 0) && (_index + 2) < _volumeNum.count){
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index + 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];

        [userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index + 1]]
            forKey:@"volume"];
        
        _index++;
    } else if (_index + 2 == _volumeNum.count){
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index + 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusGrey"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index + 1]] forKey:@"volume"];
        
        _index++;
    }
}

- (IBAction)minusBtn:(UIButton *)sender{
    if (_index == 1) {
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index - 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusGrey"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index - 1]] forKey:@"volume"];
        
        _index--;
    } else if ((_index > 1) && (_index + 1) <= _volumeNum.count) {
        [self.volume setText:[NSString stringWithFormat:@"%@ мл", _volumeNum[_index - 1]]];
        [self.plus setImage:[UIImage imageNamed:@"plusBrown"] forState:UIControlStateNormal];
        [self.minus setImage:[UIImage imageNamed:@"minusBrown"] forState:UIControlStateNormal];
        
        [userDefaults setObject:[NSString stringWithFormat:@"%@", _volumeNum[_index - 1]] forKey:@"volume"];
        
        _index--;
    }
}

- (IBAction)orderBtn:(UIButton*)sender {
    
//    [_source setValue:[NSString stringWithFormat:@"%@", _volumeNum[_index]] forKey:@"volume"];
//    [_source setValue:self.coffeeName.text forKey:@"coffee"];
//    [_source setValue:[userDefaults objectForKey:@"id"] forKey:@"id"];
    
    [self.delegate makeOrder:self];
}

//- (void) makeOrder {
//    
////    [userDefaults setObject:[NSString stringWithFormat:@"%@", volumeNum[index]] forKey:@"volume"];
////    [userDefaults setObject:self.coffeeName.text forKey:@"coffee"];
////    
////    NSLog(@"hey!");
////    NSLog(@"%@", self.coffeeName.text);
////    NSLog(@"%@", [userDefaults objectForKey:@"coffee"]);
//    
//    
//}

@end
