//
//  WithdrawnPackagesView.swift
//  mobile-courier-app
//
//  Created by Vladimir Espinola on 2024-06-15.
//

import SwiftUI
import JustACourierAppDomain

struct WithdrawnPackagesView: View {
  @StateObject var viewModel: WithdrawnPackagesViewModel
  @EnvironmentObject var coordinator: Coordinator

  var body: some View {
    ZStack {
      if let groupedPackagesEntity = viewModel.filteredGroupedPackages {
        content(for: groupedPackagesEntity)
      }
    }
    .onAppear {
      getPackages()
    }
    .refreshable {
      getPackages(forceUpdate: true)
    }
    .showRippleSpinner(isLoading: $viewModel.isLoading)
    .toast(message: $viewModel.toastMessage)
  }

  private func getPackages(forceUpdate: Bool = false) {
    Task {
      await viewModel.getPackages(forceUpdate: forceUpdate)
    }
  }

  @ViewBuilder
  private func content(for groupedPackages: [GroupedPackageEntity]) -> some View {
    if groupedPackages.isEmpty {
      PackagePlaceholderView()
    } else {
      VStack {
        getYearPicker()
        packagesList(groupedPackages)
      }
    }
  }

  @ViewBuilder
  private func getYearPicker() -> some View {
    HStack(alignment: .top) {
      Text("Please select a year for filtering your shipments")
      Spacer()
      Picker("Select Year", selection: $viewModel.selectedYear) {
        ForEach(viewModel.getYearsForFiltering, id: \.self) {
          Text($0)
        }
      }
      .pickerStyle(.menu)
    }
    .padding([.leading, .trailing, .top], 20)
  }

  @ViewBuilder
  private func packagesList(_ groupedPackages: [GroupedPackageEntity]) -> some View {
    List(groupedPackages) { row in
      GroupedPackageRowView(groupedPackage: row)
        .groupedPackageRowStyle()
        .onTapGesture {
          coordinator.present(
            sheet: .shipmentDetail(groupedPackage: row)
          )
        }
    }
    .listStyle(.plain)
  }
}

#Preview {
  WithdrawnPackagesView(viewModel: .previewInstance())
    .environmentObject(Coordinator(diContainer: AppDIContainerMock()))
}
