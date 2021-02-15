//
//  MapViewController.swift
//  MukitList_Firebase
//
//  Created by 이숭인 on 2021/02/13.
//

import UIKit
import NMapsMap

public let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 14, tilt: 0, heading: 0)

class MapViewController: UIViewController {

    @IBOutlet weak var naverMapView: NMFNaverMapView!
    var mapView : NMFMapView {
        return naverMapView.mapView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))

    }
}
