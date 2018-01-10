class BRIO
  require 'io/console'
  require 'colorize'

  def self.progress str='', min=0, max=0
    print "\n   × ",  str.green, " × \n\n"
    print '[  ', 'PROGESS'.green, '  ] '

    #NOTE normalize data here
    @pbar = Thread.new do
      _, w = IO.console.winsize
      cnt = 0
      until cnt >= w-25 do
        iter = @pbar.thread_variable_get(:iter).to_i
        cnt += iter

        until iter == 0 do
          sleep 0.06 and print '='
          @pbar.thread_variable_set(
            :iter, iter -= 1
            )
        end
        loop do
          break if iter
          @pbar.thread_variable_set(:iter, 0)
        end
      end
      print ' [  ', 'DONE'.green,'  ]', "\n"
    end

    yield.tap { @pbar.join }
  end

  def self.pbar_set iter
    @pbar.thread_variable_set(:iter, iter)
  end

  def self.log str=''
    print '→ ', str, "\n"
  end

  def self.rlog str=''
    glif = ['×','-','_','^']
    
    idx, st = 0, :up
    thread = Thread.new do
      loop do
        break unless st
        
        sleep 0.06 and print "\r[ #{glif[idx]} ] ".green, str, "\b"
        
        idx += 1
        idx = 0 if idx == glif.size
      end
    end

    yield.tap do
      st = nil
      thread.join
    end

    print "\r| ", str.green, "  → done.\n"
  end

  def self.info str=''
    print '[  INFO     ] << ', str, "\n"
  end

  def self.success str=''
    print '[  SUCCESS  ] >> '.green, str, "\n"
  end

  def self.warn str=''
    print '[  WARNING  ] -- '.yellow, str, "\n"
  end

  def self.danger str=''
    print '[ ', '  DANGER '.
      black.on_red.bold.blink,
      ' ] >> '.red, str.yellow, "\n"
  end

  def self.vcat str=''
    print ' '*3, '·̣  ', str, "\n"
  end

  def self.xcat str=''
    print ' '*3, '×  ', str, "\n"
  end

  def self.mcat str=''
    print ' '*3, '-  '.green, str, "\n"
  end

  def self.cat str=''
    print ' '*3, str, "\n"
  end

  def self.spacer
    print "\n"
  end
  self.singleton_class.send(
    :alias_method,
    :sp, :spacer
    )
end

BRIO.spacer
BRIO.success 'Cluedo!!'
BRIO.info 'Comment?'
BRIO.warn 'Ou..'
BRIO.danger 'Je ne sais quoi?'.yellow

BRIO.sp
BRIO.rlog 'Elisabeth' do
  2.times { sleep 1 }
end

BRIO.spacer
BRIO.cat 'Thx!! for the time. :^°'
BRIO.xcat 'un peu'
BRIO.mcat 'a la folie..'
BRIO.vcat 'l\'Amour.'
BRIO.log 'Qui a gagner?'

BRIO.progress 'Rotrou de Chateaudun' do
  BRIO.pbar_set 8
  sleep 2
  BRIO.pbar_set 135-33
  sleep 2
  BRIO.pbar_set 135-22
end


