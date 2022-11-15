with selfDrivingCar; use selfDrivingCar;
with Ada.Text_IO; use Ada.Text_IO;

procedure Main is
   Str : String (1..2);
   Last : Natural;

   task EntryGuard;
   task ObjectSensor is
      pragma Priority (10);
   end ObjectSensor;

   task BatteryCheck is
      pragma Priority (10);
   end BatteryCheck;

   task FullyCharge;
   task FullyDeplete;

   task SpeedCheck;

   task body EntryGuard is
   begin
      loop
         Put_Line("Select car operation: ");
         Get_Line(Str, Last);
         case Str(1) is
            when '1' => StartCharging;
            when '2' => StartDepleting;
            when others => exit;
         end case;
      end loop;
      delay 1.0;
   end EntryGuard;

   task body ObjectSensor is
   begin
      loop
         SenseObject;
         delay 0.5;
      end loop;
   end ObjectSensor;

   task body BatteryCheck is
   begin
      loop
         if MyCar.CarBatteryWarning = Off then
         LowBattery;
         if MyCar.CarBatteryWarning = On then
            Put_Line("Battery is running low. Find a charging point soon.");
         end if;
            delay 0.1;
         end if;
      end loop;
   end BatteryCheck;

   task body FullyCharge is
   begin
      loop
      while MyCar.CarBattery < 100 and MyCar.CarBatteryStatus = Charging loop
         ChargeBattery;
         Put_Line("Battery: "& MyCar.CarBattery'Image & "%");
         delay 0.1;
         end loop;
      end loop;

   end FullyCharge;

   task body FullyDeplete is
   begin
      loop
      while MyCar.CarBattery > 0 and MyCar.CarBatteryStatus = Depleting loop
         DepleteBattery;
         Put_Line("Battery: "& MyCar.CarBattery'Image & "%");
         delay 0.1;
         end loop;
      end loop;
   end FullyDeplete;

   task body SpeedCheck is
   begin
      loop
         SpeedLimitCheck;
         delay 0.5;
      end loop;
   end SpeedCheck;

begin

   Put_Line("TurnOnCar procedure: ");
   Put_Line("Car status: " & MyCar.CarStatus'Image);
   TurnOnCar;
   Put_Line("Procedure TurnOnCar ran");
   Put_Line("Car status: " & MyCar.CarStatus'Image);
   Put_Line("");

   Put_Line("StartDriving procedure: ");
   Put_Line("Car gearbox: " & MyCar.CarGearBox'Image);
   StartDriving;
   Put_Line("Procedure StartDriving ran");
   Put_Line("Car gearbox: " & MyCar.CarGearBox'Image);
   Put_Line("");


   Put_Line("Object detection: ");
   SetSpeed(40);
   Put_Line("Speed before object: " & MyCar.CarSpeed'Image);
   MyCar.CarSensor := Detected;
   Put_Line("Car object sensor detects an object, SenseObject procedure brakes car");
   delay 1.0;
   Put_Line("Speed after object: " & MyCar.CarSpeed'Image);
   MyCar.CarSensor := NotDetected;
   Put_Line("");


   SetSpeed(50);
   Put_Line("Speeding back up to 50mph");
   Put_Line("");

   Put_Line("Speed limit detection: ");
   SpeedLimit := 40;
   Put_Line("Road speed limit changes to 40");
   delay 1.0;
   Put_Line("Car speed after speed limit change: " & MyCar.CarSpeed'Image);

   null;
end Main;
