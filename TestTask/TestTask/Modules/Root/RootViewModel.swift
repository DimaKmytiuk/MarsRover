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
    @Published var cameraNames: [String] = ["All"]
    @Published var roverNames: [String] = ["All"]
    @Published var selectedFilter: FilterModel = FilterModel(rover: "All", camera: "All", date: Date())
    @Published var isCameraPopupPresented = false
    @Published var isRoverPopupPresented = false
    @Published var isCalendarPopupPresented = false
    
    private var cancellables = Set<AnyCancellable>()
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
        setupSubscriptions()
    }
    
    var historyViewModel: HistoryViewModel {
        HistoryViewModel(
            container: container,
            filterModel: .bindTo(self, keyPath: \.selectedFilter))
    }
    
    func constructImageLoaderViewModel(url: String) -> ImageLoaderViewModel {
        ImageLoaderViewModel(url: url)
    }
    
    func constructBottomSheetViewModel(type: BottomSheet) -> BottomSheetViewModel {
        switch type {
        case .camera:
            BottomSheetViewModel(
                itemsArray: cameraNames,
                selectedDate: Date(),
                title: type,
                selectedIndex: cameraNames
                    .firstIndex(of: selectedFilter.camera) ?? .zero,
                selectedFilter: .bindTo(self, keyPath: \.selectedFilter))
        case .rover:
            BottomSheetViewModel(
                itemsArray: roverNames,
                selectedDate: Date(),
                title: type,
                selectedIndex: roverNames
                    .firstIndex(of: selectedFilter.rover) ?? .zero,
                selectedFilter: .bindTo(self, keyPath: \.selectedFilter))
        case .date:
            BottomSheetViewModel(
                itemsArray: [],
                selectedDate: selectedFilter.date,
                title: type,
                selectedIndex: .zero,
                selectedFilter: .bindTo(self, keyPath: \.selectedFilter))
        }
    }
    
    func setupSubscriptions() {
        $isCameraPopupPresented
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if isCameraPopupPresented {
                    isRoverPopupPresented = false
                    isCalendarPopupPresented = false
                }
            }
            .store(in: &cancellables)
        
        $isRoverPopupPresented
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if isRoverPopupPresented {
                    isCameraPopupPresented = false
                    isCalendarPopupPresented = false
                }
            }
            .store(in: &cancellables)
        
        $isCalendarPopupPresented
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if isCalendarPopupPresented {
                    isCameraPopupPresented = false
                    isRoverPopupPresented = false
                }
            }
            .store(in: &cancellables)
        
        $selectedFilter
            .map(\.date)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] date in
                guard let self = self else { return }
                
                discountParameters()
            }
            .store(in: &cancellables)
        
        $selectedFilter
            .map(\.rover)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rover in
                guard let self = self else { return }
                
                filteredRovers = filterItems(rovers: filteredRovers)
            }
            .store(in: &cancellables)
        
        $selectedFilter
            .map(\.camera)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] camera in
                guard let self = self else { return }
                
                filteredRovers = filterItems(rovers: filteredRovers)
            }
            .store(in: &cancellables)
        
        $currentPage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                fetchPhotos()
            }
            .store(in: &cancellables)
    }
    
    func saveFilter() {
        container
            .services
            .filterService
            .saveFilter(
                .init(
                    rover: selectedFilter.rover,
                    camera: selectedFilter.camera,
                    date: selectedFilter.date)
            )
    }
    
    func fetchPhotos() {
        container
            .services
            .webService
            .getPhotos(
                apiKey: Constants.apiKey,
                earthDate: selectedFilter.date.string(formatter: .dash),
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
                removeMatchedNames(rovers: rovers)
                filteredRovers.append(contentsOf: filterItems(rovers: rovers))
                
            }).store(in: &cancellables)
    }
    
    private func discountParameters() {
        currentPage = 1
        filteredRovers = []
        rovers = []
        fetchPhotos()
    }
    
    private func filterItems(rovers: [RoverModel]) -> [RoverModel] {
        var filteredArray = rovers
        
        if selectedFilter.camera != "All" {
            filteredArray = rovers.filter { $0.camera == selectedFilter.camera }
        }
        if selectedFilter.rover != "All" {
            filteredArray = rovers.filter { $0.name == selectedFilter.rover }
        }
        return filteredArray
    }
    
    private func removeMatchedNames(rovers: [RoverModel]) {
        let uniqueCameraNames = Set(rovers.map { $0.camera }).sorted()
        let uniqueRoverNames = Set(rovers.map { $0.name }).sorted()
        
        for cameraName in uniqueCameraNames {
            if !cameraNames.contains(cameraName) {
                cameraNames.append(cameraName)
            }
        }
        for roverName in uniqueRoverNames {
            if !roverNames.contains(roverName) {
                roverNames.append(roverName)
            }
        }
    }
}

fileprivate enum Constants {
    static let apiKey = "chQSpbp85aeP7avIqLQpHchQFFxXp7vCjR7W4Fcw"
}
