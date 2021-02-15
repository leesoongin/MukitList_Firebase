//
//  SearchViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/14.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchViewContainer: UIView!
    @IBOutlet weak var tableView: UITableView!
    var searchController : UISearchController!
    
    let keywordParameterViewModel = KeywordSearchViewModel.shared
 
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchItem()
    }
    
    @IBAction func close(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    func initSearchItem(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.delegate = self // searchBar delegate 설정, Delegate extension
        searchViewContainer.addSubview(searchController.searchBar)
    }
}

extension SearchViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.keywordParameterViewModel.searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell") as? SearchCell else {
            return UITableViewCell()
        }
        cell.placeNameLabel.text = keywordParameterViewModel.searchResults[indexPath.row].place_name
        cell.categoryNameLabel.text = keywordParameterViewModel.searchResults[indexPath.row].category_group_name
        
        return cell
    }
}

extension SearchViewController : UITableViewDelegate {
    
}

extension SearchViewController : UISearchBarDelegate {
    //search request 부분
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let requestParameter = KeywordParameter(query: searchBar.text!)
        keywordParameterViewModel.fetchParams(parameter: requestParameter)
        
        keywordParameterViewModel.searchKeyWord { response in
            self.keywordParameterViewModel.fetchSearchResults(results: response)
            self.tableView.reloadData()
        }
        searchController.isActive = false
    }
}

extension SearchViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //한 글자가 입력될 때마다 이벤트. 이건 뭐 지금 내가 쓸거아니니 냅두자
    }
}
