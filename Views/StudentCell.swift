//
//  TableViewCell.swift
//  Map boy
//
//  Created by Fish on 15/11/2019.
//  Copyright © 2019 Fish. All rights reserved.
//

import UIKit

class StudentCell: UITableViewCell {
    
    let name: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .purple
        return lbl
    }()
    
    let link: UILabel =
    {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .purple
        return lbl
    }()
    
    let stack: UIStackView =
    {
        let stck = UIStackView()
        stck.axis = .horizontal
        stck.distribution = .fillEqually
        stck.alignment = .center
        stck.spacing = 8
        stck.translatesAutoresizingMaskIntoConstraints = false
        return stck
    }()
    
    var studentLocation: StudentLocation? {
        didSet {
            guard let studentLocation = studentLocation else { return }
            name.text = "\(studentLocation.firstName ?? "") \(studentLocation.lastName ?? "")"
            link.text = studentLocation.mediaURL
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func setupViews()
    {
        //add media view + video icon
        self.addSubview(stack)
        stack.addArrangedSubview(name)
        stack.addArrangedSubview(link)
        
        //constraint media view + video icon
        addConstraints([
            stack.topAnchor.constraint(equalTo: self.topAnchor, constant: 2),
            stack.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -2),
            stack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 4),
            stack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -4)
        ])
        
        backgroundColor = .systemYellow
        
    }
    
}
