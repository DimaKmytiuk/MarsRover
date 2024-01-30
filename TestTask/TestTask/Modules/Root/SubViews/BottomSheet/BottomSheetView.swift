//
//  BottomSheetView.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 25.01.2024.
//

import SwiftUI

struct BottomSheetView: View {
    
    @Binding var isShowing: Bool
    @ObservedObject var viewModel: BottomSheetViewModel
    @Environment(\.presentationMode) var presintationMode


    init(isShowing: Binding<Bool>,
         viewModel: BottomSheetViewModel) {
        self.viewModel = viewModel
        _isShowing = isShowing
         }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                VStack(alignment: .center) {
                    HStack {
                        constructDismissButton()
                            .padding(.leading)
                        
                        Spacer()
                                                
                        Text(viewModel.pickerHeader.title)
                            .font(.largeTitle)
                        
                        Spacer()
                        
                        constructSelectButton()
                            .padding(.trailing)
                    }
                    .padding(.top)
                    
                    if case .date = viewModel.pickerHeader {
                        constructDatePicker()
                    }
                    
                    if let array = viewModel.itemsArray, !array.isEmpty {
                        constructPicker(filterArray: array)
                    }
                    
                    else {
                        EmptyView()
                    }
                }
            }
        }
        .background(Color.white)
        .cornerRadius(35, corners: [.topLeft, .topRight])
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
    }
}

extension BottomSheetView {
    func constructSelectButton() -> some View {
        Button {
            if case .camera = viewModel.pickerHeader {
                viewModel.selectedFilter.camera = viewModel.itemsArray?[viewModel.selectedIndex] ?? ""
            }
            if case .date = viewModel.pickerHeader {
                viewModel.selectedFilter.date = viewModel.selectedDate
            }
            if case .rover = viewModel.pickerHeader {
                viewModel.selectedFilter.rover = viewModel.itemsArray?[viewModel.selectedIndex] ?? ""
            }
            
            isShowing.toggle()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color.primaryOrange.opacity(0.5))
                
                Image("select")
                    .scaledToFit()
            }
        }
    }
    
    func constructDismissButton() -> some View {
        Button {
            isShowing.toggle()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundColor(.gray)
                
                Image("cancel")
                    .scaledToFit()
            }
        }
    }
    
    func constructDatePicker() -> some View {
        DatePicker( "", selection: $viewModel.selectedDate, in: ...Date(), displayedComponents: [.date])
            .datePickerStyle(.wheel)
            .padding()
            .labelsHidden()
    }
    
    func constructPicker(filterArray: [String]) -> some View {
        Picker(viewModel.pickerHeader.title, selection: $viewModel.selectedIndex) {
            ForEach(filterArray.indices, id: \.self) { index in
                Text(filterArray[index])
                    .tag(index)
            }
        }
        .pickerStyle(.wheel)
    }
    
}
