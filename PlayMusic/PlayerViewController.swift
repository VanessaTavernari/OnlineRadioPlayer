//
//  ViewController.swift
//  PlayMusic
//
//  Created by Vanessa Tavares Tavernari on 21/02/2022.
//


import UIKit
import AVFoundation
import MessageUI
import Combine

class PlayerViewController: UIViewController, MFMailComposeViewControllerDelegate {
    

    let pauseImage = UIImage(named: "pauseButtonIcon")
    let playImage = UIImage(named: "playButtonIcon")
    
    var player = RadioStreamPlayer()
     
    @IBOutlet var playOrPauseButton: UIButton!
    @IBOutlet var phoneButton: UIButton!
    @IBOutlet var facebookButton: UIButton!
    @IBOutlet var instagramButton: UIButton!
    
    @IBOutlet var autoPlayText: UILabel!
    @IBOutlet var optionSwitch: UISwitch!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!

    
    var playingCancellable: AnyCancellable?
    var bufferingCancellable: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.shouldAutoPlay() == true {
            optionSwitch.setOn(true, animated: true)
            autoPlayText.text = "Auto play ligado"
            self.player.playRadio()
    
            
        } else {
            optionSwitch.setOn(false, animated: true)
            autoPlayText.text = "Auto play desligado"
        }
        
        self.phoneButton.imageView?.contentMode = .scaleAspectFit
        self.facebookButton.imageView?.contentMode = .scaleAspectFit
        self.instagramButton.imageView?.contentMode = .scaleAspectFit
        self.playOrPauseButton.imageView?.contentMode = .scaleAspectFit
        
        self.playingCancellable = player.isPlaying.sink { isPlaying in
            
            if isPlaying {
                
                self.playOrPauseButton.setImage(self.pauseImage, for: .normal)
            } else {
                
                self.playOrPauseButton.setImage(self.playImage, for: .normal)
            }
        }
        
        self.bufferingCancellable = player.isBuffering.sink { isBuffering in
            
            if isBuffering {
                print("is buffering")
                self.activityIndicator.startAnimating()
                
            } else {
                print("stop buffering")
                self.activityIndicator.stopAnimating()
            }
        }
    }
}

// MARK: Player functions

extension PlayerViewController {

    @IBAction func playOrPause() {
        player.togglePlayOrPause()
    }
}

// MARK: Phone functions

extension PlayerViewController {
  
    @IBAction func makeCall() {
        if let phoneNumber = URL(string: "tel://+552433531794"),
           UIApplication.shared.canOpenURL(phoneNumber) {
            
                UIApplication.shared.open(phoneNumber)
        }
    }
    
    @IBAction func openInstagram() {
        let instagramPage = NSURL(string:  "https://instagram.com/colonia.fm?utm_medium=copy_link")
        if UIApplication.shared.canOpenURL(instagramPage! as URL) {
            
            UIApplication.shared.open(instagramPage! as URL, options: [:], completionHandler: nil)
            
        } else {
          
            UIApplication.shared.open(NSURL(string: "http://instagram.com/")! as URL)
        }
    }
    
    @IBAction func openFacebook() {
        let facebookPage = NSURL(string: "https://www.facebook.com/coloniafm/")
        if UIApplication.shared.canOpenURL(facebookPage! as URL) {
            UIApplication.shared.open(facebookPage! as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.open(NSURL(string: "https://www.facebook.com/coloniafm/")! as URL)
        }
    }

//    @IBAction func sendEmail() {
//        if !MFMailComposeViewController.canSendMail() {
//            print("mail services are not available")
//            return
//        }
//
//        let setEmail = MFMailComposeViewController()
//        setEmail.mailComposeDelegate = self
//
//        setEmail.setToRecipients(["vanessa.tavernari@gmail.com"])
//        setEmail.setSubject("Help")
//        setEmail.setMessageBody("I need help", isHTML: false)
//
//        self.present(setEmail, animated: true, completion: nil)
//    }
//
//    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
//        controller.dismiss(animated: true, completion: nil)
//    }
    
    @IBAction func onClickSwitch(_ sender: UISwitch) {
        
        if sender.isOn == false {
            UserDefaults.standard.setShouldAutoPlay(value: false)
            autoPlayText.text = "Auto play desligado"
        } else {
            UserDefaults.standard.setShouldAutoPlay(value: true)
            autoPlayText.text = "Auto play ligado"
        }
    }
}
