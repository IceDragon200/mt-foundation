-- @namespace foundation.com

-- Time in 'Network' frames, all networks run at the same speed so this function will return the equivalent network frame count

function foundation.com.time_network_frames(time)
  --return math.floor(time)
  return time
end

function foundation.com.time_network_seconds(s)
  ---return foundation.com.time_network_frames(s * 60)
  return s
end

function foundation.com.time_network_minutes(m)
  return foundation.com.time_network_seconds(m * 60)
end

function foundation.com.time_network_hours(h)
  return foundation.com.time_network_minutes(h * 60)
end

function foundation.com.time_network_hms(h, m, s)
  return foundation.com.time_network_hours(h) +
    foundation.com.time_network_minutes(m) +
    foundation.com.time_network_seconds(s)
end
