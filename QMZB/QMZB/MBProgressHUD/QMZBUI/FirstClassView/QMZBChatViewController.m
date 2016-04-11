//
//  ChatViewController.m
//  GotyeLiveDemo
//
//  Created by Nick on 15/11/11.
//  Copyright © 2015年 AiLiao. All rights reserved.
//

#import "QMZBChatViewController.h"
#import "GLPlayer.h"
#import "GLCore.h"
//#import "GLChatManager.h"
#import "GLPublisher.h"
#import "GLPublisherDelegate.h"
#import "ChatView.h"
#import "UIView+Extension.h"
#import "WXApiObject.h"
#import "WXApi.h"
#import "GLClientUrl.h"
#import "WeiboSDK.h"
#import <MediaPlayer/MediaPlayer.h>
#import "QMZBUIUtil.h"
#import "GLChatObserver.h"
#import "GLChatSession.h"
#import "GLRoomPlayer.h"
#import "GLRoomPublisher.h"
#import "GLRoomPublisherDelegate.h"
#import "MBProgressHUD.h"
#import "QMZBNetwork.h"
#import "NSString+Extension.h"

@interface QMZBChatViewController() <GLPlayerDelegate,GLRoomPlayerDelegate, GLChatObserver, GLRoomPublisherDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate,MBProgressHUDDelegate>
{
    IBOutlet GLPlayerView *_videoView;
    IBOutlet UITextField *_inputField;
    IBOutlet UIView *_chatView;
    IBOutlet ChatView *_chatContentView;
    
    IBOutlet UIButton *_closeBtn;
    IBOutlet UIView *_shareBG;
    IBOutlet UIView *_shareDialog;
    IBOutlet UIButton *_foldBtn;
    IBOutlet UIButton *_recBtn;
    IBOutlet UIButton *_toggleCameraBtn;
    IBOutlet UIButton *_toggleMicBtn;
    IBOutlet UIButton *_toggleTorchBtn;
    IBOutlet UIButton *_toggleChatBtn;
    IBOutlet UIButton *_toggleVolumeBtn;
    IBOutlet UIButton *_toggleRecBtn;
    IBOutlet UILabel *_tip;
    IBOutlet UIActivityIndicatorView *_indicator;
    IBOutlet UISlider   *_volumeSlider;
    IBOutlet UIButton *_fullscreenBtn;
    IBOutlet UIView *_volumeView;
    IBOutlet UIImageView *_chatBG;
    IBOutlet UIButton *_shareBtn;
    IBOutlet UILabel *_timeLabel;
    IBOutlet UILabel *_liveTitleLabel;
    IBOutlet UIView *_liveTitleView;
    IBOutlet UIView *_roomTitleView;
    IBOutlet UIButton *_presetBtn;
    IBOutlet UIImageView *_recIcon;
    IBOutlet UIButton *_emojiBtn;
    IBOutlet UIView *_emojiView;
    IBOutlet UICollectionView *_emojiCollectionView;
    IBOutlet UIPageControl *_emojiPageControl;
    
    IBOutlet NSLayoutConstraint *_chatViewAndVideoViewAlignConstraint;
    IBOutlet NSLayoutConstraint *_chatContentViewTopConstraint;
    IBOutlet NSLayoutConstraint *_chatBtnShareBtnAlignConstrint;
    IBOutlet NSLayoutConstraint *_shareBtnBottomAlignConstraint;
    IBOutlet NSLayoutConstraint *_flashBtnBottomAlignConstraint;
    IBOutlet NSLayoutConstraint *_cameraBtnBottomAlignConstraint;
    IBOutlet NSLayoutConstraint *_inputFieldTrailingConstraint;
    IBOutlet NSLayoutConstraint *_volumeViewLeadingConstraint;
    IBOutlet NSLayoutConstraint *_fullscreenBtnBottomConstraint;
    IBOutlet NSLayoutConstraint *_fullscreenBtnTrailingConstraint;
    IBOutlet NSLayoutConstraint *_presetBtnTrailingConstraint;
    
    BOOL _isSidebarFolded;
    BOOL _isLanscapeMode;
    UISlider *_systemVolmeSlider;
    NSTimer *_publishTimer;
    NSTimer *_hideActionViewTimer;
    NSUInteger _totalPublishSeconds;
    NSInteger _currentUserCount;
    NSArray *_emojiImages;
    NSTimer *_pushLiveStreamTimer;
}

@property (nonatomic,copy)GLRoomPublisher *publisher;

@property (nonatomic,copy)GLRoomPlayer *player;

@property (nonatomic,copy)GLChatSession *chatKit;

@property (nonatomic,copy)GLRoomSession * session;

@property(nonatomic ,strong) QMZBNetwork *requestClient;

@end

@implementation QMZBChatViewController

#pragma mark - Override

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loginRoom];
    
