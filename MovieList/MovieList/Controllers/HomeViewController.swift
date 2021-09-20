//
//  ViewController.swift
//  MovieList
//
//  Created by Khoa Mai on 9/17/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController, Routing {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var loadingView: UIActivityIndicatorView!
    
    public var viewModel:HomeViewModel!
    
    private let appear = PassthroughSubject<Void, Never>()
    private let search = PassthroughSubject<String, Never>()
    private let selection = PassthroughSubject<Int, Never>()
    private let loadMore = PassthroughSubject<String, Never>()
    private let favourite = PassthroughSubject<Bool, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private var items = [MovieCellViewModel]()
    private var limit: Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        appear.send(())
    }
    
    private func configureUI() {
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureViewModel() {
        viewModel = HomeViewModel.init(useCase: MoviesUseCase.init(networkService: ServiceProvider.defaultProvider().network), routing: self)
        
        let input = HomeViewModelInput.init(appear: appear.eraseToAnyPublisher(),
                                            search: search.eraseToAnyPublisher(),
                                            loadMore: loadMore.eraseToAnyPublisher(),
                                            selection: selection.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        output.sink { [weak self] state in
            
            self?.loadState(state)
        }.store(in: &cancellables)
    }
    
    private func loadState(_ state: HomeViewState) {
        switch state {
        case .idle:
            print("init")
            self.items.removeAll()
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            }
            break
        case .empty:
            print("empty")
            self.items.removeAll()
            DispatchQueue.main.async {
                self.loadingView.stopAnimating()
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            }
            break
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
            self.items += items
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
    
    func movieDetail(_ movieId: Int) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.viewModel = DetailViewModel.init(MovieDetailUseCase.init(networkService: ServiceProvider.defaultProvider().network, localService: LocalService.init(CoreDataStack.shared.persistentContainer.viewContext)), id: movieId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.items.removeAll()
        search.send(searchText)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = items[indexPath.row].id
        selection.send(id)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.canLoardMore {
            loadMore.send(searchBar.text ?? "\"\"")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120.0
    }
}

extension HomeViewController: UITableViewDataSource {
    
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
