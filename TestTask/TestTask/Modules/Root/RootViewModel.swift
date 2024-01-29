//
//  RootViewModel.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 22.01.2024.
//

import SwiftUI
import UIKit
import Combine

final class RootViewModel: ObservableObject {
    
    @Published var currentPage = 1
    @Published var rovers: [RoverModel] = []
    @Published var filteredRovers: [RoverModel] = []
    @Published var filterArray: [FilterModel] = []
    @Published var cameraFilterArray: [String] = ["All"]
    @Published var roverFilterArray: [String] = ["All"]
    @Published var selectedDate: String = Date().string(formatter: .customDateWithDashFormatter) {
        didSet {
            discountParameters()
        }
    }
    @Published var isCameraPopupPresented = false {
        didSet {
            if isCameraPopupPresented {
                isRoverPopupPresented = false
                isCalendarPopupPresented = false
            }
        }
    }
    @Published var isRoverPopupPresented = false {
        didSet {
            if isRoverPopupPresented {
                isCameraPopupPresented = false
                isCalendarPopupPresented = false
            }
        }
    }
    @Published var isCalendarPopupPresented = false {
        didSet {
            if isCalendarPopupPresented {
                isRoverPopupPresented = false
                isCameraPopupPresented = false
            }
        }
    }
    @Published var selectedCameraFilter: String = "All" {
        didSet {
            filterCameras()
        }
    }
    @Published var selectedRoverFilter: String = "All" {
        didSet {
            filterRovers()
        }
    }
    private var cancellables = Set<AnyCancellable>()
    private var imageCache = NSCache<NSString, UIImage>()
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    var historyViewModel: HistoryViewModel {
        HistoryViewModel(container: container,
                         selectedDate: .bindTo(self, keyPath: \.selectedDate),
                         selectedRover: .bindTo(self, keyPath: \.selectedRoverFilter),
                         selectedCamera: .bindTo(self, keyPath: \.selectedCameraFilter)
        )
    }
    
    func constructImageLoaderViewModel(url: String) -> ImageLoaderViewModel {
        ImageLoaderViewModel(url: url)
    }
    
    func constructBottomSheetViewModel(type: BottomSheet) -> BottomSheetViewModel {
        switch type {
        case .camera:
            BottomSheetViewModel(
                array: cameraFilterArray,
                title: type, selectedIndex: cameraFilterArray.firstIndex(of: selectedCameraFilter) ?? .zero,
                selectedItem: .bindTo(self, keyPath: \.selectedCameraFilter))
        case .rover:
            BottomSheetViewModel(array: roverFilterArray,
                                 title: type, selectedIndex: roverFilterArray.firstIndex(of: selectedRoverFilter) ?? .zero,
                                 selectedItem: .bindTo(self, keyPath: \.selectedRoverFilter))
        case .date:
            BottomSheetViewModel(title: type,
                                 selectedIndex: .zero, selectedItem: .bindTo(self, keyPath: \.selectedDate))
        }
    }
    
    func saveFilter() {
        container
            .services
            .filterService
            .saveFilter(.init(
                rover: selectedRoverFilter,
                camera: selectedCameraFilter,
                date: selectedDate))
    }
    
    func fetchPhotos() {
        container
            .services
            .APIService
            .getPhotos(
                apiKey: Constants.apiKey,
                earthDate: selectedDate,
                page: currentPage)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { data in
                
            }, receiveValue: { [weak self] data in
                guard let self else { return }
                
                let rovers = data.photos.map { photo in
                    RoverModel(name: photo.rover.name,
                               camera: photo.camera.full_name,
                               date: photo.earth_date,
                               imageSRC: photo.img_src)
                }
                self.rovers.append(contentsOf: rovers)
                self.filteredRovers.append(contentsOf: rovers)
                removeMatchedNames(rovers: rovers)
                                                
            }).store(in: &cancellables)
    }
    
    private func discountParameters() {
        currentPage = 1
        filteredRovers = []
        rovers = []
        fetchPhotos()
    }
    
    private func filterCameras() {
         if selectedCameraFilter == "All" {
             filteredRovers = rovers
         } else {
             filteredRovers = rovers.filter { $0.camera == selectedCameraFilter }
         }
     }
    
    private func filterRovers() {
         if selectedRoverFilter == "All" {
             filteredRovers = rovers
         } else {
             filteredRovers = rovers.filter { $0.name == selectedRoverFilter }
         }
     }
    
    private func removeMatchedNames(rovers: [RoverModel]) {
        cameraFilterArray = ["All"] +  Set(rovers.map { $0.camera }).sorted()
        roverFilterArray = ["All"] + Set(rovers.map { $0.name }).sorted()
    }
}

fileprivate enum Constants {
    static let apiKey = "chQSpbp85aeP7avIqLQpHchQFFxXp7vCjR7W4Fcw"
}