/*
//    _session = [GLCore currentSession];
//    _chatKit = [[GLChatSession alloc] initWithSession:_session];
//    [_chatKit loginOnSuccess:^(NSString *account, NSString *nickname) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    
//    _inputField.leftView = _emojiBtn;
//    _inputField.leftViewMode = UITextFieldViewModeAlways;
//    UIColor *color = [UIColor lightGrayColor];
//    _inputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_inputField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
//    _emojiPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
//    _emojiPageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
//    [_emojiCollectionView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
//    
//    NSMutableArray *emojiArray = [NSMutableArray array];
//    for (int index = 1; index <= 27; ++index) {
//        NSString *name = [NSString stringWithFormat:@"smiley_%ld", (long)index];
//        UIImage *image = [UIImage imageNamed:name];
//        [emojiArray addObject:image];
//    }
//    _emojiImages = [NSArray arrayWithArray:emojiArray];
//    
//    
//    
//    
//    if (self.isLiveMode) {
//        _publisher = [[GLRoomPublisher alloc] initWithSession:_session];
//        _publisher.delegate = self;
//        [self applyWatermark];
//        [_publisher startPreview:_videoView success:^{
//            NSLog(@"preview success");
//        } failure:^(NSError *error) {
//            NSLog(@"preview failed. %@", error);
//        }];
//        _recBtn.hidden
//        = _toggleCameraBtn.hidden
//        = _toggleTorchBtn.hidden
//        = _toggleMicBtn.hidden
//        = _toggleChatBtn.hidden
//        = _toggleRecBtn.hidden
//        = _foldBtn.hidden
//        = _presetBtn.hidden
//        = NO;
//        _volumeView.hidden
//        = _fullscreenBtn.hidden
//        = YES;
//        [_presetBtn setTitle:[self stringForSize:_publisher.videoPreset.videoSize] forState:UIControlStateNormal];
//    } else {
//        _player.delegate = self;
//        [_player playWithView:(GLPlayerView *)_videoView];
//        [self showIndicator];
//        
//        [_volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"bg_volume_min"] forState:UIControlStateNormal];
//        [_volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"bg_volume_max"] forState:UIControlStateNormal];
//        [_volumeSlider setThumbImage:[UIImage imageNamed:@"btn_volume_thumb"] forState:UIControlStateNormal];
//        [_volumeSlider setThumbImage:[UIImage imageNamed:@"btn_volume_thumb"] forState:UIControlStateHighlighted];
//        
//        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
//        volumeView.hidden = YES;
//        [self.view addSubview:volumeView];
//        for (UIView *view in [volumeView subviews]){
//            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
//                _systemVolmeSlider = (UISlider*)view;
//                [_systemVolmeSlider addTarget:self action:@selector(systemVolumeChanged:) forControlEvents:UIControlEventValueChanged];
//                break;
//            }
//        }
//        _liveTitleLabel.text = [NSString stringWithFormat:@"直播室%@", self.roomId];
//        [self startHideActionViewTimer];
//    }
//    
//    [_chatKit addObserver:self];
//    [_chatKit sendNotify:@"enter" extra:nil success:nil failure:nil];
 */
}

- (void)initView
{
//    _session = [GLCore currentSession];
//    _chatKit = [[GLChatSession alloc] initWithSession:_session];
//    _publisher = [[GLRoomPublisher alloc] initWithSession:_session];
//    _player = [[GLRoomPlayer alloc] initWithRoomSession:_session];
    
    _inputField.leftView = _emojiBtn;
    _inputField.leftViewMode = UITextFieldViewModeAlways;
    UIColor *color = [UIColor lightGrayColor];
    _inputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_inputField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
    _emojiPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    _emojiPageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    [_emojiCollectionView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew context:nil];
    
    NSMutableArray *emojiArray = [NSMutableArray array];
    for (int index = 1; index <= 27; ++index) {
        NSString *name = [NSString stringWithFormat:@"smiley_%ld", (long)index];
        UIImage *image = [UIImage imageNamed:name];
        [emojiArray addObject:image];
    }
    _emojiImages = [NSArray arrayWithArray:emojiArray];
    
    
    
    
    if (self.isLiveMode) {
        _publisher.delegate = self;
        [self applyWatermark];
        [_publisher startPreview:_videoView success:^{
            NSLog(@"preview success");
        } failure:^(NSError *error) {
            NSLog(@"preview failed. %@", error);
        }];
        _recBtn.hidden
        = _toggleCameraBtn.hidden
        = _toggleTorchBtn.hidden
        = _toggleMicBtn.hidden
        = _toggleChatBtn.hidden
        = _toggleRecBtn.hidden
        = _foldBtn.hidden
        = _presetBtn.hidden
        = NO;
        _volumeView.hidden
        = _fullscreenBtn.hidden
        = YES;
        [_presetBtn setTitle:[self stringForSize:_publisher.videoPreset.videoSize] forState:UIControlStateNormal];
    } else {
        _player.delegate = self;
        _videoView.fillMode = GLPlayerViewFillModeAspectRatio;

        [_player playWithView:_videoView];
        [self showIndicator];
        
        [_volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"bg_volume_min"] forState:UIControlStateNormal];
        [_volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"bg_volume_max"] forState:UIControlStateNormal];
        [_volumeSlider setThumbImage:[UIImage imageNamed:@"btn_volume_thumb"] forState:UIControlStateNormal];
        [_volumeSlider setThumbImage:[UIImage imageNamed:@"btn_volume_thumb"] forState:UIControlStateHighlighted];
        
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        volumeView.hidden = YES;
        [self.view addSubview:volumeView];
        for (UIView *view in [volumeView subviews]){
            if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
                _systemVolmeSlider = (UISlider*)view;
                [_systemVolmeSlider addTarget:self action:@selector(systemVolumeChanged:) forControlEvents:UIControlEventValueChanged];
                break;
            }
        }
        _liveTitleLabel.text = [NSString stringWithFormat:@"直播室%@", self.roomId];
        [self startHideActionViewTimer];
    }
    
    [_chatKit addObserver:self];
    [_chatKit sendNotify:@"enter" extra:nil success:nil failure:nil];
}

