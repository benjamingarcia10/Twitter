//
//  TweetCell.swift
//  Twitter
//
//  Created by Benjamin Garcia on 9/17/20.
//  Copyright © 2020 Dan. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var tweetContentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func enableDarkMode() {
        backgroundColor = UIColor.black
        userNameLabel.textColor = UIColor.white
        tweetContentLabel.textColor = UIColor.white
    }
    
    func disableDarkMode() {
        backgroundColor = UIColor.white
        userNameLabel.textColor = UIColor.black
        tweetContentLabel.textColor = UIColor.black
    }

}
