//
//  LimitsView.swift
//  UnUpset
//
//  Created by Андрей Степанов on 02.06.2025.
//

import SwiftUI

struct LimitsView: View {
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.limits.isEmpty {
                    VStack(spacing: 8) {
                        UnUpsad()
                            .frame(width: 113.17, height: 97)
                        Rectangle()
                            .frame(height: 16)
                            .opacity(0)
                        Text("No limits yet")
                            .font(.title2)
                        Text("Please add new limit as soon as possible")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                    }
                    .foregroundStyle(.disabledText)
                    .frame(width: 250, height: 72)
                } else {
                    
                }
            }
            .navigationTitle("Limits")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Text("Edit")
                            .foregroundStyle(.action)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.showSheetButton()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.action)
                    }
                }
            }
            .sheet(isPresented: $viewModel.isAddingSheetPresented) {
                AddLimitView(viewModel: viewModel)
            }
        }
    }
}

struct AddLimitView: View {
    @ObservedObject var viewModel: LimitsView.ViewModel
    @State private var selectedHours = 5
    @State private var selectedMinutes = 30
    
    var body: some View {
        VStack(spacing: 20) {
            sheetHeader

            DatePicker("", selection: $viewModel.selectedDate, displayedComponents: [.hourAndMinute])
                .datePickerStyle(.wheel)
                .labelsHidden()
                .frame(height: 150)
                .overlay {
                    HStack {
                        HStack {
                            Spacer()
                            Text("h")
                                .padding(.leading, -17)
                                .padding(.top, -1)
                                .scaleEffect(CGSize(width: 1.2, height: 1.3))
                        }
                        .frame(maxWidth: .infinity)
                        HStack {
                            Text("min")
                                .padding(.leading, -27)
                                .padding(.top, -1)
                                .scaleEffect(CGSize(width: 1.2, height: 1.3))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding()

            // Текстовое поле
            TextField("Name", text: $viewModel.limitName)
                .padding()
                .foregroundStyle(.primary)
                .background{
                    RoundedRectangle(cornerRadius: 13)
                        .stroke()
                }
                .padding(.horizontal)

            // Панель с настройками
            VStack(spacing: 0) {
                HStack(spacing: 16) {
                    squaredIcon(systemName: "lock.fill")
                    Button {
                        //viewModel.selectAppsAction()
                    } label: {
                        Text("Select Apps")
                            .padding(.vertical, 11)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                .padding(.horizontal, 16)
            }
            .foregroundStyle(.primary)
            .background{
                RoundedRectangle(cornerRadius: 13)
                    .stroke()
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
    }

    var sheetHeader: some View {
        HStack {
            Button("Cancel") {
                viewModel.isAddingSheetPresented = false
            }
            .foregroundColor(.orange)

            Spacer()

            Text("New limit")
                .font(.headline)

            Spacer()

            Button("Add") {
                viewModel.isAddingSheetPresented = false
            }
            .foregroundColor(.blue)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AddLimitView(viewModel: .init())
}