- (void)loginRoom
{
//    NSString *roomId = AppDelegateInstance.userInfo.channelID;
//    NSString *pwd = AppDelegateInstance.userInfo.passWord;
//    NSString *nickname = AppDelegateInstance.userInfo.nickName;
//        _roomId = @"210150";
//        _password = @"openAnchor";
//        _nickName = @"123";
//    if (roomId.length == 0 || pwd.length == 0 || nickname.length == 0) {
//        return;
//    }
//    NSLog(@"====%@",_roomId);
//    NSLog(@"====%@",_password);
//    NSLog(@"====%@",_nickName);

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _session = [GLCore sessionWithType:GLRoomSessionTypeDefault roomId:_roomId password:_password nickname:_nickName bindAccount:nil];
    _chatKit = [[GLChatSession alloc] initWithSession:_session];
    if (self.isLiveMode) {
        
        _publisher = [[GLRoomPublisher alloc] initWithSession:_session];
    }else {
        
        _player = [[GLRoomPlayer alloc] initWithRoomSession:_session];
    }
    [_session authOnSuccess:^(GLAuthToken *authToken) {
        if (authToken.role == GLAuthTokenRolePresenter) {
            [self _loginPublisherWithForce:NO callback:^(NSError *error) {
                if (!error) {
                    [self _enterChatRoomWithRoomId:_roomId password:_password callback:^(NSError *error, NSString *account, NSString *nickname) {
                        if (error) {
                            [self hud:hud showError:error.localizedDescription];
                        } else {
                            [hud hide:YES];
                            [self initView];
                        }
                    }];
                    
                    return;
                }
                
                if (error.code == GLPublisherErrorCodeOccupied) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"当前直播间已经有人登录了，继续登录的话将会踢出当前用户的用户。是否继续？" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *goOn = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self _loginPublisherWithForce:YES callback:^(NSError *error) {
                            if (error) {
                                [self hud:hud showError:error.localizedDescription];
                                return;
                            }
                            
                            [self _enterChatRoomWithRoomId:_roomId password:_password callback:^(NSError *error, NSString *account, NSString *nickname) {
                                if (error) {
                                    [self hud:hud showError:error.localizedDescription];
                                } else {
                                    [hud hide:YES];
                                }
                            }];
                        }];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                        [hud hide:YES];
                        [self.view endEditing:YES];
                    }];
                    [alert addAction:cancel];
                    [alert addAction:goOn];
                    
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    [self hud:hud showError:error.localizedDescription];
                }
            }];
        } else {
            [self _enterChatRoomWithRoomId:_roomId password:_password callback:^(NSError *error, NSString *account, NSString *nickname) {
                if (error) {
                    [self hud:hud showError:error.localizedDescription];
                } else {
                    [hud hide:YES];
                    [self initView];
                }
            }];
        }
        
        
    } failure:^(NSError *error) {
        NSLog(@"====%@",error.localizedDescription);
        [self hud:hud showError:error.localizedDescription];
    }];
    

    
}

- (void)_loginPublisherWithForce:(BOOL)force callback:(void(^)(NSError *error))callback
{
    [_publisher loginWithForce:force success:^{
//        NSLog(@"=========_publisher loginWithForce==success======");
        if (callback) {
            callback(nil);
        }
    } failure:^(NSError *error) {
//        NSLog(@"+++++publisher login++error+++++");
        if (callback) {
            callback(error);
        }
    }];
}

- (void)hud:(MBProgressHUD *)hud showError:(NSString *)error
{
    hud.detailsLabelText = error;
    hud.mode = MBProgressHUDModeText;
    [hud hide:YES afterDelay:1];
}


