//
//  EditiView.swift
//  BucketList
//
//  Created by Ana Polo  on 4/5/25.
//

import SwiftUI

struct EditView: View {
    @Environment(\.dismiss) var dismiss

    var onDelete: (Location) -> Void
    @State private var viewModel: ViewModel

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Place name", text: $viewModel.name)
                    TextField("Description", text: $viewModel.description)
                }

                Section("Nearby…") {
                    switch viewModel.loadingState {
                    case .loaded:
                        ForEach(viewModel.pages, id: \.pageid) { page in
                            VStack(alignment: .leading) {
                                Text(page.title)
                                    .font(.headline)
                                if !page.description.isEmpty {
                                    Text(page.description)
                                        .italic()
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }

                    case .loading:
                        Text("Loading…")

                    case .failed:
                        Text("Please try again later.")
                    }
                }
            }
            .navigationTitle("Place details")
            .toolbar {
                Button("Save") {
                    viewModel.save()
                    dismiss()
                }
                Button("Delete", systemImage: "trash") {
                    onDelete(viewModel.location)
                    dismiss()
                }
            }
            .task {
                await viewModel.fetchNearbyPlaces()
            }
        }
    }

    init(location: Location, onSave: @escaping (Location) -> Void, onDelete: @escaping (Location) -> Void) {
        _viewModel = State(initialValue: ViewModel(location: location, onSave: onSave))
        self.onDelete = onDelete
    }
}

#Preview {
    EditView(location: .example, onSave: { _ in }, onDelete: { _ in })
}
