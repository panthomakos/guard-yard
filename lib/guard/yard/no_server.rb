module Guard
  class Yard
    class NoServer
      [:kill, :spawn, :verify].each do |method|
        define_method(method) { true }
      end
    end
  end
end
