//
//  HistoryView.swift
//  TestTask
//
//  Created by Dmytro Kmytiuk on 27.01.2024.
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel: HistoryViewModel
    @State var isPresented: Bool = false
    @Environment(\.presentationMode) var presintationMode
    
    var body: some View {
        GeometryReader { screen in
            VStack {
                VStack {
                    HStack(spacing: .leastNormalMagnitude) {
                        constructBackButton()
                            .padding(.bottom)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Text("History")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom)
                            .padding(.leading, -50)
                        
                        Spacer()
                    }
                    .padding(.top, 75)
                    
                }
                .frame(width: screen.size.width)
                .background(Color.primaryOrange)
                
                List {
                    ForEach(viewModel.filers, id: \.id) { filter in
                        constructFilterCell(filterModel: filter)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isPresented = true
                            }
                            .actionSheet(isPresented: $isPresented) {
                                ActionSheet(title: Text("Menu Filter"), buttons: [
                                    .default(Text("Use")) {
                                        viewModel.selectedDate = filter.date
                                        viewModel.selectedCamera = filter.camera
                                        viewModel.selectedRover = filter.rover
                                        presintationMode.wrappedValue.dismiss()
                                    }  ,
                                    .destructive(Text("Delete")) {
                                        viewModel.removeFilter(filter: filter)
                                        
                                        isPresented = false
                                    },
                                    .cancel()
                                ])
                            }
                    }
                }
                .listRowBackground(
                    RoundedRectangle(cornerRadius: 8)
                        .foregroundColor(.white)
                        .background(Color.gray.cornerRadius(8))
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
            .edgesIgnoringSafeArea(.top)
            .navigationBarHidden(true)
        }
        
    }
}

private extension HistoryView {
    func constructFilterCell(filterModel: FilterModel) -> some View {
        HStack {
            VStack(spacing: 8) {
                HStack {
                    Rectangle()
                        .frame(height: 2)
                        .foregroundColor(Color.primaryOrange)
                    
                    Text("Filters")
                        .foregroundColor(Color.primaryOrange)
                        .font(.system(size: 22, weight: .bold))
                }
                HStack {
                    Text("Rover:")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(filterModel.rover)
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                    
                }
                HStack {
                    Text("Camera:")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(filterModel.camera)
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                }
                HStack {
                    Text("Date:")
                        .foregroundColor(Color.gray)
                        .font(.system(size: 16, weight: .medium))
                    
                    Text(Date.changeDate(date: filterModel.date))
                        .foregroundColor(Color.black)
                        .font(.system(size: 16, weight: .bold))
                    
                    Spacer()
                    
                }
            }
        }
    }
    
    func constructBackButton() -> some View {
        Button {
            presintationMode.wrappedValue.dismiss()
        } label: {
            ZStack {
                Circle()
                    .frame(width: 44, height: 44)
                    .foregroundColor(Color.black.opacity(0.3))
                
                Image("back")
                    .scaledToFit()
            }
        }
    }
    
}