- (void)_enterChatRoomWithRoomId:(NSString *)roomId password:(NSString *)password callback:(void(^)(NSError *error, NSString *account, NSString *nickname))callback
{
    [_chatKit loginOnSuccess:^(NSString *account, NSString *nickname) {
//        NSLog(@"-----_chatKit loginOnSuccess-------");
        callback(nil, account, nickname);
    } failure:^(NSError *error) {
//        NSLog(@"~~~~~~~_chatKit login error~~~~~~~");
        if (callback) {
            callback(error, nil, nil);
        }
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (object == _emojiCollectionView && [keyPath isEqualToString:@"bounds"]) {
        CGRect bounds = [((NSValue *)[change objectForKey:NSKeyValueChangeNewKey]) CGRectValue];
        _emojiPageControl.numberOfPages = ceil(_emojiCollectionView.collectionViewLayout.collectionViewContentSize.width / bounds.size.width);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    if (_emojiCollectionView) {
        
//        [_emojiCollectionView removeObserver:self forKeyPath:@"bounds"];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _volumeSlider.value = _systemVolmeSlider.value;
    if ([self isStatusbarLandscape]) {
        [self willChangeToLandscapeMode:self.view.bounds.size];
    } else {
        [self willChangeToPortraitMode];
    }
    
    if (_emojiBtn.selected) {
        _inputField.width = self.view.width - _inputField.x * 2;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if (_isLiveMode) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - UI Actions

- (IBAction)emojiClick:(id)sender
{
    [self showEmoji:!_emojiBtn.selected];
}

- (IBAction)closeClick:(id)sender
{
    [_player stop];
    [_publisher stop];
    [_chatKit logout];
    [_chatKit removeObserver:self];
    
    [self stopPublishTimer];
    [_pushLiveStreamTimer invalidate];
    [self PushLiveStreamOff];

    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;

    [self dismissViewControllerAnimated:YES completion:nil];
    if (_isLiveMode == 1) {
        [[NSNotificationCenter defaultCenter]  postNotificationName:NotificationUpdateTab object:[NSString stringWithFormat:@"%ld", (long)_itemTag]];
    }else {
        
    }
    AppDelegateInstance.allowRotation = NO;
}

- (IBAction)sendClick:(id)sender
{
    if (_inputField.text.length == 0) {
        return;
    }
    
    NSString *toSend = _inputField.text;
    [_chatKit sendText:toSend extra:nil success:^{
        [_chatContentView addCellWithName:[_chatKit currentLoginUser].nickname comment:toSend];
    } failure:^(NSError *error) {
        //show error
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"发送失败" message:[error description]  preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    
    [self dismissKeyboard];
    [self showEmoji:NO];
    _inputField.text = nil;
}

- (IBAction)handleSingleTap:(id)sender
{
    if ([_inputField isFirstResponder]) {
        [self dismissKeyboard];
    } else if (_emojiBtn.selected) {
        [self showEmoji:NO];
    } else if (_isLanscapeMode) {
        [self videoClick:nil];
    }
}

- (IBAction)shareBtnClick:(id)sender
{
    [self showShareView];
}

- (IBAction)closeShareBtnClick:(id)sender
{
    [self hideShareView];
}

- (IBAction)foldBtnClick:(id)sender
{
    _foldBtn.selected = !_foldBtn.selected;
    if (_foldBtn.selected) {
        [self foldSideView];
    } else {
        [self unfoldSideView];
    }
}

- (IBAction)recBtnClick:(id)sender
{
    BOOL isLiving = _recBtn.selected;
    if (isLiving) {
        [_publisher unpublish];
        [self publishDidStop];
        [self setTip:nil];
        [_pushLiveStreamTimer invalidate];
        [self PushLiveStreamOff];
    } else {
        _recBtn.enabled = NO;
        [self showIndicator];
        [_publisher publish];
    }
}

- (IBAction)toggleBtnClick:(id)sender
{
    UIButton *toggleBtn = (UIButton *)sender;
    BOOL selected =  toggleBtn.selected = !toggleBtn.selected;
    
    if (toggleBtn == _toggleCameraBtn) {
        [self toggleCamera:selected];
    } else if (toggleBtn == _toggleMicBtn) {
        [self toggleMic:selected];
    } else if (toggleBtn == _toggleTorchBtn) {
        [self toggleTorh:selected];
    } else if (toggleBtn == _toggleChatBtn) {
        [self toggleChat:selected];
    } else if (toggleBtn == _toggleVolumeBtn) {
        [self toggleVolume:selected];
    } else if (toggleBtn == _toggleRecBtn) {
        [self toggleRec:selected];
    }
}

- (IBAction)shareToClick:(id)sender
{
    [self hideShareView];
    NSInteger tag = [(UIButton *)sender tag];
    [_session getClientUrlsOnSuccess:^(GLClientUrl *clientUrl) {
        NSString *shareUrl = clientUrl.educVisitorUrl;
        switch (tag) {
            case 1:
                [self shareToWeiXin:shareUrl inScene:WXSceneTimeline];
                break;
            case 2:
                [self shareToWeiXin:shareUrl inScene:WXSceneSession];
                break;
            case 3:
                [self shareToSinaWeibo:shareUrl];
                break;
            default:
                break;
        }
    } failure:^(NSError *error) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"获取分享url出错！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)fullScreenBtnClick:(id)sender
{
    if (_fullscreenBtn.selected) {
        [self setOrientation:UIInterfaceOrientationPortrait];
    } else {
        [self setOrientation:UIInterfaceOrientationLandscapeRight];
    }
}

- (IBAction)volumeValueChanged:(id)sender
{
    _systemVolmeSlider.value = _volumeSlider.value;
}

- (IBAction)videoClick:(id)sender
{
    if (_isLiveMode) {
        return;
    }
    
    if (_volumeView.alpha == 1) {
        [self hideActionView];
    } else {
        [self showActionView];
    }
}

- (IBAction)presetBtnClick:(id)sender
{
    UIAlertController *sheet;
    
    if (_isLiveMode) {
        if (_recBtn.selected) {
            return;
        }
        
        sheet = [UIAlertController alertControllerWithTitle:@"选择分辨率" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSArray *resolutions = @[[self actionForResolution:GLPublisherVideoResolution480x272],
                                 [self actionForResolution:GLPublisherVideoResolution640x360],
                                 [self actionForResolution:GLPublisherVideoResolution854x480],
                                 [self actionForResolution:GLPublisherVideoResolution320x240],
                                 [self actionForResolution:GLPublisherVideoResolution640x480],
                                 [self actionForResolution:GLPublisherVideoResolution768x576]];
        [resolutions enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [sheet addAction:obj];
        }];
    } else {
        sheet = [UIAlertController alertControllerWithTitle:@"选择清晰度" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [_player.availableVideoQualities enumerateObjectsUsingBlock:^(NSNumber * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIAlertAction *aciton = [self actionForVideoQuality:obj.integerValue];
            [sheet addAction:aciton];
        }];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [sheet addAction:cancel];
    
    [self presentViewController:sheet animated:YES completion:nil];
}

#pragma mark - Private Methods

- (void)showEmoji:(BOOL)show
{
    CGFloat emojiY = show ? _chatView.height - _emojiView.height : _chatView.height;
    CGFloat offset = show ? 0 : 8;
    CGFloat moveY = emojiY - (_inputField.frame.origin.y + _inputField.frame.size.height + offset);
    
    [UIView animateWithDuration:.3f animations:^{
        if (![_inputField isFirstResponder] || show) {
            _inputField.transform = CGAffineTransformTranslate(_inputField.transform, 0, moveY);
            _chatContentView.transform = CGAffineTransformTranslate(_chatContentView.transform, 0, moveY);
            
            if (show) {
                _inputField.width = self.view.width - _inputField.x * 2;
            } else {
                _inputFieldTrailingConstraint.active = NO;
                _inputFieldTrailingConstraint.active = YES;
                [_inputField layoutIfNeeded];
            }
        }
        
        _emojiView.transform = CGAffineTransformTranslate(_emojiView.transform, 0, emojiY - _emojiView.y);
    } completion:nil];
    
    _emojiBtn.selected = show;
    
    if (show) {
        [self dismissKeyboard];
    }
}

- (void)applyWatermark
{
    [_publisher clearWatermark];
    
    CGSize videoSize = _publisher.videoPreset.videoSize;
    CGSize watermarkSize = CGSizeMake(171, 48);
    [_publisher addWatermark:[UIImage imageNamed:@"watermark"] withFrame:CGRectMake(videoSize.width - watermarkSize.width - 10, videoSize.height - watermarkSize.height - 10, watermarkSize.width, watermarkSize.height)];
}

- (NSString *)stringForSize:(CGSize)size
{
    return [NSString stringWithFormat:@"%ldx%ld", (long)size.width, (long)size.height];
}

- (UIAlertAction *)actionForResolution:(GLPublisherVideoResolution)resolution
{
    GLPublisherVideoPreset *preset = [GLPublisherVideoPreset presetWithResolution:resolution];
    NSString *title = [self stringForSize:preset.videoSize];
    NSString *ratio = nil;
    switch (resolution) {
        case GLPublisherVideoResolution320x240:
        case GLPublisherVideoResolution640x480:
        case GLPublisherVideoResolution768x576:
            ratio = @"4:3";
            break;
        case GLPublisherVideoResolution480x272:
        case GLPublisherVideoResolution640x360:
        case GLPublisherVideoResolution854x480:
            ratio = @"16:9";
            break;
        default:
            break;
    }
    if (ratio) {
        title = [title stringByAppendingFormat:@" (%@)", ratio];
    }
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [_publisher setVideoPreset:preset];
        [_presetBtn setTitle:title forState:UIControlStateNormal];
        [self applyWatermark];
    }];
    
    return action;
}

- (NSString *)stringForVideoQuality:(GLVideoQuality)videoQuality
{
    switch (videoQuality) {
        case GLVideoQualityOriginal:
            return @"原画";
        case GLVideoQualityHigh:
            return @"高清";
        case GLVideoQualityMedium:
            return @"标清";
        case GLVideoQualityLow:
            return @"流畅";
        default:
            break;
    }
    
    return nil;
}

- (UIAlertAction *)actionForVideoQuality:(GLVideoQuality)videoQuality
{
    NSString *title = [self stringForVideoQuality:videoQuality];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([_player switchToQuality:videoQuality]) {
            [_presetBtn setTitle:title forState:UIControlStateNormal];
            [self showIndicator];
        }
    }];
    
    return action;
}

- (void)systemVolumeChanged:(id)sender
{
    _volumeSlider.value = _systemVolmeSlider.value;
}

- (void)setOrientation:(NSInteger)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        NSInteger val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

- (BOOL)isStatusbarLandscape
{
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation);
}

- (BOOL)isDeviceLandscape
{
    return UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation);
}

- (void)willChangeToLandscapeMode:(CGSize)size
{
    if (_isLanscapeMode) {
        return;
    }
    
    [self setLandscapeMode:YES];
    
    [self hideActionView];
    [_chatContentView clear];
    
    _liveTitleView.hidden = _roomTitleView.hidden = YES;
    _chatContentViewTopConstraint.constant = 0;
    _toggleChatBtn.hidden = NO;
    _chatViewAndVideoViewAlignConstraint.constant = -size.height;
    _chatView.frame = CGRectMake(0, 0, size.width, size.height);
    _chatBG.hidden = YES;
    _presetBtn.hidden = NO;
    _shareBtnBottomAlignConstraint.constant += _foldBtn.height;
    _volumeViewLeadingConstraint.constant = size.width - _fullscreenBtnTrailingConstraint.constant * 2 - _fullscreenBtn.width - _volumeView.width;
    
    if (_isLiveMode) {
        _chatBtnShareBtnAlignConstrint.constant = _shareBtn.height + _toggleRecBtn.height + 8 * 2;
        _presetBtnTrailingConstraint.constant = 6;
        _inputFieldTrailingConstraint.constant = _fullscreenBtnBottomConstraint.constant + _volumeView.width + 60;
    } else {
        _chatBtnShareBtnAlignConstrint.constant = _shareBtn.height + 8 ;
        _presetBtnTrailingConstraint.constant = 80;
        _inputFieldTrailingConstraint.constant = _fullscreenBtnBottomConstraint.constant + _volumeView.width + _presetBtn.width + 60;
    }
}

- (void)willChangeToPortraitMode
{
    if (!_isLanscapeMode) {
        return;
    }
    
    [self setLandscapeMode:NO];
    
    [self stopHideActionViewTimer];
    [self showActionView];
    [_chatContentView clear];
    
    _shareBtn.alpha = 1;
    _liveTitleView.hidden = _roomTitleView.hidden = NO;
    _chatContentViewTopConstraint.constant = _liveTitleView.height + _roomTitleView.height;
    _toggleChatBtn.hidden = YES;
    _chatViewAndVideoViewAlignConstraint.constant = 0;

    _chatBG.hidden = NO;
    _presetBtn.hidden = YES;
    _shareBtnBottomAlignConstraint.constant = 8;
    _chatBtnShareBtnAlignConstrint.constant = 8;
    _volumeViewLeadingConstraint.constant = 20;
    _inputFieldTrailingConstraint.constant = 0;
}

- (void)setLandscapeMode:(BOOL)landscape
{
    _isLanscapeMode = landscape;
    _fullscreenBtn.selected = _isLanscapeMode;
}

- (void)foldSideView
{
    [UIView animateWithDuration:.3 animations:^{
        CGFloat dy = _foldBtn.height;
        int distance = 1;
        [self view:_shareBtn moveDownAndFadeOut:distance++ * dy];
        [self view:_toggleRecBtn moveDownAndFadeOut:distance++ * dy];
        [self view:_toggleChatBtn moveDownAndFadeOut:(distance++ * dy)];
        [self view:_toggleTorchBtn moveDownAndFadeOut:(distance++ * dy)];
        [self view:_toggleCameraBtn moveDownAndFadeOut:(distance++ * dy)];
        _foldBtn.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)view:(UIView *)view moveDownAndFadeOut:(CGFloat)dy
{
    view.transform = CGAffineTransformMakeTranslation(0, dy);
    view.alpha = 0;
}

- (void)viewMoveBackAndFadeIn:(UIView *)view
{
    view.transform = CGAffineTransformIdentity;
    view.alpha = 1;
}

- (void)unfoldSideView
{
    [UIView animateWithDuration:.3 animations:^{
        [self viewMoveBackAndFadeIn:_shareBtn];
        [self viewMoveBackAndFadeIn:_toggleRecBtn];
        [self viewMoveBackAndFadeIn:_toggleChatBtn];
        [self viewMoveBackAndFadeIn:_toggleTorchBtn];
        [self viewMoveBackAndFadeIn:_toggleCameraBtn];
        _foldBtn.transform = CGAffineTransformRotate(_foldBtn.transform, -M_PI_2);
        _foldBtn.transform = CGAffineTransformRotate(_foldBtn.transform, -M_PI_2);
    }];
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (void)startPublishTimer
{
    if (_publishTimer) {
        return;
    }
    
    _publishTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePublishTime) userInfo:nil repeats:YES];
    [_publishTimer fire];
}

- (void)stopPublishTimer
{
    [_publishTimer invalidate];
    _publishTimer = nil;
}

- (void)updatePublishTime
{
    _timeLabel.text = [self timeFormatted:(int)_totalPublishSeconds++];
    if (_totalPublishSeconds % 60 == 0) {
        [self updateRoomUserCount];
    }
}

- (void)publishDidStop
{
    _recBtn.enabled = YES;
    _recBtn.selected = NO;
    [_recBtn setImage:[UIImage imageNamed:@"btn_start"] forState:UIControlStateNormal];
    
    _timeLabel.hidden = YES;
    [self hideRecIcon];
    _totalPublishSeconds = 0;
    [self stopPublishTimer];
    [self hideIndicator];
}

- (void)shareToWeiXin:(NSString *)url inScene:(enum WXScene)scene
{
    WXMediaMessage *message = [[WXMediaMessage alloc]init];
    message.title = @"亲加视频直播";
    message.description = @"这是一个直播";
    [message setThumbImage:[UIImage imageNamed:@"AppIcon60x60"]];
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = url;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.bText = NO;
    req.message = message;
    req.scene = scene;
    
    [WXApi sendReq:req];
}

- (void)shareToSinaWeibo:(NSString *)url
{
    WBMessageObject *message = [WBMessageObject message];
    
    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = @"亲加视频直播";
    webpage.description = @"这是一个直播";
    webpage.thumbnailData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"AppIcon60x60@2x" ofType:@"png"]];
    webpage.webpageUrl = url;
    message.mediaObject = webpage;
    message.text = @"#亲加直播#";
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message authInfo:authRequest access_token:nil];
    
    [WeiboSDK sendRequest:request];
}

- (void)showIndicator
{
    _indicator.hidden = NO;
    [_indicator startAnimating];
}

- (void)hideIndicator
{
    _indicator.hidden = YES;
    [_indicator stopAnimating];
}

- (void)setTip:(NSString *)tip
{
    _tip.text = tip;
}

- (void)toggleChat:(BOOL)selected
{
    if (selected) {
        [self hideChatView];
        [_toggleChatBtn setImage:[UIImage imageNamed:@"btn_chat_off"] forState:UIControlStateNormal];
    } else {
        [self showChatView];
        [_toggleChatBtn setImage:[UIImage imageNamed:@"btn_chat_on"] forState:UIControlStateNormal];
    }
}

- (void)toggleMic:(BOOL)selected
{
    if (selected) {
        [_toggleMicBtn setImage:[UIImage imageNamed:@"btn_mic_off"] forState:UIControlStateNormal];
    } else {
        [_toggleMicBtn setImage:[UIImage imageNamed:@"btn_mic_on"] forState:UIControlStateNormal];
    }
    
    [_publisher setMute:selected];
}

- (void)toggleCamera:(BOOL)selected
{
    [_publisher toggleCamera];
    _toggleTorchBtn.selected =  !_publisher.torchOn;
    if (_toggleTorchBtn.selected) {
        [_toggleTorchBtn setImage:[UIImage imageNamed:@"btn_flash_off"] forState:UIControlStateNormal];
    } else {
        [_toggleTorchBtn setImage:[UIImage imageNamed:@"btn_flash_on"] forState:UIControlStateNormal];
    }
}

- (void)toggleTorh:(BOOL)selected
{
    [_publisher setTorchOn:!selected];
    _toggleTorchBtn.selected =  !_publisher.torchOn;
    if (_toggleTorchBtn.selected) {
        [_toggleTorchBtn setImage:[UIImage imageNamed:@"btn_flash_off"] forState:UIControlStateNormal];
    } else {
        [_toggleTorchBtn setImage:[UIImage imageNamed:@"btn_flash_on"] forState:UIControlStateNormal];
    }
}

- (void)toggleVolume:(BOOL)selected
{
    [_player setMute:selected];
}

- (void)toggleRec:(BOOL)selected
{
    if (selected) {
        [_toggleRecBtn setImage:[UIImage imageNamed:@"btn_rec_off"] forState:UIControlStateNormal];
        [self hideRecIcon];
        [_publisher endRecording:^(NSError *error) {
            if (error) {
                NSLog(@"保存录播失败%@", error);
            }
        }];
    } else {
        [_toggleRecBtn setImage:[UIImage imageNamed:@"btn_rec_on"] forState:UIControlStateNormal];
        if (_recBtn.selected) {
            [self showRecIcon];
            [_publisher beginRecording];
        }
    }
}

- (void)fadeIn:(UIView *)view
{
    view.hidden = NO;
    view.alpha = 0;
    [UIView animateWithDuration:.5 animations:^{
        view.alpha = 1.0;
    } completion:nil];
}

- (void)fadeOut:(UIView *)view
{
    [UIView animateWithDuration:.5 animations:^{
        view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (finished) {
            view.hidden = YES;
        }
    }];
}

- (void)showShareView
{
    _shareBG.hidden = NO;
    _shareDialog.alpha = 0;
    _shareDialog.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.1 animations:^{_shareDialog.alpha = 1.0;} completion:^(BOOL finished) {
        if (finished) {
        }
    }];
    
    CAKeyframeAnimation *bounceAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    bounceAnimation.values = @[@0.01f, @1.1f, @0.8f, @1.0f];
    bounceAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    bounceAnimation.duration = 0.4;
    [_shareDialog.layer addAnimation:bounceAnimation forKey:@"bounce"];
}

- (void)hideShareView
{
    _shareDialog.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        _shareDialog.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished){
        if (finished) {
            _shareBG.hidden = YES;
        }
    }];
}

- (void)showChatView
{
    _chatContentView.hidden = NO;
    [UIView animateWithDuration:.5 animations:^{
        _inputField.transform = CGAffineTransformMakeTranslation(0, -(self.view.height - _inputField.y));
        _chatContentView.alpha = 1.0;
    } completion:nil];
}

- (void)hideChatView
{
    [UIView animateWithDuration:.5 animations:^{
        _inputField.transform = CGAffineTransformMakeTranslation(0, self.view.height - _inputField.y);
        _chatContentView.alpha = 0.0;
    } completion:nil];
}

- (void)dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)startHideActionViewTimer
{
    if (_hideActionViewTimer) {
        return;
    }
    
    _hideActionViewTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideActionView) userInfo:nil repeats:NO];
}

