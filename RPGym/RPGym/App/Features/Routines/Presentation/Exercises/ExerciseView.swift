//
//  ExerciseView.swift
//  RPGym
//
//  Created by Javier Heisecke on 2025-06-20.
//

import SwiftUI

// --- Helper: Theme Colors (Adjust as needed) ---
struct Theme {
    static let backgroundColor = Color(UIColor.systemGroupedBackground) // Adapts to light/dark mode
    static let cardBackgroundColor = Color(UIColor.secondarySystemGroupedBackground)
    static let textColor = Color.primary
    static let secondaryTextColor = Color.secondary
    static let accentColor = Color.blue
    static let primaryMuscleColor = Color.green
    static let secondaryMuscleColor = Color.orange
    static let accessoryMuscleColor = Color.purple
}

// --- Helper: Section Header View ---
struct SectionHeaderView: View {
    let title: String
    let iconName: String

    var body: some View {
        HStack {
            Image(systemName: iconName)
                .font(.title2)
                .foregroundColor(Theme.accentColor)
            Text(title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(Theme.textColor)
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

// --- Helper: Muscle Tag View ---
struct MuscleTagView: View {
    let muscleName: String
    let color: Color

    var body: some View {
        Text(muscleName)
            .font(.caption)
            .fontWeight(.medium)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(color.opacity(0.2))
            .foregroundColor(color)
            .clipShape(Capsule())
    }
}

// --- Main Exercise Detail View ---
struct ExerciseDetailView: View {
    let exercise: Exercise

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // --- Exercise Name ---
                Text(exercise.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Theme.accentColor)
                    .padding(.bottom, 5)

                // --- Description ---
                Text(exercise.description)
                    .font(.body)
                    .foregroundColor(Theme.secondaryTextColor)
                    .lineSpacing(5)

                // --- Card Sections ---
                Group {
                    // --- Breathing Technique ---
                    if let breathing = exercise.breathingTechnique, !breathing.isEmpty {
                        cardSection(title: "Breathing", icon: "lungs.fill") {
                            Text(breathing)
                                .font(.subheadline)
                                .foregroundColor(Theme.textColor)
                        }
                    }

                    // --- General Instructions ---
                    cardSection(title: "Instructions", icon: "list.bullet.clipboard.fill") {
                        Text(exercise.generalInstructions)
                            .font(.subheadline)
                            .foregroundColor(Theme.textColor)
                    }

                    // --- Steps ---
                    if let steps = exercise.steps, !steps.isEmpty {
                        cardSection(title: "Steps", icon: "figure.walk") {
                            VStack(alignment: .leading, spacing: 8) {
                                ForEach(steps.indices, id: \.self) { index in
                                    HStack(alignment: .top) {
                                        Text("\(index + 1).")
                                            .fontWeight(.semibold)
                                            .foregroundColor(Theme.accentColor)
                                        Text(steps[index])
                                            .font(.subheadline)
                                            .foregroundColor(Theme.textColor)
                                    }
                                }
                            }
                        }
                    }

                    // --- Muscles Worked ---
                    if !(exercise.primaryMuscles?.isEmpty ?? true) ||
                       !(exercise.secondaryMuscles?.isEmpty ?? true) ||
                       !(exercise.accessoryMuscles?.isEmpty ?? true) {
                        cardSection(title: "Muscles Targeted", icon: "figure.strengthtraining.functional") {
                            VStack(alignment: .leading, spacing: 10) {
                                muscleGroupView(title: "Primary", muscles: exercise.primaryMuscles, color: Theme.primaryMuscleColor)
                                muscleGroupView(title: "Secondary", muscles: exercise.secondaryMuscles, color: Theme.secondaryMuscleColor)
                                muscleGroupView(title: "Accessory", muscles: exercise.accessoryMuscles, color: Theme.accessoryMuscleColor)
                            }
                        }
                    }

                    // --- Variations ---
                    if !exercise.variationIDS.isEmpty {
                        cardSection(title: "Variations", icon: "arrow.triangle.branch") {
                            FlexibleView(data: exercise.variationIDS, spacing: 8, alignment: .leading) { item in
                                Text(item) // Assuming variationIDS are human-readable names or IDs you'd lookup
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Theme.accentColor.opacity(0.15))
                                    .foregroundColor(Theme.accentColor)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                }
            }
            .padding()
        }
        .background(Theme.backgroundColor.edgesIgnoringSafeArea(.all))
        .navigationTitle(exercise.name) // Or keep it empty if you prefer the large title in the content
        .navigationBarTitleDisplayMode(.inline)
    }

    // Helper for card-like sections
    @ViewBuilder
    private func cardSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading) {
            SectionHeaderView(title: title, iconName: icon)
            content()
                .padding(.top, 5)
        }
        .padding()
        .background(Theme.cardBackgroundColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    // Helper for muscle groups
    @ViewBuilder
    private func muscleGroupView(title: String, muscles: [String]?, color: Color) -> some View {
        if let muscles = muscles, !muscles.isEmpty {
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(color)
                FlexibleView(data: muscles, spacing: 8, alignment: .leading) { muscle in
                    MuscleTagView(muscleName: muscle, color: color) // Assuming these are displayable names
                }
            }
        }
    }
}

// --- Helper: Flexible Grid View for Tags (from the web, common pattern) ---
struct FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State private var availableWidth: CGFloat = 0

    var body: some View {
        ZStack(alignment: Alignment(horizontal: alignment, vertical: .center)) {
            Color.clear
                .frame(height: 1)
                .readSize { size in
                    availableWidth = size.width
                }

            _FlexibleView(
                availableWidth: availableWidth,
                data: data,
                spacing: spacing,
                alignment: alignment,
                content: content
            )
        }
    }
}

struct _FlexibleView<Data: Collection, Content: View>: View where Data.Element: Hashable {
    let availableWidth: CGFloat
    let data: Data
    let spacing: CGFloat
    let alignment: HorizontalAlignment
    let content: (Data.Element) -> Content
    @State var elementsSize: [Data.Element: CGSize] = [:]

    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            ForEach(computeRows(), id: \.self) { rowElements in
                HStack(spacing: spacing) {
                    ForEach(rowElements, id: \.self) { element in
                        content(element)
                            .fixedSize()
                            .readSize { size in
                                elementsSize[element] = size
                            }
                    }
                }
            }
        }
    }

    func computeRows() -> [[Data.Element]] {
        var rows: [[Data.Element]] = [[]]
        var currentRow = 0
        var remainingWidth = availableWidth

        for element in data {
            let elementSize = elementsSize[element, default: CGSize(width: availableWidth, height: 1)]

            if remainingWidth - (elementSize.width + spacing) >= 0 {
                rows[currentRow].append(element)
            } else {
                currentRow += 1
                rows.append([element])
                remainingWidth = availableWidth
            }
            remainingWidth -= (elementSize.width + spacing)
        }
        return rows
    }
}

