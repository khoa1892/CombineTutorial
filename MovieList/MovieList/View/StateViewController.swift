//
//  StateViewController.swift
//  MovieList
//
//  Created by Khoa Mai on 9/21/21.
//

import UIKit

class StateViewController: UIViewController {
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showStartSearch() {
        updateState(viewModel: StateViewModel.startSearch)
    }

    func showNoResults() {
        updateState(viewModel: StateViewModel.noResults)
    }

    fileprivate func updateState(viewModel: StateViewModel) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
    }
}
