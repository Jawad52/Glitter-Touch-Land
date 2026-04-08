# Glitter-Touch-Land

✨ ShimmerFlow: Physics-Based Glitter Simulation
A high-performance, native-fidelity Flutter application that simulates realistic glitter physics. ShimmerFlow combines accelerometer data with a 2D physics engine to create an interactive "glitter jar" experience where particles react to gravity, device orientation, and user touch.

🚀 Features
Dual-Density Particle System: Simulates a realistic mixture of Chunky Metallic Confetti and Fine Sand Glitter.

Dynamic Gravity Engine: Real-time integration with the device accelerometer. Tilt your phone to watch the glitter pile slide, tumble, and settle.

Tactile Interaction:

Tap to Spawn: Generate bursts of light-reactive glitter in the upper screen area.

Swipe to Stir: Interact directly with the accumulated pile at the bottom to displace particles without spawning new ones.

High-Performance Rendering: Powered by CustomPainter and Forge2D to maintain a silky-smooth 60/120 FPS experience.

🛠 Tech Stack
Framework: Flutter

Physics Engine: Forge2D (Box2D port for Flutter/Flame)

Sensors: sensors_plus for accelerometer and gyroscope data.

Rendering: Canvas API for low-level, high-speed particle drawing.

📦 Installation
Clone the repository:

Bash
git clone https://github.com/Jawad52/Glitter-Touch-Land.git
Install dependencies:

Bash
flutter pub get
Run the application:

Bash
flutter run --release
(Note: Using --release mode is recommended to witness the full performance of the particle simulation.)

🏗 Architecture
The project follows a clean separation between the UI layer and the Physics simulation:

/lib/physics: Contains the GlitterWorld logic, defining how particles collide and react to the gravity vector.

/lib/render: Houses the ParticlePainter, responsible for the shimmering metallic shaders and frame-by-frame canvas updates.

/lib/sensors: Manages the stream of data from the device hardware to the physics engine.

🎨 Design Philosophy
The app utilizes a Contemporary Minimalist interface, ensuring that the focus remains entirely on the fluid movement and light-reflecting properties of the glitter. By bypassing standard Widget-based animations in favor of a dedicated game loop, ShimmerFlow achieves a level of responsiveness typically reserved for native C++ applications.

📝 License
This project is licensed under the MIT License - see the LICENSE file for details.
