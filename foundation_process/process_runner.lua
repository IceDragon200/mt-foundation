-- @namespace foundation.com

--
-- The ProcessRunner is a registry and hosting class for coroutine processes.
--
-- Please be aware that even though this is built to mimic erlang somewhat
-- there is no proper scheduler, and processes are expected to have very, very
-- short execution times, otherwise you run into the wonderful lag.
--
-- The process runner will re-run a process as long as it has messages in its mailbox and it is
-- willing to receive those messages.
--
-- Therefore it is possible to deadlock the process runner by sending a message to itself
-- constantly.
--
-- Usage:
--     local pr = ProcessRunner:new()
--     pr:spawn(function (my_pid, my_process_runner)
--       while true do
--         local success, message = my_process_runner:receive()
--         if success then
--           local message_type = message[1]
--           if message_type == 'send' then
--             -- message received from a send
--             -- do something interesting with the message
--           elseif message_type == 'exit' then
--             break -- break main loop and allow the coroutine to die normally
--           end
--
--         else
--           -- only happens when a timeout is provided to the receive
--         end
--       end
--     end)
--
-- @class ProcessRunner
local ProcessRunner = foundation.com.Class:extends("foundation.com.ProcessRunner")
local ic = ProcessRunner.instance_class

local function pop_from_mailbox(process)
  if process.mailbox_head then
    local head = process.mailbox_head
    process.mailbox_head = head.next

    return head.message
  end
  return nil
end

local function push_to_mailbox(process, message)
  local node = {
    message = message,
    next = nil
  }

  if process.mailbox_end then
    -- attach the node to the end of the previous node
    process.mailbox_end.next = node
  else
    if process.mailbox_head then
      process.mailbox_head.next = node
    else
      process.mailbox_head = node
    end
  end

  -- then replace the end with this node
  process.mailbox_end = node
end

-- @spec #initialize(): void
function ic:initialize()
  self.monotonic_time = 0
  self.g_id = 0
  self.delayed_messages_start = nil
  self.delayed_messages_end = nil
  self.processes = {}
  self.reaper = {}
end

-- Retrieves a processes' mailbox (for debugging purposes)
--
-- @spec #get_mailbox(PID): [Message]
function ic:get_mailbox(pid)
  local process = self.processes[pid]

  if process then
    local i = 0
    local result = {}
    local mail = process.mailbox_head

    while mail do
      i = i + 1
      result[i] = mail.message
      mail = mail.next
    end

    return result
  end
  return nil
end

-- Spawns a new process
--
-- @spec #spawn(ProcessCallback): PID
function ic:spawn(callback)
  self.g_id = self.g_id + 1
  local pid = self.g_id
  local pr = self
  local process = {
    receive_age = nil,
    receive_timeout = nil,
    callback = callback,
    mailbox_end = nil,
    mailbox_head = nil,
    state = 'main',
    traps = {},
    sleep_until = nil,
  }
  process.co = coroutine.create(function ()
    local success, err = xpcall(function ()
      process.callback(pid, pr)
    end, debug.traceback)

    if not success then
      process.state = 'crash'
      process.last_error = err
      coroutine.yield('crash', err)
    end
  end)
  self.processes[pid] = process
  return pid
end

-- Terminates a process by id, no notifications are sent out
--
-- @spec #kill(PID): self
function ic:kill(pid)
  self.processes[pid] = nil
  return self
end

-- Terminates every process, without notifying anyone or anything
--
-- @spec #kill_all(): self
function ic:kill_all()
  self.processes = {}
  return self
end

-- Sends the exit message to the process
-- The process can then handle this message itself
--
-- @spec #send_exit(PID, reason: Any): (queued_to_valid_process: Boolean)
function ic:send_exit(pid, reason)
  local process = self.processes[pid]

  if process then
    push_to_mailbox(process, {'exit', reason})
    return true
  end
  return false
end

