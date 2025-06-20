//
//  ExercisesView.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-19.
//

import SwiftUI

struct ExercisesView: View {
    @EnvironmentObject private var exercisesManager: ExercisesManager
    @EnvironmentObject private var musclesManager: MusclesManager
    @EnvironmentObject private var navigation: Navigation
    @State private var isLoadingExercises: Bool = true
    @State private var isLoadingMuscles: Bool = true
    @State private var errorMessage: String?
    @State private var selectedMuscles: [MuscleGroup] = []
    @State private var path: [NavigationPathOption] = []

    func isMuscleGroupSelected(_ muscleGroups: MuscleGroup) -> Bool {
        return selectedMuscles.contains(where: { $0 == muscleGroups })
    }

    func getExercisesByMuscles(_ muscleGroups: [MuscleGroup]) -> Exercises {
        guard !muscleGroups.isEmpty else { return exercisesManager.exercises }
        return exercisesManager.exercises.filter { exercise in
            selectedMuscles.contains { muscleGroup in
                muscleGroup.muscles.contains { muscle in
                    (exercise.primaryMuscles ?? []).contains { targetedMuscle in
                        targetedMuscle == muscle
                    }
                }
            }
        }
    }

    var body: some View {
        VStack {
            musclesScroll
            exercisesList()
        }
        .task {
            await loadData()
        }
    }

    // MARK: - Muscles

    private var musclesScroll: some View {
        ScrollView(.horizontal) {
            HStack {
                if musclesManager.muscleGroups.isEmpty {
                    Text("NO DATA")
                } else {
                    ForEach(musclesManager.muscleGroups, id:\.id) { muscle in
                        Text(muscle.name)
                            .padding()
                            .frame(width: 100, height: 100)
                            .background(isMuscleGroupSelected(muscle) ? .accent : .accent.opacity(0.5))
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding(.leading, 15)
                            .anyButton(.highlight) {
                                onMuscleGroupButtonPressed(muscle)
                            }
                    }
                }
            }
        }
        .scrollIndicators(.hidden)
    }

    // MARK: - Exercises List

    @ViewBuilder
    private func exercisesList() -> some View {
        if isLoadingExercises {
            ProgressView("Loading exercises...")
                .padding()
        } else if let errorMessage = errorMessage {
            Text("Error: \(errorMessage)")
                .foregroundColor(.red)
                .padding()
        } else if exercisesManager.exercises.isEmpty {
            Text("No exercises found.")
                .foregroundColor(.secondary)
                .padding()
        } else {
            List {
                ForEach(getExercisesByMuscles(selectedMuscles), id: \.id) { exercise in
                    ExerciseCellView(exercise: exercise)
                        .removeListRowFormatting()
                        .padding(.bottom, 8)
                        .anyButton {
                            onExerciseButtonPressed(exercise)
                        }
                }
            }
            .animation(.bouncy, value: selectedMuscles)
            .listStyle(.plain)
            .navigationTitle("Fitness Library")
        }
    }

    // MARK: - Actions

    private func onMuscleGroupButtonPressed(_ muscleGroups: MuscleGroup) {
        if isMuscleGroupSelected(muscleGroups) {
            selectedMuscles.removeAll(where: { $0 == muscleGroups })
        } else {
            selectedMuscles.append(muscleGroups)
        }
    }

    private func onExerciseButtonPressed(_ exercise: Exercise) {
        navigation.path.append(.exercise(exercise: exercise))
    }

    // MARK: - Data

    private func loadData() async {
        async let fetchExercises: () = loadExercises()
        async let fetchMuscles: () = loadMuscles()

        let (_, _) = await (fetchExercises, fetchMuscles)
    }

    private func loadExercises() async {
        isLoadingExercises = true
        errorMessage = nil
        do {
            try await exercisesManager.fetchExercises()
        } catch let error as FileReadingError {
            self.errorMessage = error.errorDescription
        } catch {
            self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        isLoadingExercises = false
    }

    private func loadMuscles() async {
        isLoadingMuscles = true
        errorMessage = nil
        do {
            try await exercisesManager.fetchExercises()
        } catch let error as FileReadingError {
            self.errorMessage = error.errorDescription
        } catch {
            self.errorMessage = "An unexpected error occurred: \(error.localizedDescription)"
        }
        isLoadingMuscles = false
    }
}

#Preview {
    ExercisesView()
        .previewEnvironment()
}
