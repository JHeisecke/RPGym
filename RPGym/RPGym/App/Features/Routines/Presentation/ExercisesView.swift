//
//  ExercisesView.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-19.
//

import SwiftUI

struct ExercisesView: View {

    @EnvironmentObject private var exercisesManager: ExercisesManager

    @State private var exercies: Exercises?

    var body: some View {
        VStack {
            if let exercises = exercies?.exercises {
                List {
                    ForEach(exercises, id: \.id) { exercise in
                        VStack {
                            Text(exercise.name)
                            Text(exercise.description)
                        }
                    }
                }
            } else {
                ProgressView()
                    .frame(width: 150, height: 150)
                    .overlay(alignment: .bottom) {
                        Text("Loading...")
                    }
                    .padding(.bottom, 5)
                    .background(Color.gray.opacity(0.6))
            }
        }
        .task {
            do {
                exercies = try await exercisesManager.fetchExercises()
            } catch {
                print("Error Loading")
            }
        }
    }
}

#Preview {
    ExercisesView()
        .previewEnvironment()
}
