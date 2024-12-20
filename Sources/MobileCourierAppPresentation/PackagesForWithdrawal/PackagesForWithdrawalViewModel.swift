//
//  PackagesForWithdrawalViewModel.swift
//  mobile-courier-app
//
//  Created by Vladimir Espinola on 2024-06-18.
//

import Foundation
import JustACourierAppDomain

public final class PackagesForWithdrawalViewModel: ObservableObject {
  @Published var isLoading: Bool = false
  @Published var toastMessage: String?
  @Published var groupedPackagesEntity: [GroupedPackageEntity]?

  private let packagesRepository: PackagesRepositoryProtocol

  public init(packagesRepository: PackagesRepositoryProtocol) {
    self.packagesRepository = packagesRepository
  }

  @MainActor
  func getPackages(forceUpdate: Bool = false) async {
    guard groupedPackagesEntity == nil || forceUpdate else { return }

    defer { isLoading = false }

    do {
      isLoading = true
      groupedPackagesEntity = try await packagesRepository.getPackagesForWithdrawl()
    } catch {
      toastMessage = error.localizedDescription
    }
  }
}
