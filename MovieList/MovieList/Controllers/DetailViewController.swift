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
    @IBOutlet weak private var loadingView: UIActivityIndicatorView!
    @IBOutlet weak private var addBtn: UIBarButtonItem!
    
    private let appear = PassthroughSubject<Void, Never>()
    private let favourite = PassthroughSubject<(MovieDetailModel, Bool), Never>()
    
    var viewModel: DetailViewModel!
    private var movieDetail: MovieDetailModel?
    private var isFav: Bool = false
    
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
        
        let output = viewModel.transform(input: DetailViewModelInput.init(appear: appear.eraseToAnyPublisher(), favourite: favourite.eraseToAnyPublisher()))
        
        output.receive(on: RunLoop.main)
            .sink { [weak self] state in
            self?.loadState(state)
        }.store(in: &cancellables)
    }
    
    private func loadState(_ state: DetailViewState) {
        switch state {
        case .loading:
            self.loadingView.isHidden = false
            self.loadingView.startAnimating()
            break
        case .error(let error):
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            self.showMsg(error.localizedDescription)
            break
        case .success(let movieDetail):
            self.movieDetail = movieDetail
            
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            self.updateView(movieDetail)
            break
        case .empty:
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
            self.titleLbl.text = nil
            break
        case .favourite(let isFav):
            self.addBtn.title = isFav ? "Added" : "Add"
            self.isFav = isFav
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
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
    
    @IBAction func addBtnTapped(_ sender: Any) {
        guard let movieDetail = self.movieDetail else {
            return
        }
        favourite.send((movieDetail, isFav))
    }
    
    deinit {
        self.titleLbl.text = nil
    }
}
