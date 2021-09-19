//
//  DetailViewController.swift
//  MovieList
//
//  Created by Khoa Mai on 9/17/21.
//

import UIKit
import Combine
import SDWebImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak private var thumbnailView: UIImageView!
    @IBOutlet weak private var titleLbl: UILabel!
    @IBOutlet weak private var ratingLbl: UILabel!
    @IBOutlet weak private var overviewLbl: UITextView!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    let appear = PassthroughSubject<Void, Never>()
    let favourite = PassthroughSubject<Bool, Never>()
    
    var viewModel: DetailViewModel!
    
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBinding()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }
    
    private func configureBinding() {
        
        let output = viewModel.initInput(input: DetailViewModelInput.init(appear: appear.eraseToAnyPublisher(), favourite: favourite.eraseToAnyPublisher()))
        
        output.sink { [weak self] state in
            self?.loadState(state)
        }.store(in: &cancellables)
    }
    
    private func loadState(_ state: DetailViewState) {
        switch state {
        case .loading:
            DispatchQueue.main.async {
                self.loadingView.isHidden = false
                self.loadingView.startAnimating()
            }
            break
        case .error(let error):
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.loadingView.stopAnimating()
                self.showMsg(error.localizedDescription)
            }
            break
        case .success(let movieDetail):
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.loadingView.stopAnimating()
                self.updateView(movieDetail)
            }
            break
        case .empty:
            DispatchQueue.main.async {
                self.loadingView.isHidden = true
                self.loadingView.stopAnimating()
                self.titleLbl.text = nil
            }
            break
        }
    }
    
    private func updateView(_ movieDetail: MovieDetailModel) {
        titleLbl.text = movieDetail.title
        ratingLbl.text = movieDetail.rating
        overviewLbl.text = movieDetail.overview
        if let poster = movieDetail.poster {
            thumbnailView.sd_setImage(with: poster, completed: nil)
        }
    }
    
    private func showMsg(_ msg: String) {
        let alertController = UIAlertController.init(title: "", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    deinit {
        self.titleLbl.text = nil
    }
}