// Helper to read view size
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}
extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}


// --- Example Usage (Preview) ---
struct ExerciseDetailView_Previews: PreviewProvider {
    static var sampleExercise = Exercise(
        id: "sample-crunch",
        name: "Abdominal Crunch",
        description: "A foundational core exercise that targets the rectus abdominis, commonly known as the 'six-pack' muscles. It involves flexing the spine to bring the shoulders towards the pelvis.",
        breathingTechnique: "Exhale forcefully as you curl your upper body, inhale slowly as you lower back down.",
        generalInstructions: "Ensure your lower back remains in contact with the floor throughout the movement. Avoid pulling on your neck; let your abs do the work.",
        steps: [
            "Lie flat on your back with your knees bent and feet flat on the floor, about hip-width apart.",
            "Place your hands lightly behind your head or across your chest.",
            "Engage your abdominal muscles to lift your head, neck, and shoulders off the floor.",
            "Curl up until you feel a good contraction in your abs, then slowly lower back to the starting position."
        ],
        primaryMuscles: ["Rectus Abdominis"],
        secondaryMuscles: ["Obliques"],
        accessoryMuscles: ["Hip Flexors (minor)"],
        videoURL: nil,
        imageUrls: [],
        variationIDS: ["Cable Crunch", "Weighted Crunch", "Reverse Crunch"]
    )

    static var bodyweightSquat = Exercise(
        id: "bodyweight-squat",
        name: "Bodyweight Squat",
        description: "A fundamental lower body exercise engaging multiple muscle groups.",
        breathingTechnique: "Inhale as you lower, exhale as you stand up.",
        generalInstructions: "Keep your chest up and back straight. Push your hips back as if sitting in a chair. Ensure your knees track in line with your toes.",
        steps: [
            "Stand with your feet shoulder-width apart, toes pointing slightly outwards.",
            "Lower your hips back and down, bending your knees until your thighs are at least parallel to the floor.",
            "Keep your weight in your heels and mid-foot.",
            "Push through your heels to return to the starting position."
        ],
        primaryMuscles: ["Quadriceps", "Gluteus Maximus"],
        secondaryMuscles: ["Hamstrings", "Adductors"],
        accessoryMuscles: ["Erector Spinae", "Calves"],
        videoURL: nil,
        imageUrls: [],
        variationIDS: ["Goblet Squat", "Jump Squat", "Pistol Squat"]
    )


    static var previews: some View {
        NavigationView {
            ExerciseDetailView(exercise: sampleExercise)
        }
        .preferredColorScheme(.light) // Test light mode

        NavigationView {
            ExerciseDetailView(exercise: bodyweightSquat)
        }
        .preferredColorScheme(.dark) // Test dark mode
    }
}
