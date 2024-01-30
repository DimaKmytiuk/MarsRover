//
//  RootView.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 22.01.2024.
//

import SwiftUI
import UIKit

struct RootView: View {
    
    @StateObject var viewModel: RootViewModel
    @State private var isAlertPresented = false
    
    var body: some View {
        GeometryReader { screen in
            VStack {
                VStack {
                    Spacer()
                    HStack {
                        VStack(alignment: .leading) {
                            Text(LocalConstants.mainTitle)
                                .font(.system(size: 34, weight: .bold))
                                .padding(.top, 16)
                                .padding(.leading, 0)
                            
                            Text(viewModel.selectedFilter.date.string(formatter: .userFriendly))
                                .padding(.leading, 0)
                        }
                        .padding(.top)
                        
                        Spacer()
                        
                        constructCallendarButton()
                            .padding(.top)
                    }
                    .padding([.top, .horizontal])
                    
                    HStack(spacing: 16) {
                        constructRoverButton(screen: screen)
                        
                        constructCameraButton(screen: screen)
                        
                        constructPlusButton(screen: screen)
                            .alert(isPresented: $isAlertPresented) {
                                Alert(
                                    title: Text(LocalConstants.saveFilters),
                                    message: Text(LocalConstants.alertMessage),
                                    primaryButton: .default(Text(LocalConstants.save), action: {
                                        viewModel.saveFilter()
                                    } ),
                                    secondaryButton: .cancel()
                                )
                                
                            }
                    }
                    .padding()
                    
                }
                .background(Color.primaryOrange)
                .frame(width: screen.size.width)
                
                ZStack {
                    List {
                        ForEach(viewModel.filteredRovers, id: \.id) { rover in
                            constructRoverCell(roverModel: rover, screen: screen)
                                .cornerRadius(0)
                                .id(rover.id)
                                .onAppear {
                                    if let lastItem = viewModel.filteredRovers.last, rover.id == lastItem.id {
                                        viewModel.currentPage += 1
                                    }
                                }
                        }
                        .listRowBackground(
                            RoundedRectangle(cornerRadius: 25)
                                .foregroundColor(.white)
                                .background(Color.clear)
                                .padding(
                                    EdgeInsets(
                                        top: 4,
                                        leading: 0,
                                        bottom: 4,
                                        trailing: 0
                                    )
                                )
                                .padding(.horizontal, 8)
                                .padding(.vertical, 2)
                        )
                    }
                    .padding(.top, 0)
                    .frame(width: screen.size.width, height: screen.size.height * 0.9)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            constructHistoryButton()
                                .padding(.bottom, 48)
                                .padding(.trailing, 16)
                        }
                    }
                }
            }
            .onAppear {
                viewModel.fetchPhotos()
            }
            .edgesIgnoringSafeArea(.top)
            if viewModel.isCameraPopupPresented {
                BottomSheetView(isShowing: $viewModel.isCameraPopupPresented,
                                viewModel: viewModel.constructBottomSheetViewModel(type: .camera))
            }
            if viewModel.isRoverPopupPresented {
                BottomSheetView(isShowing: $viewModel.isRoverPopupPresented,
                                viewModel: viewModel.constructBottomSheetViewModel(type: .rover))
            }
            if viewModel.isCalendarPopupPresented {
                BottomSheetView(isShowing: $viewModel.isCalendarPopupPresented,
                                viewModel: viewModel.constructBottomSheetViewModel(type: .date))
            }
        }
    }
    
}

private extension RootView {
    
    func constructRoverButton(screen: GeometryProxy) -> some View {
        Button {
            viewModel.isRoverPopupPresented.toggle()
        } label: {
            HStack {
                Image("rover")
                    .padding(.leading)
                
                Text(viewModel.selectedFilter.rover)
                    .foregroundColor(Color.black)
                    .bold()
                
                Spacer()
            }
            .frame(width: 160, height: 40)
            .background(Color.white)
        }
        .cornerRadius(8)
    }
    
    func constructCameraButton(screen: GeometryProxy) -> some View {
        Button {
            viewModel.isCameraPopupPresented.toggle()
        } label: {
            HStack {
                Image("camera")
                    .padding(.leading)
                
                Text(viewModel.selectedFilter.camera)
                    .foregroundColor(Color.black)
                    .bold()
                
                Spacer()
            }
            .frame(width: 160, height: 40)
            .background(Color.white)
        }
        .cornerRadius(8)
        
    }
    
    func constructPlusButton(screen: GeometryProxy) -> some View {
        Button {
            isAlertPresented.toggle()
        } label: {
            HStack {
                Text("+")
                    .foregroundColor(Color.black)
                    .bold()
            }
            .frame(width: 40, height: 40)
            .background(Color.white)
        }
        .cornerRadius(8)
        
    }
    
    func constructRoverCell(roverModel: RoverModel, screen: GeometryProxy) -> some View {
        HStack {
            VStack {
                HStack {
                    Text("Rover:")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(roverModel.name)
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                }
                HStack(alignment: .firstTextBaseline) {
                    Text("Camera:")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(roverModel.camera.splitInTwoParts()[0])
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                }
                HStack {
                    Text(roverModel.camera.splitInTwoParts()[1])
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                }
                HStack {
                    Text("Date:")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(Date.changeDate(date: roverModel.date))
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                }
                
            }
            
            ImageLoaderView(viewModel: viewModel
                .constructImageLoaderViewModel(url: roverModel.imageSRC))
            
        }
        .frame(height: 150)
    }
    
    func constructHistoryButton() -> some View {
        
        NavigationLink {
            HistoryView(viewModel: viewModel.historyViewModel)
        } label: {
            ZStack {
                Circle()
                    .foregroundColor(Color.primaryOrange)
                    .frame(width: 70, height: 70)
                
                Image("history")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
            }
        }
        .foregroundColor(Color.primaryOrange)
    }
    
    func constructCallendarButton() -> some View {
        Button {
            viewModel.isCalendarPopupPresented.toggle()
        } label: {
            Image("calendar")
        }
    }
    
}

fileprivate enum LocalConstants {
    static let mainTitle = "MARS.CAMERA"
    static let saveFilters = "Save Filters"
    static let alertMessage = "The current filters and the date you have chosen can be saved to the filter history."
    static let save = "Save"
}


extension Array where Element: Identifiable {
    var isLastItemVisible: Bool {
        guard let lastItem = last else { return false }
        return lastItem.id == last?.id
    }
}