-- Determines if the specified process is alive
--
-- @spec #is_alive(PID): Boolean
function ic:is_alive(pid)
  local process = self.processes[pid]
  if process then
    return process.state ~= 'dead'
  end
  return false
end

-- Send a message to process
--
-- @spec #send(PID, Any): (queued_to_valid_process: Boolean)
function ic:send(pid, message)
  local process = self.processes[pid]
  if process then
    push_to_mailbox(process, {'send', message})
    return true
  end
  return false
end

-- Send a message to a process after some time has passed
--
-- @spec #send_after(PID, Any, Timeout): self
function ic:send_after(pid, message, timeout)
  local node = {
    pid = pid,
    message = message,
    timeout_at = self.monotonic_time + timeout,
    next = nil,
  }
  if self.delayed_messages_end then
    self.delayed_messages_end.next = node
  else
    if self.delayed_messages_start then
      self.delayed_messages_start.next = node
    else
      self.delayed_messages_start = node
    end
  end
  self.delayed_messages_end = node
  return self
end

-- @spec #update(delta: Float): void
function ic:update(delta)
  self.monotonic_time = self.monotonic_time + delta

  if self.delayed_messages_start then
    local prev
    local node = self.delayed_messages_start

    while node do
      if node.timeout_at <= self.monotonic_time then
        self:send(node.pid, node.message)
        if not prev then
          self.delayed_messages_start = node.next
        else
          prev.next = node.next
        end
        node = node.next
      else
        prev = node
        node = node.next
      end
    end
  end

  local success, act_or_error, arg
  local message

  for pid, process in pairs(self.processes) do
    self.active_process = process

    if process.state == 'sleep' then
      if not process.sleep_until or process.sleep_until >= self.monotonic_time then
        process.state = 'main'
      end
    end

    while true do
      if process.state == 'receive' then
        process.receive_age = process.receive_age + delta
        if process.receive_timeout and
           process.receive_age >= process.receive_timeout then
          process.state = 'main'
          success, act_or_error, arg = coroutine.resume(process.co, false)
        else
          message = pop_from_mailbox(process)

          if message then
            process.state = 'main'
            success, act_or_error, arg = coroutine.resume(process.co, true, message)
          else
            -- report that the process resume was a success, even though it didn't resume
            -- this is done so the process isn't prematurely reaped
            success = true
            act_or_error = nil
          end
        end
      elseif process.state == 'main' then
        success, act_or_error, arg = coroutine.resume(process.co)
      end

      if success then
        if act_or_error then
          if act_or_error == 'receive' then
            process.state = 'receive'
            process.receive_age = 0
            process.receive_timeout = arg
          elseif act_or_error == 'sleep' then
            process.state = 'sleep'
            process.sleep_until = self.monotonic_time + arg
            break
          elseif act_or_error == 'exit' then
            process.state = 'exit'
            break
          else
            break
          end
        else
          break
        end
      else
        process.state = 'dead'
        process.last_error = act_or_error
        self.reaper[pid] = true
        break
      end
    end
  end

  self.active_process = nil

  local reaped = false
  for pid, _ in pairs(self.reaper) do
    reaped = true
    self.processes[pid] = nil
  end

  if reaped then
    self.reaper = {}
  end
end

-- Should be called from inside a process to put it to sleep for a period
--
-- @spec #sleep(timeout: Integer): Any
function ic:sleep(timeout)
  return coroutine.yield('sleep', timeout)
end

-- Mark the process as waiting for a message (either an exit or 'send')
--
-- @spec #receive(timeout: Integer): (success: Boolean, { type: String, message: Any })
function ic:receive(timeout)
  return coroutine.yield('receive', timeout)
end

-- Return control to the process runner, nothing special happens
--
-- @spec #yield(): Any
function ic:yield()
  return coroutine.yield('yield')
end

-- Notify the process runner that the process would like to exit
--
-- @spec #exit(reason: Any): Any
function ic:exit(reason)
  return coroutine.yield('exit', reason)
end

foundation.com.ProcessRunner = ProcessRunner
