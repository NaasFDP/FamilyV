local BateauPris = nil
local VoiturePrise = nil
local enService = nil
local ESX = nil
local poissonQTE = 0
local isfishing = true
local PlayerData                = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)


function ShowBlips(bool)
  if(bool)then
			local blip = AddBlipForCoord(Config.Zones.PriseService.x,Config.Zones.PriseService.y,Config.Zones.PriseService.z)
			SetBlipSprite(blip,Config.BlipsType)
			SetBlipColour(blip,Config.BlipsColor)
			SetBlipScale(blip, 1.2)
			BeginTextCommandSetBlipName("STRING")
			AddTextComponentString('Pêche')
			EndTextCommandSetBlipName(blip)
			SetBlipAsShortRange(blip,true)
			SetBlipAsMissionCreatorBlip(blip,true)
    end
end











function DrawNotif(text)
	SetNotificationTextEntry("STRING")
	AddTextComponentString(text)
	DrawNotification(false, false)
end

function ShowInfo(text, state)
	SetTextComponentFormat("STRING")
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, state, 0, -1)
end

function drawTxtfish(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end


AddEventHandler('playerSpawned', function(spawn)
	ShowBlips(true)
end)

function IsNearZonePriseService()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local distance = GetDistanceBetweenCoords(Config.Zones.PriseService.x,Config.Zones.PriseService.y,Config.Zones.PriseService.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 4) then
      return true
    else
      return false
    end
end


function IsNearZoneSortieBateau()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local distance = GetDistanceBetweenCoords(Config.Zones.SortieBateau.x,Config.Zones.SortieBateau.y,Config.Zones.SortieBateau.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 4) then
      return true
    else
      return false
    end
end

function IsNearZonePeche()
  local ply = GetPlayerPed(-1)
  local plyCoords = GetEntityCoords(ply, 0)
  local distance = GetDistanceBetweenCoords(Config.Zones.PecheRecolte.x,Config.Zones.PecheRecolte.y,Config.Zones.PecheRecolte.z, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if(distance <= 50) then
      return true
    else
      return false
    end
end

local function LocalPed()
	return GetPlayerPed(-1)
end

function GetPed() return GetPlayerPed(-1) end
function AttachEntityToPed(prop,bone_ID,x,y,z,RotX,RotY,RotZ)
  BoneID = GetPedBoneIndex(GetPed(), bone_ID)
  obj = CreateObject(GetHashKey(prop),  1729.73,  6403.90,  34.56,  true,  true,  true)
  vX,vY,vZ = table.unpack(GetEntityCoords(GetPed()))
  xRot, yRot, zRot = table.unpack(GetEntityRotation(GetPed(),2))
  AttachEntityToEntity(obj,  GetPed(),  BoneID, x,y,z, RotX,RotY,RotZ,  false, false, false, false, 2, true)
  return obj
end




Citizen.CreateThread(function()
  while true do
    Citizen.Wait(0)

    --Proche prise de service
    if(PlayerData.job.name == 'taxi')then 
      if(IsNearZonePriseService())then
      	DrawMarker(Config.MarkerType,Config.Zones.PriseService.x,Config.Zones.PriseService.y,Config.Zones.PriseService.z,0,0,0,0,0,0,2.001,2.0001,0.5001,Config.MarkerColor.r,Config.MarkerColor.g,Config.MarkerColor.b,200,0,0,0,0)
     		if(enService)then
     			ShowInfo("Appuyez sur ~INPUT_CONTEXT~ pour ~r~finir ~w~votre service.", 0)
     			
     			if IsControlJustPressed(1,38) then
					enService = false
					DrawNotif("Vous avez ~r~fini votre service~w~.")


				end


     		else
     			ShowInfo("Appuyez sur ~INPUT_CONTEXT~ pour ~g~prendre ~w~votre service.", 0)
				if IsControlJustPressed(1,38) then
					enService = true
					DrawNotif("Vous avez ~g~pris votre service~w~.")
						SetPedComponentVariation(GetPlayerPed(-1), 3, 44, 1, 0)
						SetPedComponentVariation(GetPlayerPed(-1), 4, 36, 0, 0)
						SetPedComponentVariation(GetPlayerPed(-1), 6, 27, 0, 0)
						SetPedComponentVariation(GetPlayerPed(-1), 8, 15, 0, 0)
						SetPedComponentVariation(GetPlayerPed(-1), 11, 69, 4, 0)
				end

     		end 
     
       end

       -- Proche Bateau

       if(enService)then
       		if(BateauPris==nil)then
	        	if(IsNearZoneSortieBateau())then
	        		DrawMarker(Config.MarkerType,Config.Zones.SortieBateau.x,Config.Zones.SortieBateau.y,Config.Zones.SortieBateau.z,0,0,0,0,0,0,2.001,2.0001,0.5001,Config.MarkerColor.r,Config.MarkerColor.g,Config.MarkerColor.b,200,0,0,0,0)
	        		ShowInfo("Appuyez sur ~INPUT_CONTEXT~ pour ~g~sortir votre bâteau ~w~.", 0)
	        			if IsControlJustPressed(1,38) then
	        				local car = GetHashKey("tug")
	        				Citizen.CreateThread(function()
								Citizen.Wait(10)
								RequestModel(car)
								while not HasModelLoaded(car) do
									Citizen.Wait(0)
								end
								veh = CreateVehicle(car, 3878.12,4478.72,1.803, 0.0, true, false)
								Citizen.Wait(100)
								SetEntityVelocity(veh, 2000)
								SetVehicleOnGroundProperly(veh)
								SetVehicleHasBeenOwnedByPlayer(veh,true)
								local id = NetworkGetNetworkIdFromEntity(veh)
								SetNetworkIdCanMigrate(id, true)
								SetVehRadioStation(veh, "OFF")
								SetVehicleColours(veh, 84,84)
								SetVehicleLivery(veh, 3)
								SetPedIntoVehicle(GetPlayerPed(-1),  veh,  -1)
								DrawNotif("Véhicule sorti, bonne route")
								BateauPris = veh
								end)



	        			end

	        	end
	        else

	        	
	        	
	        	if(IsNearZoneSortieBateau())then
		        	ShowInfo("Appuyez sur ~INPUT_CONTEXT~ pour ~r~ranger votre bâteau ~w~.", 0)
		        	if IsControlJustPressed(1,38) then
		      			SetEntityAsMissionEntity(BateauPris, true, true)
						Citizen.InvokeNative(0xEA386986E786A54F, Citizen.PointerValueIntInitialized(BateauPris))
				
					    BateauPris = nil

		        	end
		        end

					DrawMarker(Config.MarkerType,Config.Zones.PecheRecolte.x,Config.Zones.PecheRecolte.y,Config.Zones.PecheRecolte.z,0,0,0,0,0,0,15.001,15.0001,0.5001,Config.MarkerColor.r,Config.MarkerColor.g,Config.MarkerColor.b,200,0,0,0,0)
	        		
		        if(IsNearZonePeche())then

		        	ShowInfo("Appuyez sur ~INPUT_CONTEXT~ pour ~b~pêcher~w~.", 0)
		        	if(IsControlJustPressed(1,38))then
		        		isfishing = true
		        		Citizen.Wait(1000)
		        		while((poissonQTE < 31) and (IsNearZonePeche()) and (isfishing)) do 
		        		
			        		Citizen.Wait(4000)
			        		TriggerServerEvent("job_peche_s:recolte")

			        		FishRod = AttachEntityToPed('prop_fishing_rod_02',60309, 0,0,0, 0,0,0)
							local dict = "amb@world_human_stand_fishing@base"
							local anim = "base"
							RequestAnimDict(dict)

							while not HasAnimDictLoaded(dict) do
									Citizen.Wait(0)
							end

							local myPed = GetPlayerPed(-1)
							local animation = anim
							local flags = 16 -- only play the animation on the upper body

							TaskPlayAnim(myPed, dict, animation, 8.0, -8, -1, flags, 0, 0, 0, 0)
							Wait(5000)


			        		DrawNotif("Vous avez reçu ~b~un poisson~w~.")
			        		poissonQTE = poissonQTE +1
							DeleteEntity(FishRod)
			        		

			        	end

			        	if(poissonQTE==30)then
			        		ShowInfo("Vous avez ~r~trop de poissons ~w~sur vous.", 0)
			        		
			        		isfishing = false
			        	end

		        	end



		        end

	        --end [if BeateauPris]
	       	end
	
	--end [enService]
       end







	end
  end
end)


