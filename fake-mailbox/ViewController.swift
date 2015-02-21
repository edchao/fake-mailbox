//
//  ViewController.swift
//  fake-mailbox
//
//  Created by Ed Chao on 2/16/15.
//  Copyright (c) 2015 edchao. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var mainSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    @IBOutlet weak var msgContainerView: UIView!
    @IBOutlet weak var msgImageView: UIImageView!
    
    @IBOutlet weak var msgColorView: UIView!
    @IBOutlet weak var leftIcon: UIImageView!
    @IBOutlet weak var rightIcon: UIImageView!
    
    @IBOutlet weak var overlayView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    
    
    @IBOutlet weak var archiveScrollView: UIScrollView!
    @IBOutlet weak var archiveImageView: UIImageView!
    
    @IBOutlet weak var laterScrollView: UIScrollView!
    @IBOutlet weak var laterImageView: UIImageView!
    
    var containerCenter : CGPoint!
    var originCenter : CGPoint!
    
    let greenColor = UIColor(red: 98/255, green: 217/255, blue: 98/255, alpha: 1)
    let redColor = UIColor(red: 239/255, green: 84/255, blue: 12/255, alpha: 1)
    let yellowColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
    let brownColor = UIColor(red: 216/255, green: 166/255, blue: 116/255, alpha: 1)
    let blueColor = UIColor(red: 81/255, green: 185/255, blue: 219/255, alpha: 1)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overlayView.alpha = 0
        self.listView.alpha = 0
        
        originCenter = msgImageView.center
        mainScrollView.contentSize = CGSize(width: 320, height: 1288)
        
        // Scroll Setups
        mainScrollView.center.x = 160
        archiveScrollView.center.x = 480
        
        // Attach edge Pan to container View
        var edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        self.containerView.addGestureRecognizer(edgeGesture)
        edgeGesture.delegate = self
        

        
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(motion: UIEventSubtype, withEvent event: UIEvent) {
        if(event.subtype == UIEventSubtype.MotionShake) {
            self.slideDownFeed()
            delay(0.4) {
                self.springBack()
            }
            
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            //Started
            containerCenter = self.containerView.center
            
        }else if sender.state == UIGestureRecognizerState.Changed {
            //Changing
            self.containerView.center = CGPoint(x: containerCenter.x + translation.x, y: containerCenter.y)
            
        }else if sender.state == UIGestureRecognizerState.Ended {
            //Ended
            self.containerView.center = CGPoint(x: containerView.center.x + translation.x, y: containerCenter.y)

            if velocity.x > 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 20, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    self.containerView.center.x = 400
                }, completion: { (Bool) -> Void in
                    var containerPanGesture = UIPanGestureRecognizer(target: self, action: "onContainerPan:")
                    self.containerView.addGestureRecognizer(containerPanGesture)
                    containerPanGesture.delegate = self
                })
            }else if velocity.x < 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 20, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    self.containerView.center.x = 160
                    }, completion: { (Bool) -> Void in
                        //
                })
            }
            
            
        }
    }

    func onContainerPan(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        var velocity = sender.velocityInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            //Started to Pan
            containerCenter = self.containerView.center
            
        }else if sender.state == UIGestureRecognizerState.Changed {
            //Panning
            self.containerView.center = CGPoint(x: containerCenter.x + translation.x, y: containerCenter.y)
            
            
            
        }else if sender.state == UIGestureRecognizerState.Ended {
            //Ended
            if velocity.x > 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 20, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    self.containerView.center.x = 400
                    }, completion: { (Bool) -> Void in
                        //
                })
            }else if velocity.x < 0 {
                UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 20, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                    self.containerView.center.x = 160
                    }, completion: { (Bool) -> Void in
                        //
                })
            }

            
        }
    }

    
    @IBAction func didPanMsg(sender: UIPanGestureRecognizer) {
        var location = sender.locationInView(view)
        var translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            //
        }else if sender.state == UIGestureRecognizerState.Changed {

            
            
            // Movement
            msgImageView.center.x = translation.x + originCenter.x
            self.leftIcon.center.x = msgImageView.center.x - 160 - 30
            self.rightIcon.center.x = msgImageView.center.x + 160 + 30
            
            // Conditionals
            if msgImageView.center.x < 240 && msgImageView.center.x > 80{
                msgColorView.backgroundColor = UIColor.lightGrayColor()
                self.rightIcon.image = UIImage(named: "later_icon.png")
                self.leftIcon.image = UIImage(named: "archive_icon.png")

            }else if msgImageView.center.x <= 80 && msgImageView.center.x > 0{
                msgColorView.backgroundColor = yellowColor
                self.rightIcon.image = UIImage(named: "later_icon.png")

            }else if msgImageView.center.x < 0 {
                msgColorView.backgroundColor = brownColor
                self.rightIcon.image = UIImage(named: "list_icon.png")

            }else if msgImageView.center.x >= 240 && msgImageView.center.x < 320{
                msgColorView.backgroundColor = greenColor
                self.leftIcon.image = UIImage(named: "archive_icon.png")

            }else if msgImageView.center.x > 320 {
                msgColorView.backgroundColor = redColor
                self.leftIcon.image = UIImage(named: "delete_icon.png")

            }

            
        }else if sender.state == UIGestureRecognizerState.Ended {
        
            
            if msgImageView.center.x < 240 && msgImageView.center.x > 80{
                springBack()
            }else if msgImageView.center.x <= 80 && msgImageView.center.x > 0 {
                springLeft()
                showView(self.overlayView)
            }else if msgImageView.center.x < 0 {
                springLeft()
                showView(self.listView)
            }else if msgImageView.center.x >= 240 && msgImageView.center.x < 320{
                springRight()
            }else if msgImageView.center.x > 320 {
                springRight()
            }
            
        
        }
        
    }
    
    
    @IBAction func didTapOverlay(sender: UITapGestureRecognizer) {
        hideView(self.overlayView)
    }
    
    @IBAction func didTapList(sender: UITapGestureRecognizer) {
        hideView(self.listView)
    }
    
    func springBack() {

        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 20, options:UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.msgImageView.center.x = 160
            }, completion: { (Bool) -> Void in
                //
        })
    }
    
    func springRight() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 20, options:UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.msgImageView.center.x = 480
            // Icon Movement
            self.leftIcon.center.x = self.msgImageView.center.x - 160 - 30
            self.rightIcon.center.x = self.msgImageView.center.x + 160 + 30
            }, completion: { (Bool) -> Void in
                self.slideUpFeed()
        })
    }
    
    func springLeft() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.5, initialSpringVelocity: 20, options:UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.msgImageView.center.x = -160
            // Icon Movement
            self.leftIcon.center.x = self.msgImageView.center.x - 160 - 30
            self.rightIcon.center.x = self.msgImageView.center.x + 160 + 30
            }, completion: { (Bool) -> Void in
                self.slideUpFeed()
        })
    }

    func slideUpFeed() {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.9, initialSpringVelocity: 2, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.feedImageView.center.y = 601
            }, completion: { (Bool) -> Void in
                //
        })

    }
    
    func slideDownFeed(){
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1.9, initialSpringVelocity: 2, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.feedImageView.center.y = 687
            }, completion: { (Bool) -> Void in
                //
        })
    }
    
    func showView(target: UIView) {
        
        UIView.animateWithDuration(0.5, delay: 0.5, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            target.alpha = 1
        }) { (Bool) -> Void in
            //
        }
        
    }
    
    func hideView(target: UIView) {
        UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            target.alpha = 0
            }) { (Bool) -> Void in
                //
        }
        
    }
    
    
    

    @IBAction func didSwitchSegment(sender: AnyObject) {
        var segmentIndex = self.mainSegmentedControl.selectedSegmentIndex
        println(segmentIndex)
        if segmentIndex == 0 {
            
            self.mainSegmentedControl.tintColor = yellowColor
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.laterScrollView.center.x = 160
                self.mainScrollView.center.x = 480
                self.archiveScrollView.center.x = 800

            }, completion: { (Bool) -> Void in
                //
            })
        }else if segmentIndex == 1 {
            self.mainSegmentedControl.tintColor = blueColor

            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.laterScrollView.center.x = -160
                self.mainScrollView.center.x = 160
                self.archiveScrollView.center.x = 480
                
                }, completion: { (Bool) -> Void in
                    //
            })
        }else if segmentIndex == 2 {
            
            self.mainSegmentedControl.tintColor = greenColor

            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
                self.laterScrollView.center.x = -800
                self.mainScrollView.center.x = -160
                self.archiveScrollView.center.x = 160
                
                }, completion: { (Bool) -> Void in
                    //
            })

        }
    }
    
    

    
    

}

