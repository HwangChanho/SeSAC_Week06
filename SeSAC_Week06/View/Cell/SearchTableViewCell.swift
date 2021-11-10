//
//  SearchTableViewCell.swift
//  SeSAC_Week06
//
//  Created by ChanhoHwang on 2021/11/02.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = "SearchTableViewCell"

    @IBOutlet weak var imageViewS: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var writeDate: UILabel!
    @IBOutlet weak var regDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(row: UserDiary) {
        titleLabel.text = row.diaryTitle
        
        let format = DateFormatter()
        format.dateFormat = "yyyy년 MM월 dd일"
        regDate.text = format.string(from: row.regDate)
        writeDate.text = format.string(from: row.writeDate)
    }
}
