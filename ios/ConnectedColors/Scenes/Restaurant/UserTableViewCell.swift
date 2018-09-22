//
//  UserTableViewCell.swift
//  ConnectedColors
//
//  Created by ZhongZhongzhong on 2018-09-22.
//  Copyright © 2018 Example. All rights reserved.
//

import UIKit

class UserTableViewCell: BaseTableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    override class var cellHeight: CGFloat { return 60.0 }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with user: User) {
        nameLabel.text = (user.giveName ?? "") + " " + (user.surname ?? "")
        
        messageLabel.text = user.occupationIndustry
        
        genderLabel.text = user.gender?.rawValue
    }
    
}
