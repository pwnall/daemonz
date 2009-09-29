# Mocks the sys-proctable gem using ps.
#
# This is useful even if sys-proctable is available, because it may fail for
# random reasons.
module Daemonz::ProcTable
  class ProcInfo
    def initialize(pid, cmdline)
      @pid = pid
      @cmdline = cmdline
    end
    attr_reader :pid, :cmdline
  end

  def self.ps_emulation
    retval = []
    ps_output = `ps ax`
    ps_output.each_line do |pline|
      pdata = pline.split(nil, 5)
      pinfo = ProcInfo.new(pdata[0].strip, pdata[4].strip)
      retval << pinfo
    end
    return retval
  end
end

begin
  require 'sys/proctable'
  if Sys::ProcTable::VERSION == '0.7.6'
    raise LoadError, 'Buggy sys/proctable, emulate'
  end
  
  module Daemonz::ProcTable
    def self.ps
      # We don't use ps_emulation all the time because sys-proctable is
      # faster. We only pay the performance penalty when sys-proctable fails.
      begin
        Sys::ProcTable.ps
      rescue Exception
        self.ps_emulation
      end
    end
  end
rescue LoadError
  # The accelerated version is not available, use the slow version all the time.
  
  module Daemonz::ProcTable
    def self.ps
      self.ps_emulation
    end
  end
end

module Daemonz 
  # returns information about a process or all the running processes
  def self.process_info(pid = nil)
    info = Hash.new
    
    Daemonz::ProcTable.ps.each do |process|
      item = { :cmdline => process.cmdline, :pid => process.pid.to_s }

      if pid.nil?
        info[process.pid.to_s] = item
      else
        return item if item[:pid].to_s == pid.to_s
      end
    end
    
    if pid.nil?
      return info
    else
      return nil
    end
  end
end
