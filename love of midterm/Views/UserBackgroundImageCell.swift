//
//  UserBackgroundImageCell.swift
//  love of midterm
//
//  Created by 신동규 on 2020/03/20.
//  Copyright © 2020 Mac circle. All rights reserved.
//

import UIKit
import SDWebImage

protocol  UserBackgroumdImageCellDelegate:class {
    func presentOneUserBackgroundImageController(cell:UserBackgroundImageCell)
}

class UserBackgroundImageCell: UICollectionViewCell {
    
    // MARK: Properties
    
    weak var delegate:UserBackgroumdImageCellDelegate?
    
    var backgroundImageId:String? {
        didSet {
            fetchBackgroundImage()
        }
    }
    
    var backgroundImageUrl:String?
    
    // MARK: UIKits
    
    lazy var imageView:UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .veryLightGray
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    // MARK: Life cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: Selectors
    
    @objc func imageTapped(){
        self.delegate?.presentOneUserBackgroundImageController(cell: self)
    }
    
    // MARK: APIs
    
    func fetchBackgroundImage(){
        guard let id = backgroundImageId else { return }
        BackgroundImageService.shared.fetchBackgroundImageWithId(id: id) { (error, backgroundImage) in
            if let error = error {
                print(error.localizedDescription)
            }else {
                self.backgroundImageUrl = backgroundImage!.downloadUrl
                if let url = URL(string: backgroundImage!.downloadUrl) {
                    self.imageView.sd_setImage(with: url, completed: nil)
                }
            }
        }
    }
    
    // MARK: Configure
    
    
    
    func configure(){
        configureUI()
    }
    
    func configureUI(){
        addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
}
