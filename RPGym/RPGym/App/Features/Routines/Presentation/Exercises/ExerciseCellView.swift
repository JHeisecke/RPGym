//
//  ExerciseCellView.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-20.
//

import SwiftUI

struct ExerciseCellView: View {
    let exercise: Exercise
    @State private var isExpanded: Bool = false

    private var primaryMuscleDisplay: String {
        return exercise.targetedMuscles.first?.capitalized.replacingOccurrences(of: "-", with: " ") ?? "Core"
    }

    private var intensityIndicator: String {
        if exercise.targetedMuscles.count > 3 {
            return "High"
        } else if exercise.targetedMuscles.count > 1 {
            return "Mid"
        } else {
            return "Low"
        }
    }

    private var intensityColor: Color {
        switch intensityIndicator {
        case "High": return .red
        case "Mid": return .orange
        default: return .green
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 15) {
                ZStack {
                    placeholderImage()
                }
                .frame(width: 80, height: 80)

                VStack(alignment: .leading, spacing: 6) {
                    Text(exercise.name)
                        .font(.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .lineLimit(2)

                    Text(primaryMuscleDisplay)
                        .font(.system(.subheadline, design: .rounded))
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.15))
                        .clipShape(Capsule())

                    HStack {
                        Circle()
                            .fill(intensityColor)
                            .frame(width: 10, height: 10)
                        Text("Intensity: \(intensityIndicator)")
                            .font(.caption)
                            .foregroundColor(intensityColor)
                    }
                }
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal)
            .background(Color(UIColor.systemBackground))
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(UIColor.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.08), radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal)
        .padding(.vertical, 6)
    }

    @ViewBuilder
    private func placeholderImage() -> some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(LinearGradient(gradient: Gradient(colors: [.gray.opacity(0.3), .gray.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay(
                Image(systemName: "figure.strengthtraining.traditional")
                    .font(.largeTitle)
                    .foregroundColor(.gray.opacity(0.5))
            )
    }
}

struct ExerciseCellView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseCellView(exercise: Exercise(
            id: "sample-crunch",
            name: "Advanced Power Crunch with Twist",
            description: "A challenging abdominal exercise targeting the rectus abdominis and obliques by curling the upper torso off the floor with a rotational movement.",
            breathingTechnique: "Exhale as you curl up and twist, inhale as you lower.",
            generalInstructions: "Lie on back, knees bent, feet flat. Hands behind head (lightly). Lift shoulders and twist.",
            steps: ["Step 1...", "Step 2..."],
            primaryMuscles: ["rectus-abdominis", "obliques"],
            secondaryMuscles: [],
            accessoryMuscles: [],
            videoURL: "",
            imageUrls: ["https://plus.unsplash.com/premium_photo-1664190615160-c76f6a53cab4?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8N3x8ZXhlcmNpc2V8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=500&q=60"],
            variationIDS: ["cable-crunch"]
        ))
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
