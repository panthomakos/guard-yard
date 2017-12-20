module Guard
  class Yard
    # NULL Server
    class NoServer
      %i[kill spawn verify].each do |method|
        define_method(method) { true }
      end
    end
  end
end
