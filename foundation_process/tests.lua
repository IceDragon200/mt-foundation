local ProcessRunner = foundation.com.ProcessRunner
local case = foundation.com.Luna:new("foundation.com.ProcessRunner")

local function wait_until_dead(pr, pid, timeout)
  local elapsed = 0
  while pr:is_alive(pid) do
    pr:update(0.016)
    elapsed = elapsed + 0.016

    if elapsed > timeout then
      error("timeout")
    end
  end
end

case:describe("spawn/1", function (t2)
  t2:test("can spawn a new process", function (t3)
    local pr = ProcessRunner:new()
    local x
    local pid = pr:spawn(function (my_pid, my_pr)
      x = my_pid
    end)
    t3:assert(pr:is_alive(pid))
    wait_until_dead(pr, pid, 5000)
    t3:assert_eq(x, pid)
  end)
end)

case:describe("send/1", function (t2)
  t2:test("can send a message to a process", function (t3)
    local pr = ProcessRunner:new()
    local received_message
    local pid = pr:spawn(function (my_pid, my_pr)
      local success, msg = my_pr:receive()
      received_message = msg
    end)

    t3:assert(pr:send(pid, "hello"))
    t3:assert_deep_eq(pr:get_mailbox(pid), {{"send", "hello"}})
    wait_until_dead(pr, pid, 5000)
    t3:assert_deep_eq(received_message, {"send", "hello"})
  end)
end)

case:describe("send_exit/1", function (t2)
  t2:test("can order a process to exit normally", function (t3)
    local pr = ProcessRunner:new()
    local received_message
    local pid = pr:spawn(function (my_pid, my_pr)
      local success, msg = my_pr:receive()
      received_message = msg
    end)

    t3:assert(pr:send_exit(pid, "please stop"))
    wait_until_dead(pr, pid, 5000)
    t3:assert_deep_eq(received_message, {"exit", "please stop"})
  end)
end)

case:describe("send_after/1", function (t2)
  t2:test("can schedule a message to be received by a process later", function (t3)
    local pr = ProcessRunner:new()
    local received_message

    local pid = pr:spawn(function (my_pid, my_pr)
      local success, msg = my_pr:receive()
      received_message = msg
    end)

    pr:send_after(pid, "future item", 3)

    pr:update(1)
    t3:assert_deep_eq(pr:get_mailbox(pid), {})

    pr:update(2)
    t3:assert_deep_eq(received_message, {"send", "future item"})
  end)
end)

case:describe("kill/1", function (t2)
  t2:test("immediately kill a process without notifying it", function (t3)
    local pr = ProcessRunner:new()

    local pid = pr:spawn(function (my_pid, my_pr)
      local success, msg = my_pr:receive()
      received_message = msg
    end)

    pr:kill(pid)

    t3:refute(pr:is_alive(pid))
  end)
end)

case:execute()
case:display_stats()
case:maybe_error()