- (void)stopHideActionViewTimer
{
    [_hideActionViewTimer invalidate];
    _hideActionViewTimer = nil;
}

- (void)resetHideActionViewTimer
{
    [self stopHideActionViewTimer];
    [self startHideActionViewTimer];
}

- (void)hideActionView
{
    [self stopHideActionViewTimer];
    [UIView animateWithDuration:.3 animations:^{
        _volumeView.alpha = 0;
        _fullscreenBtn.alpha = 0;
        if (_isLanscapeMode && !_isLiveMode) {
            _shareBtn.alpha = 0;
            _toggleChatBtn.alpha = 0;
            _presetBtn.alpha = 0;
        }
    }];
}

- (void)showActionView
{
    [UIView animateWithDuration:.3 animations:^{
        _volumeView.alpha = 1;
        _fullscreenBtn.alpha = 1;
        _shareBtn.alpha = 1;
        _toggleChatBtn.alpha = 1;
        _presetBtn.alpha = 1;
    } completion:^(BOOL finished) {
        if (finished) {
            [self startHideActionViewTimer];
        }
    }];
}

- (void)blinkRecIcon
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:1.0]];
    [animation setToValue:[NSNumber numberWithFloat:0.0]];
    [animation setDuration:0.5f];
    [animation setTimingFunction:[CAMediaTimingFunction
                                  functionWithName:kCAMediaTimingFunctionLinear]];
    [animation setAutoreverses:YES];
    [animation setRepeatCount:MAXFLOAT];
    [[_recIcon layer] addAnimation:animation forKey:@"opacity"];
}

