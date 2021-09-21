//
//  ViewController.swift
//  MovieList
//
//  Created by Khoa Mai on 9/17/21.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    private lazy var stateViewController = StateViewController(nibName: nil, bundle: nil)
    
    public var viewModel:HomeViewModel!
    
    private let appear = PassthroughSubject<Void, Never>()
    private let loading = PassthroughSubject<Void, Never>()
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
        
        add(stateViewController)
        stateViewController.showStartSearch()
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
                                            loading: loading.eraseToAnyPublisher(),
                                            loadMore: loadMore.eraseToAnyPublisher(),
                                            selection: selection.eraseToAnyPublisher())
        
        let output = viewModel.transform(input: input)
        
        viewModel.$state.sink { [weak self] state in
            self?.updateState(state)
        }.store(in: &cancellables)
        
        output.sink { [weak self] state in
            
            self?.updateState(state)
        }.store(in: &cancellables)
    }
    
    private func updateState(_ state: HomeViewState) {
        switch state {
        case .idle:
            self.items.removeAll()
            DispatchQueue.main.async {
                self.stateViewController.view.isHidden = false
                self.stateViewController.showStartSearch()
                self.tableView.reloadData()
            }
            break
        case .empty:
            self.items.removeAll()
            DispatchQueue.main.async {
                self.stateViewController.view.isHidden = false
                self.stateViewController.showNoResults()
                self.tableView.reloadData()
            }
            break
        case .loading:
            DispatchQueue.main.async {
                self.stateViewController.view.isHidden = false
                self.stateViewController.startingSearch()
            }
            break
        case .error(let error):
            DispatchQueue.main.async {
                self.stateViewController.view.isHidden = false
                self.stateViewController.showNoResults()
                self.showMsg(error.localizedDescription)
                self.tableView.reloadData()
            }
            break
        case .success(let items):
            DispatchQueue.main.async {
                self.items = items
                self.stateViewController.view.isHidden = true
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.searchBar.endEditing(true)
    }
    
    private func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        child.didMove(toParent: self)
    }
    
}

extension HomeViewController: Routing {
    
    func movieDetail(_ movieId: Int) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.viewModel = DetailViewModel.init(MovieDetailUseCase.init(networkService: ServiceProvider.defaultProvider().network, localService: LocalService<Favourite1>.init(CoreDataStack.shared.persistentContainer.viewContext)), id: movieId)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loading.send(())
        search.send(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = items[indexPath.row].id
        selection.send(id)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if viewModel.canLoardMore && indexPath.row >= items.count - 3 {
            loadMore.send(searchBar.text ?? "")
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
