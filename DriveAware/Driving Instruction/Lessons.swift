//
//  Lessons.swift
//  DriveAware
//
//  Created by Alexander Ur on 10/14/25.
//

import Foundation

struct Lesson: Identifiable, Codable {
    var id = UUID()
    let title: String
    let description: String
    let content: String
    let questions: [QuizQuestion]
}

struct QuizQuestion: Identifiable, Codable {
    var id = UUID()
    let question: String
    let options: [String]
    let correctAnswer: [String]
}

let drivingLessons: [Lesson] = [
    Lesson(
        title: "Chapter 1: Early Licensing",
        description: "Uncover the technical purpose, timeline, requirements of your driver's license.",
        content: "We must start with the legal side of licensing. You may either be a U.S. citizen or an international applicant, but the process will look different for each. Before receiving a driver's license, you must start with a beginner's permit (for which you must be at least 15 years old), pass a vision and knowledge exam, and stay within the driving constraints. Once you have held a permit for at least 180 days, you may attempt to obtain your driver's license. Furthermore, you must have completed a driver's education course backed by 8 hours of classroom instruction and 6 hours of actual driving. School attendance and behavior must be in check, as well as driving practice of at least 40 hours, 10 of which must be at night with either your father, mother, legal guardian, individual who has custody of you, person approved by the Department of Social Services, person in place of parent for 60 days or more, or a responsible adult with notarized permission. Finally, you will achieve department certificates based on your completion of the above steps. For a fully-equipped regular driver's license however, you must be at least 17 years old.",
        questions: [
            QuizQuestion(
                question: "What is the main prerequisite for obtaining a driver's license?",
                options: ["Beginner's Permit", "U.S. Citizenship", "International Driver's Permit", "Student ID"],
                correctAnswer: ["Beginner's Permit"]
            ),
            QuizQuestion(
                question: "How long must you have your beginner's permit to be eligible for a driver's license?",
                options: ["250 days", "180 days", "360 days", "140 days"],
                correctAnswer: ["180 days"]
            ),
            QuizQuestion(
                question: "How many hours of night driving with an approved adult must you complete for a driver's license?",
                options: ["10 hours", "16 hours", "20 hours", "6 hours"],
                correctAnswer: ["10 hours"]
            ),
            QuizQuestion(
                question: "Which of the following is an example of an approved adult who can accompany you prior to licensing?",
                options: ["Father", "Teacher", "Driving instructor", "Responsible adult"],
                correctAnswer: ["Father"]
            ),
            QuizQuestion(
                question: "After the required certifications, how old must you be for a regular driver's license?",
                options: ["18 years old", "21 years old", "16 years old", "17 years old"],
                correctAnswer: ["17 years old"]
            )
        ]
    ),
    Lesson(
        title: "Chapter 2: Driving Safe",
        description: "Learn the measures to take for a safe driving experience.",
        content: "While driving, adequate vision is essential to the safety of you and others around you. If your vision is impaired, make sure to wear lenses that ensure you can see well enough. The SCDMV stresses this importance by employing vision checks for first-time beginner's permits and driver's licenses, and when you choose to renew either one. Another important factor to consider when driving is fatigue. Physical and even mental stress can affect performance on the road. If you ever feel tired or find it late at night while driving, take a break and rest. Ensure 7-9 hours of sleep every night and do not use alcohol or other drugs before driving, also make sure any medications you use before hitting the road do not cause drowsiness. A third factor to consider while driving is distraction. There are laws in place to prevent such action, but it is your responsibility as a driver to exercise safe driving. Physical and mental activities such as using your phone, engaging in heated arguments, or eating can all cause distractions. A fourth factor to consider while on the road is aggressive driving. Be wary of your interactions with other drivers and deescalate the situation if possible. Another common danger is alcohol. The legal limit for those 21 and older is 0.08% blood alcohol concentration (BAC). Finally, make sure to keep your emotions in check. Heightened levels of any emotion will affect your performance on the road. Until you cool off, take a moment away from the wheel, give yourself extra time for the trip, or let someone else drive for you.",
        questions: [
            QuizQuestion(
                question: "Who does the SCDMV employ vision checks for? (Select all that apply)",
                options: ["First-time beginner's permit holders", "New commercial drivers", "New passenger vehicle drivers", "First-time driver's license holders"],
                correctAnswer: ["First-time beginner's permit holders", "First-time driver's license holders"]
            ),
            QuizQuestion(
                question: "What is a side effect of medicine that directly affects your ability to drive?",
                options: ["Drowsiness", "Skin reactions", "Weight changes", "Gastrointestinal issues"],
                correctAnswer: ["Drowsiness"]
            ),
            QuizQuestion(
                question: "Which of the following directly contributes to distracted driving? (Select all that apply)",
                options: ["Eating food", "Using your phone", "Arguing with another person", "Having a full ride"],
                correctAnswer: ["Eating food", "Using your phone", "Arguing with another person"]
            ),
            QuizQuestion(
                question: "What is the legal limit for BAC in a driver's license in the United States?",
                options: ["0.02%", "0.04%", "0.08%", "0.12%"],
                correctAnswer: ["0.08%"]
            ),
            QuizQuestion(
                question: "If you experience an aggressive driver or heightened levels of emotions, what is your best course of action? (Select all that apply)",
                options: ["Pull away somewhere safe", "Deescalate and collect yourself", "Ignore the situation", "Accelerate and engage the driver"],
                correctAnswer: ["Pull away somewhere safe", "Deescalate and collect yourself"]
            )
        ]
    ),
    Lesson(
        title: "Chapter 3: Pre-Drive Checklist",
        description: "Understand the safety measures that should be taken before entering a roadway.",
        content: "Before you hit the road, it is imperative to stop for a moment and check your vehicle. A good starting point is to check tire pressure every month with a pressure gauge. Also, ensure your tread depth is safe for roadways; if you want a handy tool, look up the penny trick online. When you are in your car, be sure to adjust your posture so that you are positioned in a way that allows for the airbag to be deployed properly. Also, adjust all of your mirrors and head restraints on so that they are aligned with the back of your head. Lastly, ensure that all seat belts are fastened correctly and that any child in the vehicle is secured by a child safety seat; doing so obeys the law and keeps you and your passengers safe in the event of a collision. Also, airbags are supplemental and work best in conjunction with a seat belt.",
        questions: [
            QuizQuestion(
                question: "What is one way to inspect your vehicle for safe driving?",
                options: ["Check for dents all around", "Get an oil change", "Poke your tires to ensure they're in shape", "Check tire pressure"],
                correctAnswer: ["Check tire pressure"]
                ),
            QuizQuestion(
                question: "What is another safe practice in conjunction with adjusting your head restraints?",
                options: ["Adjusting your seat", "Adjusting your air-conditioning", "Adjusting your mirrors", "Adjusting your seatbelt"],
                correctAnswer: ["Adjusting your mirrors"]
            ),
            QuizQuestion(
                question: "What is the best way to ensure your head restraints are positioned correctly?",
                options: ["If they are aligned with the back of your head", "If they are aligned with your shoulders", "If they are aligned with your ears", "If they are aligned with your neck"],
                correctAnswer: ["If they are aligned with the back of your head"]
            ),
            QuizQuestion(
                question: "Who may have special accommodations regarding standard seat belts?",
                options: ["Children", "Old people", "Commercial drivers", "Public transportation passengers"],
                correctAnswer: ["Children"]
            ),
            QuizQuestion(
                question: "Do airbags work best alone?",
                options: ["No, you must wear a seatbelt", "No, you must adjust your posture", "Yes, they work best alone", "They can work best alone or in conjunction with something else"],
                correctAnswer: ["No, you must wear a seatbelt"]
            ),
            QuizQuestion(
                question: "Checkpoint: Do you feel ready to advance onto the next chapter?",
                options: ["Yes, I feel ready", "No, but I will review missed content and repeat until mastery"],
                correctAnswer: ["Yes, I feel ready"]
            ),
        ]
    ),
    Lesson(
        title: "Chapter 4: The Foundation",
        description: "Apply basic driving knowledge to safe habits on the road.",
        content: "Now we get into the actual driving side of things. First thing's first, turn the car on. There are different ways to do this dependent on your vehicle type, but it is universal to either have a key or button to turn or push while pressing the brake pedal with your right foot. The parking brake should be on before and after you start the car; it is only when you are ready to drive that you release the parking brake and shift your gear into drive. Before pressing the gas pedal, ensure your path is clear on all sides and check for any blind spots by looking over your shoulder. When safe, signal your intentions by using either turn signal and then gradually accelerate with the gas pedal. When stopping or accelerating, you should have your heel on the ground and the top of your foot on the pedal. When you want to halt, gently apply pressure to the brake pedal until your vehicle comes to a complete stop. Now we move to steering. You should have your left hand on the steering wheel at 7 to 9 o'clock and your right hand on the steering wheel at 3 to 5 o'clock. However, when you are turning, you can adjust your grip. Now, we get into backing up. Ensure that there are no obstructions behind the vehicle that are out of view. Then, push the brake pedal and shift into reverse. With your left hand on the steering at 12 o'clock, place your right arm on the back of the front passenger seat and look through the rear window. You may check your mirrors or back up camera occassionally. Press lightly on the gas pedal, stay low in speed, and make only slight steering adjustments. If you back up while turning, quickly check your front and sides as well. Only when you come to a complete halt may you stop looking through the rear window.",
        questions: [
            QuizQuestion(
                question: "Which foot should be where when turning a car on?",
                options: ["The right foot on gas pedal", "The left foot on gas pedal", "The right foot on brake pedal", "The left foot on brake pedal"],
                correctAnswer: ["The right foot on brake pedal"]
            ),
            QuizQuestion(
                question: "What is safe practice when stopping or accelerating? (Select all that apply)",
                options: ["To keep your heel on the floor", "To gently apply pressure to the brake pedal", "To keep the top of your foot on the pedal", "To always look down before pressing either pedal"],
                correctAnswer: ["To keep your heel on the floor", "To gently apply pressure to the brake pedal", "To keep the top of your foot on the pedal"]
            ),
            QuizQuestion(
                question: "Oftentimes, where should your hands be on the steering wheel?",
                options: ["5 to 7 o'clock and 1 to 3 o'clock", "3 to 4 o'clock and 6 to 7 o'clock", "7 to 9 o'clock and 3 to 5 o'clock", "12 o'clock"],
                correctAnswer: ["7 to 9 o'clock and 3 to 5 o'clock"]
            ),
            QuizQuestion(
                question: "Primarily, where should you look when backing up a vehicle?",
                options: ["The rearview mirror", "The rear window", "The backup camera", "The side mirors"],
                correctAnswer: ["The rear window"]
            ),
            QuizQuestion(
                question: "When backing up, which guidelines are best to follow? (Select all that apply)",
                options: ["Remain at low speeds", "Steer only slightly", "Stick to one view only", "Accelerate only slightly"],
                correctAnswer: ["Remain at low speeds", "Steer only slightly", "Accelerate only slightly"]
            ),
        ]
    ),
    Lesson(
        title: "Chapter 5: The Laws and Guidelines",
        description: "Interpret situations lawfully while driving and identify the purpose of traffic control devices.",
        content: "This chapter is very dense, so we will break it up into sections. Right-of-Way: a concept built on situation and largely depends on rule systems in place. Let's run through a few examples. When in an intersection, you must always yield to pedestrians, cyclists, and other drivers who may be caught in the middle of that intersection. There is a standard called the First Car Rule. It states your obligation to yield the right-of-way to any driver who is at the intersection before you are. There are plenty of other rules as well. For example, you must also yield to drivers that are on the opposite traffic lane when making a left turn. Following the Same Time Rule in a four-way intersection, you must yield to the driver on your right given that both parties arrive at the same time. When merging onto a public highway from a driveway or private road, you must yield to drivers who are already on the highway. Similarily, you must also yield to drivers who are already on a limited access or interstate highway if you are on the entrance or acceleration ramp. Traffic Control Devices: a broad term for the many electronic guidlines and signals of the road. Traffic Signals: used all around the U.S. to control traffic flow, and you are most likely familiar with them. They can vary based on location, but typically they use three colors in order: red, yellow, and green. Red meaning stop, yellow meaning caution/slow down for light change, and green meaning go. However, there are also special types of traffic signals. A flashing red light requires you to stop before a crosswalk, stop line or intersection, treating it as you would a stop sign. A flashing yellow light requires you to slow down and proceed wary, and also notes that you stop for any traffic flow entering the intersection. Traffic Signs: a collection of signs that signal conditions ahead to passing drivers, which can serve to either warn or inform them. Let's start off with warning signs. These help warn drivers of possible dangers or special situations on the road, but they can also signal drivers to slow down and prepare themselves to stop. Physically, these signs are diamond shaped and often appear yellow with its content inside being black. A few examples you can look up online include 'Cross Road Ahead,' 'Merging Traffic,' 'Pedestrian Crossing,' and 'Side Road Ahead.' There is also a specific subtype of warning signs called railroad crossing warning signs. You have probably seen these before, but they are characterized by an RR symbol, X-shaped 'Railroad Crossing' and a few other variations. Another common encounter are work zone signs that warn you of work zones ahead either with workers on or near the roadway. After passing these signs, you may see a person with a sign or flag to guide the traffic; do as they instruct. Barriers like cones, tubes, and barrels are also common in work zones, so be sure to drive slowly and follow standard procedures. You will often see regulatory signs as well. These are typically square or rectangular with a white background and black, green or red letters or symbols within. The purpose of them are to enforce specific laws of the road and prohibit actions that are crossed with a red line within the sign. A few example of regulatory signs include speed limit signs, stop signs, yield signs, 'shared center lane left turn only' signs, and one-way street signs. When traveling a greater distance, you will face guide signs. The purpose of them is to provide valuable information on points of interest or nearby amenities. They are common to see on road trips and typically appear green, brown, or blue in a square or rectangular shape. Identifying a type of roadway, route number signs are effective in providing checkpoints for drivers. Look up the types of route number signs online-like interstate, US, and state-to get a better idea. Emphasizing local roads, secondary system road markers are used to list road numbers across counties along with a separate section for road numbers within counties. The layout usually starts with the letter 'S,' followed by a number for the county, and then the road number. Each component is separated by a dash. A rare sign you may see in the event of a hurricane is an evacuation route sign, which signals a certain road or highway used for evacuation purposes. Pavement Markings: used on a road to control traffic flow and have varying purposes. White lines between a road indicate same-direction traffic, while yellow lines indicate different-direction traffic. Dotted lines, whether white or yellow, mean that you can pass other drivers, while solid lines mean that you may not do so. If there are two lines in between a roadway with space for other drivers, then that signals a shared center left turn lane for intersections. If traveling on reversible lanes, traffic flow will be same direction unless marked otherwise by a red X in place of a green arrow. Crosswalks are another important note. Be sure to halt behind a stop line or marked crosswalk; if neither are apparent, stop at a point where both directions are visible and behind the intersection.",
        questions: [
            QuizQuestion(
                question: "In a four-way intersection, what does the Same Time Rule state?",
                options: ["That you must yield to the driver on your right given same time arrival", "That you must yield to emergency vehicles given same time arrival", "That you must yield to the driver on your left given same time arrival", "That you must yield to city vehicles given same time arrival"],
                correctAnswer: ["That you must yield to the driver on your right given same time arrival"]
            ),
            QuizQuestion(
                question: "Which of the following is not an example of a traffic control device?",
                options: ["Traffic signal", "Warning sign", "Work zone sign", "Pavement marking"],
                correctAnswer: ["Pavement marking"]
            ),
            QuizQuestion(
                question: "What do secondary system road markers start with?",
                options: ["The letter 'S'", "The county number", "The state number", "The road number"],
                correctAnswer: ["The letter 'S'"]
            ),
            QuizQuestion(
                question: "Which of the following explains dotted and solid lines on the road?",
                options: ["Dotted lines mean you can pass other drivers, solid lines mean you can but with caution", "Dotted lines mean you cannot pass other drivers, solid lines mean you can", "Solid lines mean you can pass other drivers, dotted lines mean you can but with caution", "Solid lines mean you cannot pass other drivers, dotted lines mean you can"],
                correctAnswer: ["Solid lines mean you cannot pass other drivers, dotted lines mean you can"]
            ),
            QuizQuestion(
                question: "As a driver, when do you have the right-of-way at a pedestrian crosswalk?",
                options: ["When there is no marked crosswalk", "When an emergency vehicle is nearby", "Never", "Always but proceed with caution"],
                correctAnswer: ["Never"]
            ),
            QuizQuestion(
                question: "Checkpoint: Do you feel ready to advance onto the next chapter?",
                options: ["Yes, I feel ready", "No, but I will review missed content and repeat until mastery"],
                correctAnswer: ["Yes, I feel ready"]
            ),
        ]
    ),
    Lesson(
        title: "Chapter 6: Driving Etiquette",
        description: "Further understand driving situations and apply that knowledge to the road.",
        content: "This chapter is also very dense, so we will again break it down into smaller sections. Turning and Turnabouts: concept centers around the basic function of turning and turnabouts on the road. When turning, is general procedure that you search all corners for traffic controls, like signs, obstacles, and other drivers. Also, be sure to signal your intentions. Enter the lane closest to your desired direction. When you are in the lane, accelerate out and cancel your turn signal. However, when you are in the left lane, be sure to yield to oncoming traffic before executing the turn. Remember, you must enter and finish through the correct lane that correlates with your intended one. With your driving instructor, you will learn and practice three-point turnabouts. Before then, do some preliminary research on the topic. Intersections: road formations are the most common you'll see while driving; because of that, they are also the most dangerous. Make sure to let your safety depend on your performance on the road, not on other drivers'. For example, a driver may mistakingly leave their turn signal on or have other intentions. Lastly, obey traffic laws and driving etiquette. For specifics on intersections, consult your driving instructor for Diverging Diamond Interchange (DDI) and Restricted Crossing U-turn (RCUT). Roundabouts: road formations that allow vehicles to travel counterclockwise. There are rules to these, however. You must yield to circulating traffic before entering; also, look out for a yellow sign with black arrows indicating a loop. You must be traveling counterclockwise. You must also signal your intent before exiting a roundabout. School Buses: special vehicles that call for special rules. On a two-lane road, you must stop for school buses. On a multi-lane highway, you must only stop when traveling behind the school bus. Parking: a topic very prevalent to driving. Your driving instructor will practice scenarios with you. However, ensure your understanding of hill parking: when parked downhill, turn your wheels to the right; when parked uphill with a curb, turn your wheels to the center of the street; when parked uphill without a curb, you generally turn your wheels to the right. Changing Lanes When you want to change lanes on a road, you should first check your mirrors for a car behind. Next, you should check your 'blind spots' around your vehicle. Finally, smoothly move into your intended lane and signal before adjusting speed and steering for the lane. Highways These are a universal road formation that you will certainly drive on many times in your life. When entering one, use the acceleration lane to reach a speed that allows you to identify an open space for merging into traffic. When exiting one, move to the lane closest to your means of departure. Then, signal your intention, enter the deceleration lane, and match the posted speed before you reach the ramp. Lastly, when passing, consider the left-most lane as a means for passing slower vehicles. Try and do so as quickly and safely as possible. Standard passing procedure states you should check for oncoming traffic, check your mirrors and over your shoulder for vehicles, signal your intentions 100 feet before, and steer smoothly into the lane. If you are being passed, maintain a constant speed, avoid any erratic or unsafe actions, and do not change lanes.",
        questions: [
            QuizQuestion(
                question: "What should you do when turning left on a turnabout?",
                options: ["Signal, proceed with caution, then go", "Signal, then go", "Signal, yield to oncoming traffic, then go", "Go"],
                correctAnswer: ["Signal, yield to oncoming traffic, then go"]
            ),
            QuizQuestion(
                question: "What is an accepted truth about intersections?",
                options: ["Do not rely on other drivers", "Try to avoid them if possible", "Always wait at least a few minutes before crossing", "Let other people drive for you"],
                correctAnswer: ["Do not rely on other drivers"]
            ),
            QuizQuestion(
                question: "Which direction should you travel on roundabouts?",
                options: ["Clockwise", "Straight through", "Left to right", "Counterclockwise"],
                correctAnswer: ["Counterclockwise"]
            ),
            QuizQuestion(
                question: "Which drivers should stop for a school bus on a multi-lane highway?",
                options: ["All drivers on the highway", "Drivers behind the school bus", "Drivers on the opposite lanes", "It is unnecessary to stop for a school bus on a highway"],
                correctAnswer: ["Drivers behind the school bus"]
            ),
            QuizQuestion(
                question: "What is the standard procedure for passing other drivers on a highway?",
                options: ["Check for oncoming traffic, check your mirrors and over your shoulder for vehicles, signal your intentions 100 feet before, and steer smoothly into the lane", "Check your mirrors and over your shoulder for vehicles, check for oncoming traffic, signal your intentions 100 feet before, and steer smoothly into the lane", "Check for oncoming traffic, signal your intentions 100 feet before, and steer smoothly into the lane", "Signal your intentions 100 feet before, check for oncoming traffic, check your mirrors and over your shoulder for vehicles, and steer smoothly into the lane"],
                correctAnswer: ["Check for oncoming traffic, check your mirrors and over your shoulder for vehicles, signal your intentions 100 feet before, and steer smoothly into the lane"]
            ),
        ]
    ),
    Lesson(
        title: "Chapter 7: Additional Suggestions",
        description: "Improve your readiness for situations on the road and learn the ways to communicate with other drivers.",
        content: "It is best to be visually aware of your vehicle and its surroundings. You can do this by checking around your vehicle before and while driving. Use your mirrors to ensure a safe position and and encourage yourself to constantly look around on the road. Maintain a 20 to 30 second gap from the front of your vehicle to what you can see in front of you. Speed is another point of concern. When entering a curved roadway, reduce your speed and apply minimal acceleration throughout. If conditions prove dangerous, do not hesitate to slow down even more. A sharp brake after entering a curve poses a traction risk. When on slippery roads or encountering hydroplaning, ensure your speed is reduced to a safe level. In the event of a flooded road, it is best practice to avoid the area and take a detour, especially at night. If an alternate path is impossible, then travel to higher ground and wait out the water elevation. When driving, you should consider your stopping distance to ensure safety. To do this, maintain a 4 second following distance between your vehicle and the one in front of yours. Make sure you have a space cushion on the sides of your vehicle as well. Lastly, communicate with other drivers based on the situation that calls for it. You should use your headlights to let other drivers be aware of your presence. You should lightly tap on your horn when non-vehicle users, or vehicle users who you pass, start to enter your lane of travel and when a driver is unaware of his surroundings or may not be aware of your presence. Also, be sure to use your signals to communicate. You can do this by using your turn signal 100 feet or more before changing direction (lanes, turns, or merges). Another way is to use your automatic brake lights when reducing your speed.",
        questions: [
            QuizQuestion(
                question: "How much of a time gap is recommended between your vehicle and your line of sight?",
                options: ["10 to 20 seconds", "30 to 40 seconds", "20 to 30 seconds", "40 to 50 seconds"],
                correctAnswer: ["20 to 30 seconds"]
            ),
            QuizQuestion(
                question: "What is the best way to counter hydroplaning?",
                options: ["Reduce your speed", "Stop your vehicle", "Increase your speed", "Avoid roads until conditions subside"],
                correctAnswer: ["Reduce your speed"]
            ),
            QuizQuestion(
                question: "What are two solutions for encountering a flooded road?",
                options: ["Call for help, drive through the flood", "Get out of your car, stop and wait it out", "Wait for help, find someone willing to assist", "Take a detour, travel to higher ground"],
                correctAnswer: ["Take a detour, travel to higher ground"]
            ),
            QuizQuestion(
                question: "How much of a time gap is recommended between your vehicle and the one in front of yours?",
                options: ["8 seconds", "6 seconds", "4 seconds", "2 seconds"],
                correctAnswer: ["4 seconds"]
            ),
            QuizQuestion(
                question: "To communicate your intentions with other drivers, how far before changing direction should you use your turn signals?",
                options: ["150 feet or more", "100 feet or more", "200 feet or more", "50 feet or more"],
                correctAnswer: ["100 feet or more"]
            ),
        ]
    ),
]
