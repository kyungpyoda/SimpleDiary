//
//  MemoTableViewCell.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/09.
//

import UIKit

class MemoTableViewCell: UITableViewCell {
    static let identifier = String(describing: MemoTableViewCell.self)

    @IBOutlet weak var contentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(content: String) {
        self.contentLabel.text = content
    }
}