- (void)stopBlinkRecIcon
{
    [[_recIcon layer]removeAllAnimations];
}

- (void)showRecIcon
{
    _recIcon.hidden = NO;
    [self blinkRecIcon];
}

- (void)hideRecIcon
{
    _recIcon.hidden = YES;
    [self stopBlinkRecIcon];
}

- (void)keyboardWillChange:(NSNotification *)note
{
    if (_emojiBtn.selected) {
        return;
    }
    
    UIView *viewToChange = _inputField;
    CGFloat offset = _chatView.y;
    BOOL isKeyboardShowing = [note.name isEqualToString:UIKeyboardWillShowNotification];
    
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - (viewToChange.frame.origin.y + viewToChange.frame.size.height + offset);
    
    if (!isKeyboardShowing) {
        if (moveY < 0) {
            return;
        }
        moveY = MIN(moveY, -viewToChange.transform.ty);
    }
    
    [UIView animateWithDuration:duration animations:^{
        viewToChange.transform = CGAffineTransformTranslate(viewToChange.transform, 0, moveY);
        _chatContentView.transform = CGAffineTransformTranslate(_chatContentView.transform, 0, moveY);
        if (isKeyboardShowing) {
            _inputField.width = self.view.width - _inputField.x * 2;
        } else {
            _inputFieldTrailingConstraint.active = NO;
            _inputFieldTrailingConstraint.active = YES;
            [_inputField layoutIfNeeded];
        }
    } completion:nil];
}

