//
//  DUTRegistrationTableViewController.m
//  Dutch
//
//  Created by rajmohan lokanath on 3/30/13.
//  Copyright (c) 2013 Dutch Inc. All rights reserved.
//

#import "DUTRegistrationViewController.h"

#import "DUTUtility+Validation.h"
#import "DUTServerOperations.h"
#import "DUTEditableCellController.h"
#import "DUTEmailValidator.h"
#import "DUTTextLengthValidator.h"


@interface DUTRegistrationViewController ()


@property(nonatomic,strong,readwrite) DUTEditableCellController *userName;
@property(nonatomic,strong,readwrite) DUTEditableCellController *name;
@property(nonatomic,strong,readwrite) DUTEditableCellController *pwd;
@property(nonatomic,strong,readwrite) DUTEditableCellController *pwd_confirmation;
@property(nonatomic,strong,readwrite) IBOutlet UINavigationBar *navigationBar;
@property(nonatomic,strong,readwrite) IBOutlet UIBarButtonItem *applyButton;
@property(nonatomic,strong,readwrite) DUTGroupedCellControllerContainer *controllerContainer;


@end


@implementation DUTRegistrationViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self setupSections];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

// *************************************************************************************************
#pragma mark -
#pragma mark Actions


- (NSString *)stringWithUUID {
    CFUUIDRef uuidObj = CFUUIDCreate(nil);//create a new UUID
    NSString *uuid = (__bridge_transfer NSString *)(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuid;
}


- (IBAction)done:(id)sender {
     NSDictionary *registrationInfoDictionary =
    @{@"user" : @{@"email":self.userName.text, @"name":self.name.text, @"password":self.pwd.text,
                  @"password_confirmation":self.pwd_confirmation.text}};
    [DUTServerOperations registerUserWithInformation:registrationInfoDictionary
                                        successBlock:^(id object) {
                                            NSLog(@"Response:%@",object);
                                        } failureBlock:^(id object) {
                                            NSLog(@"Failure:%@",object);
                                        }];
}


- (IBAction)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)setupSections {

    self.controllerContainer =[DUTGroupedCellControllerContainer containerForViewController:self frame:CGRectZero];
    self.controllerContainer.delegate = self;
    self.controllerContainer.table.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationBar.translatesAutoresizingMaskIntoConstraints = NO;
    [self.controllerContainer assignSectionWithTitle:@"Info" index:0];
    self.userName =
        [DUTEditableCellController cellControllerWithText:@""
                                              placeHolder:@"User email" ];
    [self.userName addValidator:[[DUTEmailValidator alloc]init]];
    self.userName.descriptiveFormat = @"User email is %@";
    [self.controllerContainer addCellController:self.userName section:0];
    
    self.name =
        [DUTEditableCellController cellControllerWithText:@""
                                              placeHolder:@"Name" ];
    self.name.descriptiveFormat = @"User name is %@";
    [self.controllerContainer addCellController:self.name section:0];
    
    DUTTextLengthValidator *lengthValidator = [DUTTextLengthValidator validatorWithMinLenth:2 maxLength:10];
    [self.name addValidator:lengthValidator];
    
    self.pwd =
        [DUTEditableCellController cellControllerWithText:@""
                                              placeHolder:@"Password" ];
    self.pwd.mask = YES;
    [self.controllerContainer addCellController:self.pwd section:0];
    
    self.pwd_confirmation =
        [DUTEditableCellController cellControllerWithText:@""
                                              placeHolder:@"Password Confirmation" ];
    self.pwd_confirmation.mask = YES;
    [self.controllerContainer addCellController:self.pwd_confirmation section:0];
    
    // Autolayout
    
    {
        id constraint = [NSLayoutConstraint constraintWithItem:self.controllerContainer.table attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.navigationBar attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.view addConstraint:constraint];
    }
    {
        id constraint = [NSLayoutConstraint constraintWithItem:self.controllerContainer.table attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
        [self.view addConstraint:constraint];
    }
    {
        id constraint = [NSLayoutConstraint constraintWithItem:self.controllerContainer.table attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
        [self.view addConstraint:constraint];
    }
    {
        id constraint = [NSLayoutConstraint constraintWithItem:self.controllerContainer.table attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
        [self.view addConstraint:constraint];
    }
    [self.controllerContainer reloadData];
}

- (UITableView *)table {
    return self.controllerContainer.table;
}

#pragma mark - 
#pragma DUTCellContainerDelegate

- (void)cellContainer:(DUTGroupedCellControllerContainer *)cellContainer dataValidity:(BOOL)valid {
    self.navigationBar.topItem.rightBarButtonItem = valid ? self.applyButton:nil;
}

@end