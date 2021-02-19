//
//  MukitListViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/12.
//

import UIKit
import NMapsMap

class MukitListViewController: MapViewController {
    let userViewModel = UserViewModel()
    let mukitListViewModel = MukitListViewModel.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.positionMode = .compass
        naverMapView.showLocationButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            //위치정보 가져오는게 네트워킹이라 좀 느림 그래서 메인 큐에서 해야함
            self.mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: self.mapView.locationOverlay.location.lat, lng: self.mapView.locationOverlay.location.lng), zoom: 15)))
        }
    }
}

extension MukitListViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.mukitListViewModel.mukitList.count
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "mukitCell", for: indexPath) as? MukitCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension MukitListViewController : UICollectionViewDelegate {
    
}
