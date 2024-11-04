//
//  ViewController.swift
//  Quipper Test
//
//  Created by Irfan on 02/11/24.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelError: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var viewModel = CourseViewModel()
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initNavigationBar()
        initTableView()
        
        viewModel.$state
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
        
        viewModel.fetchCourses()
    }
    
    private func initNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = UIColor(named: "AppBlue")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    private func initTableView() {
        tableView.register(UINib(nibName: CourseTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CourseTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 280
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func handleState(_ state: AppState) {
        switch state {
        case .loading:
            self.labelError.isHidden = true
            self.activityIndicator.isHidden = false
        case .success:
            self.activityIndicator.isHidden = true
            self.tableView.reloadData()
        case .error(let message):
            self.activityIndicator.isHidden = true
            self.labelError.text = message
            self.labelError.isHidden = false
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == CourseDetalViewController.segue {
            guard let detailVC = segue.destination as? CourseDetalViewController, let indexPath = tableView.indexPathForSelectedRow else {
                return
            }
            
            let selectedItem = viewModel.courses[indexPath.row]
            let detailViewModel = CourseDetailViewModel(title: selectedItem.title)
            detailVC.viewModel = detailViewModel
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CourseTableViewCell.identifier, for: indexPath) as! CourseTableViewCell
        let course = viewModel.courses[indexPath.row]
        cell.configure(with: course)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: CourseDetalViewController.segue, sender: self)
    }
}
