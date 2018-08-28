//
//  searchQRcodeOrTouchIDTableViewCell.swift
//  miniProject
//
//  Created by 楷岷 張 on 2018/8/28.
//  Copyright © 2018年 楷岷 張. All rights reserved.
//

import UIKit

enum searchQRcodeOrTouchIDCellType {
    case touchID
    case QRcode
}

protocol searchQRcodeOrTouchIDCellDelegate: class {
    func qrcodeSwitchValueChange(isOn: Bool)
}

class SearchQRcodeOrTouchIDTableViewCell: UITableViewCell {
    
    var cellType: searchQRcodeOrTouchIDCellType = .touchID {
        didSet {
            switch cellType {
            case .QRcode:
                titleImageView.image = UIImage(named: "qrcode")
                titleLabel.text = "新增相簿"
                touchIDSwitch.isHidden = true
                self.selectionStyle = .default
            case .touchID:
                titleImageView.image = UIImage(named: "Touch ID")
                titleLabel.text = "Touch ID登入"
                touchIDSwitch.isHidden = false
                self.selectionStyle = .none
            }
        }
    }
    
    var isOn: Bool? {
        didSet {
            guard let isOn = isOn else { return }
            touchIDSwitch.isOn = isOn
        }
    }
    
    weak var delegate: searchQRcodeOrTouchIDCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUserInterface()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - private Method
    
    private func setUserInterface() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        contentView.addSubviews([titleImageView, titleLabel, touchIDSwitch])
        
        let views: [String: Any] = ["titleImageView": titleImageView, "titleLabel": titleLabel, "touchIDSwitch": touchIDSwitch]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[titleImageView]-5-|",
            options: [],
            metrics: nil,
            views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[titleLabel]-5-|",
            options: [],
            metrics: nil,
            views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-5-[touchIDSwitch]-5-|",
            options: [],
            metrics: nil,
            views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-20-[titleImageView(30)]-20-[titleLabel]",
            options: [],
            metrics: nil,
            views: views))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[touchIDSwitch(50)]-20-|",
            options: [],
            metrics: nil,
            views: views))
    }
    
    // MARK: - init Element
    
    lazy private var touchIDSwitch: UISwitch = {
        let view = UISwitch()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = TAStyle.orange
        view.onTintColor = TAStyle.orange
        view.addTarget(self, action: #selector(touchIDSwitchValueChange(sender:)), for: .valueChanged)
        return view
    }()
    
    lazy private var titleImageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit
        view.tintColor = TAStyle.orange
        return view
    }()
    
    lazy private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = TAStyle.orange
        return label
    }()
    
    // MARK: - Action Method
    
    @objc private func touchIDSwitchValueChange(sender: UISwitch) {
        delegate?.qrcodeSwitchValueChange(isOn: sender.isOn)
    }
}
