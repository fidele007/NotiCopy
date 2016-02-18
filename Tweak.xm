@interface SBLockScreenNotificationListView : UIView
@end

@interface _SBFVibrantTableViewCell : UITableViewCell
@end

@interface SBNotificationCell : _SBFVibrantTableViewCell
@property(copy, nonatomic) NSString *secondaryText;
@property(copy, nonatomic) NSString *subtitleText;
@property(copy, nonatomic) NSString *primaryText;
@end

@interface SBLockScreenNotificationCell : SBNotificationCell
@property(readonly, retain, nonatomic) UIScrollView *contentScrollView; //SBLockScreenNotificationScrollView
@property(retain, nonatomic) id <UIScrollViewDelegate> delegate; //SBLockScreenNotificationListView
@end

@interface SBNotificationsBulletinCell : SBNotificationCell
@end

// Hook notification cells on lock screen
%hook SBLockScreenNotificationCell
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 {
	
	// NSLog(@"[NotiCopy] Lock Screen Notification Cell Initiated.");

	UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleNotificationLongPress:)];
	
	// longPressGestureRecognizer.delegate = self.contentScrollView;
	
	[self addGestureRecognizer:longPressGestureRecognizer];
	[longPressGestureRecognizer release];
	
	return %orig;
}

%new
-(void)handleNotificationLongPress:(UILongPressGestureRecognizer *)gesture {
	//TODO: Find a way to make UIGestureRecognizerStateBegan fire without lifting finger
	if (gesture.state == UIGestureRecognizerStateEnded) {
		// NSLog(@"[NotiCopy] %@", self.secondaryText);

		// Copy text to pasteboard
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		pasteboard.string = self.secondaryText;

		// Add alert view to let users know the text is copied
		CGSize screenSize = [UIScreen mainScreen].bounds.size;
		UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width/2 - 80, screenSize.height/2, 160, 40)]; // (x - width/2) to center the view
		[customView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
		customView.layer.cornerRadius = 10;
		customView.userInteractionEnabled = NO;

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
		[label setText:@"Copied to clipboard."];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label setTextColor:[UIColor whiteColor]];
		[customView addSubview:label];

		customView.alpha = 0;
		[self.window.rootViewController.view addSubview:customView];

		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut
			animations:^{
				customView.alpha = 1;
			} 
			completion:^(BOOL finished){
				[UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationCurveEaseOut
					animations:^{
						customView.alpha = 0;
					}
					completion:^(BOOL finished) {
						[customView removeFromSuperview];
						[customView release];
						[label release];
					}];
			}];
	}
}
%end


// Hook notification cells in Notification Center
%hook SBNotificationsBulletinCell
-(id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 {
	// NSLog(@"[NotiCopy] Notification Center Cell Initiated.");

	UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleNotificationLongPress:)];
		
	[self addGestureRecognizer:longPressGestureRecognizer];
	[longPressGestureRecognizer release];

	return %orig;
}

%new
-(void)handleNotificationLongPress:(UILongPressGestureRecognizer *)gesture {
	if (gesture.state == UIGestureRecognizerStateBegan) {
		// NSLog(@"[NotiCopy] %@", self.secondaryText);

		// Copy text to pasteboard
		UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
		pasteboard.string = self.secondaryText;

		// Add alert view to let users know the text is copied
		CGSize screenSize = [UIScreen mainScreen].bounds.size;
		UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(screenSize.width/2 - 80, self.frame.origin.y + self.frame.size.height/2 - 20, 160, 40)]; // (x - width/2) to center the view
		[customView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8]];
		customView.layer.cornerRadius = 10;
		customView.userInteractionEnabled = NO;

		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
		[label setText:@"Copied to clipboard."];
		[label setTextAlignment:NSTextAlignmentCenter];
		[label setTextColor:[UIColor whiteColor]];
		[customView addSubview:label];

		customView.alpha = 0;
		[self.superview addSubview:customView];

		[UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut
			animations:^{
				customView.alpha = 1;
			} 
			completion:^(BOOL finished){
				[UIView animateWithDuration:0.3 delay:0.5 options:UIViewAnimationCurveEaseOut
					animations:^{
						customView.alpha = 0;
					}
					completion:^(BOOL finished) {
						[customView removeFromSuperview];
						[customView release];
						[label release];
					}];
			}];
	}
}
%end