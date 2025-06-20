//
//  RoutinesListView.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-05-14.
//

import SwiftUI

struct RoutinesListView: View {

    @State private var searchText: String = ""
    @State private var selectedMuscles: [String] = []

    private let muscles = ["Back", "Biceps", "Triceps", "Chest", "Calves", "Glutes", "Ham String" , "Abs", "Trapecoids"]

    func isMuscleSelected(_ muscle: String) -> Bool {
        return selectedMuscles.contains(muscle)
    }

    func getRoutinesByMuscles(_ muscles: [String]) -> [Routine] {
        Routine.mocks.filter({ $0.muscles.contains(muscles) })
    }

    var body: some View {
        VStack {
            searchBar
                .padding(15)
            musclesScroll
            ScrollView(.vertical) {
                ForEach(getRoutinesByMuscles(selectedMuscles)) { routine in
                    routineCell(routine)
                        .padding()
                }
            }
            Spacer()
        }
    }

    // MARK: - Search Bar

    private var searchBar: some View {
        HStack {
            TextField("Search", text: $searchText)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.gray.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 25))
            Image(systemName: "line.3.horizontal.decrease") //TODO: Implement context Menu
                .font(.title)
                .foregroundStyle(.black)
                .tappableBackground()
                .contextMenu {
                    Button(String("Order by Date Added")) {
                        print("Order by Data Added")
                    }
                    Button("Order by Most Used") {
                        print("Order by name")
                    }
                    Button("Order by Recently Used") {
                        print("Order by name")
                    }
                }
        }
    }

    // MARK: - Muscles

    private var musclesScroll: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(muscles, id: \.self) { muscle in
                    Text(muscle)
                        .padding()
                        .frame(width: 100, height: 100)
                        .background(isMuscleSelected(muscle) ? .accent : .accent.opacity(0.5))
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding(.leading, 15)
                        .anyButton(.highlight) {
                            onMuscleButtonPressed(muscle)
                        }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    private func routineCell(_ routine: Routine) -> some View {
        VStack(alignment: .leading) {
            Text(routine.name)
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(Color.offYellow)
            HStack {
                VStack(alignment: .leading) {
                    Text(routine.muscles.joined(separator: ", "))
                }
                Spacer()
                VStack {
                    ForEach(routine.exercises, id: \.self) { exercise in
                        Text(exercise)
                    }
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .background(.blue.opacity(0.4))
        .animation(.bouncy, value: selectedMuscles)
    }

    // MARK: - Actions

    private func onMuscleButtonPressed(_ muscle: String) {
        if isMuscleSelected(muscle) {
            selectedMuscles.removeAll(where: { $0 == muscle })
        } else {
            selectedMuscles.append(muscle)
        }
    }
}

// MARK: - Preview

#Preview {
    RoutinesListView()
}
