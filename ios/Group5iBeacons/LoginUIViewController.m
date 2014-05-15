//
//  LoginUIViewController.m
//  FBLoginUIControlSample
//
//  Created by John Tubert.
//  Copyright (c) 2014 FAll rights reserved.
//

#import "LoginUIViewController.h"

#import "MainViewController.h"

@interface LoginUIViewController ()

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UITextField *message;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@property (weak, nonatomic) id<FBGraphUser> currentUser;

@end

@implementation LoginUIViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    // Custom initialization
    
    // Create a FBLoginView to log the user in with basic, email and likes permissions
    // You should ALWAYS ask for basic permissions (basic_info) when logging the user in
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_likes"]];
    
    // Set this loginUIViewController to be the loginView button's delegate
    loginView.delegate = self;
    
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame,
                                   (self.view.center.x - (loginView.frame.size.width / 2)),
                                   105);
    
    // Align the button in the center vertically
    //loginView.center = self.view.center;
    
    // Add the button to the view
    [self.view addSubview:loginView];
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(handleLongPressGesture:)];
    longPressGestureRecognizer.minimumPressDuration = 3.0;
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer*)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        MainViewController *mainViewController = [[MainViewController alloc] init];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        [self presentViewController:navigationController
                           animated:YES
                         completion:nil];
    }
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    
    self.currentUser = (id<FBGraphUser>)user;
    
    [[NSUserDefaults standardUserDefaults] setValue:[user objectForKey:@"id"]
                                             forKey:@"facebookId"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSLog(@"loginViewFetchedUserInfo %@ / %@", user.id, [user name]);
    
    self.profilePictureView.profileID = user.id;
    self.nameLabel.text = user.name;
    
    UNIUrlConnection* asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"http://fast-taiga-2263.herokuapp.com/users"];
        [request setUsername:@"admin"];
        [request setPassword:@"admin"];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        UNIJsonNode* body = [response body];
        NSArray* arr = [body JSONArray];
        
        BOOL exsist = NO;
        
        for (int i=0; i< arr.count; i++) {
            NSDictionary* dic = arr[i];
            if([[dic objectForKey:@"facebookId"] isEqualToString:user.id]){
                exsist = YES;
                break;
            }
        }
        
        if(!exsist){
            NSDictionary* headers = @{@"accept": @"application/json"};
            NSDictionary* parameters = @{@"facebookId": user.id, @"name": user.name, @"date": [[NSDate new] description]};
            [[UNIRest post:^(UNISimpleRequest* request) {
                [request setUrl:@"http://fast-taiga-2263.herokuapp.com/users"];
                [request setHeaders:headers];
                [request setParameters:parameters];
                [request setUsername:@"admin"];
                [request setPassword:@"admin"];
            }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
                //UNIJsonNode* body = [response body];
                //NSDictionary* dic = [body JSONObject];
                //NSLog(@"response: %@",[dic objectForKey:@"content"]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.message.text = @"";
                });
            }];
            
        }
        
        //NSDictionary* dic = [body JSONObject];
    }];
}

//fast-taiga-2263.herokuapp.com

- (IBAction)send:(id)sender{
    NSDictionary* headers = @{@"accept": @"application/json"};
    NSDictionary* parameters = @{@"facebookId": self.currentUser.id};
    [[UNIRest post:^(UNISimpleRequest* request) {
        [request setUrl:@"http://fast-taiga-2263.herokuapp.com/fenceentry"];
        [request setHeaders:headers];
        [request setParameters:parameters];
        [request setUsername:@"admin"];
        [request setPassword:@"admin"];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        //UNIJsonNode* body = [response body];
        //NSDictionary* dic = [body JSONObject];
        //NSLog(@"response: %@",[dic objectForKey:@"content"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.message.text = @"";
        });
    }];
    
}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    self.statusLabel.text = @"You're logged in as";
}


// Implement the loginViewShowingLoggedOutUser: delegate method to modify your app's UI for a logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    self.profilePictureView.profileID = nil;
    self.nameLabel.text = @"";
    self.statusLabel.text= @"You're not logged in!";
}

// You need to override loginView:handleError in order to handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures since that happen outside of the app.
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

@end
