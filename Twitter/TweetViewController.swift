//
//  TweetViewController.swift
//  Twitter
//
//  Created by Benjamin Garcia on 9/23/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var tweetTextView: UITextView!
    @IBOutlet weak var tweetLengthLabel: UILabel!
    @IBOutlet weak var tweetContentHeightConstraint: NSLayoutConstraint!
    // Set the max character limit
    let characterLimit = 280
    let minimumTextViewHeight = 150
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.becomeFirstResponder()
        // Do any additional setup after loading the view.
        
        tweetTextView.delegate = self
        tweetTextView.layer.borderColor = UIColor.systemTeal.cgColor
        tweetTextView.layer.borderWidth = 1.0
        tweetTextView.layer.cornerRadius = 5.0
        tweetContentHeightConstraint.constant = CGFloat(minimumTextViewHeight)
        tweetLengthLabel.text = "Tweet Length: \(tweetTextView.text.count) / \(characterLimit)"
         adjustTextViewHeight()
    }
    
    func adjustTextViewHeight() {
        let fixedWidth = tweetTextView.frame.size.width
        let newSize = tweetTextView.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        if (newSize.height > CGFloat(minimumTextViewHeight)) {
            tweetContentHeightConstraint.constant = newSize.height
            view.layoutIfNeeded()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
         self.adjustTextViewHeight()
        tweetLengthLabel.text = "Tweet Length: \(tweetTextView.text.count) / \(characterLimit)"
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // TODO: Check the proposed new text character count
        // Allow or disallow the new text
        // Construct what the new text would be if we allowed the user's latest edit
        let newText = NSString(string: textView.text!).replacingCharacters(in: range, with: text)

        // The new text should be allowed? True/False
        return newText.count <= characterLimit
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tweet(_ sender: Any) {
        if (!tweetTextView.text.isEmpty) {
            TwitterAPICaller.client?.postTweet(tweetString: tweetTextView.text, success: {
                self.dismiss(animated: true, completion: nil)
            }, failure: { (error) in
                print(error)
                self.dismiss(animated: true, completion: nil)
            })
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
