//
//  GIFSearchViewController.m
//  GIFs
//
//  Created by Boris Bügling on 16/05/14.
//  Copyright (c) 2014 Team GIFs. All rights reserved.
//

#import "GIFSearchViewController.h"
#import "ORGIFController.h"
#import "ORSearchController.h"

@interface GIFSearchViewController () <UITextViewDelegate>

@property (nonatomic) ORSearchController* searchController;
@property (nonatomic) UITextView* textView;

@end

#pragma mark -

@implementation GIFSearchViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.textView becomeFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    self.textView.delegate = self;
    self.textView.font = [UIFont boldSystemFontOfSize:20.0];
    [self.view addSubview:self.textView];
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"Return pressed");
        
        ORGIFController* gifController = [ORGIFController new];
        
        self.searchController = [ORSearchController new];
        [self.searchController setSearchQuery:textView.text];
        self.searchController.gifViewController = gifController;
        
        gifController.source = self.searchController;
        [self.searchController getNextGIFs];
        
        [self.navigationController pushViewController:gifController
                                             animated:YES];
    } else {
        NSLog(@"Other pressed");
    }
    return YES;
}

@end
