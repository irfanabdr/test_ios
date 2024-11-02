//
//  CourseTableViewCell.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import UIKit
import SDWebImage

class CourseTableViewCell: UITableViewCell {
    
    static let identifier = "CourseTableViewCell"
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imageThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPresenterName: UILabel!
    @IBOutlet weak var labelDescription: UILabel!
    
    func configure(with course: Course) {
        labelTitle.text = course.title
        labelPresenterName.text = course.presenterName
        labelDescription.text = course.description
        imageThumbnail.sd_setImage(with: URL(string: course.thumbnailURL))
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewContainer.clipsToBounds = false
        viewContainer.layer.cornerRadius = 4
        viewContainer.layer.shadowColor = UIColor.black.cgColor
        viewContainer.layer.shadowOpacity = 0.2
        viewContainer.layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
}
