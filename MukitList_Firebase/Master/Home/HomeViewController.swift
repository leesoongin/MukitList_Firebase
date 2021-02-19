//
//  HomeViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/12.
//

import UIKit
import NMapsMap
import FloatingPanel

class HomeViewController: MapViewController {
    var locationManager = CLLocationManager()
    
    let userViewModel = UserViewModel()
    let keywordSearchViewModel = KeywordSearchViewModel.shared
    
    @IBOutlet weak var dummySearchBar: UIButton! //뷰 레이어 다루기 위함
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //가장 먼저 위치 권한이 없다면 위치 권한 가지고 오기
        if !requestGPSPermission(){
            locationManager.requestAlwaysAuthorization()
        }
        initView()
        addFloatingPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        DispatchQueue.main.async {
            //위치정보 가져오는게 네트워킹이라 좀 느림 그래서 메인 큐에서 해야함
            self.mapView.moveCamera(NMFCameraUpdate(position: NMFCameraPosition(NMGLatLng(lat: self.mapView.locationOverlay.location.lat, lng: self.mapView.locationOverlay.location.lng), zoom: 15)))
        }
    }
    // 서치화면으로 전환
    @IBAction func moveToSearchScene(_ sender: Any) {
      
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Search")
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    //내 주변 맛집 찾기
    @IBAction func searchNearByRestaurants(_ sender: Any) {
        let parameter = KeywordParameter(query: "맛집", x: "\(mapView.locationOverlay.location.lng)", y: "\(mapView.locationOverlay.location.lat)", radius: "2000")
        keywordSearchViewModel.fetchParams(parameter: parameter)
        
        keywordSearchViewModel.searchKeyWord { response in
            self.keywordSearchViewModel.fetchNearbyRestaurantSearchResults(results: response)
            DispatchQueue.main.async {
                self.setNearByRestaurantResults(documents: self.keywordSearchViewModel.nearbyRestaurantSearchResults)
            }//dispatchQueue
        }//closure
    }
    
    func setNearByRestaurantResults(documents : [Document]){
        for item in documents {
            let marker = NMFMarker(position: NMGLatLng(lat: Double(item.y)!, lng: Double(item.x)!))
            marker.iconImage = NMF_MARKER_IMAGE_BLUE
            marker.captionText = item.place_name
            marker.touchHandler = { overlay in
                //TODO : 해당 가게에 대한 리뷰리스트 띄워보자 floating panel에
                //1.  Notification center를 이용해 패널에 음식점id전송
                //2. contentViewController에서 해당 음식점id에 존재하는 리뷰리스트를 읽어와 collectionView에 뿌리기
                NotificationCenter.default.post(name: Notification.Name("restaurantId"), object: nil, userInfo: ["document":item])
                return true
            }
            marker.mapView = mapView
        }
    }
    
    func initView(){
        mapView.positionMode = .compass
        naverMapView.showLocationButton = true
        
        dummySearchBar.layer.cornerRadius = 15
        dummySearchBar.layer.opacity = 0.9
        dummySearchBar.layer.borderWidth = 1.0
        dummySearchBar.layer.borderColor =  #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    }
    
    func requestGPSPermission() -> Bool {
          switch CLLocationManager.authorizationStatus() {
          case .authorizedAlways, .authorizedWhenInUse:
            print("GPS: 권한 있음")
            return true
          case .restricted, .notDetermined:
            print("GPS: 아직 선택하지 않음")
            return false
          case .denied:
              print("GPS: 권한 없음")
            return false
          default:
              print("GPS: Default")
            return false
        }
    }
}

extension HomeViewController : FloatingPanelControllerDelegate {
    func addFloatingPanel() {
        let fpc = FloatingPanelController()
        fpc.delegate = self
        
        let storyboard = UIStoryboard(name: "Content", bundle: nil)
        guard let contentVC = storyboard.instantiateInitialViewController() as? NavigationViewController else{
            return
        }
        fpc.set(contentViewController: contentVC)
        fpc.addPanel(toParent: self)
    }
}
