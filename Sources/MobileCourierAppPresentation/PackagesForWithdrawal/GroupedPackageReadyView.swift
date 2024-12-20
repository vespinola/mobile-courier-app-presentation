//
//  GroupedPackageReadyView.swift
//  mobile-courier-app
//
//  Created by Vladimir Espinola on 2024-06-19.
//

import SwiftUI
import JustACourierAppDomain

struct GroupedPackageReadyView: View {

  var groupedPackage: GroupedPackageEntity

  var body: some View {
    VStack(spacing: 8) {
      HStack(alignment: .center) {
        Text("At the branch")
          .roundedIndicator()

        Spacer()

        VStack(alignment: .trailing) {
          Text("\(groupedPackage.totalWeight) Kg")
        }
      }

      HStack {
        Text("\(groupedPackage.packages.count) packages")

        Spacer()

        Text("Gs \(groupedPackage.formattedTotalCost)")
          .foregroundStyle(Color.accent)
          .font(.title2)
          .fontWeight(.bold)
      }

    }
    .frame(maxWidth: .infinity)
    .padding(.init(
      top: 8,
      leading: 16,
      bottom: 8,
      trailing: 16)
    )
    .foregroundStyle(.black)
    .background(
      RoundedRectangle(cornerRadius: 6)
        .fill(Color.surface)
    )
    .clipped()
  }
}

#Preview {
  GroupedPackageReadyView(
    groupedPackage: .init(
      shipmentCode: 2000,
      packages: [
        .mock
      ]
    )
  )
}
