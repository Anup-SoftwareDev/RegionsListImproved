//
//  ViewController.swift
//  RegionsListImproved
//
//  Created by Anup Kuriakose on 15/11/2023.
//

import UIKit

class RegionsViewController: UIViewController, UISearchBarDelegate {
    var viewModel = RegionsViewModel()
    let searchBar = UISearchBar()
    private let tableView = UITableView()
    let backResetButtonGreen = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))?.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        setupCustomNavigationBar()
        viewModel.initializeRegionsData()
        viewModel.regionsFilteredLoadingData = viewModel.regionsBaseData
        setUpTableView()
    }
    
    // MARK: - Navigation Bar Setup
    func setupCustomNavigationBar() {
        setUpBarButtonsAndTitle()
        setUpSearchBarAndConstraints()
    }
    
    private func setUpBarButtonsAndTitle() {
        // Customize navigation bar
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.title = "Select region"
        
        // Add BarButtons
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backResetButtonGreen, style: .plain, target: self, action: #selector(backBarResetButtonAction))
        setupBoldDoneButton()
    }
    
    // Function called to make 'Done' label bold
    func setupBoldDoneButton() {
        let label = UILabel()
        label.text = "Done"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .systemGreen
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(doneBarButtonAction))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)

        let barButtonItem = UIBarButtonItem(customView: label)
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    // Function to implement 'Reset' procedure for backBarResetButton
    @objc func backBarResetButtonAction() {
        // Reset search bar and table view
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.initializeRegionsData()
        viewModel.regionsFilteredLoadingData = viewModel.regionsBaseData
        tableView.reloadData()
        presentAlert(title: "Reset", message: "Regions List Reset")
    }

    // Function to display Dialog box indicating Region selected by user
    @objc func doneBarButtonAction() {
        let (selectedRegionFound, selectedIndex) = viewModel.findSelectedRegion()
        if selectedRegionFound {
            presentAlert(title: "Selected Region", message: viewModel.regionsBaseData[selectedIndex].name)
        }else{
            presentAlert(title: "No Selection", message: "Please select a region first.")
        }
    }
  
    // Function to add SearchBar into CustomNavigation Bar
    private func setUpSearchBarAndConstraints() {
        // Setup Search Bar UI
        let customView = UIView()
        customView.backgroundColor = .systemGray6
        view.addSubview(customView)

        // Constraints for custom view
        customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            customView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            customView.heightAnchor.constraint(equalToConstant: 50)
        ])

        // Add search bar to custom view with constraints
        customView.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = UIColor.systemGray6
        searchBar.searchTextField.backgroundColor = UIColor.systemGray5
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: customView.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: customView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: customView.trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: customView.bottomAnchor)
        ])
    }
    
    
    private func setUpTableView() {
        
        //tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(RegionCell.self, forCellReuseIdentifier: "RegionCell")
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        // Hide default cell separators to accommodate for custom one
        tableView.separatorStyle = .none
        
        // Constraints for TableView
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }
    
    // Present Alert Function
    private func presentAlert(title: String, message: String) {
        // Display Alert Controller
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }}

// MARK: - SearchBar Delegate
extension RegionsViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.regionsFilteredLoadingData = viewModel.filterRegions(searchText: searchText)
        tableView.reloadData()
       
    }

    // Handle search bar cancel button click
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.regionsFilteredLoadingData = viewModel.regionsBaseData
        print(viewModel.regionsFilteredLoadingData)
        tableView.reloadData()
    }
}
extension RegionsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.regionsFilteredLoadingData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RegionCell", for: indexPath) as! RegionCell
        let region = viewModel.regionsFilteredLoadingData[indexPath.row].name
        let isSelected = viewModel.regionsFilteredLoadingData[indexPath.row].isSelected
        let cellViewModel = RegionCellViewModel(regionName: region, isSelected: isSelected)
        cell.configure(with: cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.updateFilteredLoadingData(index: indexPath.row)
        viewModel.updateRegionsBaseData()
        tableView.reloadData()
        
    }
    // Configure cell display
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let RegionCell = cell as? RegionCell {
            let isSelected = viewModel.regionsFilteredLoadingData[indexPath.row].isSelected
            RegionCell.configureCell(isSelected: isSelected)
        }
        }
    }
