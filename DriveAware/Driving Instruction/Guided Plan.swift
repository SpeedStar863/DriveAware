//
//  Untitled.swift
//  DriveAware
//
//  Created by Alexander Ur on 10/14/25.
//

import SwiftUI

struct Plans: View {
    @AppStorage("completedTasks") private var completedTasksData: Data = Data()
    @AppStorage("expandedDays") private var expandedDaysData: Data = Data()
    @State private var completedTasks: Set<String> = []
    @State private var expandedDays: Set<String> = []
    
    private let plans: [String: [String]] = [
        "Beginner Day 1": ["• Get comfortable with your vehicle (adjust your seat, posture, mirrors, and head restraints)", "• Let an adult take you to an empty or abandoned parking lot where you can learn the mechanics of your pedals and steering wheel", "• Practice forward driving around the space and use your turn signals to imitate real-world scenarios", "• Continue at a calm pace and emphasize smooth driving"],
        "Beginner Day 2": ["• Return to the parking lot and recall your smooth driving movements from the day before", "• Practice turning on your headlights, windshield wipers, and hazard lights (also known as four-way flashers)", "• Brake a few times to practice your stopping technique and to test your brake lights", "• Shift gears and reverse for any amount of distance to accustom yourself", "• Accurately park in a parking space and reverse out of it, smoothly positioning your vehicle to drive in a different direction", "• Carefully navigate the parking lot as if it were full of cars and traffic"],
        "Beginner Day 3": ["• Return to the parking lot and remember your muscle movements from the day before", "• Imitate intersections and assumed stop signs to practice your application of road rules", "• Imagine different road signs and execute the appropriate actions", "• Finish off with a simple three-point turn"],
        "Beginner Day 4": ["• Return to the parking lot for the last time", "• To understand the basics of parallel parking, align yourself with the curb along multiple parking spaces", "• Practice safe measures to transition from a parallel park to driving on the road, or the other way around (use SMOG - signal, mirror, over the shoulder, and go)", "• If comfortable with reversing, execute a 100 foot backing and ensure you follow proper etiquette"],
        "Beginner Day 5": ["• If you live in a house, residential area, or apartment complex, slowly position your vehicle in the area as you may pull out of the driveway", "• Drive carefully on the streets and emphasize intersections, following guidelines and stopping at times necessary", "• Practice stopping immediately under pressure, examples being for children on the road or objects thrown on the street", "• Finally, return home and carefully back in or park your vehicle"],
        "Beginner Day 6": ["• Return to the parking lot for more practice on reversing", "• If your space allows, practice straight line backing and move up to 100 feet once again", "• Execute another three-point turn until you understand the sequence", "• Find room to imitate either a left or right lane change, using SMOG to follow through with your transition"],
        "Beginner Day 7": ["• Return to the area around your home before you get ready for the road", "• Involve yourself in special situations, like four-way intersections or stop signs and follow proper guidelines", "• Signal each of your turns and always beware of pedestrians, who have the right of way, in residential areas", "• Make plenty of left and right turns", "• Be sure to practice identifying signs and to do as they instruct", "• Find a nearby hill and practice parking on it, following the curb rules that affect your wheel placement"],
        "Intermediate Day 1": ["• Create a driving plan that incorporates only calm roadways and stays within a small radius", "• Enter one of those near your place of residency, carefully following every rule suggested or required", "• Reach an intersection and signal to turn right regardless of a red light unless a sign is posted", "• Reach another intersection and turn left, yielding to other drivers unless you have a green arrow"],
        "Intermediate Day 2": ["• Continue to practice your driving on calm roads around your place of residency", "• Reach the same amount of intersections plus one, but drive straight ahead on at least one of them", "• Ensure you reach a mix of light-powered and stop sign-powered intersections", "• Develop good driving habits and find your rhythm"],
        "Intermediate Day 3": ["• Check: ensure that you can read a speedometer and turn on your defroster", "• Shift your driving practice to busier roads and in a wider radius than before", "• Involve yourself in a four-way intersection where communication is a must", "• Pay attention to warning signs and adjust your speed to at least one advisory speed sign"],
        "Intermediate Day 4": ["• If you live in a city, try for the center of its activity; otherwise, head to your town's busier areas", "• Reach one more intersection than you did the day before", "• Develop responsible driving habits and look both ways when crossing intersections, keep your foot hovering above the brake when going downhill, and slow down and stay sharp when in an area prone to animals", "• If applicable, commit to a left turn during a yellow arrow when it's unsafe to stop abruptly"],
        "Intermediate Day 5": ["• Continue to drive on busy roads and emphasize a smooth experience", "• On this trip, change lanes five times and ensure one of those times is to enter the left-turning lane of an intersection and another is to enter the right-turning lane of an intersection", "• Practice passing another vehicle five times", "• Develop a safe tendency to stop whenever you see a yellow light, unless you are either committed to an intersection or about to commit"],
        "Intermediate Day 6": ["• Continue to drive on busy roads but ramp up the intensity of your practice", "• If you have a nearby roundabout, practice driving on one and follow its specific rules", "• If you live in a rural area, drive through fields or forests marked with roads", "• Cross through six intersections while hovering your foot over the brake and looking both ways", "• Reach three crosswalks and follow standard procedure", "• Practice changing lanes ten times; five of which for passing another vehicle"],
        "Intermediate Day 7": ["• Drive on the busiest roads in your area and stay extremely vigilant", "• Approach five blind curbs and stay cautious while on them, keeping your foot hovered over the brake", "• Approach five dips in elevation and ride your brake each time", "• Perform as much safe driving on roads, intersections, crosswalks, and other formations until you feel ready for the highway"],
        "Advanced Day 1": ["• Identify a highway near you and choose the least used one", "• Signal your intentions when merging onto the highway and use the acceleration lane to match the flow of traffic", "• Stay on the lane directly next to the acceleration lane", "• Maintain a 3-4 second distance from the car in front of you", "• Adjust to the fast speed of a highway and the requirement to stay within your lane"],
        "Advanced Day 2": ["• Enter the same highway as you did the day before", "• Execute three lane change sequences from one end of the highway to the other", "• Pass three different vehicles safely", "• Try to reach a personal status of highway flexibility"],
        "Advanced Day 3": ["• Continue on a busier highway and repeat the exercises from the day before", "• Try to reach a personal status of highway comfort", "• Determine your weak points and sharpen your skills on the same highway from day one"],
        "Advanced Day 4": ["• Enter the most busy highway in your area and repeat the exercises from the day before", "• Try to reach a personal status of highway familiarity", "• Navigate to a nearby exit using GPS, starting in the leftmost lane and ending in the rightmost one"],
        "Advanced Day 5": ["• Enter the same highway and locate your weak spots to repeat yesterday's exercises effectively", "• Try to reach a personal status of highway confidence", "• Navigate to a specific exit without using GPS, instead using the mile markers on the side of a highway, which correspond to the next exit number", "• Incorporate further intersection practice from the intermediate level once you are off the highway", "• If time allows, merge onto the same highway or a different one to repeat the first three objectives"],
        "Advanced Day 6": ["• Travel to your town or city's center of activity and prepare yourself for parallel parking", "• Execute one successful parallel parking maneuver using SMOG", "• Repeat the previous exercise until you feel a sense of mastery", "• If time allows, sharpen your parallel parking skills on a less busy street"],
        "Advanced Day 7": ["• Travel to the most busy highway in your area, turning off your GPS once you are there", "• Using guide signs, regulatory signs, warning signs, work zone signs, and mile markers, navigate to a specific faraway exit", "• Try to reach a personal status of highway proficiency!", "• Strengthen your intersection skills and road awareness once you are off the highway by repeating exercises from the intermediate level"],
    ]
    