- (void)forceLogout
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"你的账号在别处登录了！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self closeClick:nil];
    }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)updateRoomUserCount
{
    [_session getLiveContextOnSuccess:^(GLLiveContext *liveContext) {
        _currentUserCount = liveContext.playUserCount;
        if (_player.state == GLPlayerStateStarted || _publisher.state == GLPublisherStatePublished) {
            [self setTip:[NSString stringWithFormat:@"观看人数: %ld", (long)_currentUserCount]];
        }
        
    } failure:^(NSError *error) {
        NSLog(@"getLiveContext %@", error);
    }];
}

#pragma mark - text field delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self showEmoji:NO];
}

#pragma mark - collection view delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _emojiPageControl.currentPage = _emojiCollectionView.contentOffset.x / _emojiCollectionView.width;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _emojiImages.count;
}


// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"emoji";
    static NSInteger emojiTag = 110;
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    UIImageView *emojiView = [(UIImageView *) cell viewWithTag:emojiTag];
    if (!emojiView) {
        emojiView = [[UIImageView alloc]init];
        emojiView.tag = emojiTag;
        [cell.contentView addSubview:emojiView];
    }
    
    UIImage *emoji = _emojiImages[indexPath.row];
    emojiView.image = emoji;
    emojiView.frame = cell.bounds;
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *text = _inputField.text;
    NSString *toAppend = [NSString stringWithFormat:@"[s%ld]", (long)indexPath.row + 1];
    if (text) {
        text = [text stringByAppendingString:toAppend];
    } else {
        text = toAppend;
    }
    
    _inputField.text = text;
}

