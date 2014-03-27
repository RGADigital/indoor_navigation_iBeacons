//
//  LoginUIViewController.m
//  FBLoginUIControlSample
//
//  Created by John Tubert.
//  Copyright (c) 2014 FAll rights reserved.
//



#import "LoginUIViewController.h"

@interface LoginUIViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UITextField *message;
@property (strong, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation LoginUIViewController

- (void) viewDidLoad{
    [super viewDidLoad];
    // Custom initialization
    
    // Create a FBLoginView to log the user in with basic, email and likes permissions
    // You should ALWAYS ask for basic permissions (basic_info) when logging the user in
    FBLoginView *loginView = [[FBLoginView alloc] initWithReadPermissions:@[@"basic_info", @"email", @"user_likes"]];
    
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
    
}

// This method will be called when the user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
  self.profilePictureView.profileID = user.id;
  self.nameLabel.text = user.name;
}

- (IBAction)send:(id)sender{    
    NSDictionary* headers = @{@"accept": @"application/json"};
    NSDictionary* parameters = @{@"content": self.message.text, @"user": self.nameLabel.text};
    [[UNIRest post:^(UNISimpleRequest* request) {
        [request setUrl:@"http://calm-harbor-1376.herokuapp.com/messages"];
        [request setHeaders:headers];
        [request setParameters:parameters];
        [request setUsername:@"admin"];
        [request setPassword:@"admin"];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        //NSInteger* code = [response code];
        //NSDictionary* responseHeaders = [response headers];
        UNIJsonNode* body = [response body];
        //NSData* rawBody = [response rawBody];
        NSDictionary* dic = [body JSONObject];
        //NSString* newStr = [[NSString alloc] initWithData:rawBody encoding:NSUTF8StringEncoding];
        NSLog(@"response: %@",[dic objectForKey:@"content"]);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.message.text = @"";
        });
        
        
    }];

}

// Implement the loginViewShowingLoggedInUser: delegate method to modify your app's UI for a logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
  self.statusLabel.text = @"You're logged in as";
    
    //[self postMessage:@"content 123" andUser:@"User2"];
    
    UNIUrlConnection* asyncConnection = [[UNIRest get:^(UNISimpleRequest *request) {
        [request setUrl:@"http://calm-harbor-1376.herokuapp.com/messages"];
        [request setUsername:@"admin"];
        [request setPassword:@"admin"];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {
        UNIJsonNode* body = [response body];
        
        NSArray* arr = [body JSONArray];
        
        for (int i=0; i< arr.count; i++) {
            NSDictionary* dic = arr[i];
            NSLog(@"response: %@",[dic objectForKey:@"content"]);
        }
        
        //NSDictionary* dic = [body JSONObject];
       
    }];
    
    //[asyncConnection cancel]; // Cancel request
    
}

- (void) postMessage:(NSString*)content andUser:(NSString*)user{
    NSDictionary* headers = @{@"accept": @"application/json"};
    NSDictionary* parameters = @{@"content": content, @"user": user};
    [[UNIRest post:^(UNISimpleRequest* request) {
        [request setUrl:@"http://calm-harbor-1376.herokuapp.com/messages"];
        [request setHeaders:headers];
        [request setParameters:parameters];
    }] asJsonAsync:^(UNIHTTPJsonResponse* response, NSError *error) {
        // This is the asyncronous callback block
        //NSInteger* code = [response code];
        //NSDictionary* responseHeaders = [response headers];
        UNIJsonNode* body = [response body];
        //NSData* rawBody = [response rawBody];
        NSDictionary* dic = [body JSONObject];
        //NSString* newStr = [[NSString alloc] initWithData:rawBody encoding:NSUTF8StringEncoding];
        NSLog(@"response: %@",[dic objectForKey:@"content"]);
    }];

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
