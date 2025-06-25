float topSpeed = 0;

enum SpeedValue {
	FrontSpeed,
	Velocity,
}

[Setting name="Speed Type"]
SpeedValue Setting_Speed_Value = SpeedValue::Velocity;

[Setting name="Peak Hold Time (milliseconds)" min=250 max=5000]
uint64 waitTime = 2000;

void Main() {
    uint64 startTime = Time::get_Now();
    uint64 endTime = Time::get_Now();
    float prevSpeed = 0;
    float currentSpeed = 0;
    
    while (true) {
        const auto vehicle = VehicleState::ViewingPlayerState();
        if (vehicle !is null) {
            switch (Setting_Speed_Value) {
                case SpeedValue::FrontSpeed: currentSpeed = vehicle.FrontSpeed * 3.6f; break;
                case SpeedValue::Velocity: currentSpeed = vehicle.WorldVel.Length() * 3.6f; break;
            }
            
            if (currentSpeed > prevSpeed && currentSpeed > topSpeed) {
                topSpeed = currentSpeed;
                startTime = Time::get_Now();
            }
            else {
                endTime = Time::get_Now();
                if (endTime - startTime > waitTime) {
                    topSpeed = currentSpeed;
                }
            }
            prevSpeed = currentSpeed;
        }
        else {
            topSpeed = 0;
        }
        yield();
    }
}

void Render() {
    UI::SetNextWindowPos(20, 20, UI::Cond::Always); // top-left corner
    UI::Begin("Speed Display", UI::WindowFlags::AlwaysAutoResize | UI::WindowFlags::NoTitleBar);
    UI::Text("Speed: " + Text::Format("%.0f", topSpeed) + " km/h");
    UI::End();
}