    private var sortedDays: [String] {
        let levels = ["Beginner", "Intermediate", "Advanced"]
        
        func parse(_ s: String) -> (Int, Int) {
            let parts = s.split(separator: " ")
            let level = parts.first.map(String.init) ?? ""
            let levelIndex = levels.firstIndex(of: level) ?? Int.max
            let num = Int(parts.last?.filter(\.isNumber) ?? "") ?? Int.max
            return (levelIndex, num)
        }
        return plans.keys.sorted {
            let a = parse($0), b = parse($1)
            return a.0 == b.0 ? a.1 < b.1 : a.0 < b.0
        }
    }
    
    var body: some View {
            NavigationView {
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 14) {
                        ForEach(sortedDays, id: \.self) { day in
                            let tasks = plans[day] ?? []
                            let total = Double(tasks.count)
                            let completed = Double(tasks.filter { completedTasks.contains($0) }.count)
                            let progress = total > 0 ? completed / total : 0
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        toggleExpanded(day)
                                    }
                                }) {
                                    HStack {
                                        Image(systemName: progress == 1.0 ? "checkmark.circle.fill" : (expandedDays.contains(day) ? "chevron.down.circle.fill" : "chevron.right.circle.fill"))
                                            .foregroundColor(progress == 1.0 ? .green : .blue)
                                            .font(.title3)
                                        
                                        Text(day)
                                            .font(.title3)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.primary)
                                        
                                        Spacer()
                                        
                                        Text("\(Int(progress * 100))%")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(Color.gray.opacity(0.2))
                                            .frame(height: 6)
                                        
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(progress == 1.0 ? Color.green : Color.blue)
                                            .frame(width: geo.size.width * progress, height: 6)
                                            .animation(.easeInOut(duration: 0.4), value: progress)
                                    }
                                }
                                .frame(height: 6)
                                .padding(.bottom, 4)
                                
                                if expandedDays.contains(day) {
                                    VStack(alignment: .leading, spacing: 8) {
                                        ForEach(plans[day]!, id: \.self) { task in
                                            Button(action: {
                                                toggleTaskCompletion(task)
                                            }) {
                                                HStack(alignment: .top) {
                                                    Image(systemName: completedTasks.contains(task) ? "checkmark.circle.fill" : "circle")
                                                        .foregroundColor(completedTasks.contains(task) ? .green : .gray)
                                                        .font(.title3)
                                                    Text(task)
                                                        .foregroundColor(.primary)
                                                        .multilineTextAlignment(.leading)
                                                }
                                                .padding(.vertical, 5)
                                                .padding(.horizontal, 8)
                                                .background(Color.blue.opacity(0.05))
                                                .cornerRadius(10)
                                            }
                                            .buttonStyle(PlainButtonStyle())
                                        }
                                    }
                                    .padding(.leading, 4)
                                    .transition(.opacity.combined(with: .slide))
                                }
                            }
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                .navigationTitle("Driving Plan")
            }
            .onAppear(perform: loadData)
        }
    
    private func toggleTaskCompletion(_ task: String) {
        if completedTasks.contains(task) {
            completedTasks.remove(task)
        } else {
            completedTasks.insert(task)
        }
        saveData()
    }
    
    private func toggleExpanded(_ day: String) {
        if expandedDays.contains(day) {
            expandedDays.remove(day)
        } else {
            expandedDays.insert(day)
        }
        saveData()
    }
    
    private func isDayComplete(_ day: String) -> Bool {
        guard let tasks = plans[day] else { return false }
        return tasks.allSatisfy { completedTasks.contains($0) }
    }
    
    private func saveData() {
        if let encodedTasks = try? JSONEncoder().encode(completedTasks) {
            completedTasksData = encodedTasks
        }
        if let encodedDays = try? JSONEncoder().encode(expandedDays) {
            expandedDaysData = encodedDays
        }
    }
    
    private func loadData() {
        if let decoded = try? JSONDecoder().decode(Set<String>.self, from: completedTasksData) {
            completedTasks = decoded
        }
        if let decodedDays = try? JSONDecoder().decode(Set<String>.self, from: expandedDaysData) {
            expandedDays = decodedDays
        }
    }
}
    
    #Preview {
        Plans()
    }
