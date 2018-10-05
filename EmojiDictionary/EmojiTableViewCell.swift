/* EmojiTableViewCell.swift
   EmojiDictionary
   Creates a dictionary of emojis, allowing the user to add, remove, or edit items.
   Created by Nour Yehia on 8/16/18.
   Copyright © 2018 Nour Yehia. All rights reserved. */

import UIKit

class EmojiTableViewCell: UITableViewCell {
    
    // Declare outlets
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Updates cell with right symbol, name, and description.
    func update(with emoji: Emoji){
        symbolLabel.text = "\(emoji.symbol)   "
        nameLabel.text = emoji.name
        descriptionLabel.text = emoji.description
    }
}
