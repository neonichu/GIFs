//
//  ORGIFController.m
//  GIFs
//
//  Created by Boris Bügling on 16/05/14.
//  Copyright (c) 2014 Team GIFs. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <MDCSwipeToChoose/MDCSwipeToChoose.h>

#import "GIF.h"
#import "ORGIFController.h"

@interface ORGIFController () <MDCSwipeToChooseDelegate>

@property (nonatomic) MDCSwipeToChooseView* chooseView;
@property (nonatomic) NSInteger currentIndex;

@property (nonatomic) UIImageView* otherImageView;
@property (nonatomic) UIImageView* yetAnotherView;

@end

#pragma mark -

@implementation ORGIFController

-(void)gotNewGIFs {
    [self setupChooseView];
    
    /*
     - (NSInteger)numberOfGifs;
     - (GIF *)gifAtIndex:(NSInteger)index;
     */
    
    self.currentIndex = 0;
    
    NSLog(@"Got soem GIFs, bro - %d of them actually!", [self.source numberOfGifs]);
    
    [self refresh];
}

-(void)refresh {
    if ([self.source numberOfGifs] == 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"No GIFs found :(" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    GIF* gif = [self.source gifAtIndex:self.currentIndex];
    
    UIActivityIndicatorView* activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 44.0) / 2, (self.view.frame.size.height - 44.0) / 2, 44.0, 44.0)];
    [self.chooseView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    
    NSURLRequest* req = [NSURLRequest requestWithURL:gif.downloadURL];
    [NSURLConnection sendAsynchronousRequest:req
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data,
                                               NSError *connectionError) {
                               UIImage* image = [UIImage imageWithData:data];
                               self.chooseView.imageView.image = image;
                               self.otherImageView.image = image;
                               self.yetAnotherView.image = image;
                               
                               [activityIndicator removeFromSuperview];
                           }];
}

-(void)setupChooseView {
    MDCSwipeToChooseViewOptions *options = [MDCSwipeToChooseViewOptions new];
    options.delegate = self;
    options.likedColor = [UIColor blueColor];
    
    self.chooseView = [[MDCSwipeToChooseView alloc] initWithFrame:self.view.bounds
                                                          options:options];
    self.chooseView.imageView.backgroundColor = [UIColor cyanColor];
    [self.view insertSubview:self.chooseView atIndex:0];
    
    self.otherImageView = [[UIImageView alloc] initWithFrame:self.chooseView.likedView.bounds];
    [self.chooseView.likedView addSubview:self.otherImageView];
    self.yetAnotherView = [[UIImageView alloc] initWithFrame:self.chooseView.nopeView.bounds];
    [self.chooseView.nopeView addSubview:self.yetAnotherView];
    
    self.chooseView.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.otherImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.yetAnotherView.contentMode = UIViewContentModeScaleAspectFit;
}

#pragma mark - MDCSwipeToChooseDelegate

-(void)view:(UIView *)view wasChosenWithDirection:(MDCSwipeDirection)direction {
    switch (direction) {
        case MDCSwipeDirectionLeft:
            self.currentIndex--;
            if (self.currentIndex < 0) {
                self.currentIndex = [self.source numberOfGifs] - 1;
            }
            break;
        case MDCSwipeDirectionRight:
            self.currentIndex++;
            if (self.currentIndex >= [self.source numberOfGifs]) {
                self.currentIndex = 0;
            }
            break;
        default:
            break;
    }
    
    [self setupChooseView];
    
    [self refresh];
}

@end
