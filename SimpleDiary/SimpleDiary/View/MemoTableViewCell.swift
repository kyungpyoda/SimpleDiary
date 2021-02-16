//
//  MemoTableViewCell.swift
//  SimpleDiary
//
//  Created by 홍경표 on 2021/02/09.
//

import UIKit

protocol ChangeMemoStateDelegate {
    func changeState(of cell: MemoTableViewCell)
}
class MemoTableViewCell: UITableViewCell {
    static let identifier = String(describing: MemoTableViewCell.self)
    
    var delegate: ChangeMemoStateDelegate?
    var state: MemoState = .notInProgress

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure(memo: Memo) {
        self.contentLabel.text = memo.content
        let state = MemoState(rawValue: memo.state ?? "") ?? .notInProgress
        setState(to: state)
    }
    
    private func setState(to state: MemoState) {
        self.state = state
        switch state {
        case .notInProgress:
            self.stateButton.setTitle("X", for: .normal)
        case .delayed:
            self.stateButton.setTitle("->", for: .normal)
        case .inProgress:
            self.stateButton.setTitle("~~", for: .normal)
        case .done:
            self.stateButton.setTitle("O", for: .normal)
        }
    }
    
    @IBAction func touchedChangeState(_ sender: Any) {
        delegate?.changeState(of: self)
    }
}

extension MemoTableViewCell {
    enum MemoState: String {
        case notInProgress
        case delayed
        case inProgress
        case done
    }
}
