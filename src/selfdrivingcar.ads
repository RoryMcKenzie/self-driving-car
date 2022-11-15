with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

package selfDrivingCar with SPARK_Mode
is
   type OnOff is (On, Off);
   type GearBox is (InReverse, Parked, Drive);

   type Sensor is (Detected, NotDetected);

   type Speed is range 0..70;
   type Battery is range 0..100;
   type BatteryStatus is (Charging, Depleting, Stable);

   type WeightSensor is (Detected, NotDetected);

   type Buckle is (Fastened, Unfastened);

   type Door is (Open, Closed);

  type Seatbelt is record
      SeatWeightSensor: WeightSensor := Detected;
      SeatBuckle: Buckle := Fastened;
   end record;

   type Safety is record
      DriverSeatbelt: Seatbelt;
      PassengerSeatbelt: Seatbelt;
      DriverDoor: Door := Closed;
      PassengerDoor: Door := Closed;
   end record;

   type Car is record
      CarStatus : OnOff := Off;
      CarGearBox: GearBox := Parked;
      CarDiagnosticMode: OnOff := Off;
      CarSensor: Sensor := NotDetected;
      CarSpeed: Speed := 0;
      CarBattery: Battery := 50;
      CarBatteryWarning: OnOff := Off;
      CarBatteryStatus: BatteryStatus := Stable;
      CarSafety: Safety;
   end record;

   SpeedLimit : Speed := 40;

   MyCar : Car;

   function DrivingInvariant return Boolean is
      (MyCar.CarStatus = On and MyCar.CarGearBox = Drive and MyCar.CarDiagnosticMode = Off);

   function ParkedInvariant return Boolean is
      (MyCar.CarGearBox = Parked and MyCar.CarDiagnosticMode = Off);

   procedure TurnOnCar with
     Global => (In_Out => MyCar),
     Pre => ParkedInvariant and MyCar.CarStatus = Off,
     Post => MyCar.CarStatus = On;

   procedure TurnOffCar with
     Global => (In_Out => MyCar),
     Pre => ParkedInvariant and MyCar.CarStatus = On,
     Post => MyCar.CarStatus = Off;

   procedure StartDriving with
     Global => (In_Out => MyCar),
     Pre => MyCar.CarBattery >= 10 and SafetyCheck and MyCar.CarStatus = On and ParkedInvariant,
     Post => MyCar.CarGearBox = Drive;

   procedure SenseObject with
     Global => (In_Out => MyCar),
     Pre => DrivingInvariant;

   procedure SetSpeed (thespeed: in Speed) with
     Global => (In_Out => MyCar),
     Pre => DrivingInvariant,
     Post => MyCar.CarSpeed = thespeed;

   procedure EnableDiagnosticMode with
     Global => (In_Out => MyCar),
     Pre => MyCar.CarDiagnosticMode = Off,
     Post => MyCar.CarDiagnosticMode = On;

   procedure DisableDiagnosticMode with
     Global => (In_Out => MyCar),
     Pre => MyCar.CarDiagnosticMode = On,
     Post => MyCar.CarDiagnosticMode = Off;

   procedure DepleteBattery with
     Global => (In_Out => MyCar),
     Pre => DrivingInvariant and MyCar.CarBattery > 0,
     Post => MyCar.CarBattery = MyCar.CarBattery'Old - 1 and DrivingInvariant;

   procedure ChargeBattery with
     Global => (In_Out => MyCar),
     Pre =>  MyCar.CarBattery < 100 and ParkedInvariant,
     Post => MyCar.CarBattery = MyCar.CarBattery'Old + 1 and ParkedInvariant;

   procedure LowBattery with
     Global => (In_Out => MyCar),
     Pre => DrivingInvariant and MyCar.CarBatteryWarning = Off;

   procedure StartCharging with
     Global => (In_Out => MyCar),
     Pre => ParkedInvariant,
     Post => MyCar.CarBatteryStatus = Charging;

   procedure StartDepleting with
     Global => (In_Out => MyCar),
     Pre =>  MyCar.CarDiagnosticMode = Off,
     Post => MyCar.CarBatteryStatus = Depleting;

   procedure SpeedLimitCheck with
     Global => (In_Out => MyCar, Input => SpeedLimit),
     Pre => DrivingInvariant,
     Post => MyCar.CarSpeed <= SpeedLimit;

   function SeatbeltCheck return Boolean with
     Global => (Input => MyCar);

   function SafetyCheck return Boolean with
     Global => (Input => MyCar);

end selfDrivingCar;
