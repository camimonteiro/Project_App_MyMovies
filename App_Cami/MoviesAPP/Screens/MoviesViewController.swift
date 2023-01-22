//
//  MoviesViewController.swift
//  MoviesAPP
//
//  Created by Karolina Attekita on 28/03/22.
//

import UIKit

final class MoviesViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var backgroundImage: UIImageView = {
       let backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "popcorn3")
        backgroundImage.contentMode = .scaleToFill
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.alpha = 0.4
        return backgroundImage
    }()
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.tintColor = .white
        searchController.searchBar.barStyle = .black
        searchController.searchBar.delegate = self
        return searchController
    }()
    
    private lazy var listMoviesTableView: UITableView = {
        let listMoviesTableView = UITableView()
        listMoviesTableView.dataSource = self
        listMoviesTableView.delegate = self
        listMoviesTableView.backgroundColor = .clear
        listMoviesTableView.translatesAutoresizingMaskIntoConstraints = false
        listMoviesTableView.estimatedRowHeight = 44
        listMoviesTableView.rowHeight = UITableView.automaticDimension
        listMoviesTableView.registerCell(type: MovieCell.self)
        return listMoviesTableView
    }()
    
    private var movies: [Movie]? {
        didSet {
            self.listMoviesTableView.reloadData()
        }
    }
    
    private let service: MoviesService = MoviesService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    // MARK: - Private Methods
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchMovies()
    }
    
    private func fetchMovies() {
        service.fetchList { [weak self] result in
            switch result {
            case .success(let response):
                self?.movies = response
            case .failure:
                self?.movies = nil
            }
        }
    }
    
    private func searchMovies(term: String) {
        service.fetchResults(term) { [weak self] result in
            switch result {
            case .success(let response):
                self?.movies = response.compactMap({ $0.show })
            case .failure:
                self?.movies = nil
            }
        }
    }
    

    private func setupNavigation() {
        title = "Meus Filmes e Séries"
        navigationController?.navigationBar.prefersLargeTitles = true
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = textAttributes
        navigationItem.searchController = searchController
    }
}

// MARK: - ViewCode

extension MoviesViewController: ViewCode {
    func buildHierarchy() {
        view.addSubview(backgroundImage)
        view.addSubview(listMoviesTableView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            listMoviesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listMoviesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listMoviesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listMoviesTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func applyAdditionalChanges() {
        setupNavigation()
    }
}

// MARK: - Data Source

extension MoviesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let movieCell = tableView.dequeueCell(withType: MovieCell.self, for: indexPath) as? MovieCell else {
            return UITableViewCell()
        }
        if let model = movies?[indexPath.row] {
            movieCell.configure(with: model)
        }
        return movieCell
    }
}


// MARK: - Search Bar
extension MoviesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            fetchMovies()
            return
        }
        searchMovies(term: searchText)
    }
}
