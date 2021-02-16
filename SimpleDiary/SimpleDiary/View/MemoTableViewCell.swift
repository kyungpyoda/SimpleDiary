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
    
    // MARK: Constants
    
    static let identifier = String(describing: MemoTableViewCell.self)
    
    // MARK: Properties
    
    var delegate: ChangeMemoStateDelegate?
    var state: MemoState = .notInProgress

    // MARK: Views
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var stateButton: UIButton!
    
    // MARK: Initialize
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(memo: Memo) {
        self.contentLabel.text = memo.content
        let state = MemoState(rawValue: memo.state ?? "") ?? .notInProgress
        setState(to: state)
    }
    
    // MARK: Methods
    
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

// MARK: MemoState

extension MemoTableViewCell {
    enum MemoState: String {
        case notInProgress
        case delayed
        case inProgress
        case done
    }
}
