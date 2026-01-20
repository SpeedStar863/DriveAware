//
//  Untitled.swift
//  DriveAware
//
//  Created by Alexander Ur on 10/14/25.
//

import SwiftUI

class DrivingManager: ObservableObject {
    private let tasksKey = "completedTasks"
    private let daysKey = "expandedDays"
    
    @Published var completedTasks: Set<String> = []
    @Published var expandedDays: Set<String> = []
    
    let plans: [String: [String]] = [
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
    
    var sortedDays: [String] {
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
        
        init() {
            loadData()
        }
        
        func toggleTaskCompletion(_ task: String) {
            if completedTasks.contains(task) {
                completedTasks.remove(task)
            } else {
                completedTasks.insert(task)
            }
            saveData()
        }
        
        func toggleExpanded(_ day: String) {
            if expandedDays.contains(day) {
                expandedDays.remove(day)
            } else {
                expandedDays.insert(day)
            }
            saveData()
        }
        
    func generateAIContext(motionManager: MotionManager) -> String {
            let completed = completedTasks.joined(separator: ", ")
            let remaining = plans.values.flatMap { $0 }.filter { !completedTasks.contains($0) }
            
            let eventSummary = motionManager.eventCounts.map { "\($0.key.rawValue): \($0.value)" }.joined(separator: ", ")
        
            let totalEvents = motionManager.debouncedEvents.count
            
            let timestamp = Date().formatted(date: .abbreviated, time: .shortened)
            
            var context = """
                ROLE: You are 'DriveCoach', a professional and encouraging driving instructor.
                GOAL: Help the student master driving by reviewing their progress and answering questions.
                
                PERFORMANCE DATA (FROM AI SENSORS):
                - Total Harsh Events Detected: \(totalEvents)
                - Specific Event Breakdown: [\(eventSummary.isEmpty ? "No incidents detected yet" : eventSummary)]
                
                STUDENT PROGRESS:
                - Completed Tasks: [\(completed)]
                - Next Recommended Tasks: [\(remaining.prefix(3).joined(separator: ", "))]
                
                CURRENT TIME: \(timestamp)
                
                GUIDELINES:
                1. Be concise. Student drivers are often busy.
                2. Safety first. If a student asks something dangerous, correct them firmly but kindly.
                3. Use the progress data. If they haven't finished 'Day 1: Basic Controls', remind them to start there.
                4. Keep the tone motivational, like a coach.
                5. Assume the user's location is South Carolina, but if they state otherwise, then adjust your answers to that area instead.
                6. If a user asks a question completely unrelated to driving in general, politely bring their attention back to either driving in general, their driving progress or their performance data.
                7. Use the performance data. Offer tailored advice to the user based on their logs and analyze trends and recent events.
                8. If 'Hard Brake' is frequent, suggest scanning the road 15 seconds ahead.
                9. If 'Sharp Turn' is frequent, suggest slowing down before the apex of the turn.
                10. If 'Normal' is the only thing logged, congratulate them on smooth driving!
                
                STUDENT PROGRESS LOG
                """
            
            for day in sortedDays {
                let tasks = plans[day] ?? []
                let done = tasks.filter { completedTasks.contains($0) }
                
                if !done.isEmpty {
                    context += "\n- \(day): \(done.count)/\(tasks.count) tasks finished."
                }
            }
            
            let nextDay = sortedDays.first(where: { day in
                let tasks = plans[day] ?? []
                return !tasks.allSatisfy { completedTasks.contains($0) }
            }) ?? "Course Complete!"
            
            context += "\n\nCURRENT GOAL: \(nextDay)."
            
            return context
        }
        
        private func saveData() {
            if let encodedTasks = try? JSONEncoder().encode(completedTasks) {
                UserDefaults.standard.set(encodedTasks, forKey: tasksKey)
            }
            if let encodedDays = try? JSONEncoder().encode(expandedDays) {
                UserDefaults.standard.set(encodedDays, forKey: daysKey)
            }
        }
        
        private func loadData() {
            if let data = UserDefaults.standard.data(forKey: tasksKey),
               let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                completedTasks = decoded
            }
            if let data = UserDefaults.standard.data(forKey: daysKey),
               let decoded = try? JSONDecoder().decode(Set<String>.self, from: data) {
                expandedDays = decoded
            }
        }
    }
