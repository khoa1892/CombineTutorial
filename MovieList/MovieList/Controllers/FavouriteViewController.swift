//
//  FavouriteViewController.swift
//  MovieList
//
//  Created by Khoa Mai on 9/19/21.
//

import UIKit
import Combine
import CoreData

class FavouriteViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet weak private var loadingView: UIActivityIndicatorView!
    
    private let appear = PassthroughSubject<Void, Never>()
    private let selection = PassthroughSubject<MovieCellViewModel, Never>()
    private var cancellabels = Set<AnyCancellable>()
    
    private var items = [MovieCellViewModel]()
    private var viewModel:FavouriteViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureBindings()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }
    
    private func configureBindings() {
        
        viewModel = FavouriteViewModel.init(useCase: FavouriteUseCase.init(LocalService.init(CoreDataStack.shared.persistentContainer.viewContext)), routing: self)
        
        let input = FavouriteViewModelInput.init(selection: selection.eraseToAnyPublisher(), appear: appear.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        
        output.sink { [weak self] state in
            
            self?.updateState(state)
        }.store(in: &cancellabels)
    }
    
    private func configureUI() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func updateState(_ state: FavouriteViewState) {
        switch state {
        case .loading:
            DispatchQueue.main.async {
                self.loadingView.isHidden = false
                self.loadingView.startAnimating()
            }
            break
        case .error(let error):
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.loadingView.isHidden = true
                self.showMsg(error.localizedDescription)
                self.tableView.reloadData()
            }
            break
        case .success(let items):
            self.items = items
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            }
            break
        }
    }
    
    private func showMsg(_ msg: String) {
        let alertController = UIAlertController.init(title: "", message: msg, preferredStyle: .alert)
        let alertAction = UIAlertAction.init(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension FavouriteViewController: FavouriteRouting {
    
    func movieDetail(_ movieId: Int) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.viewModel = DetailViewModel.init(MovieDetailUseCase.init(networkService: ServiceProvider.defaultProvider().network, localService: LocalService<Favourite1>.init(CoreDataStack.shared.persistentContainer.viewContext)), id: movieId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension FavouriteViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        selection.send(item)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

extension FavouriteViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieInfoCell") as! MovieInfoCell
        
        cell.item = items[indexPath.row]
        return cell
    }
}
