begin
  # use the sys-proctable gem if it's available
  if RUBY_PLATFORM =~ /darwin/
    raise 'Need to mock sys-proctable because it fails on OSX.'
  else
    require 'sys/proctable'
  end
rescue Exception
  # mock it using ps if it's not available
  
  module Sys
  end

  module Sys::ProcTable
    class ProcInfo
      def initialize(pid, cmdline)
        @pid = pid
        @cmdline = cmdline
      end
      attr_reader :pid, :cmdline
    end
  
    def self.ps
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
end

module Daemonz 
  # returns information about a process or all the running processes
  def self.process_info(pid = nil)
    info = Hash.new
    Sys::ProcTable.ps.each do |process|
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
