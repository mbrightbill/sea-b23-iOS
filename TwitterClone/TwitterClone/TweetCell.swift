//
//  TweetCell.swift
//  TwitterClone
//
//  Created by Bradley Johnson on 10/9/14.
//  Copyright (c) 2014 Code Fellows. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!

    @IBOutlet weak var tweetLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
