with Ada.Text_IO; use Ada.Text_IO;
with Ada.Real_Time; use Ada.Real_Time;

package body selfDrivingCar with SPARK_Mode
is
   procedure TurnOnCar is
   begin
      MyCar.CarStatus := On;
   end TurnOnCar;

   procedure TurnOffCar is
   begin
      MyCar.CarStatus := Off;
   end TurnOffCar;

   procedure StartDriving is
   begin
      MyCar.CarGearBox := Drive;
   end StartDriving;

   procedure SetSpeed (thespeed: in Speed) is
   begin
      MyCar.CarSpeed := thespeed;
   end SetSpeed;

   procedure SenseObject is
   begin
      if MyCar.CarSensor = Detected then
         SetSpeed(0);
      end if;
   end SenseObject;

   procedure EnableDiagnosticMode is
   begin
      MyCar.CarDiagnosticMode := On;
   end EnableDiagnosticMode;

   procedure DisableDiagnosticMode is
   begin
      MyCar.CarDiagnosticMode := Off;
   end DisableDiagnosticMode;

   procedure DepleteBattery is
   begin
      MyCar.CarBattery := MyCar.CarBattery - 1;
   end DepleteBattery;

   procedure ChargeBattery is
   begin
      MyCar.CarBattery := MyCar.CarBattery + 1;
   end ChargeBattery;

   procedure LowBattery is
   begin
      if MyCar.CarBattery <= 10 then
         MyCar.CarBatteryWarning := On;
      end if;
   end LowBattery;

   procedure StartCharging is
   begin
      MyCar.CarBatteryStatus := Charging;
   end StartCharging;

   procedure StartDepleting is
   begin
      MyCar.CarBatteryStatus := Depleting;
   end StartDepleting;

   procedure SpeedLimitCheck is
   begin
      if MyCar.CarSpeed > SpeedLimit then
         MyCar.CarSpeed := SpeedLimit;
      end if;
   end SpeedLimitCheck;

   function SeatbeltCheck return Boolean is
   begin
      return MyCar.CarSafety.DriverSeatBelt.SeatWeightSensor = Detected and MyCar.CarSafety.DriverSeatbelt.SeatBuckle = Fastened and ((MyCar.CarSafety.PassengerSeatbelt.SeatWeightSensor = Detected and MyCar.CarSafety.PassengerSeatbelt.SeatBuckle = Fastened) or (MyCar.CarSafety.PassengerSeatbelt.SeatWeightSensor = NotDetected));
   end SeatbeltCheck;

   function SafetyCheck return Boolean is
   begin
      return SeatbeltCheck and MyCar.CarSafety.DriverDoor = Closed and MyCar.CarSafety.PassengerDoor = Closed;
   end SafetyCheck;

end selfDrivingCar;