#pragma mark - 聊天回调

- (void)chatClientDidReceiveMessage:(GLChatMessage *)msg room:(NSString *)roomId;
{
    if (msg.type == GLChatMessageTypeNotify && [msg.text isEqualToString:@"enter"]) {
        [_chatContentView addCellWithName:msg.sendName comment:@"进入了频道"];
        [self updateRoomUserCount];
    } else {
        [_chatContentView addCellWithName:msg.sendName comment:msg.text];
    }
}

- (void)chatClientDidForceLogout:(NSString *)roomId;
{
    [self forceLogout];
}

#pragma mark - 视频播放回调

- (void)playerDidConnect:(GLPlayer *)player;
{
    NSLog(@"playerDidConnect");
    _player.playerView.backgroundColor = [UIColor blackColor];
    [self hideIndicator];
    [self setTip:nil];
    [self updateRoomUserCount];
    [_presetBtn setTitle:[self stringForVideoQuality:_player.videoQuality] forState:UIControlStateNormal];
    if (_isLanscapeMode) {
        _presetBtn.hidden = NO;
    }
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES] ;
}

- (void)playerReconnecting:(GLPlayer *)player;
{
    NSLog(@"playerReconnecting");
    [self setTip:@"重新连线中..."];
    [self showIndicator];
}

- (void)onLiveStart:(GLRoomPlayer *)player;
{
    NSLog(@"playerOnLiveStart");
    [self setTip:@"正在开始直播..."];
    [self showIndicator];
}

- (void)onLiveStop:(GLRoomPlayer *)player;
{
    NSLog(@"playerOnLiveStop");
    [self setTip:@"直播已结束！"];
    [self hideIndicator];
}

- (void)player:(GLPlayer *)player onError:(NSError *)error;
{
    NSLog(@"playerOnError: %@ ", error);
    
    [self hideIndicator];
    [self setTip:error.localizedDescription];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}

#pragma 视频直播回调

- (void)publisherDidConnect:(GLPublisher *)publisher;
{
    _recBtn.enabled = YES;
    _recBtn.selected = YES;
    [_recBtn setImage:[UIImage imageNamed:@"btn_stop"] forState:UIControlStateNormal];
    _timeLabel.hidden = NO;
    if (_toggleRecBtn.selected) {
        [self hideRecIcon];
    } else {
        [self showRecIcon];
        [_publisher beginRecording];
    }
    [self startPublishTimer];
    [self hideIndicator];
    [self setTip:nil];
    [self updateRoomUserCount];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES] ;
    
    _pushLiveStreamTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(PushLiveStream) userInfo:nil repeats:YES];
    [_pushLiveStreamTimer fire];
}

- (void)publisher:(GLPublisher *)publisher onError:(NSError *)error;
{
    [self publishDidStop];
    [self hideIndicator];
    [self setTip:error.localizedDescription];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}

- (void)publisherReconnecting:(GLPublisher *)publisher;
{
    [self setTip:@"重新连线中..."];
    [self showIndicator];
}

- (void)publisherDidForceLogout:(GLRoomPublisher *)publisher;
{
    [self publishDidStop];
    [self forceLogout];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}

- (void)publisherDidDisconnected:(GLPublisher *)publisher;
{
    [self publishDidStop];
    [self setTip:nil];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO] ;
}


//与服务器交互
- (void)PushLiveStream
{
    NSLog(@"====");
    int romId = [_roomId intValue];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    [parameters setObject:@(romId) forKey:@"liveRoomId"];
    [parameters setObject:@(1) forKey:@"status"];
    [parameters setObject:@(60) forKey:@"timeout"];

    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [_requestClient postddByByUrlPath:@"/live/PushLiveStream" andParams:parameters andCallBack:^(id back) {
        if ([back isKindOfClass:[NSString class]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }

        NSDictionary *dics = back;
        NSLog(@"====%@", dics);
        int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
        if (result_type == 10000) {
            
            NSLog(@"%@", dics);
        
        }else if (result_type  == 10003) {
            AppDelegateInstance.userInfo.isLogin = NO;
            [_requestClient reLogin_andCallBack:^(BOOL back) {
                if (back) {
                    
                    [self PushLiveStream];
                }
            }];
            
        }else {
           
        }
    }];
    
}

- (void)PushLiveStreamOff
{
    int romId = [_roomId intValue];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:AppDelegateInstance.userInfo.sessionId forKey:@"sessionId"];
    [parameters setObject:@(romId) forKey:@"liveRoomId"];
    [parameters setObject:@(0) forKey:@"status"];
    [parameters setObject:@(60) forKey:@"timeout"];
    
    if (_requestClient == nil) {
        _requestClient = [[QMZBNetwork alloc] init];
    }
    [_requestClient postddByByUrlPath:@"/live/PushLiveStream" andParams:parameters andCallBack:^(id back) {
        if ([back isKindOfClass:[NSString class]]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:back delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            return;
        }

        NSDictionary *dics = back;
        NSLog(@"%@", dics);
        int result_type = [[NSString jsonUtils:[dics objectForKey:@"status"]] intValue];
        if (result_type == 10000) {
            
            NSLog(@"%@", dics);
            
        }else if (result_type  == 10003) {
            AppDelegateInstance.userInfo.isLogin = NO;
            [_requestClient reLogin_andCallBack:^(BOOL back) {
                if (back) {
                    
                    [self PushLiveStreamOff];
                }
            }];
            
        }else {
            
        }
    }];
    
}

@end
