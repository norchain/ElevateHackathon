//
//  BaseTableViewCell.swift
//  FaceGPS
//
//  Created by Zhenjiang Liu on 2018-09-09.
//  Copyright © 2018 zhenjiang. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    
    class var hasNib: Bool { return true }
    
    class var cellHeight: CGFloat { return 60.0 }
    
    class var cellType: String { return String(describing: self) }
    
    var tapColor: UIColor? { return UIColor.blue }
    /// The `backgroundColor` property of the cell is changed
    /// when the user highlights it, so subclasses should set this property.
    /// Should be done BEFORE `super.awakeFromNib()`
    /// or `super.configureView()` in subclasses.
    var baseBackgroundColor: UIColor { return .white }
    
    var separatorViewColor: UIColor { return .clear }
    
    fileprivate lazy var separatorView: UIView = {
        $0.backgroundColor = self.separatorViewColor
        self.addSubview($0)
        // Autolayout constraints
        $0.translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraint = $0.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        let bottomConstraint = $0.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        let widthConstraint = $0.widthAnchor.constraint(equalTo: self.widthAnchor)
        let heightConstraint = $0.heightAnchor.constraint(equalToConstant: self.separatorHeight)
        NSLayoutConstraint.activate([horizontalConstraint, bottomConstraint, widthConstraint, heightConstraint])
        return $0
    }(UIView())
    
    var separatorHeight: CGFloat = 1 {
        didSet {
            guard separatorHeight > 0 else {
                separatorView.isHidden = true
                return
            }
            
            separatorView.heightAnchor.constraint(equalToConstant: separatorHeight)
            layoutIfNeeded()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configureView()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        var frame = contentView.frame
        frame.size.height -= separatorHeight
        contentView.frame = frame
    }
    
    // Mark: - helper
    
    func configureView() {
        backgroundColor = baseBackgroundColor
        selectionStyle = .none
        // firing off `didSet`
        let s = separatorHeight
        separatorHeight = s
        
        // the left-padding for the default `textLabel` in `UITableViewCell`
        // note: should match constraints in `ImageLabelCell`
        indentationLevel = 1
        indentationWidth = 10
    }
    
    
}
