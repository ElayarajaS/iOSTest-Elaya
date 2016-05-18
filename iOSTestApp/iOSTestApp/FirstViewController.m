//
//  FirstViewController.m
//  iOSTestApp
//
//  Created by ODC-MAC3 on 15/02/16.
//  Copyright © 2016 inteliment. All rights reserved.
//

#import "FirstViewController.h"
#import "FirstCustomTableViewCell.h"
#import "SecondCustomTableViewCell.h"
#import "ProfileViewController.h"
#import "CollectionViewController.h"
#import "Constants.h"

@interface FirstViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL isDatePickerVisible;
    NSDateFormatter *dateFormatter;
}
@property (nonatomic, strong) IBOutlet UITableView *mainTableView;
@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) IBOutlet UIView *pickerContainerView;


@end

NSInteger const kRowCount = 5;
NSInteger const kFirstCustomCellRowHeight = 62;
NSInteger const kSecondCustomCellRowHeight = 85;

@implementation FirstViewController

#pragma mark - View Life Cycle Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    isDatePickerVisible = NO;
    [self.pickerView addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventValueChanged];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - UITableView DataSource/Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return kRowCount;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return  kSecondCustomCellRowHeight;
    } else {
        return kFirstCustomCellRowHeight;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        
        static NSString *cellIdentifier = @"cellTwo";
        SecondCustomTableViewCell *cell = (SecondCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[SecondCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        return cell;
        
    } else {
        static NSString *cellIdentifier = @"cellOne";
        FirstCustomTableViewCell *cell = (FirstCustomTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[FirstCustomTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        
        [self prepareCell:cell ForIndex:indexPath.row];
        return cell;
    }
    
    return nil;
}

-(void)prepareCell:(FirstCustomTableViewCell *)cell ForIndex:(NSInteger)index {
    
    cell.cellTitleTextField.hidden = NO;
    cell.bulbImageView.hidden = YES;
    cell.cellTitleTextField.userInteractionEnabled = NO;

    switch (index) {
        case 0:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.cellTitleTextField.borderStyle = UITextBorderStyleNone;
            cell.cellTitleTextField.text = @"Navigate to CollectionView";
            
            break;
        case 1:
            cell.accessoryType = UITableViewCellAccessoryDetailButton;
            cell.cellTitleTextField.borderStyle = UITextBorderStyleNone;
            cell.cellTitleTextField.text = @"Present Modal View";
            
            
            break;
        case 2:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.cellTitleTextField.hidden = YES;
            cell.bulbImageView.hidden = NO;
            
            UISwitch *onOffSwitch = [[UISwitch alloc] init];
            [onOffSwitch setOn:YES];
            [cell addSubview:onOffSwitch];
            cell.accessoryView = onOffSwitch;
            [onOffSwitch addTarget:self action:@selector(switchStateChanged:) forControlEvents:UIControlEventValueChanged];
        }
            break;
        case 3:
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.cellTitleTextField.borderStyle = UITextBorderStyleLine;
            cell.cellTitleTextField.textAlignment = NSTextAlignmentCenter;
            cell.cellTitleTextField.placeholder = @"Tap Calendar to insert date";
            
            UIButton *calendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [calendarButton setFrame:kCalendarButtonFrame];
            [calendarButton setImage:[UIImage imageNamed:@"calendar-icon"] forState:UIControlStateNormal];
            [calendarButton setImage:[UIImage imageNamed:@"calendar-icon"] forState:UIControlStateHighlighted];
            [cell addSubview:calendarButton];
            cell.accessoryView = calendarButton;
            [calendarButton addTarget:self action:@selector(showDatePickerView:) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        CollectionViewController *collectionViewController = [storyboard instantiateViewControllerWithIdentifier:@"collectionVCID"];
        [self.navigationController pushViewController:collectionViewController animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
        {
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
            ProfileViewController *profileViewController = [storyboard instantiateViewControllerWithIdentifier:@"ProfileView"];
            profileViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
            [self.navigationController presentViewController:profileViewController animated:YES completion:nil];
        }
            break;
        default:
            break;
    }
}

#pragma mark - Button Actions

- (void)switchStateChanged:(UISwitch *)sender {
    FirstCustomTableViewCell *cell = (FirstCustomTableViewCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (![sender isOn]) {
        [sender setOn:NO animated:YES];
        [cell.bulbImageView setImage:[UIImage imageNamed:@"bulbOFF"]];
    } else {
        [sender setOn:YES animated:YES];
        [cell.bulbImageView setImage:[UIImage imageNamed:@"bulbON"]];
    }
    cell = nil;
}

- (void)showDatePickerView:(UIButton *)sender {
    if (isDatePickerVisible == NO) {
        isDatePickerVisible = YES;
        [self.view addSubview:self.pickerContainerView];
        [self.pickerContainerView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.pickerContainerView.frame.size.width, self.pickerContainerView.frame.size.height)];
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.pickerContainerView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height-self.pickerContainerView.frame.size.height, self.pickerContainerView.frame.size.width, self.pickerContainerView.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             
                         }];
        
    } else {
        isDatePickerVisible = NO;
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.pickerContainerView setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.size.height, self.pickerContainerView.frame.size.width, self.pickerContainerView.frame.size.height)];
                         }
                         completion:^(BOOL finished) {
                             [self.pickerContainerView removeFromSuperview];
                         }];
    }
}

- (void)chooseDate:(UIDatePicker *)picker {
    FirstCustomTableViewCell *cell = (FirstCustomTableViewCell *)[self.mainTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];

    cell.cellTitleTextField.text = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:picker.date]];
}

- (IBAction)doneAction:(id)sender {
    [self showDatePickerView:sender];
}

@end
