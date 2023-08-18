local registration_number = "000AAA"

function tCLIMB.setRegistrationNumber(registration)
  registration_number = registration
end

function tCLIMB.getRegistrationNumber()
  return registration_number
end

-- function tCLIMB.getUserID()
--   local player = GetPlayerServerId(-1)
--   return player
-- end
